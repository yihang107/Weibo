-- 微博数据表 --
CREATE TABLE IF NOT EXISTS "T_Status" (
  "statusId" integer PRIMARY KEY,
  "status" text(128) NOT NULL,
  "userId" integer(128) NOT NULL,
  "createTime" text(128) DEFAULT (datetime('now', 'localtime'))
);
