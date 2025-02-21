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

  async findOneType(id: number) {
    return await this.typesRepository.findOne({
      where: { id },
    });
  }

  async findOneTypeOrFail(typeId: number) {
    const type = await this.findOneType(typeId);

    if (!type) {
      throw new BadRequestException(CategoryErrorCodes.TypeNotFoundError);
    }

    return type;
  }
}
