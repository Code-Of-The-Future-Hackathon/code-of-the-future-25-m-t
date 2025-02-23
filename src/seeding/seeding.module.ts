import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/users/entities';
import { CategoryEntity, TypeEntity } from 'src/categories/entities';

import { SeedingService } from './seeding.service';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity, CategoryEntity, TypeEntity])],
  providers: [SeedingService],
  exports: [SeedingService],
})
export class SeedingModule {}
