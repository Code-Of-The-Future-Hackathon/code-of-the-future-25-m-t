import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  Request,
  UseGuards,
} from '@nestjs/common';
import { RequestWithUser } from 'src/common';
import { ApiBearerAuth, ApiBody, ApiTags } from '@nestjs/swagger';

import { GoogleOAuthGuard, LocalAuthGuard, RefreshAuthGuard } from './guards';
import {
  GoogleTokenDto,
  LoginDto,
  RegisterDto,
  RequestWithSession,
} from './dtos';
import { AuthService } from './auth.service';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() dto: RegisterDto) {
    return await this.authService.register(dto);
  }

  @Post('register-guest')
  async registerGuest() {
    return await this.authService.registerGuest();
  }

  @UseGuards(LocalAuthGuard)
  @ApiBody({ type: LoginDto })
  @Post('login')
  async login(@Request() req: RequestWithUser) {
    return await this.authService.login(req.user);
  }

  @Post('google-token-login')
  async googleTokenLogin(@Body() dto: GoogleTokenDto) {
    return await this.authService.googleTokenLogin(dto.token);
  }

  @ApiBearerAuth('RefreshToken')
  @UseGuards(RefreshAuthGuard)
  @Post('refresh')
  async refreshTokens(@Req() req: RequestWithSession) {
    return await this.authService.refreshTokens(req.user.session);
  }

  @Get('google')
  @UseGuards(GoogleOAuthGuard)
  async googleAuth() {}

  @Get('google-redirect')
  @UseGuards(GoogleOAuthGuard)
  async googleAuthRedirect(@Request() req: RequestWithUser) {
    return await this.authService.googleLoginOrCreateProfile(req.user);
  }
}
