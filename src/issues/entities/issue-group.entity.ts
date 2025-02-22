import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToMany,
  JoinTable,
  CreateDateColumn,
  ManyToOne,
} from 'typeorm';
import { TypeEntity } from 'src/categories/entities';

import { GroupStatusEnum, ReporterEnum } from '../enums';

import { IssueEntity } from './issue.entity';

@Entity('issue_group')
export class IssueGroupEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  address?: string;

  @Column({
    type: 'real',
  })
  lat: number;

  @Column({
    type: 'real',
  })
  lon: number;

  @Column({
    type: 'enum',
    enum: ReporterEnum,
    default: ReporterEnum.User,
  })
  reporter: ReporterEnum;

  @Column({
    type: 'enum',
    enum: GroupStatusEnum,
    default: GroupStatusEnum.Active,
  })
  status: GroupStatusEnum;

  @ManyToOne(() => TypeEntity, (type) => type.groups)
  type: TypeEntity;

  @ManyToMany(() => IssueEntity, (issue) => issue.groups)
  @JoinTable()
  issues: IssueEntity[];

  @CreateDateColumn()
  createdAt: Date;
}
