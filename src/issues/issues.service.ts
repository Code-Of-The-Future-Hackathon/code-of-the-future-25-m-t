import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from 'src/users/entities';
import { CategoriesService } from 'src/categories/categories.service';
import { FilesService } from 'src/files/files.service';

import { IssueEntity, IssueGroupEntity } from './entities';
import { CreateIssueDto } from './dto';
import { IssueErrorCodes } from './errors';

@Injectable()
export class IssuesService {
  private readonly EARTH_RADIUS = 6378000;

  constructor(
    @InjectRepository(IssueEntity)
    private readonly issueRepository: Repository<IssueEntity>,
    @InjectRepository(IssueGroupEntity)
    private readonly issueGroupsRepository: Repository<IssueGroupEntity>,
    private readonly categoriesService: CategoriesService,
    private readonly filesService: FilesService,
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
    await this.categoriesService.checkImageSupport(dto.typeId, file);

    const fileEntity = file
      ? await this.filesService.uploadFile(file)
      : undefined;

    const type = await this.categoriesService.findOneTypeOrFail(dto.typeId);
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
    await this.addToGroupsOrCreate(issueEntity);

    return issueEntity;
  }

  async addToGroupsOrCreate(issue: IssueEntity) {
    const { topLeft, bottomRight } = this.boundingBox(issue.lat, issue.lon, 10);

    const groups = await this.issueGroupsRepository
      .createQueryBuilder('group')
      .leftJoinAndSelect('group.type', 'type')
      .leftJoinAndSelect('group.issues', 'issue')
      .where('type.id = :typeId', { typeId: issue.type.id })
      .andWhere('group.lat <= :topLat', { topLat: topLeft.lat })
      .andWhere('group.lat >= :bottomLat', { bottomLat: bottomRight.lat })
      .andWhere('group.lon >= :topLon', { topLon: topLeft.lon })
      .andWhere('group.lon <= :bottomLon', { bottomLon: bottomRight.lon })
      .getMany();

    if (groups.length > 0) {
      groups.forEach((group) => {
        if (!group.issues) group.issues = [];
        group.issues.push({ id: issue.id } as IssueEntity);
      });

      return await this.issueGroupsRepository.save(groups);
    }

    const group = this.issueGroupsRepository.create({
      lat: issue.lat,
      lon: issue.lon,
      type: {
        id: issue.type.id,
      },
      issues: [
        {
          id: issue.id,
        },
      ],
    });

    return await this.issueGroupsRepository.save(group);
  }

  async findAllGroups() {
    return await this.issueGroupsRepository.find({
      relations: ['type', 'issues'],
    });
  }

  async findAll() {
    return await this.issueRepository.find({
      relations: ['type', 'type.category', 'user', 'file'],
    });
  }

  async findOne(id: number) {
    return await this.issueRepository.findOne({
      relations: ['type', 'type.category', 'user', 'file'],
      where: {
        id,
      },
    });
  }

  async findOneOrFail(id: number) {
    const issue = await this.findOne(id);

    if (!issue) {
      throw new BadRequestException(IssueErrorCodes.IssueNotFoundError);
    }

    return issue;
  }
}
