-- Moroianu Theodor

-- 4

SELECT * 
FROM (SELECT COUNT(distinct t.title_id) "Titluri", COUNT(*) "Exemplare" 
     FROM title_copy tc JOIN rental r ON (tc.copy_id = r.copy_id and tc.title_id = r.title_id) 
         JOIN title t ON (t.title_id = tc.title_id) 
     GROUP BY t.category 
     ORDER BY COUNT(*) DESC) 
WHERE rownum = 1; 

-- 5

SELECT tc.title_id "Title_id", COUNT(*) "Number Disponible" 
FROM title_copy tc JOIN rental r ON (tc.title_id = r.title_id and tc.copy_id = r.copy_id) 
WHERE NVL(status, '') = 'AVAILABLE' 
GROUP BY tc.title_id; 

-- 6

SELECT tc.title_id, tc.copy_id, tc.status, 
    CASE WHEN EXISTS (SELECT *  
                      FROM rental r 
                      WHERE r.copy_id = tc.copy_id 
                            AND r.title_id = tc.title_id 
                            AND act_ret_date IS NULL) 
    THEN 'RENTED' ELSE 'AVAILABLE' END "Real Status" 
FROM title_copy tc; 

-- 7

SELECT COUNT(*) "Numar eronate" 
FROM title_copy tc 
WHERE status != CASE WHEN (tc.copy_id, tc.title_id) in 
                     (SELECT r.copy_id, r.title_id 
                      FROM rental r 
                      WHERE act_ret_date IS NULL)  
                THEN 'RENTED' ELSE 'AVAILABLE' END; 
  
CREATE TABLE title_copy_tmo AS 
    SELECT copy_id, title_id, CASE WHEN (tc.copy_id, tc.title_id) in 
                                 (SELECT r.copy_id, r.title_id 
                                  FROM rental r 
                                  WHERE act_ret_date IS NULL)  
                THEN 'RENTED' ELSE 'AVAILABLE' END "Status" 
    FROM title_copy tc; 

-- 8

SELECT CASE WHEN EXISTS
    (SELECT 1
     FROM rental rnt JOIN reservation res ON (rnt.member_id = res.member_id AND rnt.title_id = res.title_id)
     WHERE rnt.book_date != res.res_date)
THEN 'DA' ELSE 'NU' END "Raspuns"
FROM dual;

-- 9

SELECT m.first_name "Nume", m.last_name "Prenume", t.title "Film",
    (SELECT COUNT(1)
     FROM rental r
     WHERE r.title_id = t.title_id
        AND r.member_id = m.member_id) "Numar de inchirieri"
FROM member m, title t;

-- 10

SELECT m.first_name "Nume", m.last_name "Prenume", t.title "Film", tc.copy_id "Copie",
    (SELECT COUNT(1)
     FROM rental r
     WHERE r.title_id = t.title_id
        AND r.member_id = m.member_id
        AND r.copy_id = tc.copy_id) "Numar de inchirieri"
FROM member m, title t JOIN title_copy tc ON (t.title_id = tc.title_id);

-- 11

SELECT t.title "Titlu", tc.status "status", COUNT(*)
FROM title t JOIN title_copy tc ON (t.title_id = tc.title_id)
    JOIN rental r ON (r.title_id = t.title_id AND r.copy_id = tc.copy_id)
GROUP BY t.title, tc.status, tc.copy_id, t.title_id
HAVING COUNT(*) =
    (SELECT MAX(COUNT(*))
     FROM title_copy tc1 JOIN rental r1 ON (tc1.copy_id = r1.copy_id
                                        AND tc1.title_id = r1.title_id)
     WHERE tc1.title_id = t.title_id
     GROUP BY tc1.copy_id, tc1.status, tc1.title_id);
           
-- 12

-- a

SELECT EXTRACT(DAY FROM book_date) "Zi", COUNT(*) "Imprumutari"
FROM rental
WHERE EXTRACT(DAY FROM book_date) <= 2
    AND EXTRACT(MONTH FROM book_date) = EXTRACT(MONTH FROM sysdate)
GROUP BY book_date;

-- b    

SELECT EXTRACT(DAY FROM book_date) "Zi", COUNT(*) "Imprumutari"
FROM rental
WHERE EXTRACT(MONTH FROM book_date) = EXTRACT(MONTH FROM sysdate)
GROUP BY book_date;

-- c

WITH numbers as (SELECT Level AS Sequence 
                 FROM Dual 
                 CONNECT BY Level <= 31)
SELECT n.Sequence "Zi", COUNT(r.book_date)
FROM numbers n LEFT JOIN rental r ON (EXTRACT(MONTH FROM r.book_date) = EXTRACT(MONTH FROM sysdate)
                                      AND EXTRACT(DAY FROM r.book_date) = n.Sequence)
GROUP BY n.Sequence
ORDER BY "Zi";
