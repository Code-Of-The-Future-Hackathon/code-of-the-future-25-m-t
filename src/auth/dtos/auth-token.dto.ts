import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class AuthTokenDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  token: string;
}
