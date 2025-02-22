import { MigrationInterface, QueryRunner } from "typeorm";

export class Sensors1740236483404 implements MigrationInterface {
    name = 'Sensors1740236483404'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "sensor" ("id" SERIAL NOT NULL, "lat" integer NOT NULL, "lon" integer NOT NULL, "alias" character varying NOT NULL, "secret" character varying NOT NULL, CONSTRAINT "PK_ccc38b9aa8b3e198b6503d5eee9" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "sensor"`);
    }

}
