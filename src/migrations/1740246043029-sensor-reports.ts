import { MigrationInterface, QueryRunner } from "typeorm";

export class SensorReports1740246043029 implements MigrationInterface {
    name = 'SensorReports1740246043029'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" ADD "sensorId" integer`);
        await queryRunner.query(`CREATE TYPE "public"."issue_group_reporter_enum" AS ENUM('USER', 'SENSOR', 'ALL')`);
        await queryRunner.query(`ALTER TABLE "issue_group" ADD "reporter" "public"."issue_group_reporter_enum" NOT NULL DEFAULT 'USER'`);
        await queryRunner.query(`ALTER TABLE "issue" ADD CONSTRAINT "FK_e3bec35db4e754e4f24f1287e25" FOREIGN KEY ("sensorId") REFERENCES "sensor"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" DROP CONSTRAINT "FK_e3bec35db4e754e4f24f1287e25"`);
        await queryRunner.query(`ALTER TABLE "issue_group" DROP COLUMN "reporter"`);
        await queryRunner.query(`DROP TYPE "public"."issue_group_reporter_enum"`);
        await queryRunner.query(`ALTER TABLE "issue" DROP COLUMN "sensorId"`);
    }

}
