import { MigrationInterface, QueryRunner } from "typeorm";

export class AddressInfo1740220557887 implements MigrationInterface {
    name = 'AddressInfo1740220557887'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group" ADD "address" character varying NOT NULL`);
        await queryRunner.query(`ALTER TABLE "issue" ADD "address" character varying NOT NULL`);
        await queryRunner.query(`ALTER TABLE "issue" ALTER COLUMN "description" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" ALTER COLUMN "description" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "issue" DROP COLUMN "address"`);
        await queryRunner.query(`ALTER TABLE "issue_group" DROP COLUMN "address"`);
    }
}
