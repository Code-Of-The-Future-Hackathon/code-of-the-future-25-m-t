import { MigrationInterface, QueryRunner } from "typeorm";

export class GroupStatus1740224404252 implements MigrationInterface {
    name = 'GroupStatus1740224404252'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."issue_group_status_enum" AS ENUM('ACTIVE', 'RESOLVED', 'EXPIRED')`);
        await queryRunner.query(`ALTER TABLE "issue_group" ADD "status" "public"."issue_group_status_enum" NOT NULL DEFAULT 'ACTIVE'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."issue_group_status_enum"`);
    }

}
