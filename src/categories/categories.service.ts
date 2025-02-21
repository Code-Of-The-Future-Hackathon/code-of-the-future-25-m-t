import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { CategoryEntity, TypeEntity } from './entities';
import { CategoryErrorCodes } from './errors';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoriesRepository: Repository<CategoryEntity>,
    @InjectRepository(TypeEntity)
    private readonly typesRepository: Repository<TypeEntity>,
  ) {}

  async getAll() {
    return await this.categoriesRepository.find({ relations: { types: true } });
  }

  async getById(id: number) {
    return await this.categoriesRepository.findOne({
      where: { id },
      relations: { types: true },
    });
  }

  async findOneType(id: number, loadCategory = false) {
    return await this.typesRepository.findOne({
      ...(loadCategory ? { relations: ['category'] } : {}),
      where: { id },
    });
  }

  async findOneTypeOrFail(typeId: number, loadCategory = false) {
    const type = await this.findOneType(typeId, loadCategory);

    if (!type) {
      throw new BadRequestException(CategoryErrorCodes.TypeNotFoundError);
    }

    return type;
  }

  async checkImageSupport(typeId: number, file: Express.Multer.File) {
    const type = await this.findOneTypeOrFail(typeId, true);

    if (file && !type.category.supportsImages) {
      throw new BadRequestException(CategoryErrorCodes.ImageNotSupportedError);
    }
  }
}
