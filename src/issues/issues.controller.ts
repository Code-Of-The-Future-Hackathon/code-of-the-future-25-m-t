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
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard, RolesGuard } from 'src/auth/guards';
import { RequestWithUser, UserRoles } from 'src/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Role } from 'src/auth/decorators';

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

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.issuesService.findOneGroup(+id);
  }

  @ApiBearerAuth('AccessToken')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Role(UserRoles.Admin)
  @Patch('/status/:id')
  async changeStatus(@Param('id') id: string, @Query() dto: ChangeStatusDto) {
    return await this.issuesService.changeStatus(+id, dto);
  }
}
