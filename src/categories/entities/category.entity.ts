import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';

import { TypeEntity } from './type.entity';

@Entity('category')
export class CategoryEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column()
  icon: string;

  @OneToMany(() => TypeEntity, (type) => type.category, {
    cascade: true,
  })
  types: TypeEntity[];
}
