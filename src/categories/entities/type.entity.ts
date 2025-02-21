import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import { IssueEntity } from 'src/issues/entities';

import { CategoryEntity } from './category.entity';

@Entity('type')
export class TypeEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @ManyToOne(() => CategoryEntity, (category) => category.types)
  category: CategoryEntity;

  @OneToMany(() => IssueEntity, (issue) => issue.type)
  issues: IssueEntity[];
}
