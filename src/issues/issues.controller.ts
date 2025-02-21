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
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { JwtAuthGuard } from 'src/auth/guards';
import { RequestWithUser } from 'src/common';
import { FileInterceptor } from '@nestjs/platform-express';

import { IssuesService } from './issues.service';
import { CreateIssueDto } from './dto';

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
  async findAll() {
    return await this.issuesService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return await this.issuesService.findOne(+id);
  }
}
