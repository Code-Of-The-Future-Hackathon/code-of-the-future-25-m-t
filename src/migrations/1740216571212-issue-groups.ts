import { MigrationInterface, QueryRunner } from "typeorm";

export class IssueGroups1740216571212 implements MigrationInterface {
    name = 'IssueGroups1740216571212'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue" RENAME COLUMN "created" TO "createdAt"`);
        await queryRunner.query(`CREATE TABLE "issue_group" ("id" SERIAL NOT NULL, "lat" real NOT NULL, "lon" real NOT NULL, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "typeId" integer, CONSTRAINT "PK_715387a5ade060ce40f392a7a92" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "issue_groups_issue_group" ("issueId" integer NOT NULL, "issueGroupId" integer NOT NULL, CONSTRAINT "PK_f4261df5acfc954e5182a1ddb3d" PRIMARY KEY ("issueId", "issueGroupId"))`);
        await queryRunner.query(`CREATE INDEX "IDX_4dc8b5a77d4f85026e70f35a5c" ON "issue_groups_issue_group" ("issueId") `);
        await queryRunner.query(`CREATE INDEX "IDX_cfc248d1abaade5caf8d4869b3" ON "issue_groups_issue_group" ("issueGroupId") `);
        await queryRunner.query(`CREATE TABLE "issue_group_issues_issue" ("issueGroupId" integer NOT NULL, "issueId" integer NOT NULL, CONSTRAINT "PK_79278ec45c666677864f8f15755" PRIMARY KEY ("issueGroupId", "issueId"))`);
        await queryRunner.query(`CREATE INDEX "IDX_fc48896b0d0558e8937d32ba17" ON "issue_group_issues_issue" ("issueGroupId") `);
        await queryRunner.query(`CREATE INDEX "IDX_2732e443d620e345aed091dc0b" ON "issue_group_issues_issue" ("issueId") `);
        await queryRunner.query(`ALTER TABLE "issue_group" ADD CONSTRAINT "FK_5a2393a8dca622c74ff8624617b" FOREIGN KEY ("typeId") REFERENCES "type"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "issue_groups_issue_group" ADD CONSTRAINT "FK_4dc8b5a77d4f85026e70f35a5ca" FOREIGN KEY ("issueId") REFERENCES "issue"("id") ON DELETE CASCADE ON UPDATE CASCADE`);
        await queryRunner.query(`ALTER TABLE "issue_groups_issue_group" ADD CONSTRAINT "FK_cfc248d1abaade5caf8d4869b3a" FOREIGN KEY ("issueGroupId") REFERENCES "issue_group"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "issue_group_issues_issue" ADD CONSTRAINT "FK_fc48896b0d0558e8937d32ba17b" FOREIGN KEY ("issueGroupId") REFERENCES "issue_group"("id") ON DELETE CASCADE ON UPDATE CASCADE`);
        await queryRunner.query(`ALTER TABLE "issue_group_issues_issue" ADD CONSTRAINT "FK_2732e443d620e345aed091dc0b2" FOREIGN KEY ("issueId") REFERENCES "issue"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "issue_group_issues_issue" DROP CONSTRAINT "FK_2732e443d620e345aed091dc0b2"`);
        await queryRunner.query(`ALTER TABLE "issue_group_issues_issue" DROP CONSTRAINT "FK_fc48896b0d0558e8937d32ba17b"`);
        await queryRunner.query(`ALTER TABLE "issue_groups_issue_group" DROP CONSTRAINT "FK_cfc248d1abaade5caf8d4869b3a"`);
        await queryRunner.query(`ALTER TABLE "issue_groups_issue_group" DROP CONSTRAINT "FK_4dc8b5a77d4f85026e70f35a5ca"`);
        await queryRunner.query(`ALTER TABLE "issue_group" DROP CONSTRAINT "FK_5a2393a8dca622c74ff8624617b"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_2732e443d620e345aed091dc0b"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_fc48896b0d0558e8937d32ba17"`);
        await queryRunner.query(`DROP TABLE "issue_group_issues_issue"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_cfc248d1abaade5caf8d4869b3"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_4dc8b5a77d4f85026e70f35a5c"`);
        await queryRunner.query(`DROP TABLE "issue_groups_issue_group"`);
        await queryRunner.query(`DROP TABLE "issue_group"`);
        await queryRunner.query(`ALTER TABLE "issue" RENAME COLUMN "createdAt" TO "created"`);
    }

}
