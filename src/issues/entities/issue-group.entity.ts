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

import { IssueEntity } from './issue.entity';

@Entity('issue_group')
export class IssueGroupEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  address: string;

  @Column({
    type: 'real',
  })
  lat: number;

  @Column({
    type: 'real',
  })
  lon: number;

  @ManyToOne(() => TypeEntity, (type) => type.groups)
  type: TypeEntity;

  @ManyToMany(() => IssueEntity, (issue) => issue.groups)
  @JoinTable()
  issues: IssueEntity[];

  @CreateDateColumn()
  createdAt: Date;
}
