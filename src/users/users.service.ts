import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RegisterDto } from 'src/auth/dtos';
import { nanoid } from 'nanoid';
import { NotificationsService } from 'src/notifications/notifications.service';

import { UpdatePushTokenDto, UserEntity } from './entities';
import { UserErrorCodes } from './errors';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly usersRepository: Repository<UserEntity>,
    private readonly notificationsService: NotificationsService,
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
      title: this.mapUserTitle(0),
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
      title: this.mapUserTitle(0),
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
      title: this.mapUserTitle(0),
    });

    return await this.usersRepository.save(user);
  }

  async createAppleUser(email: string, appleId: string) {
    if (await this.checkEmail(email)) {
      throw new BadRequestException(
        UserErrorCodes.UserWithThisEmailAlreadyCreatedError,
      );
    }

    const user = this.usersRepository.create({
      email,
      appleId,
      title: this.mapUserTitle(0),
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

  async findOneByAppleIdOrEmail(appleId: string, email: string) {
    return await this.usersRepository
      .createQueryBuilder()
      .where('"appleId" = :appleId OR email = :email', { appleId, email })
      .getOne();
  }

  async updateGoogleUser(userId: string, googleId: string, email: string) {
    return await this.usersRepository.update(userId, {
      googleId,
      email,
    });
  }

  async updateAppleUser(userId: string, appleId: string, email: string) {
    return await this.usersRepository.update(userId, {
      appleId,
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

  constructNotifications(user: UserEntity, prevTitle: string, points: number) {
    const messages = [
      {
        title: 'Issue Resolved',
        body: `You earned ${points} points`,
      },
    ];

    if (prevTitle !== user.title) {
      messages.push({
        title: 'New Title Unlocked',
        body: `You are now a ${user.title}`,
      });
    }

    return messages;
  }

  async incrUserPoints(user: UserEntity, points: number) {
    const prevTitle = user.title;

    user.points += points;
    user.title = this.mapUserTitle(user.points);

    await this.notificationsService.sendMessages(
      this.constructNotifications(user, prevTitle, points),
      user.pushToken,
    );

    return await this.usersRepository.save(user);
  }

  mapUserTitle(points: number) {
    return (
      this.getTitleMappings().find((mapping) => points >= mapping.points)
        ?.title || 'Beginner'
    );
  }

  getTitleMappings() {
    return [
      { points: 1000, title: 'City Changemaker' },
      { points: 900, title: 'Urban Champion' },
      { points: 800, title: 'Watchdog' },
      { points: 700, title: 'Metropolis Defender' },
      { points: 600, title: 'City Guardian' },
      { points: 500, title: 'Neighborhood Sentinel' },
      { points: 400, title: 'Street Protector' },
      { points: 300, title: 'Wayfinder' },
      { points: 200, title: 'Community Observer' },
      { points: 100, title: 'Local Reporter' },
      { points: 0, title: 'Newcomer' },
    ].sort((a, b) => b.points - a.points);
  }

  async updatePushToken(user: UserEntity, dto: UpdatePushTokenDto) {
    return await this.usersRepository.update(user.id, {
      pushToken: dto.pushToken,
    });
  }
}
