import { BadRequestException, Injectable } from '@nestjs/common';
import { UsersService } from 'src/users/users.service';
import * as argon2 from 'argon2';
import { UserEntity } from 'src/users/entities';
import { JwtService } from '@nestjs/jwt';
import { UserErrorCodes } from 'src/users/errors';
import { OAuth2Client } from 'google-auth-library';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import ms from 'ms';
import { nanoid } from 'nanoid';

import { AuthErrorCodes } from './errors';
import { RegisterDto } from './dtos';
import { SessionEntity } from './entities';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    @InjectRepository(SessionEntity)
    private readonly sessionsRepository: Repository<SessionEntity>,
  ) {}

  async register(dto: RegisterDto) {
    const user = await this.usersService.create(dto);

    return await this.login(user);
  }

  async generateTokens(payload: any) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(payload, {
        secret: this.configService.get('JWT_ACCESS_SECRET'),
        expiresIn: this.configService.get('JWT_ACCESS_EXPIRES_IN'),
      }),
      this.jwtService.signAsync(payload, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
        expiresIn: this.configService.get('JWT_REFRESH_EXPIRES_IN'),
      }),
    ]);

    return { accessToken, refreshToken };
  }

  async refreshTokens(session: SessionEntity) {
    const tokens = await this.generateTokens({
      id: session?.user.id,
      email: session?.user.email,
      googleId: session?.user.googleId,
      sessionId: session?.id,
    });

    const expiresAt = new Date(
      Date.now() + ms(this.configService.get('JWT_REFRESH_EXPIRES_IN')),
    );

    await this.sessionsRepository.update(session, {
      expiresAt,
      refreshToken: tokens.refreshToken,
    });

    return tokens;
  }

  async createSession(
    sessionId: string,
    user: UserEntity,
    refreshToken: string,
  ) {
    const session = this.sessionsRepository.create({
      id: sessionId,
      user,
      refreshToken: refreshToken,
      expiresAt: new Date(
        Date.now() + ms(this.configService.get('JWT_REFRESH_EXPIRES_IN')),
      ),
    });

    return await this.sessionsRepository.save(session);
  }

  async login(user: UserEntity) {
    const sessionId = nanoid();

    const payload = {
      id: user.id,
      email: user.email,
      googleId: user.googleId,
      sessionId,
    };

    const tokens = await this.generateTokens(payload);

    await this.createSession(sessionId, user, tokens.refreshToken);

    return tokens;
  }

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.usersService.findOneByEmailOrFail(email);

    if (await argon2.verify(user.password, password)) {
      return user;
    }
    return null;
  }

  async googleLoginOrCreateProfile(user: UserEntity) {
    if (!user) {
      throw new BadRequestException(UserErrorCodes.UserNotFoundError);
    }

    const databaseUser = await this.usersService.findOneByGoogleIdOrEmail(
      user.id,
      user.email,
    );

    if (databaseUser) {
      await this.usersService.updateGoogleUser(
        databaseUser.id,
        user.id,
        user.email,
      );

      return this.login(databaseUser);
    }

    const newUser = await this.usersService.createGoogleUser(
      user.email,
      user.id,
    );

    return this.login(newUser);
  }

  async googleTokenLogin(token: string) {
    try {
      const client = new OAuth2Client();

      const ticket = await client.verifyIdToken({
        idToken: token,
        audience: [
          this.configService.get('GOOGLE_CLIENT_ID'),
          this.configService.get('GOOGLE_ANDROID_CLIENT_ID'),
          this.configService.get('GOOGLE_IOS_CLIENT_ID'),
        ],
      });

      const payload = ticket.getPayload();

      const user = {
        id: payload.sub,
        email: payload.email,
      } as UserEntity;

      return await this.googleLoginOrCreateProfile(user);
    } catch (e) {
      console.error(e);
      throw new BadRequestException(AuthErrorCodes.GoogleTokenInvalidError);
    }
  }
}
