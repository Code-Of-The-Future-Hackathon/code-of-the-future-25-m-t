import { MigrationInterface, QueryRunner } from "typeorm";

export class IssueUser1740170265772 implements MigrationInterface {
    name = 'IssueUser1740170265772'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" ADD "userId" uuid`);
        await queryRunner.query(`ALTER TABLE "issue" ADD CONSTRAINT "FK_9ec9992868e098e4e861a1aa9df" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" DROP CONSTRAINT "FK_9ec9992868e098e4e861a1aa9df"`);
        await queryRunner.query(`ALTER TABLE "issue" DROP COLUMN "userId"`);
    }

}
