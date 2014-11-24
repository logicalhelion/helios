CREATE TABLE helios_job_history_entry_tb 
(
    jobhistoryid NUMBER(24,0) PRIMARY KEY NOT NULL,
    jobid NUMBER(24,0) NOT NULL,
    jobtypeid NUMBER(10,0),
    args VARCHAR2(4000),
    uniqkey VARCHAR2(255),
    insert_time NUMBER(32,6),
    run_after NUMBER(32,6),
    locked_until NUMBER(32,6),
    priority NUMBER(5,0),
    coalesce VARCHAR2(255),
    complete_time NUMBER(32,6) NOT NULL,
    exitstatus NUMBER(5,0)
);


CREATE TABLE helios_log_entry_tb
(
    logid NUMBER(24,0) PRIMARY KEY NOT NULL,
    log_time DECIMAL(32,6) NOT NULL,
    host VARCHAR2(64),
    pid NUMBER(10,0),
    jobid NUMBER(24,0),
    jobtypeid NUMBER(24,0),
    service VARCHAR2(128),
    priority VARCHAR2(20),
    message VARCHAR2(4000),
    INDEX(log_time, logid)
);


CREATE TABLE helios_config_tb
(
    paramid NUMBER(24,0) PRIMARY KEY NOT NULL,
    host VARCHAR2(64),
    service VARCHAR2(64),
    param VARCHAR2(64),
    value VARCHAR2(256)
);


CREATE TABLE helios_service_registry_entry_tb
(
    registryid NUMBER(24,0) PRIMARY KEY NOT NULL,
    register_time NUMBER(32,6) NOT NULL,
    start_time NUMBER(32,6),
    service VARCHAR2(128),
    service_version VARCHAR2(16),
    host VARCHAR2(64),
    pid NUMBER(10,0)
);

