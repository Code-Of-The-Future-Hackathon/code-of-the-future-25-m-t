import { MigrationInterface, QueryRunner } from "typeorm";

export class UserPoints1740159315054 implements MigrationInterface {
    name = 'UserPoints1740159315054'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" ADD "points" integer NOT NULL DEFAULT '0'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "points"`);
    }

}
