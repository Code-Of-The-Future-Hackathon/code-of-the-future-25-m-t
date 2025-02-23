import {
  Column,
  Entity,
  CreateDateColumn,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { Exclude } from 'class-transformer';
import { UserRoles } from 'src/common';
import { SessionEntity } from 'src/auth/entities';
import { IssueEntity, IssueGroupEntity } from 'src/issues/entities';

@Entity('user')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    nullable: true,
  })
  firstName: string;

  @Column({
    nullable: true,
  })
  lastName: string;

  @Column({
    nullable: true,
  })
  title?: string;

  @Column({
    unique: true,
  })
  email: string;

  @Exclude()
  @Column({
    nullable: true,
  })
  password: string;

  @Column({
    unique: true,
    nullable: true,
  })
  googleId: string;

  @Column({
    unique: true,
    nullable: true,
  })
  appleId: string;

  @Exclude()
  @Column({
    nullable: true,
  })
  pushToken: string;

  @Column({
    enum: UserRoles,
    default: UserRoles.User,
  })
  role: UserRoles;

  @Column({ default: false })
  isGuest: boolean;

  @Column({
    default: 0,
    type: 'int',
  })
  points: number;

  @OneToMany(() => SessionEntity, (session) => session.user, {
    nullable: true,
    cascade: true,
  })
  sessions: SessionEntity[];

  @OneToMany(() => IssueEntity, (issue) => issue.user)
  issues: IssueEntity[];

  @OneToMany(() => IssueGroupEntity, (issue) => issue.resolver)
  resolvedGroups: IssueGroupEntity[];

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: string;

  @UpdateDateColumn({ type: 'timestamptz' })
  updatedAt: string;
}
