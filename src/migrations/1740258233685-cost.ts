import { MigrationInterface, QueryRunner } from "typeorm";

export class Cost1740258233685 implements MigrationInterface {
    name = 'Cost1740258233685'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" ADD "costEstimates" jsonb`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" DROP COLUMN "costEstimates"`);
    }

}
