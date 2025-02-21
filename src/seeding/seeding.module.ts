import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/users/entities';

import { SeedingService } from './seeding.service';
import { CategoryEntity, TypeEntity } from 'src/categories/entities';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity, CategoryEntity, TypeEntity])],
  providers: [SeedingService],
  exports: [SeedingService],
})
export class SeedingModule {}
