import { MigrationInterface, QueryRunner } from "typeorm";

export class GuestFlag1740169134670 implements MigrationInterface {
    name = 'GuestFlag1740169134670'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" ADD "isGuest" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "isGuest"`);
    }

}
