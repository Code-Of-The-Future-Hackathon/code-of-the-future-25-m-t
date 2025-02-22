import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RegisterDto } from 'src/auth/dtos';
import { nanoid } from 'nanoid';

import { UserEntity } from './entities';
import { UserErrorCodes } from './errors';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly usersRepository: Repository<UserEntity>,
  ) {}

  async checkEmail(email: string) {
    return await this.usersRepository.exists({
      where: {
        email,
      },
    });
  }

  async createGuest() {
    const user = this.usersRepository.create({
      email: nanoid(10) + '@guest.com',
      password: nanoid(10),
      isGuest: true,
    });

    return await this.usersRepository.save(user);
  }

  async create(dto: RegisterDto) {
    if (await this.checkEmail(dto.email)) {
      throw new BadRequestException(
        UserErrorCodes.UserWithThisEmailAlreadyCreatedError,
      );
    }

    const user = this.usersRepository.create({
      ...dto,
    });

    return await this.usersRepository.save(user);
  }

  async createGoogleUser(email: string, googleId: string) {
    if (await this.checkEmail(email)) {
      throw new BadRequestException(
        UserErrorCodes.UserWithThisEmailAlreadyCreatedError,
      );
    }

    const user = this.usersRepository.create({
      email,
      googleId,
    });

    return await this.usersRepository.save(user);
  }

  async findOne(id: string) {
    return await this.usersRepository.findOne({
      where: {
        id,
      },
    });
  }

  async findOneOrFail(id: string) {
    const user = await this.findOne(id);

    if (!user) {
      throw new UnauthorizedException(UserErrorCodes.UserNotFoundError);
    }

    return user;
  }

  async findOneByEmail(email: string) {
    return await this.usersRepository.findOne({
      where: {
        email,
      },
    });
  }

  async findOneByEmailOrFail(email: string) {
    const user = await this.findOneByEmail(email);

    if (!user) {
      throw new UnauthorizedException(UserErrorCodes.UserNotFoundError);
    }

    return user;
  }

  async findOneByGoogleIdOrEmail(googleId: string, email: string) {
    return await this.usersRepository
      .createQueryBuilder()
      .where('"googleId" = :googleId OR email = :email', { googleId, email })
      .getOne();
  }

  async updateGoogleUser(userId: string, googleId: string, email: string) {
    return await this.usersRepository.update(userId, {
      googleId,
      email,
    });
  }

  async updateRefreshTokenVersion(userId: string) {
    return await this.usersRepository.increment(
      { id: userId },
      'refreshTokenVersion',
      1,
    );
  }

  async incrUserPoints(userId: string, points: number) {
    return await this.usersRepository.increment(
      { id: userId },
      'points',
      points,
    );
  }
}
