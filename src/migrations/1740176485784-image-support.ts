import { MigrationInterface, QueryRunner } from "typeorm";

export class ImageSupport1740176485784 implements MigrationInterface {
    name = 'ImageSupport1740176485784'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "category" ADD "supportsImages" boolean NOT NULL DEFAULT true`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "category" DROP COLUMN "supportsImages"`);
    }

}
