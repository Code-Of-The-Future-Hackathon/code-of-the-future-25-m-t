import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

export class GetGroupsDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  lat: number;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  lon: number;

  @ApiProperty({ description: 'Radius in meters' })
  @IsNotEmpty()
  @IsNumber()
  @Type(() => Number)
  radius: number;

  @ApiProperty()
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  categoryId?: number;
}
