-- Tema 6
-- Moroianu Theodor

SET SERVEROUTPUT ON;

-- Ex 1 -----------------------------------------------------------------------------------

SELECT * FROM jobs;


-- Cu cursori clasici

DECLARE 
    CURSOR j IS (SELECT *
                 FROM jobs);
    CURSOR e (jb VARCHAR2) IS
            (SELECT *
             FROM employees e
             WHERE e.job_id = jb);
    v_job       jobs%ROWTYPE;
    v_emp       employees%ROWTYPE;
    nr          NUMBER;
    
BEGIN
    OPEN j;
    LOOP
        FETCH j INTO v_job;
        EXIT WHEN j%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
    
        OPEN e(v_job.job_id);
        nr := 0;
        
        LOOP
            FETCH e INTO v_emp;
            EXIT WHEN e%NOTFOUND;
            
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE('    ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        
        CLOSE e;
        
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    No employees found!');
        END IF;
    END LOOP;
    CLOSE j;
END;
/

-- Cu ciclu cursoare

DECLARE 
    CURSOR j IS (SELECT *
                 FROM jobs);
    CURSOR e (jb VARCHAR2) IS
            (SELECT *
             FROM employees e
             WHERE e.job_id = jb);
    nr          NUMBER;
    
BEGIN
    FOR v_job IN j LOOP
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
    
        nr := 0;
        
        FOR v_emp IN e(v_job.job_id) LOOP
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE('    ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    No employees found!');
        END IF;
    END LOOP;
END;
/

-- Cu ciclu cursoare cu subcereri

DECLARE
    nr          NUMBER;
    
BEGIN
    FOR v_job IN (SELECT *
                  FROM jobs) LOOP
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
    
        nr := 0;
        
        FOR v_emp IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id) LOOP
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE('    ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    No employees found!');
        END IF;
    END LOOP;
END;
/


-- Cu ciclu expresii cursor

SELECT * FROM jobs;

DECLARE 
    TYPE refcursor IS REF CURSOR;
    CURSOR j IS (SELECT j.job_title, CURSOR (SELECT *
                                             FROM employees e
                                             WHERE e.job_id = j.job_id)
                 FROM jobs j);
    v_job       VARCHAR2(100); --jobs%ROWTYPE;
    v_emp       employees%ROWTYPE;
    v_cursor    refcursor;
    nr          NUMBER;
    
BEGIN
    OPEN j;
    LOOP
        FETCH j INTO v_job, v_cursor;
        EXIT WHEN j%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job || ':');
    
        nr := 0;
        
        LOOP
            FETCH v_cursor INTO v_emp;
            EXIT WHEN v_cursor%NOTFOUND;
            
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE('    ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    No employees found!');
        END IF;
    END LOOP;
    CLOSE j;
END;
/



-- Ex 2 -----------------------------------------------------------------------------------


DECLARE
    nr_job          NUMBER;
    nr_total        NUMBER;
    sum_job         NUMBER;
    sum_total       NUMBER;
BEGIN
    sum_total := 0;
    nr_total := 0;
    
    FOR v_job IN (SELECT *
                  FROM jobs) LOOP
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
    
        nr_job := 0;
        sum_job := 0;
        FOR v_emp IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id) LOOP
            nr_job := nr_job + 1;
            sum_job := sum_job + v_emp.salary;
        END LOOP;
        
        sum_total := sum_total + sum_job;
        nr_total := nr_total + nr_job;
        
        DBMS_OUTPUT.PUT_LINE('Jobul are ' || nr_job || ' angajati.');
        IF nr_job > 0 THEN
            DBMS_OUTPUT.PUT_LINE('    Suma salariilor este ' || sum_job || ' si media salariilor este ' || sum_job / nr_job);
            DBMS_OUTPUT.PUT_LINE('    Lista de angajati este:'); 
        END IF;
            
        
        FOR v_emp IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id) LOOP
            DBMS_OUTPUT.PUT_LINE('        ' || v_emp.first_name || ' ' || v_emp.last_name);
        END LOOP;
        
        IF nr_job = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    No employees found!');
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('In total sunt ' || nr_total || ' angajati.');
    DBMS_OUTPUT.PUT_LINE('Salariul total este de ' || sum_total || ' lei pe luna.');
    DBMS_OUTPUT.PUT_LINE('Salariul mediu este de ' || sum_total / nr_total || ' lei pe luna.');
END;
/


-- Ex 3 -----------------------------------------------------------------------------------

DECLARE
    sum_guy         NUMBER;
    sum_total       NUMBER;
BEGIN
    sum_total := 0;
    
    FOR v_emp IN (SELECT *
                  FROM employees) LOOP
        sum_total := sum_total + v_emp.salary;
        IF v_emp.commission_pct IS NOT NULL THEN
            sum_total := sum_total + v_emp.salary * v_emp.commission_pct;
        END IF;   
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total stuff to pay employees: ' || sum_total);

    FOR v_emp IN (SELECT *
                  FROM employees) LOOP
        sum_guy := v_emp.salary;
        IF v_emp.commission_pct IS NOT NULL THEN
            sum_guy := sum_guy * (1 + v_emp.commission_pct);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Money received by ' || v_emp.first_name || ' ' || v_emp.last_name || ': ' ||
                sum_guy || ', which is ' || 100 * sum_guy / sum_total || '% of total money!');
    END LOOP;
END;
/


-- Ex 4 -----------------------------------------------------------------------------------

DECLARE
    nr         NUMBER;
BEGIN
    FOR v_job IN (SELECT *
                  FROM jobs) LOOP
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
        
        nr := 0;
        FOR v_ang IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id
                      ORDER BY salary DESC) LOOP
            IF nr = 5 THEN
                EXIT;
            END IF;
            nr := nr + 1;
            DBMS_OUTPUT.PUT_LINE('    ' || v_ang.first_name || ' ' || v_ang.last_name
                    || ' with a salary of ' || v_ang.salary);
        END LOOP;
        
        IF nr < 5 THEN
            DBMS_OUTPUT.PUT_LINE('    There are less than 5 employees!');
        END IF;
    END LOOP;
END;
/


-- Ex 5 -----------------------------------------------------------------------------------

DECLARE
    nr         NUMBER;
    last_sal   NUMBER;
BEGIN
    FOR v_job IN (SELECT *
                  FROM jobs) LOOP
        DBMS_OUTPUT.PUT_LINE('Job ' || v_job.job_title || ':');
        
        nr := 0;
        FOR v_ang IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id
                      ORDER BY salary DESC) LOOP
            IF nr = 5 THEN
                EXIT;
            END IF;
            nr := nr + 1;
            last_sal := v_ang.salary;
        END LOOP;
        
        FOR v_ang IN (SELECT *
                      FROM employees e
                      WHERE e.job_id = v_job.job_id
                      ORDER BY salary DESC) LOOP
            IF v_ang.salary < last_sal THEN
                EXIT;
            END IF;
            DBMS_OUTPUT.PUT_LINE('    ' || v_ang.first_name || ' ' || v_ang.last_name
                    || ' with a salary of ' || v_ang.salary);
        END LOOP;
        
        IF nr < 5 THEN
            DBMS_OUTPUT.PUT_LINE('    There are less than 5 employees!');
        END IF;
    END LOOP;
END;
/
