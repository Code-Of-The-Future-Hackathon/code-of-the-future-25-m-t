import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsNotEmpty, IsNumber, IsOptional } from 'class-validator';

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

  @ApiProperty({ required: false })
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  categoryId?: number;

  @ApiProperty({
    required: false,
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  self?: boolean;

  @ApiProperty({
    required: false,
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  resolvedByMe?: boolean;

  @ApiProperty({
    required: false,
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  sort?: boolean;
}
