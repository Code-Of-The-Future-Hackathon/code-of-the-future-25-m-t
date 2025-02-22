import {
  Body,
  Controller,
  Get,
  Patch,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard, RolesGuard } from 'src/auth/guards';
import { RequestWithUser } from 'src/common';

import { UsersService } from './users.service';
import { UpdatePushTokenDto } from './entities';

@ApiTags('Users')
@ApiBearerAuth('AccessToken')
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  async getMe(@Request() req: RequestWithUser) {
    return req.user;
  }

  @Patch('push-token')
  async updatePushToken(
    @Request() req: RequestWithUser,
    @Body() dto: UpdatePushTokenDto,
  ) {
    return await this.usersService.updatePushToken(req.user, dto);
  }
}
