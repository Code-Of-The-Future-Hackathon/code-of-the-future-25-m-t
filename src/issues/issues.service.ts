import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from 'src/users/entities';
import { CategoriesService } from 'src/categories/categories.service';
import { FilesService } from 'src/files/files.service';
import { UsersService } from 'src/users/users.service';
import { SensorEntity } from 'src/sensors/entities';
import { AiService } from 'src/ai/ai.service';
import { TypeEntity } from 'src/categories/entities';

import { IssueEntity, IssueGroupEntity } from './entities';
import { ChangeStatusDto, CreateIssueDto } from './dto';
import { GetGroupsDto } from './dto/get-groups.dto';
import { GroupStatusEnum, ReporterEnum } from './enums';
import { IssueErrorCodes } from './errors';

@Injectable()
export class IssuesService {
  private readonly logger = new Logger(IssuesService.name);
  private readonly EARTH_RADIUS = 6378000;
  private readonly MAX_RADIUS_METERS = 20_000;

  constructor(
    @InjectRepository(IssueEntity)
    private readonly issueRepository: Repository<IssueEntity>,
    @InjectRepository(IssueGroupEntity)
    private readonly issueGroupsRepository: Repository<IssueGroupEntity>,
    private readonly categoriesService: CategoriesService,
    private readonly filesService: FilesService,
    private readonly usersService: UsersService,
    private readonly aiService: AiService,
  ) {}

  toDegrees(radians: number) {
    return (radians * 180) / Math.PI;
  }

  toRadians(degrees: number) {
    return (degrees * Math.PI) / 180;
  }

  haversineDistance(lat1: number, lon1: number, lat2: number, lon2: number) {
    const dLat = this.toRadians(lat2 - lat1);
    const dLon = this.toRadians(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) ** 2 +
      Math.cos(this.toRadians(lat1)) *
        Math.cos(this.toRadians(lat2)) *
        Math.sin(dLon / 2) ** 2;

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return this.EARTH_RADIUS * c;
  }

  boundingBox(lat: number, lon: number, radius: number) {
    const latDiff = this.toDegrees(radius / this.EARTH_RADIUS);
    const lonDiff = this.toDegrees(
      radius / (this.EARTH_RADIUS * Math.cos((lat * Math.PI) / 180)),
    );

    return {
      topLeft: { lat: lat + latDiff, lon: lon - lonDiff },
      bottomRight: { lat: lat - latDiff, lon: lon + lonDiff },
    };
  }

  async create(
    user: UserEntity,
    dto: CreateIssueDto,
    file: Express.Multer.File,
  ) {
    this.logger.log(
      `Creating issue for user ${user.id} and file name ${file?.originalname}`,
    );
    await this.categoriesService.checkImageSupport(dto.typeId, file);

    const fileEntity = file
      ? await this.filesService.uploadFile(file)
      : undefined;

    const type = await this.categoriesService.findOneTypeOrFail(
      dto.typeId,
      true,
    );
    const issue = this.issueRepository.create({
      ...dto,
      type: {
        id: type.id,
      },
      user: {
        id: user.id,
      },
      ...(fileEntity ? { file: { id: fileEntity.id } } : {}),
    });

    const issueEntity = await this.issueRepository.save(issue);
    await this.addToGroupsOrCreate(issueEntity, type);

    return issueEntity;
  }

  async createBySensor(sensor: SensorEntity, dto: CreateIssueDto) {
    const type = await this.categoriesService.findOneTypeOrFail(
      dto.typeId,
      true,
    );
    const issue = this.issueRepository.create({
      ...dto,
      type: {
        id: type.id,
      },
      sensor: {
        id: sensor.id,
      },
    });

    const issueEntity = await this.issueRepository.save(issue);
    await this.addToGroupsOrCreate(issueEntity, type);

    return issueEntity;
  }

  async addToGroupsOrCreate(issue: IssueEntity, type: TypeEntity) {
    const reporter = issue.user ? ReporterEnum.User : ReporterEnum.Sensor;
    const groups = await this.findAllGroups({
      lat: issue.lat,
      lon: issue.lon,
      radius: 10,
    });
    if (groups.length) {
      groups.forEach((group) => {
        if (group.reporter !== reporter) group.reporter = ReporterEnum.All;
        if (!group.address) group.address = issue.address;
        if (!group.issues) group.issues = [];
        group.issues.push({ id: issue.id } as IssueEntity);
      });

      return await this.issueGroupsRepository.save(groups);
    }

    const costEstimates = await this.aiService.estimateCost(
      issue.description,
      type,
    );

    const group = this.issueGroupsRepository.create({
      address: issue.address,
      lat: issue.lat,
      lon: issue.lon,
      reporter,
      type: {
        id: issue.type.id,
      },
      issues: [
        {
          id: issue.id,
        },
      ],
      costEstimates,
    });

    return await this.issueGroupsRepository.save(group);
  }

  async findAllGroups(data: GetGroupsDto) {
    const { topLeft, bottomRight } = this.boundingBox(
      data.lat,
      data.lon,
      Math.min(data.radius, this.MAX_RADIUS_METERS),
    );

    const query = this.issueGroupsRepository
      .createQueryBuilder('group')
      .leftJoinAndSelect('group.type', 'type')
      .leftJoinAndSelect('group.issues', 'issue')
      .leftJoinAndSelect('issue.file', 'file')
      .leftJoinAndSelect('type.category', 'category')
      .where('group.lat <= :topLat', { topLat: topLeft.lat })
      .andWhere('group.status = :status', { status: GroupStatusEnum.Active })
      .andWhere('group.lat >= :bottomLat', { bottomLat: bottomRight.lat })
      .andWhere('group.lon >= :topLon', { topLon: topLeft.lon })
      .andWhere('group.lon <= :bottomLon', { bottomLon: bottomRight.lon });

    if (data.categoryId) {
      query.andWhere('type.categoryId = :categoryId', {
        categoryId: data.categoryId,
      });
    }

    return await query.getMany();
  }

  async findUserGroups(user: UserEntity) {
    return await this.issueGroupsRepository.find({
      where: { issues: { user: { id: user.id } } },
      relations: ['type', 'issues', 'issues.file', 'type.category'],
      order: { id: 'DESC' },
    });
  }

  async findUserResolvedIssues(user: UserEntity) {
    return await this.issueGroupsRepository.find({
      where: {
        resolver: { id: user.id },
        status: GroupStatusEnum.Resolved,
      },
      relations: ['type', 'issues', 'issues.file', 'type.category'],
      order: { id: 'DESC' },
    });
  }

  async findGroupsWithDetails(data: GetGroupsDto) {
    const groups = await this.findAllGroups(data);

    const mappedGroups = groups.map((group) => {
      return {
        ...group,
        distance: this.haversineDistance(
          data.lat,
          data.lon,
          group.lat,
          group.lon,
        ),
      };
    });

    if (data.sort) {
      return mappedGroups.sort((g1, g2) => g1.distance - g2.distance);
    }

    return mappedGroups;
  }

  async findOneGroup(id: number) {
    return await this.issueGroupsRepository.findOne({
      where: { id },
      relations: [
        'type',
        'issues',
        'issues.user',
        'issues.sensor',
        'issues.file',
      ],
    });
  }

  async findOneGroupOrFail(id: number) {
    const group = await this.findOneGroup(id);

    if (!group) {
      throw new BadRequestException(IssueErrorCodes.GroupNotFoundError);
    }

    return group;
  }

  async changeStatus(user: UserEntity, dto: ChangeStatusDto) {
    const group = await this.findOneGroupOrFail(dto.id);

    if (group.status === dto.status) {
      return group;
    }

    if (dto.status === GroupStatusEnum.Resolved) {
      group.issues.forEach((issue) => {
        if (issue.user) {
          void this.usersService.incrUserPoints(issue.user, 10);
        }
      });
    }
    group.status = dto.status;
    group.resolver = user;

    return await this.issueGroupsRepository.save(group);
  }
}
