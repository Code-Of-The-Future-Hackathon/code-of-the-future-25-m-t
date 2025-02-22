import { MigrationInterface, QueryRunner } from "typeorm";

export class UserTitle1740233811118 implements MigrationInterface {
    name = 'UserTitle1740233811118'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" ADD "title" character varying`);
        await queryRunner.query(`ALTER TABLE "issue" ALTER COLUMN "address" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "issue_group" ALTER COLUMN "address" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" ALTER COLUMN "address" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "issue" ALTER COLUMN "address" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "title"`);
    }

}
