import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
  UseInterceptors,
  UploadedFile,
  Query,
  Patch,
  Req,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard, RolesGuard } from 'src/auth/guards';
import { RequestWithUser, UserRoles } from 'src/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Role } from 'src/auth/decorators';
import { UserEntity } from 'src/users/entities';

import { IssuesService } from './issues.service';
import { ChangeStatusDto, CreateIssueDto, GetGroupsDto } from './dto';

@ApiTags('Issues')
@Controller('issues')
export class IssuesController {
  constructor(private readonly issuesService: IssuesService) {}

  @ApiBearerAuth('AccessToken')
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('file'))
  @Post()
  async create(
    @Request() req: RequestWithUser,
    @Body() dto: CreateIssueDto,
    @UploadedFile() file?: Express.Multer.File,
  ) {
    return await this.issuesService.create(req.user, dto, file);
  }

  @Get()
  async findAll(@Query() query: GetGroupsDto) {
    return await this.issuesService.findGroupsWithDetails(query);
  }

  @ApiBearerAuth('AccessToken')
  @UseGuards(JwtAuthGuard)
  @Get('active/self')
  async findSelf(@Request() req: RequestWithUser) {
    return await this.issuesService.findUserGroups(req.user);
  }

  @ApiBearerAuth('AccessToken')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Get('resolved/admin')
  async findAdmin(@Request() req: RequestWithUser) {
    return await this.issuesService.findUserResolvedIssues(req.user);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.issuesService.findOneGroup(+id);
  }

  @ApiBearerAuth('AccessToken')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Patch('/status')
  async changeStatus(
    @Query() dto: ChangeStatusDto,
    @Req() req: { user: UserEntity },
  ) {
    return await this.issuesService.changeStatus(req.user, dto);
  }
}
