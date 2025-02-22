import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { nanoid } from 'nanoid';

import { CreateSensorDto, UpdateSensorDto } from './dto';
import { SensorEntity } from './entities';
import { SensorErrorCodes } from './errors';

@Injectable()
export class SensorsService {
  constructor(
    @InjectRepository(SensorEntity)
    private sensorRepository: Repository<SensorEntity>,
  ) {}

  async create(dto: CreateSensorDto) {
    const secret = nanoid(10);
    const sensor = this.sensorRepository.create({
      ...dto,
      secret,
    });

    const sensorEntity = await this.sensorRepository.save(sensor);

    return {
      sensor: sensorEntity,
      secret,
    };
  }

  async findAll() {
    return await this.sensorRepository.find();
  }

  async findOne(id: number) {
    return await this.sensorRepository.findOne({
      where: { id },
    });
  }

  async findOneOrFail(id: number) {
    const sensor = await this.findOne(id);

    if (!sensor) {
      throw new BadRequestException(SensorErrorCodes.SensorNotFoundErrorCode);
    }

    return sensor;
  }

  async update(id: number, dto: UpdateSensorDto) {
    const sensor = await this.findOneOrFail(id);

    return await this.sensorRepository.save({
      ...sensor,
      ...dto,
    });
  }

  async remove(id: number) {
    const sensor = await this.findOneOrFail(id);

    return await this.sensorRepository.remove(sensor);
  }
}
