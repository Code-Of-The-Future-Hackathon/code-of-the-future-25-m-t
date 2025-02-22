import { Exclude } from 'class-transformer';
import { IssueEntity } from 'src/issues/entities';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

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

  @OneToMany(() => IssueEntity, (issue) => issue.user)
  issues: IssueEntity[];
}
