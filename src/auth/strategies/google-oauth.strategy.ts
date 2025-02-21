import { PassportStrategy } from '@nestjs/passport';
import { Strategy, VerifyCallback } from 'passport-google-oauth20';
import { Injectable } from '@nestjs/common';

import { AuthErrorCodes } from '../errors';

@Injectable()
export class GoogleOAuthStrategy extends PassportStrategy(Strategy, 'google') {
  constructor() {
    super({
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: process.env.GOOGLE_CALLBACK_URL,
      scope: ['email', 'profile'],
    });
  }

  async validate(
    _: string,
    __: string,
    profile: any,
    done: VerifyCallback,
  ): Promise<any> {
    try {
      const { id, emails } = profile;

      if (!emails || emails.length === 0) {
        return done(new Error(AuthErrorCodes.NoEmailFoundError), null);
      }

      const user = {
        id,
        email: emails[0].value,
      };

      return done(null, user);
    } catch (error) {
      return done(error, null);
    }
  }
}
