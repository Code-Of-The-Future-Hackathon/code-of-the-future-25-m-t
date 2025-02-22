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
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard, RolesGuard } from 'src/auth/guards';
import { Role } from 'src/auth/decorators';
import { UserRoles } from 'src/common';

import { SensorsService } from './sensors.service';
import { CreateSensorDto, UpdateSensorDto } from './dto';

@ApiTags('Sensors')
@ApiBearerAuth('AccessToken')
@UseGuards(JwtAuthGuard, RolesGuard)
@Role(UserRoles.Admin)
@Controller('sensors')
export class SensorsController {
  constructor(private readonly sensorsService: SensorsService) {}

  @Post()
  async create(@Body() dto: CreateSensorDto) {
    return await this.sensorsService.create(dto);
  }

  @Get()
  async findAll() {
    return await this.sensorsService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.sensorsService.findOne(+id);
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() dto: UpdateSensorDto) {
    return await this.sensorsService.update(+id, dto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    return await this.sensorsService.remove(+id);
  }
}
