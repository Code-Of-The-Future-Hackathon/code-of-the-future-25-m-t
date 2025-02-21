import { ClassSerializerInterceptor, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SwaggerModule } from '@nestjs/swagger';
import { PassportModule } from '@nestjs/passport';
import { APP_INTERCEPTOR } from '@nestjs/core';

import { UsersModule } from './users/users.module';
import { typeOrmAsyncConfig } from './config';
import { AuthModule } from './auth/auth.module';
import { SeedingModule } from './seeding/seeding.module';
import { CategoriesModule } from './categories/categories.module';
import { FilesModule } from './files/files.module';
import { IssuesModule } from './issues/issues.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync(typeOrmAsyncConfig),
    PassportModule,
    SwaggerModule,
    UsersModule,
    CategoriesModule,
    AuthModule,
    SeedingModule,
    FilesModule,
    IssuesModule,
  ],
  controllers: [],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: ClassSerializerInterceptor,
    },
  ],
})
export class AppModule {}
