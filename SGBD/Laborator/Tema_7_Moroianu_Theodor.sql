-- Theodor Moroianu
-- Grupa 234

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
    DBMS_OUTPUT.PUT_LINE(f2_tmo('Bell'));-- FROM DUAL;
END;
/

SELECT * FROM info_tmo;

SELECT f2_tmo('King') FROM dual;