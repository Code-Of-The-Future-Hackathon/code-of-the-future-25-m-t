import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { SensorsService } from './sensors.service';
import { SensorsController } from './sensors.controller';
import { SensorEntity } from './entities';

@Module({
  imports: [TypeOrmModule.forFeature([SensorEntity])],
  controllers: [SensorsController],
  providers: [SensorsService],
  exports: [SensorsService],
})
export class SensorsModule {}
