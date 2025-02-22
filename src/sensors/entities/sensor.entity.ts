import { Exclude } from 'class-transformer';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('sensor')
export class SensorEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  lat: number;

  @Column()
  lon: number;

  @Column()
  alias: string;

  @Column()
  @Exclude()
  secret: string;
}
