import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { SensorsService } from './sensors.service';
import { SensorsController } from './sensors.controller';
import { SensorEntity } from './entities';
import { IssuesModule } from 'src/issues/issues.module';

@Module({
  imports: [TypeOrmModule.forFeature([SensorEntity]), IssuesModule],
  controllers: [SensorsController],
  providers: [SensorsService],
  exports: [SensorsService],
})
export class SensorsModule {}
