import { MigrationInterface, QueryRunner } from "typeorm";

export class IssueResolverField1740258034806 implements MigrationInterface {
    name = 'IssueResolverField1740258034806'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" ADD "resolverId" uuid`);
        await queryRunner.query(`ALTER TABLE "issue_group" ADD CONSTRAINT "FK_d554274d08f15316021377d44c0" FOREIGN KEY ("resolverId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" DROP CONSTRAINT "FK_d554274d08f15316021377d44c0"`);
        await queryRunner.query(`ALTER TABLE "issue_group" DROP COLUMN "resolverId"`);
    }

}
