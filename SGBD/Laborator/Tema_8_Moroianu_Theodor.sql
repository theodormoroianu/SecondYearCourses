-- Autor: Moroianu Theodor
-- Grupa: 234
-- Data: 12.9.2020

SET SERVEROUTPUT ON;

-- 1.A

CREATE OR REPLACE PACKAGE ExA_tmo AS
    PROCEDURE AddEmployee(
            employee_id_p         employees.employee_id%TYPE,
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE,
            email_p               employees.email%TYPE,
            phone_number_p        employees.phone_number%TYPE,
            first_name_boss_p     employees.first_name%TYPE,
            last_name_boss_p      employees.last_name%TYPE,
            department_name_p     departments.department_name%TYPE,
            job_title_p            jobs.job_title%TYPE);
    FUNCTION GetUserId(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE)
        RETURN employees.employee_id%TYPE;
    FUNCTION GetDepartmentId(
            department_name_p     departments.department_name%TYPE)
        RETURN departments.department_id%TYPE;
    FUNCTION GetJobId(
            job_title_p     jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE;
END ExA_tmo;
/


CREATE OR REPLACE PACKAGE BODY ExA_tmo AS
    PROCEDURE AddEmployee(
            employee_id_p         employees.employee_id%TYPE,
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE,
            email_p               employees.email%TYPE,
            phone_number_p        employees.phone_number%TYPE,
            first_name_boss_p     employees.first_name%TYPE,
            last_name_boss_p      employees.last_name%TYPE,
            department_name_p     departments.department_name%TYPE,
            job_title_p           jobs.job_title%TYPE)
    AS
        manager_id_d        employees.employee_id%TYPE;
        department_id_d     departments.department_id%TYPE;
        salary_d            employees.salary%TYPE;
        job_id_d            jobs.job_id%TYPE;
    BEGIN
        manager_id_d := GetUserId(first_name_boss_p, last_name_boss_p);
        department_id_d := GetDepartmentId(department_name_p);
        job_id_d := GetJobId(job_title_p);
        SELECT MIN(salary)
            INTO salary_d
            FROM employees
            WHERE department_id = department_id_d;
        
        INSERT INTO employees VALUES(
                employee_id_p,
                first_name_p,
                last_name_p,
                email_p,
                phone_number_p,
                sysdate,
                job_id_d,
                salary_d,
                NULL,
                manager_id_d,
                department_id_d);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Au fost gasite prea multe intregistrari care se potrivesc!');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu s-a gasit cv data');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('A aparut o problema!');
    END AddEmployee;
    
    FUNCTION GetUserId(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE)
        RETURN employees.employee_id%TYPE
    AS
        user_id_d       employees.employee_id%TYPE;
    BEGIN
        SELECT employee_id
            INTO user_id_d
            FROM employees
            WHERE first_name = first_name_p
                AND last_name = last_name_p;
        RETURN user_id_d;
    END GetUserId;
    
    FUNCTION GetDepartmentId(
            department_name_p     departments.department_name%TYPE)
        RETURN departments.department_id%TYPE
    AS
        department_id_d   departments.department_id%TYPE;
    BEGIN
        SELECT department_id
            INTO department_id_d
            FROM departments
            WHERE department_name = department_name_p;
        RETURN department_id_d;
    END GetDepartmentId;
    
    FUNCTION GetJobId(
            job_title_p     jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE
    AS
        job_id_d    jobs.job_id%TYPE;
    BEGIN
        SELECT job_id
            INTO job_id_d
            FROM jobs
            WHERE job_title = job_title_p;
        RETURN job_id_d;
    END GetJobId;
END ExA_tmo;
/

-- 1.B


CREATE OR REPLACE PACKAGE ExB_tmo AS
    PROCEDURE MoveEmployee(
            employee_id_p         employees.employee_id%TYPE,
            first_name_boss_p     employees.first_name%TYPE,
            last_name_boss_p      employees.last_name%TYPE,
            department_name_p     departments.department_name%TYPE,
            job_title_p            jobs.job_title%TYPE);
            
    FUNCTION GetUserId(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE)
        RETURN employees.employee_id%TYPE;
    FUNCTION GetDepartmentId(
            department_name_p     departments.department_name%TYPE)
        RETURN departments.department_id%TYPE;
    FUNCTION GetJobId(
            job_title_p     jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE;
END ExB_tmo;
/


CREATE OR REPLACE PACKAGE BODY ExB_tmo AS
   PROCEDURE MoveEmployee(
            employee_id_p         employees.employee_id%TYPE,
            first_name_boss_p     employees.first_name%TYPE,
            last_name_boss_p      employees.last_name%TYPE,
            department_name_p     departments.department_name%TYPE,
            job_title_p            jobs.job_title%TYPE)
        AS
        manager_id_d        employees.employee_id%TYPE;
        department_id_d     departments.department_id%TYPE;
        job_id_d            jobs.job_id%TYPE;
    BEGIN
        manager_id_d := GetUserId(first_name_boss_p, last_name_boss_p);
        department_id_d := GetDepartmentId(department_name_p);
        job_id_d := GetJobId(job_title_p);
        
        UPDATE employees
            SET manager_id = manager_id_d,
                department_id = department_id_d,
                job_id = job_id_d
            WHERE employee_id = employee_id_p;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Au fost gasite prea multe intregistrari care se potrivesc!');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu s-a gasit cv data');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('A aparut o problema!');
    END MoveEmployee;
    
    FUNCTION GetUserId(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE)
        RETURN employees.employee_id%TYPE
    AS
        user_id_d       employees.employee_id%TYPE;
    BEGIN
        SELECT employee_id
            INTO user_id_d
            FROM employees
            WHERE first_name = first_name_p
                AND last_name = last_name_p;
        RETURN user_id_d;
    END GetUserId;
    
    FUNCTION GetDepartmentId(
            department_name_p     departments.department_name%TYPE)
        RETURN departments.department_id%TYPE
    AS
        department_id_d   departments.department_id%TYPE;
    BEGIN
        SELECT department_id
            INTO department_id_d
            FROM departments
            WHERE department_name = department_name_p;
        RETURN department_id_d;
    END GetDepartmentId;
    
    FUNCTION GetJobId(
            job_title_p     jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE
    AS
        job_id_d    jobs.job_id%TYPE;
    BEGIN
        SELECT job_id
            INTO job_id_d
            FROM jobs
            WHERE job_title = job_title_p;
        RETURN job_id_d;
    END GetJobId;
END ExB_tmo;
/
