CREATE TABLE helios_config_tb (
    paramid        BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    host           VARCHAR(64),
    service_class  VARCHAR(64),
    param          VARCHAR(64),
    value          VARCHAR(256)
);


CREATE TABLE helios_job_history_entry_tb (
    jobhistoryid    BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    jobid           BIGINT UNSIGNED NOT NULL,
    jobtypeid       INT UNSIGNED NOT NULL,
    args            MEDIUMBLOB,
    uniqkey         VARCHAR(255) NULL,
    insert_time     DECIMAL(32,6),
    run_after       DECIMAL(32,6) NOT NULL,
    locked_until    DECIMAL(32,6) NOT NULL,
    priority        SMALLINT UNSIGNED,
    coalesce        VARCHAR(255),
    complete_time   DECIMAL(32,6) UNSIGNED NOT NULL,
    exitstatus      SMALLINT UNSIGNED,
    INDEX(jobid)
);


CREATE TABLE helios_log_entry_tb (
    logid           BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    log_time        DECIMAL(32,6) UNSIGNED NOT NULL,
    host            VARCHAR(64),
    pid             INTEGER UNSIGNED,
    jobid           BIGINT UNSIGNED,
    jobtypeid       INT UNSIGNED,
    service         VARCHAR(128),
    priority        VARCHAR(20),
    message         MEDIUMBLOB,
    INDEX(log_time, logid)
);


CREATE TABLE helios_service_registry_entry_tb (
    registryid       BIGINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
    register_time    DECIMAL(32,6) UNSIGNED NOT NULL,
    start_time       DECIMAL(32,6) UNSIGNED NOT NULL,
	service_class    VARCHAR(128),
	service_version  VARCHAR(16),
	host             VARCHAR(64),
	pid              INTEGER UNSIGNED
);


