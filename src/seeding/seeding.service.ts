import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryEntity } from 'src/categories/entities';
import { UserRoles } from 'src/common';
import { UserEntity } from 'src/users/entities';
import { Repository } from 'typeorm';

@Injectable()
export class SeedingService {
  private readonly logger = new Logger(SeedingService.name);

  constructor(
    @InjectRepository(UserEntity)
    private readonly usersRepository: Repository<UserEntity>,
    @InjectRepository(CategoryEntity)
    private readonly categoriesRepository: Repository<CategoryEntity>,
    private readonly configService: ConfigService,
  ) {}

  async seed() {
    this.logger.log('Seeding started');

    await this.seedCategories();

    const isAdminExists = await this.usersRepository.findOne({
      where: {
        email: this.configService.get<string>('DEFAULT_ADMIN_ADDRESS'),
      },
    });

    if (isAdminExists) {
      this.logger.log('Admin user already exists');
      return;
    }

    this.logger.log('Seeding admin user');
    await this.usersRepository.save({
      email: this.configService.get<string>('DEFAULT_ADMIN_ADDRESS'),
      password: this.configService.get<string>('DEFAULT_ADMIN_PASSWORD'),
      role: UserRoles.Admin,
    });

    this.logger.log('Admin user seeded');
    this.logger.log('Seeding complete');
  }

  async seedCategories() {
    const categories = [
      { title: 'Roads & Sidewalks', icon: '🛣️' },
      { title: 'Streetlights & Electrical', icon: '💡' },
      { title: 'Traffic & Signals', icon: '🚦' },
      { title: 'Water & Sewer', icon: '🚰' },
      { title: 'Waste Management', icon: '♻️' },
      { title: 'Public Infrastructure', icon: '🏗️' },
      { title: 'Internet & Telecommunications', icon: '📡' },
      { title: 'Safety Hazards', icon: '🛑' },
      { title: 'Public Transport', icon: '🚇' },
      { title: 'Health & Sanitation', icon: '🦠' },
      { title: 'Animal-Related Issues', icon: '🐾' },
    ];

    for (const category of categories) {
      const exists = await this.categoriesRepository.findOne({
        where: { title: category.title },
      });
      if (!exists) {
        await this.categoriesRepository.save(category);
        this.logger.log(`Category '${category.title}' seeded.`);
      } else {
        this.logger.log(
          `Category '${category.title}' already exists, skipping.`,
        );
      }
    }
  }
}
