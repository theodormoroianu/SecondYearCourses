-- Tema 3 SGDB
-- Autor: Theodor Moroianu
-- Grupa: 234

-- Ex 1
-- a. numar = 2
-- b. mesaj1 = "text 2"
-- c. mesaj2 = "text 3 adaugat in sub-bloc"
-- d. numar = 101
-- e. mesaj1 = "text1 adaugat un blocul principal"
-- f. mesaj2 = "text 2 adaugat in blocul principal"

-- Ex 2


--Exercitiul 2:
-- a
WITH numbers as (SELECT Level AS Sequence 
                 FROM Dual 
                 CONNECT BY Level <= 31)
SELECT sysdate + n.Sequence "Zi", COUNT(r.book_date)
FROM numbers n LEFT JOIN rental r ON (EXTRACT(MONTH FROM r.book_date) = EXTRACT(MONTH FROM sysdate)
                                      AND EXTRACT(DAY FROM r.book_date) = n.Sequence)
GROUP BY n.Sequence
ORDER BY "Zi";

-- b

DROP TABLE octombrie_tmo;
CREATE TABLE octombrie_tmo (
    Zi NUMBER PRIMARY KEY,
    Frecventa NUMBER);
SET SERVEROUTPUT ON;
DECLARE
    nr NUMBER := 0;
BEGIN
    FOR i IN 1..31 LOOP
       SELECT COUNT(*) into nr
       FROM rental r
       WHERE EXTRACT(MONTH FROM r.book_date) = EXTRACT(MONTH FROM sysdate)
          AND EXTRACT(DAY FROM r.book_date) = i;
        INSERT INTO octombrie_tmo VALUES(i, nr);
    END LOOP;
END;
/

-- Ex 3
DECLARE
    nume VARCHAR(100) := '&nume';
    ans NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO ans
        FROM rental r JOIN member m ON (r.member_id = m.member_id)
        WHERE LOWER(nume) = LOWER(m.last_name);
    dbms_output.put_line('Frecventa: ' || ans);
END;
/

-- Ex 4
DECLARE
    nume VARCHAR(100) := '&nume';
    titluri_imprumutate NUMBER := 0;
    titluri_totale NUMBER := 0;
    raport NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO titluri_totale
        FROM title t;
    SELECT COUNT(DISTINCT title_id) INTO titluri_imprumutate
        FROM rental r JOIN member m ON (r.member_id = m.member_id)
        WHERE LOWER(nume) = LOWER(m.last_name);
    
    raport := titluri_imprumutate / titluri_totale * 100;
    IF raport > 75 THEN
        dbms_output.put_line('Categoria 1!');
    ELSIF raport > 50 THEN
        dbms_output.put_line('Categoria 2!');
    ELSIF raport > 20 THEN
        dbms_output.put_line('Categoria 3!');
    ELSE
        dbms_output.put_line('Categoria 4!');
    END IF;
END;
/

SELECT * FROM rental;
SELECT * FROM title;
SELECT * FROM member;

-- Ex 5

CREATE TABLE member_tmo AS
    (SELECT * FROM member);

ALTER TABLE member_tmo
    ADD CONSTRAINT PK PRIMARY KEY (member_id);
    
ALTER TABLE member_tmo
    ADD discount NUMBER;
    
    SELECT * FROM member_tmo;
    
DECLARE
    titluri_imprumutate NUMBER := 0;
    titluri_totale NUMBER := 0;
    raport NUMBER := 0;
    new_discount NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO titluri_totale
        FROM title t;
    FOR m_id IN (SELECT m.member_id id
                 FROM member m) LOOP
        
        SELECT COUNT(DISTINCT title_id) INTO titluri_imprumutate
            FROM rental r 
            WHERE r.member_id = m_id.id;
            
        raport := titluri_imprumutate / titluri_totale * 100;
        IF raport > 75 THEN
            new_discount := 0.1;
        ELSIF raport > 50 THEN
            new_discount := 0.5;
        ELSIF raport > 20 THEN
            new_discount := 0.3;
        ELSE
            new_discount := 0.0;
        END IF;
        
        UPDATE member_tmo m
            SET m.discount = new_discount
            WHERE m.member_id = m_id.id;
    END LOOP;
END;
/
