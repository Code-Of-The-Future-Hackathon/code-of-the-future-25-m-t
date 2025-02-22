import { MigrationInterface, QueryRunner } from "typeorm";

export class Users1740238084086 implements MigrationInterface {
    name = 'Users1740238084086'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" ADD "pushToken" character varying`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "pushToken"`);
    }

}
