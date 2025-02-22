import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty } from 'class-validator';

import { GroupStatusEnum } from '../enums';

export class ChangeStatusDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsEnum(GroupStatusEnum)
  status: GroupStatusEnum;
}
