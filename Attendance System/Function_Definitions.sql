/*UTILIZE THIS FUNCTION WITH THE FOLLOWING STATEMENT:
    SELECT USER_LOGIN('USERNAME','PASSWORD');
  A RETURN OF TRUE MEANS THAT THE USER HAS BEEN AUTHENTICATED.
*/
CREATE OR REPLACE FUNCTION
  USER_LOGIN(
    IN P_USERNAME VARCHAR,
    IN P_PASSWORD VARCHAR,
    OUT P_USER_ALLOWED BOOLEAN
  )
  LANGUAGE PLPGSQL STABLE
  SECURITY DEFINER
AS $USER_LOGIN$
  BEGIN
    SELECT INTO
      P_USER_ALLOWED
      CASE WHEN (P.USERNAME IS NOT NULL AND P.PASSWORD IS NOT NULL)
        THEN TRUE
        ELSE FALSE
      END AS USER_ALLOWED
    FROM
      PUBLIC.PROFESSOR P
      INNER JOIN PUBLIC.ACCESS A ON
        A.ID = P.ACCESS_ID
      INNER JOIN PUBLIC.ROLE R ON
        R.ID = P.ROLE_ID
    WHERE
      P.USERNAME = P_USERNAME AND
      P.PASSWORD = PUBLIC.CRYPT(P_PASSWORD, P.PASSWORD);
  END;
$USER_LOGIN$;

/*UTILIZE THIS FUNCTION WITH THE FOLLOWING STATEMENT:
    SELECT GET_CURRENT_CLASS({ROOM_ID});
  RETURNS THE CURRENT CLASS SCHEDULED TO BE IN THE ROOM
*/
CREATE OR REPLACE FUNCTION
  GET_CURRENT_CLASS(
    IN P_ROOM_ID INTEGER,
    OUT P_SCHEDULED_CLASS VARCHAR
  )
  LANGUAGE PLPGSQL STABLE
  SECURITY DEFINER
AS $GET_CURRENT_CLASS$
  BEGIN
    SELECT INTO P_SCHEDULED_CLASS
      C.NAME AS SCHEDULED_CLASS
    FROM
      PUBLIC.ROOM R
      INNER JOIN PUBLIC.ROOM_SCHEDULE RS ON
        RS.ROOM_ID = P_ROOM_ID AND
        NOW()::TIMESTAMPTZ(0) BETWEEN RS.STARTTIME AND RS.ENDTIME
      INNER JOIN CLASS C ON
        C.ROOM_SCHEDULE_ID = RS.ID;
  END;
$GET_CURRENT_CLASS$;

/*UTILIZE THIS FUNCTION WITH THE FOLLOWING STATEMENT:
    CALL CREATE_CLASS({EMAIL}, {NAME}, {NUMBER}, {SECTION}, {STARTTIME}, {ENDTIME}, {ROOM}, {DAYS}); COMMIT;
  INSERTS RECORD INTO THE NECESSARY TABLES TO CREATE A CLASS.
*/
CREATE OR REPLACE PROCEDURE
  CREATE_CLASS(
    IN P_PROFESSOR_EMAIL TEXT,
    IN P_CLASS_NAME VARCHAR,
    IN P_CLASS_NUMBER VARCHAR,
    IN P_CLASS_SECTION INTEGER,
    IN P_CLASS_STARTTIME TIME,
    IN P_CLASS_ENDTIME TIME,
    IN P_CLASS_DAYS VARCHAR,
    IN P_ROOM_ID INTEGER
  )
  LANGUAGE PLPGSQL
  SECURITY DEFINER
AS $CREATE_CLASS$
  DECLARE
    V_ROOM_SCHEDULE_ID INTEGER;
    V_PROFESSOR_ID INTEGER;
    V_CLASS_EXISTS BOOLEAN;
  BEGIN
    SELECT INTO V_PROFESSOR_ID
      P.ID
    FROM
      PUBLIC.PROFESSOR P
    WHERE
      UPPER(P.EMAILADDRESS) = UPPER(P_PROFESSOR_EMAIL);

    INSERT INTO ROOM_SCHEDULE (ROOM_ID, STARTTIME, ENDTIME, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY, ACTIVE)
      VALUES (P_ROOM_ID, P_CLASS_STARTTIME, P_CLASS_ENDTIME, NOW()::TIMESTAMPTZ(0), 'CREATE_CLASS', NOW()::TIMESTAMPTZ(0), 'CREATE_CLASS', TRUE);

    SELECT INTO V_ROOM_SCHEDULE_ID
      RS.ID
    FROM
      PUBLIC.ROOM_SCHEDULE RS
    WHERE
      RS.ROOM_ID = P_ROOM_ID AND
      RS.STARTTIME = P_CLASS_STARTTIME AND
      RS.ENDTIME = P_CLASS_ENDTIME;

    IF (V_ROOM_SCHEDULE_ID IS NOT NULL AND V_PROFESSOR_ID IS NOT NULL AND
      NOT EXISTS(
      SELECT
        C.ID
      FROM
        PUBLIC.CLASS C
      WHERE
        C.PROFESSOR_ID = V_PROFESSOR_ID AND
        C.ROOM_SCHEDULE_ID = V_ROOM_SCHEDULE_ID AND
        C.NAME = P_CLASS_NAME AND
        C.SECTION = P_CLASS_SECTION
      )) THEN
      INSERT INTO CLASS (PROFESSOR_ID, ROOM_SCHEDULE_ID, NAME, NUMBER, SECTION, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY, ACTIVE)
        VALUES (V_PROFESSOR_ID, V_ROOM_SCHEDULE_ID, P_CLASS_NAME, P_CLASS_NUMBER, P_CLASS_SECTION, NOW()::TIMESTAMPTZ(0), 'CREATE_CLASS', NOW()::TIMESTAMPTZ(0), 'CREATE_CLASS', TRUE);
    END IF;
  END;
$CREATE_CLASS$;

/*UTILIZE THIS FUNCTION WITH THE FOLLOWING STATEMENT:
    CALL LOG_ATTENDANCE({ROOM_ID}, {STUDENT_ID}); COMMIT;
  INSERTS RECORD INTO THE ATTENDANCE TABLE IF A CLASS IS IN SESSION
*/
CREATE OR REPLACE PROCEDURE
  LOG_ATTENDANCE(
    IN P_ROOM_ID INTEGER,
    IN P_STUDENT_ID INTEGER
  )
  LANGUAGE PLPGSQL
  SECURITY DEFINER
AS $LOG_ATTENDANCE$
  DECLARE
    V_ROOM_SCHEDULE_ID INTEGER;
  BEGIN
    SELECT INTO V_ROOM_SCHEDULE_ID
      RS.ID
    FROM
      PUBLIC.ROOM R
      INNER JOIN PUBLIC.ROOM_SCHEDULE RS ON
        RS.ROOM_ID = P_ROOM_ID AND
        NOW()::TIMESTAMPTZ(0) BETWEEN RS.STARTTIME AND RS.ENDTIME;
    IF V_ROOM_SCHEDULE_ID IS NOT NULL THEN
        INSERT INTO ATTENDANCE (STUDENT_ID, ROOM_SCHEDULE_ID, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY, ACTIVE)
          VALUES (P_STUDENT_ID, V_ROOM_SCHEDULE_ID, NOW()::TIMESTAMPTZ(0), 'LOG_ATTENDANCE', NOW()::TIMESTAMPTZ(0), 'LOG_ATTENDANCE', TRUE);
    END IF;
  END;
$LOG_ATTENDANCE$;

/*CREATION OF LOGGING FUNCTIONS IN ORDER TO AUTOMATICALLY TRACK UPDATES TO OUR RECORDS*/
CREATE OR REPLACE FUNCTION
  LOG_PROFESSOR_UPDATE()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL VOLATILE
AS $PROFESSOR_UPDATE_STAMPS$
  BEGIN
    IF
      OLD.PASSWORD IS DISTINCT FROM NEW.PASSWORD
    THEN
      NEW.PASSWORDUPDATEDON := NOW();
    END IF;
    NEW.LASTUPDATEON := NOW();
    RETURN NEW;
  END;
$PROFESSOR_UPDATE_STAMPS$;

CREATE TRIGGER TRIGGER_PROFESSOR_UPDATE
  BEFORE UPDATE ON
    PROFESSOR
  FOR EACH ROW
    EXECUTE PROCEDURE LOG_PROFESSOR_UPDATE();

CREATE OR REPLACE FUNCTION
  LOG_PROFESSOR_INSERT()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL VOLATILE
AS $PROFESSOR_INSERT_STAMPS$
  BEGIN
    NEW.PASSWORDUPDATEDON := NOW();
    NEW.CREATEDON:= NOW();
    NEW.LASTUPDATEON := NOW();
    NEW.ACTIVE := 1;
    RETURN NEW;
  END;
$PROFESSOR_INSERT_STAMPS$;

CREATE TRIGGER TRIGGER_PROFESSOR_INSERT
  BEFORE INSERT ON
    PROFESSOR
  FOR EACH ROW
    EXECUTE PROCEDURE LOG_PROFESSOR_INSERT();

CREATE OR REPLACE FUNCTION
  LOG_UPDATE_STAMPS()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL VOLATILE
AS $LOG_UPDATE_STAMPS$
  BEGIN
    NEW.LASTUPDATEON := NOW();
    RETURN NEW;
  END;
$LOG_UPDATE_STAMPS$;

CREATE TRIGGER TRIGGER_UPDATE
  BEFORE UPDATE ON
    ROLE
  FOR EACH ROW
    EXECUTE PROCEDURE LOG_UPDATE_STAMPS();

--INSERT TRIGGER & FUNCTION
CREATE OR REPLACE FUNCTION
  LOG_INSERT_STAMPS()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL VOLATILE
AS $LOG_INSERT_STAMPS$
  BEGIN
    NEW.CREATEDON:= NOW();
    NEW.LASTUPDATEON := NOW();
    NEW.ACTIVE := 1;
    RETURN NEW;
  END;
$LOG_INSERT_STAMPS$;

CREATE TRIGGER TRIGGER_INSERT
  BEFORE INSERT ON
    ROLE
  FOR EACH ROW
    EXECUTE PROCEDURE LOG_INSERT_STAMPS();

CREATE TRIGGER TRIGGER_INSERT
  BEFORE INSERT ON
    ACCESS
  FOR EACH ROW
    EXECUTE PROCEDURE LOG_INSERT_STAMPS();
