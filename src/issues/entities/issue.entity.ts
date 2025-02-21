import { TypeEntity } from 'src/categories/entities';
import { FileEntity } from 'src/files/entities';
import { UserEntity } from 'src/users/entities';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('issue')
export class IssueEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  description: string;

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

  @ManyToOne(() => UserEntity, (user) => user.issues)
  user: UserEntity;

  @CreateDateColumn()
  created: Date;
}
