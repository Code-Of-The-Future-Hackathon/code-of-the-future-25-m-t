import { MigrationInterface, QueryRunner } from "typeorm";

export class AppleId1740271114480 implements MigrationInterface {
    name = 'AppleId1740271114480'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" ADD "appleId" character varying`);
        await queryRunner.query(`ALTER TABLE "user" ADD CONSTRAINT "UQ_909a03b328747bd46fc52eb66de" UNIQUE ("appleId")`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP CONSTRAINT "UQ_909a03b328747bd46fc52eb66de"`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "appleId"`);
    }

}
