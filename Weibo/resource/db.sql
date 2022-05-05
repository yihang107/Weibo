-- 微博数据表 --

CREATE TABLE IF NOT EXISTS "T_Status" (
  "statusId" integer PRIMARY KEY,
  "status" text(128),
  "userId" char(128)
);
