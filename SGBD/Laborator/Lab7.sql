SELECT *
    FROM employees
    WHERE LEVEL > 1
    START WITH employee_id = 101
    CONNECT BY PRIOR employee_id = manager_id;