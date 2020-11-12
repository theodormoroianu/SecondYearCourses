-- Tema 5
-- Moroianu Theodor
-- 234

-- Activez outputul
SET SERVEROUTPUT ON;

-- Ex 1

-- Creez un nou table cu angajatii, pentru a ii modifica
CREATE TABLE emp_tmo AS
    SELECT * FROM employees;

-- Blocul PL/SQL care efectueaza tranzactia
DECLARE 
    TYPE tablou_angajati IS TABLE OF emp_tmo%ROWTYPE
        INDEX BY BINARY_INTEGER;
    ang tablou_angajati;     
BEGIN
    -- Extrag cei mai prost platiti 5 angajati
    SELECT *
        BULK COLLECT INTO ang
        FROM (SELECT *
              FROM emp_tmo
              WHERE commission_pct IS NULL
              ORDER BY salary ASC)
        WHERE ROWNUM <= 5;

    -- Acum ang contine cei mai prost platiti 5 angajati
    
    FOR i IN 1..5 LOOP
        -- Procesez angajatul #i
        dbms_output.put_line('Angajatului ' || ang(i).last_name ||
            ' i-a fost crescut salariul de la ' || ang(i).salary ||
            ' la ' || 105/100 * ang(i).salary || '!');
        UPDATE emp_tmo
            SET salary = 105 / 100 * salary
            WHERE employee_id = ang(i).employee_id;
    END LOOP;
END;
/


-- Ex 2

-- Creez colectia de orase
CREATE OR REPLACE TYPE tip_orase_tmo
    AS VARRAY(100) OF VARCHAR2(100);
/
-- Creez tabelul
DROP TABLE excursie_tmo;
CREATE TABLE excursie_tmo (
    cod_excursie    NUMBER(4) PRIMARY KEY,
    denumire        VARCHAR2(20),
    orase           tip_orase_tmo,
    status          VARCHAR2(10));

-- A

INSERT INTO excursie_tmo VALUES(
    1, 'Marea Neagra',
    tip_orase_tmo('Mamaia', 'Constanta'),
    'OPEN');
INSERT INTO excursie_tmo VALUES(
    2, 'Hawaii',
    tip_orase_tmo('Idk', 'Cv Oras Smenos'),
    'CLOSED');
INSERT INTO excursie_tmo VALUES(
    3, 'Munti',
    tip_orase_tmo('Brasov', 'Idk', 'Un oras'),
    'CLOSED');
INSERT INTO excursie_tmo VALUES(
    4, 'Campie',
    tip_orase_tmo('Bucuresti', 'Valenii de Vale'),
    'OPEN');
INSERT INTO excursie_tmo VALUES(
    5, 'Italia',
    tip_orase_tmo('Roma', 'Pisa'),
    'OPEN');

-- B

-- Adaug un oras nou la sfarsitul listei
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras';
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    lista_orase.extend();
    lista_orase(lista_orase.last) := nume_oras;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/

-- Adaug un oras nou pe a doua pozitie
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras';
    i               BINARY_INTEGER;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    lista_orase.extend();
    i := lista_orase.last();
    
    WHILE i <> lista_orase.first LOOP
        lista_orase(i) := lista_orase(lista_orase.prior(i));
        i := lista_orase.prior(i);
    END LOOP;
    
    lista_orase(lista_orase.next(lista_orase.first())) := nume_oras;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/

-- Inversez doua orase
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras1      VARCHAR2(20) := '&nume_oras1';
    nume_oras2      VARCHAR2(20) := '&nume_oras2';
    i               BINARY_INTEGER;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    i := lista_orase.first();
    
    WHILE i <= lista_orase.last() LOOP
        IF lista_orase(i) = nume_oras1 THEN
            lista_orase(i) := nume_oras2;
        ELSIF lista_orase(i) = nume_oras2 THEN
            lista_orase(i) := nume_oras1;
        END IF;
        i := lista_orase.next(i);
    END LOOP;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/


-- Sterg un oras specificat
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras1';
    i               BINARY_INTEGER;
    found           BINARY_INTEGER := 0;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    i := lista_orase.first();
    
    WHILE i <= lista_orase.last() LOOP
        IF lista_orase(i) = nume_oras THEN
            found := 1;
        ELSIF found = 1 THEN
            lista_orase(lista_orase.prior(i)) := lista_orase(i);
        END IF;
        i := lista_orase.next(i);
    END LOOP;
    
    lista_orase.trim();
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/

-- C

-- Afisez nr de orase, si orasele
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    DBMS_OUTPUT.PUT_LINE('Numar de orase in excursie: ' || lista_orase.count());
    
    FOR i IN lista_orase.first() .. lista_orase.last() LOOP
        DBMS_OUTPUT.PUT_LINE('    Oras #' || i || ': ' || lista_orase(i));
    END LOOP;
END;
/

-- D

CREATE OR REPLACE TYPE lista_excursii_tmo
    AS VARRAY(100) OF INTEGER;
/
-- Afisez toate orasele pt toate excursiile
DECLARE
    lista_orase     tip_orase_tmo;
    lista_excursii  lista_excursii_tmo;
BEGIN
    SELECT cod_excursie
        BULK COLLECT INTO lista_excursii
        FROM excursie_tmo;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
            
        DBMS_OUTPUT.PUT_LINE('Numar de orase in excursie: ' || lista_orase.count());
        
        FOR i IN lista_orase.first() .. lista_orase.last() LOOP
            DBMS_OUTPUT.PUT_LINE('    Oras #' || i || ': ' || lista_orase(i));
        END LOOP;
    END LOOP;
END;
/


-- E

CREATE OR REPLACE TYPE lista_excursii_tmo
    AS VARRAY(100) OF INTEGER;
/
-- Afisez toate orasele pt toate excursiile
DECLARE
    lista_orase     tip_orase_tmo;
    lista_excursii  lista_excursii_tmo;
    minim_orase     INTEGER := 100000;
BEGIN
    SELECT cod_excursie
        BULK COLLECT INTO lista_excursii
        FROM excursie_tmo;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
        
        IF lista_orase.COUNT() < minim_orase THEN
            minim_orase := lista_orase.COUNT();
        END IF;
    END LOOP;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
        
        IF lista_orase.COUNT() = minim_orase THEN
            UPDATE excursie_tmo
                SET status = 'CLOSED'
                WHERE cod_excursie = e;        
        END IF;
    END LOOP;
END;
/








-- Ex 3

DROP TABLE excursie_tmo;

-- Se rezolva identic cu exercitiul 2, doar ca trebuie inlocuit tip_orase_tmo
-- Sa fie un nested table in loc de vector:

CREATE OR REPLACE TYPE tip_orase_tmo IS TABLE OF VARCHAR2(100);
/
DROP TABLE excursie_tmo;
CREATE TABLE excursie_tmo (
    cod_excursie    NUMBER(4) PRIMARY KEY,
    denumire        VARCHAR2(20),
    status          VARCHAR2(10));

ALTER TABLE excursie_tmo
    ADD (orase tip_orase_tmo)
    NESTED TABLE orase
        STORE AS orase_tmo;
        
-- A

INSERT INTO excursie_tmo VALUES(
    1, 'Marea Neagra', 'OPEN',
    tip_orase_tmo('Mamaia', 'Constanta'));
INSERT INTO excursie_tmo VALUES(
    2, 'Hawaii', 'CLOSED',
    tip_orase_tmo('Idk', 'Cv Oras Smenos'));
INSERT INTO excursie_tmo VALUES(
    3, 'Munti', 'CLOSED',
    tip_orase_tmo('Brasov', 'Idk', 'Un oras'));
INSERT INTO excursie_tmo VALUES(
    4, 'Campie', 'OPEN',
    tip_orase_tmo('Bucuresti', 'Valenii de Vale'));
INSERT INTO excursie_tmo VALUES(
    5, 'Italia', 'OPEN',
    tip_orase_tmo('Roma', 'Pisa'));

-- B

-- Adaug un oras nou la sfarsitul listei
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras';
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    lista_orase.extend();
    lista_orase(lista_orase.last) := nume_oras;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/

-- Adaug un oras nou pe a doua pozitie
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras';
    i               BINARY_INTEGER;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    lista_orase.extend();
    i := lista_orase.last();
    
    WHILE i <> lista_orase.first LOOP
        lista_orase(i) := lista_orase(lista_orase.prior(i));
        i := lista_orase.prior(i);
    END LOOP;
    
    lista_orase(lista_orase.next(lista_orase.first())) := nume_oras;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/


-- Inversez doua orase
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras1      VARCHAR2(20) := '&nume_oras1';
    nume_oras2      VARCHAR2(20) := '&nume_oras2';
    i               BINARY_INTEGER;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    i := lista_orase.first();
    
    WHILE i <= lista_orase.last() LOOP
        IF lista_orase(i) = nume_oras1 THEN
            lista_orase(i) := nume_oras2;
        ELSIF lista_orase(i) = nume_oras2 THEN
            lista_orase(i) := nume_oras1;
        END IF;
        i := lista_orase.next(i);
    END LOOP;
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/


-- Sterg un oras specificat
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
    nume_oras       VARCHAR2(20) := '&nume_oras1';
    i               BINARY_INTEGER;
    found           BINARY_INTEGER := 0;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    i := lista_orase.first();
    
    WHILE i <= lista_orase.last() LOOP
        IF lista_orase(i) = nume_oras THEN
            found := 1;
        ELSIF found = 1 THEN
            lista_orase(lista_orase.prior(i)) := lista_orase(i);
        END IF;
        i := lista_orase.next(i);
    END LOOP;
    
    lista_orase.trim();
    
    UPDATE excursie_tmo
        SET orase = lista_orase
        WHERE cod_excursie = excursie_ID;
END;
/

-- C

-- Afisez nr de orase, si orasele
DECLARE
    lista_orase     tip_orase_tmo;
    excursie_ID     VARCHAR2(20) := &excursieID;
BEGIN
    -- Izolez orasele din excursia specificata
    SELECT orase
        INTO lista_orase
        FROM excursie_tmo
        WHERE cod_excursie = excursie_ID;
        
    DBMS_OUTPUT.PUT_LINE('Numar de orase in excursie: ' || lista_orase.count());
    
    FOR i IN lista_orase.first() .. lista_orase.last() LOOP
        DBMS_OUTPUT.PUT_LINE('    Oras #' || i || ': ' || lista_orase(i));
    END LOOP;
END;
/

-- D

CREATE OR REPLACE TYPE lista_excursii_tmo
    AS VARRAY(100) OF INTEGER;
/
-- Afisez toate orasele pt toate excursiile
DECLARE
    lista_orase     tip_orase_tmo;
    lista_excursii  lista_excursii_tmo;
BEGIN
    SELECT cod_excursie
        BULK COLLECT INTO lista_excursii
        FROM excursie_tmo;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
            
        DBMS_OUTPUT.PUT_LINE('Numar de orase in excursie: ' || lista_orase.count());
        
        FOR i IN lista_orase.first() .. lista_orase.last() LOOP
            DBMS_OUTPUT.PUT_LINE('    Oras #' || i || ': ' || lista_orase(i));
        END LOOP;
    END LOOP;
END;
/


-- E

CREATE OR REPLACE TYPE lista_excursii_tmo
    AS VARRAY(100) OF INTEGER;
/
-- Afisez toate orasele pt toate excursiile
DECLARE
    lista_orase     tip_orase_tmo;
    lista_excursii  lista_excursii_tmo;
    minim_orase     INTEGER := 100000;
BEGIN
    SELECT cod_excursie
        BULK COLLECT INTO lista_excursii
        FROM excursie_tmo;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
        
        IF lista_orase.COUNT() < minim_orase THEN
            minim_orase := lista_orase.COUNT();
        END IF;
    END LOOP;
    
    FOR e IN lista_excursii.first() .. lista_excursii.last() LOOP
        SELECT orase
            INTO lista_orase
            FROM excursie_tmo
            WHERE cod_excursie = e;
        
        IF lista_orase.COUNT() = minim_orase THEN
            UPDATE excursie_tmo
                SET status = 'CLOSED'
                WHERE cod_excursie = e;        
        END IF;
    END LOOP;
END;
/
