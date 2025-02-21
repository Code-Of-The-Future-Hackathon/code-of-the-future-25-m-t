import { MigrationInterface, QueryRunner } from "typeorm";

export class CategoryTypes1740166249144 implements MigrationInterface {
    name = 'CategoryTypes1740166249144'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "type" ("id" SERIAL NOT NULL, "title" character varying NOT NULL, "categoryId" integer, CONSTRAINT "PK_40410d6bf0bedb43f9cadae6fef" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "type" ADD CONSTRAINT "FK_646fda6e87f34326aed5c9de5e7" FOREIGN KEY ("categoryId") REFERENCES "category"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "type" DROP CONSTRAINT "FK_646fda6e87f34326aed5c9de5e7"`);
        await queryRunner.query(`DROP TABLE "type"`);
    }

}
