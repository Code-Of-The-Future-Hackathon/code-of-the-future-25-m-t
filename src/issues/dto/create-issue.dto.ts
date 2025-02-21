import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateIssueDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  description: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  lat: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  lon: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  typeId: number;
}
