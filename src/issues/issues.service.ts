import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from 'src/users/entities';
import { CategoriesService } from 'src/categories/categories.service';
import { FilesService } from 'src/files/files.service';
import { FileEntity } from 'src/files/entities';

import { IssueEntity } from './entities';
import { CreateIssueDto } from './dto';
import { IssueErrorCodes } from './errors';

@Injectable()
export class IssuesService {
  constructor(
    @InjectRepository(IssueEntity)
    private readonly issueRepository: Repository<IssueEntity>,
    private readonly categoriesService: CategoriesService,
    private readonly filesService: FilesService,
  ) {}

  async create(
    user: UserEntity,
    dto: CreateIssueDto,
    file: Express.Multer.File,
  ) {
    let fileEntity: FileEntity | undefined;

    if (file) {
      fileEntity = await this.filesService.uploadFile(file);
    }

    const type = await this.categoriesService.findOneTypeOrFail(dto.typeId);
    const issue = this.issueRepository.create({
      ...dto,
      type: {
        id: type.id,
      },
      ...(fileEntity ? { file: { id: fileEntity.id } } : {}),
    });

    return await this.issueRepository.save(issue);
  }

  async findAll() {
    return await this.issueRepository.find({
      relations: ['type', 'user', 'file'],
    });
  }

  async findOne(id: number) {
    return await this.issueRepository.findOne({
      relations: ['type', 'user', 'file'],
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
