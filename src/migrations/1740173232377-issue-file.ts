import { MigrationInterface, QueryRunner } from "typeorm";

export class IssueFile1740173232377 implements MigrationInterface {
    name = 'IssueFile1740173232377'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" ADD "fileId" integer`);
        await queryRunner.query(`ALTER TABLE "issue" ADD CONSTRAINT "UQ_d529d98ac34525d3ee7beb221fa" UNIQUE ("fileId")`);
        await queryRunner.query(`ALTER TABLE "issue" ADD CONSTRAINT "FK_d529d98ac34525d3ee7beb221fa" FOREIGN KEY ("fileId") REFERENCES "file"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" DROP CONSTRAINT "FK_d529d98ac34525d3ee7beb221fa"`);
        await queryRunner.query(`ALTER TABLE "issue" DROP CONSTRAINT "UQ_d529d98ac34525d3ee7beb221fa"`);
        await queryRunner.query(`ALTER TABLE "issue" DROP COLUMN "fileId"`);
    }

}
