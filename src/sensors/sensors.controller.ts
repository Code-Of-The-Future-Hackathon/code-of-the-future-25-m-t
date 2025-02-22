import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeaders, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard, RolesGuard } from 'src/auth/guards';
import { Role } from 'src/auth/decorators';
import { UserRoles } from 'src/common';

import { SensorsService } from './sensors.service';
import { CreateSensorDto, UpdateSensorDto } from './dto';
import { SensorGuard } from 'src/auth/guards/sensor.guard';
import { Sensor } from 'src/auth/decorators/sensor.decorator';
import { CreateIssueDto } from 'src/issues/dto';
import { SensorEntity } from './entities';

@ApiTags('Sensors')
@ApiBearerAuth('AccessToken')
@Controller('sensors')
export class SensorsController {
  constructor(private readonly sensorsService: SensorsService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Post()
  async create(@Body() dto: CreateSensorDto) {
    return await this.sensorsService.create(dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Get()
  async findAll() {
    return await this.sensorsService.findAll();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.sensorsService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Patch(':id')
  async update(@Param('id') id: string, @Body() dto: UpdateSensorDto) {
    return await this.sensorsService.update(+id, dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Delete(':id')
  async remove(@Param('id') id: string) {
    return await this.sensorsService.remove(+id);
  }

  @Post('notify')
  @ApiHeaders([
    { name: 'x-sensor-secret', required: true },
    { name: 'x-sensor-id', required: true },
  ])
  @UseGuards(SensorGuard)
  async notify(@Body() dto: CreateIssueDto, @Sensor() sensor: SensorEntity) {
    return await this.sensorsService.notify(sensor, dto);
  }
}
