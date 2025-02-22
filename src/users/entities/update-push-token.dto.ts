import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class UpdatePushTokenDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  pushToken: string;
}
