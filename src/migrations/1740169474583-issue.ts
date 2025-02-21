import { MigrationInterface, QueryRunner } from "typeorm";

export class Issue1740169474583 implements MigrationInterface {
    name = 'Issue1740169474583'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "issue" ("id" SERIAL NOT NULL, "description" character varying NOT NULL, "lat" real NOT NULL, "lon" real NOT NULL, "created" TIMESTAMP NOT NULL DEFAULT now(), "typeId" integer, CONSTRAINT "PK_f80e086c249b9f3f3ff2fd321b7" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "issue" ADD CONSTRAINT "FK_9c4834e0a4c2b4df6bdb909963c" FOREIGN KEY ("typeId") REFERENCES "type"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" DROP CONSTRAINT "FK_9c4834e0a4c2b4df6bdb909963c"`);
        await queryRunner.query(`DROP TABLE "issue"`);
    }

}
