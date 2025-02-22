import { Module } from '@nestjs/common';
import { CategoriesModule } from 'src/categories/categories.module';

import { AiService } from './ai.service';

@Module({
  imports: [CategoriesModule],
  providers: [AiService],
  exports: [AiService],
})
export class AiModule {}
