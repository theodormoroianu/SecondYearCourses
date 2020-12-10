-- Theodor Moroianu
-- Grupa 234

SET SERVEROUTPUT ON;

-- Ex 1

CREATE TABLE info_tmo(
    ID          NUMBER(10, 2) PRIMARY KEY,
    utilizator  VARCHAR2(50),
    data        DATE,
    comanda     VARCHAR2(100),
    nr_linii    NUMBER,
    eroare      VARCHAR2(50));
    
-- Ex 2
CREATE OR REPLACE FUNCTION f2_tmo
    (v_nume employees.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER
IS
    v_utilizator    info_ari.utilizator%TYPE;
    salariu         employees.salary%TYPE;
    v_nr_linii      info_tmo.nr_linii%TYPE;
    v_err           VARCHAR2(100);
    
BEGIN
    SELECT user INTO v_utilizator from dual;
    SELECT salary INTO salariu
        FROM employees
        WHERE last_name = v_nume;
        
    v_nr_linii:= SQL%ROWCOUNT;
    INSERT INTO info_tmo
        VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
               v_utilizator,
               sysdate,
               NULL,
               v_nr_linii,
               NULL);
    RETURN salariu;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_nr_linii:= SQL%ROWCOUNT;
            v_err := SQLERRM;
            INSERT INTO info_tmo
                VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
                   v_utilizator,
                   sysdate,
                   NULL,
                   v_nr_linii,
                   v_err);
            RAISE_APPLICATION_ERROR(-20000,
                V_ERR);
        WHEN TOO_MANY_ROWS THEN
            v_nr_linii:= SQL%ROWCOUNT;
            v_err := SQLERRM;
            INSERT INTO info_tmo
                VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
                   v_utilizator,
                   sysdate,
                   NULL,
                   v_nr_linii,
                   v_err);
            RAISE_APPLICATION_ERROR(-20001,
                'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN
            v_nr_linii:= SQL%ROWCOUNT;
            v_err := SQLERRM;
            INSERT INTO info_tmo
                VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
                   v_utilizator,
                   sysdate,
                   NULL,
                   v_nr_linii,
                   v_err);
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_tmo;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(f2_tmo('Bell'));
END;
/

-- Ex 3

CREATE OR REPLACE FUNCTION find_employees_tmo
    (oras locations.city%TYPE)
RETURN NUMBER
IS
    v_utilizator    info_ari.utilizator%TYPE;
    v_ans           NUMBER;
    v_err           VARCHAR2(100);
BEGIN
    SELECT user INTO v_utilizator from dual;
    IF oras IS NULL THEN
        INSERT INTO info_tmo
            VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
               v_utilizator,
               sysdate,
               NULL,
               0,
               'Orasul dat este nul!');
        RETURN 0;
    END IF;
    
    SELECT COUNT(*)
        INTO v_ans
        FROM employees e JOIN departments d ON (e.department_id = d.department_id)
            JOIN locations l ON (l.location_id = d.location_id)
        WHERE (SELECT COUNT(*)
               FROM job_history
               WHERE employee_id = e.employee_id) >= 1;
    
    IF v_ans = 0 THEN
        v_err := 'Nu a fost gasit niciun angajat!';
    END IF;
    INSERT INTO info_tmo
            VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
               v_utilizator,
               sysdate,
               NULL,
               0,
               v_err);
            
    RETURN v_ans;
END;
/

-- Ex 4

CREATE OR REPLACE PROCEDURE increase_branch
    (mngr employees.employee_id%TYPE)
IS
    v_utilizator    info_ari.utilizator%TYPE;
    v_ans           NUMBER;
    v_err           VARCHAR2(100);
    v_nr_linii      NUMBER;
BEGIN
    SELECT user INTO v_utilizator from dual;
    
    UPDATE employees
        SET salary = salary * 110 / 100
        WHERE employee_id = mngr;
        
    v_nr_linii:= SQL%ROWCOUNT;
    
    IF v_nr_linii = 0 THEN
        INSERT INTO info_tmo
            VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
               v_utilizator,
               sysdate,
               NULL,
               0,
               'Nu a fost gasit managerul!');
        RETURN;
    END IF;
    
    INSERT INTO info_tmo
            VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_tmo),
               v_utilizator,
               sysdate,
               NULL,
               0,
               v_err);
    
    FOR i IN (SELECT employee_id
              FROM employees
              WHERE manager_id = mngr) LOOP
        increase_branch(i.employee_id);
    END LOOP;
END;
/

-- Ex 5

CREATE OR REPLACE PROCEDURE informatii_tmo
IS
    v_utilizator    info_ari.utilizator%TYPE;
    v_ans           NUMBER;
    v_err           VARCHAR2(100);
    v_nr_linii      NUMBER;
    v_zi            NUMBER;
BEGIN
    SELECT user INTO v_utilizator from dual;
    
    FOR dep IN (SELECT *
                FROM departments) LOOP
        DBMS_OUTPUT.PUT_LINE('Department ' || dep.department_name || ':');
        
        SELECT COUNT(*)
            INTO v_nr_linii
            FROM employees
            WHERE department_id = dep.department_id;
        
        IF v_nr_linii = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    NO EMPLOYEES!');
            CONTINUE;
        END IF;
        
        SELECT zi
            INTO v_zi
            FROM (SELECT EXTRACT (DAY FROM hire_date) zi, COUNT(*)
                  FROM employees e
                  WHERE e.department_id = dep.department_id
                  GROUP BY EXTRACT(DAY FROM hire_date)
                  ORDER BY COUNT(*) DESC)
            WHERE rownum = 1;
        
        DBMS_OUTPUT.PUT_LINE('    Zi maxima: ' || v_zi);
        
        FOR e IN (SELECT * 
                  FROM employees
                  WHERE department_id = dep.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE('    Name: ' || e.first_name || ', salary: ' || e.salary);
        END LOOP;
    END LOOP;
END;
/

EXECUTE informatii_tmo;