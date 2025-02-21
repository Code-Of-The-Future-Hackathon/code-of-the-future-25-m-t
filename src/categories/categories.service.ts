import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CategoryEntity } from './entities';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(CategoryEntity)
    private readonly categoriesRepository: Repository<CategoryEntity>,
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
}
