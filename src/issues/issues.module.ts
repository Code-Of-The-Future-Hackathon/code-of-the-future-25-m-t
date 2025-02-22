import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CategoriesModule } from 'src/categories/categories.module';
import { FilesModule } from 'src/files/files.module';
import { UsersModule } from 'src/users/users.module';

import { IssuesService } from './issues.service';
import { IssuesController } from './issues.controller';
import { IssueEntity, IssueGroupEntity } from './entities';

@Module({
  imports: [
    TypeOrmModule.forFeature([IssueEntity, IssueGroupEntity]),
    CategoriesModule,
    FilesModule,
    UsersModule,
  ],
  controllers: [IssuesController],
  providers: [IssuesService],
  exports: [IssuesService],
})
export class IssuesModule {}
