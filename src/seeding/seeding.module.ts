import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from 'src/users/entities';

import { SeedingService } from './seeding.service';
import { CategoryEntity } from 'src/categories/entities';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity, CategoryEntity])],
  providers: [SeedingService],
  exports: [SeedingService],
})
export class SeedingModule {}
