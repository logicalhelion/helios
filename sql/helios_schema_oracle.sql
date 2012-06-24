
--------------------------------------------------------
-- SEQUENCES TO AUTOINCREMENT FUNCMAP AND JOB
--------------------------------------------------------

   CREATE SEQUENCE  "FUNCMAP_FUNCID_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 2 CACHE 200 NOORDER  NOCYCLE ;
   CREATE SEQUENCE  "JOB_JOBID_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1 START WITH 2 CACHE 200 NOORDER  NOCYCLE ;

--------------------------------------------------------
-- TABLE DDL
--------------------------------------------------------
   
   CREATE TABLE "ERROR" 
   (	"ERROR_TIME" NUMBER(10,0), 
	"JOBID" NUMBER(24,0), 
	"MESSAGE" VARCHAR2(255 CHAR), 
	"FUNCID" NUMBER(10,0) DEFAULT '0'
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "ERROR" TO PUBLIC;


  CREATE TABLE "EXITSTATUS" 
   (	"JOBID" NUMBER(24,0), 
	"FUNCID" NUMBER(10,0) DEFAULT '0', 
	"STATUS" NUMBER(5,0), 
	"COMPLETION_TIME" NUMBER(10,0), 
	"DELETE_AFTER" NUMBER(10,0)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "EXITSTATUS" TO PUBLIC;

  
  CREATE TABLE "FUNCMAP" 
   (	"FUNCID" NUMBER(10,0), 
	"FUNCNAME" VARCHAR2(255 CHAR)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FUNCMAP" TO PUBLIC;


  CREATE TABLE "HELIOS_CLASS_MAP" 
   (	"JOB_TYPE" VARCHAR2(32 CHAR), 
	"JOB_CLASS" VARCHAR2(64 CHAR)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_CLASS_MAP" TO PUBLIC;


  CREATE TABLE "HELIOS_JOB_HISTORY_TB" 
   (	"JOBID" NUMBER(24,0), 
	"FUNCID" NUMBER(10,0), 
	"ARG" VARCHAR2(4000 CHAR), 
	"UNIQKEY" VARCHAR2(255 CHAR), 
	"INSERT_TIME" NUMBER(10,0), 
	"RUN_AFTER" NUMBER(10,0), 
	"GRABBED_UNTIL" NUMBER(10,0), 
	"PRIORITY" NUMBER(5,0), 
	"COALESCE" VARCHAR2(255 CHAR), 
	"COMPLETE_TIME" NUMBER(10,0), 
	"EXITSTATUS" NUMBER(5,0)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_JOB_HISTORY_TB" TO PUBLIC;


  CREATE TABLE "HELIOS_LOG_TB" 
   (	"LOG_TIME" NUMBER(10,0), 
	"HOST" VARCHAR2(64 CHAR), 
	"PROCESS_ID" NUMBER(10,0), 
	"JOBID" NUMBER(24,0), 
	"FUNCID" NUMBER(10,0), 
	"JOB_CLASS" VARCHAR2(64 CHAR), 
	"PRIORITY" VARCHAR2(20 CHAR), 
	"MESSAGE" VARCHAR2(4000 CHAR)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_LOG_TB" TO PUBLIC;


  CREATE TABLE "HELIOS_PARAMS_TB" 
   (	"HOST" VARCHAR2(64 CHAR), 
	"WORKER_CLASS" VARCHAR2(64 CHAR), 
	"PARAM" VARCHAR2(64 CHAR), 
	"VALUE" VARCHAR2(128 CHAR)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_PARAMS_TB" TO PUBLIC;


  CREATE TABLE "HELIOS_WORKER_REGISTRY_TB" 
   (	"REGISTER_TIME" NUMBER(10,0), 
	"START_TIME" NUMBER(10,0), 
	"WORKER_CLASS" VARCHAR2(64 CHAR), 
	"WORKER_VERSION" VARCHAR2(10 CHAR), 
	"HOST" VARCHAR2(64 CHAR), 
	"PROCESS_ID" NUMBER(10,0)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_WORKER_REGISTRY_TB" TO PUBLIC;


  CREATE TABLE "JOB" 
   (	"JOBID" NUMBER(24,0), 
	"FUNCID" NUMBER(10,0), 
	"ARG" BLOB, 
	"UNIQKEY" VARCHAR2(255 CHAR), 
	"INSERT_TIME" NUMBER(10,0), 
	"RUN_AFTER" NUMBER(10,0), 
	"GRABBED_UNTIL" NUMBER(10,0), 
	"PRIORITY" NUMBER(5,0), 
	"COALESCE" VARCHAR2(255 CHAR)
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "JOB" TO PUBLIC;


  CREATE TABLE "NOTE" 
   (	"JOBID" NUMBER(24,0), 
	"NOTEKEY" VARCHAR2(255 CHAR), 
	"VALUE" BLOB
   ) ;
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "NOTE" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table HELIOS_JOB_HISTORY_TB
--------------------------------------------------------

  ALTER TABLE "HELIOS_JOB_HISTORY_TB" MODIFY ("COMPLETE_TIME" NOT NULL ENABLE);
  ALTER TABLE "HELIOS_JOB_HISTORY_TB" MODIFY ("GRABBED_UNTIL" NOT NULL ENABLE);
  ALTER TABLE "HELIOS_JOB_HISTORY_TB" MODIFY ("RUN_AFTER" NOT NULL ENABLE);
  ALTER TABLE "HELIOS_JOB_HISTORY_TB" MODIFY ("FUNCID" NOT NULL ENABLE);
  ALTER TABLE "HELIOS_JOB_HISTORY_TB" MODIFY ("JOBID" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_JOB_HISTORY_TB" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table FUNCMAP
--------------------------------------------------------

  ALTER TABLE "FUNCMAP" ADD CONSTRAINT "PRIMARY_3" PRIMARY KEY ("FUNCID") ENABLE;
  ALTER TABLE "FUNCMAP" MODIFY ("FUNCNAME" NOT NULL ENABLE);
  ALTER TABLE "FUNCMAP" MODIFY ("FUNCID" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FUNCMAP" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table HELIOS_LOG_TB
--------------------------------------------------------

  ALTER TABLE "HELIOS_LOG_TB" MODIFY ("LOG_TIME" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_LOG_TB" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_CLASS_MAP" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table JOB
--------------------------------------------------------

  ALTER TABLE "JOB" ADD CONSTRAINT "PRIMARY_2" PRIMARY KEY ("JOBID") ENABLE;
  ALTER TABLE "JOB" MODIFY ("GRABBED_UNTIL" NOT NULL ENABLE);
  ALTER TABLE "JOB" MODIFY ("RUN_AFTER" NOT NULL ENABLE);
  ALTER TABLE "JOB" MODIFY ("FUNCID" NOT NULL ENABLE);
  ALTER TABLE "JOB" MODIFY ("JOBID" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "JOB" TO PUBLIC;


--------------------------------------------------------
--  Constraints for Table HELIOS_WORKER_REGISTRY_TB
--------------------------------------------------------

  ALTER TABLE "HELIOS_WORKER_REGISTRY_TB" MODIFY ("REGISTER_TIME" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_WORKER_REGISTRY_TB" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table ERROR
--------------------------------------------------------

  ALTER TABLE "ERROR" MODIFY ("FUNCID" NOT NULL ENABLE);
  ALTER TABLE "ERROR" MODIFY ("JOBID" NOT NULL ENABLE);
  ALTER TABLE "ERROR" MODIFY ("ERROR_TIME" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "ERROR" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table NOTE
--------------------------------------------------------

  ALTER TABLE "NOTE" ADD CONSTRAINT "PRIMARY_4" PRIMARY KEY ("JOBID", "NOTEKEY") ENABLE;
  ALTER TABLE "NOTE" MODIFY ("NOTEKEY" NOT NULL ENABLE);
  ALTER TABLE "NOTE" MODIFY ("JOBID" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "NOTE" TO PUBLIC;

--------------------------------------------------------
--  Constraints for Table EXITSTATUS
--------------------------------------------------------

  ALTER TABLE "EXITSTATUS" ADD CONSTRAINT "PRIMARY" PRIMARY KEY ("JOBID") ENABLE;
  ALTER TABLE "EXITSTATUS" MODIFY ("FUNCID" NOT NULL ENABLE);
  ALTER TABLE "EXITSTATUS" MODIFY ("JOBID" NOT NULL ENABLE);
  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "EXITSTATUS" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_PARAMS_TB" TO PUBLIC;

--------------------------------------------------------
--  DDL for Index ERROR_TIME_IDX
--------------------------------------------------------

  CREATE INDEX "ERROR_TIME_IDX" ON "ERROR" ("ERROR_TIME") 
  ;
--------------------------------------------------------
--  DDL for Index EXITSTATUS_FUNCID_IDX
--------------------------------------------------------

  CREATE INDEX "EXITSTATUS_FUNCID_IDX" ON "EXITSTATUS" ("FUNCID") 
  ;
--------------------------------------------------------
--  DDL for Index JOB_FUNCID_RA_IDX
--------------------------------------------------------

  CREATE INDEX "JOB_FUNCID_RA_IDX" ON "JOB" ("FUNCID", "RUN_AFTER") 
  ;
--------------------------------------------------------
--  DDL for Index JOB_FUNCID_C_IDX
--------------------------------------------------------

  CREATE INDEX "JOB_FUNCID_C_IDX" ON "JOB" ("FUNCID", "COALESCE") 
  ;
--------------------------------------------------------
--  DDL for Index NOTE_JOBID_NK_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "NOTE_JOBID_NK_IDX" ON "NOTE" ("JOBID", "NOTEKEY") 
  ;
--------------------------------------------------------
--  DDL for Index ERROR_FUNCID_ET_IDX
--------------------------------------------------------

  CREATE INDEX "ERROR_FUNCID_ET_IDX" ON "ERROR" ("FUNCID", "ERROR_TIME") 
  ;
--------------------------------------------------------
--  DDL for Index FUNCMAP_FUNCID_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "FUNCMAP_FUNCID_IDX" ON "FUNCMAP" ("FUNCID") 
  ;
--------------------------------------------------------
--  DDL for Index JOB_FUNCID_UK_IDX
--------------------------------------------------------

  CREATE INDEX "JOB_FUNCID_UK_IDX" ON "JOB" ("FUNCID", "UNIQKEY") 
  ;
--------------------------------------------------------
--  DDL for Index HJHT_JOBID_IDX
--------------------------------------------------------

  CREATE INDEX "HJHT_JOBID_IDX" ON "HELIOS_JOB_HISTORY_TB" ("JOBID") 
  ;
--------------------------------------------------------
--  DDL for Index HLT_LOG_TIME_IDX
--------------------------------------------------------

  CREATE INDEX "HLT_LOG_TIME_IDX" ON "HELIOS_LOG_TB" ("LOG_TIME") 
  ;
--------------------------------------------------------
--  DDL for Index HJHT_COMPLETE_TIME_IDX
--------------------------------------------------------

  CREATE INDEX "HJHT_COMPLETE_TIME_IDX" ON "HELIOS_JOB_HISTORY_TB" ("COMPLETE_TIME") 
  ;
--------------------------------------------------------
--  DDL for Index EXITSTATUS_DA_IDX
--------------------------------------------------------

  CREATE INDEX "EXITSTATUS_DA_IDX" ON "EXITSTATUS" ("DELETE_AFTER") 
  ;
--------------------------------------------------------
--  DDL for Index EXITSTATUS_JOBID_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "EXITSTATUS_JOBID_IDX" ON "EXITSTATUS" ("JOBID") 
  ;
--------------------------------------------------------
--  DDL for Index FUNCMAP_FUNCNAME_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "FUNCMAP_FUNCNAME_IDX" ON "FUNCMAP" ("FUNCNAME") 
  ;
--------------------------------------------------------
--  DDL for Index JOB_JOBID_IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "JOB_JOBID_IDX" ON "JOB" ("JOBID") 
  ;
--------------------------------------------------------
--  DDL for Index ERROR_JOBID_IDX
--------------------------------------------------------

  CREATE INDEX "ERROR_JOBID_IDX" ON "ERROR" ("JOBID") 
  ;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "ERROR" TO PUBLIC;



  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "EXITSTATUS" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FILE_DELIVERY_PRINTERLOOKUP" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FILE_DELIVERY_QUEUE" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FILE_DELIVERY_QUEUE_LOG" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FILE_RULES" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "FUNCMAP" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_CLASS_MAP" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_JOB_HISTORY_TB" TO PUBLIC;



  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_LOG_TB" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_PARAMS_TB" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "HELIOS_WORKER_REGISTRY_TB" TO PUBLIC;


  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "JOB" TO PUBLIC;

  GRANT DELETE, INSERT, SELECT, UPDATE, REFERENCES ON "NOTE" TO PUBLIC;

--------------------------------------------------------
--  DDL for Trigger FUNCMAP_FUNCID_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "FUNCMAP_FUNCID_TRG" BEFORE INSERT OR UPDATE ON funcmap
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.funcid IS NULL THEN
    SELECT  funcmap_funcid_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(funcid),0) INTO v_newVal FROM funcmap;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT funcmap_funcid_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.funcid := v_newVal;
  END IF;
END;

/
ALTER TRIGGER "FUNCMAP_FUNCID_TRG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger JOB_JOBID_TRG
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "JOB_JOBID_TRG" 
BEFORE INSERT OR UPDATE
ON LOWESFDS.JOB
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.jobid IS NULL THEN
    SELECT  job_jobid_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(jobid),0) INTO v_newVal FROM job;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT job_jobid_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.jobid := v_newVal;
  END IF;
END;
/
ALTER TRIGGER "JOB_JOBID_TRG" ENABLE;

