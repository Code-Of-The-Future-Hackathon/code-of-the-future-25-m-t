import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsNumber } from 'class-validator';

import { GroupStatusEnum } from '../enums';

export class ChangeStatusDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  id: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsEnum(GroupStatusEnum)
  status: GroupStatusEnum;
}
