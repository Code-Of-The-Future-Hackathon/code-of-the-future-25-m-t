import { TypeEntity } from 'src/categories/entities';
import { FileEntity } from 'src/files/entities';
import { UserEntity } from 'src/users/entities';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { SensorEntity } from 'src/sensors/entities';

import { IssueGroupEntity } from './issue-group.entity';

@Entity('issue')
export class IssueEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  address?: string;

  @Column({ nullable: true })
  description?: string;

  @Column({
    type: 'real',
  })
  lat: number;

  @Column({
    type: 'real',
  })
  lon: number;

  @OneToOne(() => FileEntity, (file) => file.issue, {
    nullable: true,
    cascade: true,
  })
  @JoinColumn()
  file: FileEntity;

  @ManyToOne(() => TypeEntity, (type) => type.issues)
  type: TypeEntity;

  @ManyToOne(() => UserEntity, (user) => user.issues, {
    nullable: true,
    cascade: true,
  })
  user?: UserEntity;

  @ManyToOne(() => SensorEntity, (sensor) => sensor.issues, {
    nullable: true,
    cascade: true,
  })
  sensor?: SensorEntity;

  @ManyToMany(() => IssueGroupEntity, (issueGroup) => issueGroup.issues)
  @JoinTable()
  groups: IssueGroupEntity[];

  @CreateDateColumn()
  createdAt: Date;
}
