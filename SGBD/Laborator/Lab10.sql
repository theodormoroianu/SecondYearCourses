-- Autor: Moroianu Theodor
-- Grupa: 234
-- Data: 12.9.2020

SET SERVEROUTPUT ON;

-- 1.A

CREATE OR REPLACE PACKAGE ExE_tmo AS
    PROCEDURE VerifyEmployee(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE,
            salary_p              employees.salary%TYPE);
    FUNCTION GetUserId(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE)
        RETURN employees.employee_id%TYPE;
END ExE_tmo;
/

desc jobs;

CREATE OR REPLACE PACKAGE BODY ExE_tmo AS
    PROCEDURE VerifyEmployee(
            first_name_p          employees.first_name%TYPE,
            last_name_p           employees.last_name%TYPE,
            salary_p              employees.salary%TYPE)
    AS
        employee_id_d       employees.employee_id%TYPE;
        department_id_d     departments.department_id%TYPE;
        salary_d            employees.salary%TYPE;
        invalid_d           NUMBER;
        employee_d          employees%ROWTYPE;
    BEGIN
        employee_id_d := GetUserId(first_name_p, last_name_p);
        SELECT *
            INTO employee_d
            FROM employees
            WHERE employee_id = employee_id_d;
            
        SELECT COUNT(*)
            INTO invalid_d
            FROM jobs
            WHERE jobs.job_id = employee_d.job_id
                AND (MIN_SALARY < salary_d OR MAX_SALARY > salary_d);
                
        IF invalid_d > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Invalid salary!');
            RETURN;
        END IF;
        
        UPDATE employees
            SET salary = salary_d
            WHERE employee_id = employee_id_d;
            
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Sunt prea multi angajati cu acelasi nume!');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu s-a gasit angajat!');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('A aparut o problema!');
    END VerifyEmployee;
    
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
    
END ExE_tmo;
/
