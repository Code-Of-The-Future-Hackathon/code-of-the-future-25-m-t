import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryEntity, TypeEntity } from 'src/categories/entities';
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
    @InjectRepository(TypeEntity)
    private readonly typesRepository: Repository<TypeEntity>,
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
      {
        title: 'Roads & Sidewalks',
        icon: '🛣️',
        types: [
          'Potholes',
          'Sidewalk Cracks or Uneven Pavement',
          'Road Blockages',
          'Flooded Roads',
          'Faded or Missing Road Markings',
        ],
      },
      {
        title: 'Streetlights & Electrical',
        icon: '💡',
        types: [
          'Streetlight Malfunctions',
          'Exposed Electrical Wires',
          'Public EV Charging Station Issues',
        ],
      },
      {
        title: 'Traffic & Signals',
        icon: '🚦',
        types: [
          'Traffic Signal Malfunctions',
          'Missing or Damaged Road Signs',
          'Overgrown Vegetation Blocking Traffic Signs',
        ],
      },
      {
        title: 'Water & Sewer',
        icon: '🚰',
        types: ['Water Leaks', 'Sewage Issues', 'Fire Hydrant Issues'],
      },
      {
        title: 'Waste Management',
        icon: '♻️',
        types: [
          'Illegal Dumping',
          'Overflowing Trash Bins',
          'Recycling Bin Issues',
        ],
      },
      {
        title: 'Public Infrastructure',
        icon: '🏗️',
        types: [
          'Public Property Damage',
          'Damaged Benches or Seating',
          'Broken Fountains or Public Water Dispensers',
          'Bridge or Overpass Structural Damage',
        ],
      },
      {
        title: 'Internet & Telecommunications',
        icon: '📡',
        types: ['Public WiFi Not Working', 'Cell Tower Issues'],
      },
      {
        title: 'Safety Hazards',
        icon: '🛑',
        types: [
          'Gas Leak',
          'Unsafe Areas',
          'Fallen Trees or Large Branches',
          'Damaged Guardrails or Safety Barriers',
        ],
      },
      {
        title: 'Public Transport',
        icon: '🚇',
        types: [
          'Bus Stop or Train Station Issues',
          'Public Transport Delays or Service Interruptions',
          'Bike or Scooter Share Issues',
        ],
      },
      {
        title: 'Health & Sanitation',
        icon: '🦠',
        types: [
          'Public Restroom Issues',
          'Standing Water & Mosquito Breeding Sites',
          'Dead Animals on Roads',
        ],
      },
      {
        title: 'Animal-Related Issues',
        icon: '🐾',
        types: [
          'Stray Animals',
          'Injured or Dead Animals on Roads',
          'Pest Infestation Reports',
        ],
      },
    ];

    const existingCategories = await this.categoriesRepository.find();
    const existingCategoryTitles = new Set(
      existingCategories.map((c) => c.title),
    );

    for (const category of categories) {
      if (existingCategoryTitles.has(category.title)) {
        this.logger.log(
          `Category '${category.title}' already exists, skipping.`,
        );
        continue;
      }

      const newCategory = await this.categoriesRepository.save({
        title: category.title,
        icon: category.icon,
      });
      const types = category.types.map((typeTitle) => ({
        title: typeTitle,
        category: newCategory,
      }));
      await this.typesRepository.save(types);
      this.logger.log(`Category '${category.title}' and its types seeded.`);
    }
  }
}
