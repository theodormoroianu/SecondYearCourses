-- Tema 4
-- Moroianu Theodor
-- Grupa 234

SET SERVEROUTPUT ON;

-- Ex 1

-- Creez tableulul jobs cu care pot sa ma distrez
CREATE TABLE jobs_tmo AS
    (SELECT * FROM jobs);

DECLARE
    TYPE job_record IS RECORD
        (job_id jobs.job_id%TYPE,
         job_title jobs.job_title%TYPE,
         avg_salary NUMBER);
    v   job_record;
BEGIN
    -- a
    v.job_id := 'Random ID';
    v.job_title := 'Random title';
    v.avg_salary := 1234.566;
    DBMS_OUTPUT.PUT_LINE('ID: ' || v.job_id || ', Title: ' || v.job_title
                          || ', Avg salary: ' || v.avg_salary);
                          
    
    -- b
    SELECT job_id, job_title, (min_salary + max_salary) / 2
        INTO v
        FROM jobs_tmo
        WHERE job_id = 'IT_PROG';
    DBMS_OUTPUT.PUT_LINE('ID: ' || v.job_id || ', Title: ' || v.job_title
                          || ', Avg salary: ' || v.avg_salary);
                          
                          
    -- c
    DELETE FROM jobs_tmo
        WHERE job_id = 'ST_MAN'
        RETURNING job_id, job_title, (min_salary + max_salary)
            INTO v.job_id, v.job_title, v.avg_salary;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ID: ' || v.job_id || ', Title: ' || v.job_title
                          || ', Avg salary: ' || v.avg_salary);
END;
/





-- Ex 2

-- Creez tableulul emp cu care pot sa ma distrez
CREATE TABLE emp_tmo AS
    (SELECT * FROM employees);
    
DECLARE
    v1  emp_tmo%ROWTYPE;
    v2  emp_tmo%ROWTYPE;
BEGIN
    SELECT *
        INTO v1
        FROM (SELECT *
              FROM emp_tmo
              ORDER BY salary DESC)
        WHERE rownum = 1;
    SELECT *
        INTO v2
        FROM (SELECT *
              FROM emp_tmo
              ORDER BY salary)
        WHERE rownum = 1;
    
    IF v1.salary / 10 > v2.salary THEN
        UPDATE emp_tmo
            SET salary = salary * 11 / 10
            WHERE employee_id = v2.employee_id;
    END IF;
END;
/
ROLLBACK;




-- Ex 3

CREATE TABLE dept_tmo AS
    (SELECT * FROM departments);
    
DECLARE
    v1  dept_tmo%ROWTYPE;
    v2  dept_tmo%ROWTYPE;
BEGIN
    -- a
    SELECT 300, 'Research', 103, 1700
        INTO v1
        FROM dual;

    -- b
    DELETE FROM dept_tmo
        WHERE department_id = 50
        RETURNING department_id, department_name, manager_id, location_id
        INTO v2;
    
    DBMS_OUTPUT.PUT_LINE('Dep ID: ' || v2.department_id
                          || '  Dep name: ' || v2.department_name
                          || '  Manager ID: ' || v2.manager_id
                          || '  Location ID: ' || v2.location_id);
END;
/
ROLLBACK;




-- Ex 4

DECLARE
    TYPE tablou_indexat IS TABLE OF emp_tmo%ROWTYPE
        INDEX BY BINARY_INTEGER;
    tablou  tablou_indexat;
BEGIN
    DELETE FROM emp_tmo
        WHERE NVL(commission_pct, 0) BETWEEN 0.1 AND 0.3
        RETURNING employee_id, first_name, last_name, email, phone_number,
                hire_date, job_id, salary, commission_pct, manager_id, department_id
            BULK COLLECT INTO tablou;
    FOR i IN tablou.FIRST..tablou.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Nume: ' || tablou(i).employee_id
                             || '  ID: ' || tablou(i).employee_id
                             || 'comision: ' || NVL(tablou(i).commission_pct, 0));
    END LOOP;
END;
/
ROLLBACK;








