SET SERVEROUTPUT ON;

<<principal>>
DECLARE
    v_client_id     NUMBER(4):= 1600;
    v_client_nume   VARCHAR2(50):= 'N1';
    v_nou_client_id NUMBER(3):= 500;
BEGIN
    <<secundar>>
    DECLARE
        v_client_id         NUMBER(4) := 0;
        v_client_nume       VARCHAR2(50) := 'N2';
        v_nou_client_id     NUMBER(3) := 300;
        v_nou_client_nume   VARCHAR2(50) := 'N3';
    BEGIN
        v_client_id:= v_nou_client_id;
        principal.v_client_nume:= v_client_nume ||' '|| v_nou_client_nume;
        --poziția 1
        dbms_output.put_line(v_client_id);
        dbms_output.put_line(v_client_nume);
    END;
    v_client_id:= (v_client_id *12)/10;
    --poziția 2
    dbms_output.put_line(v_client_id);
END;
/

select * from member;


-- MEMBER(member_id, last_name, first_name, address, city, phone, join_date)
-- TITLE(title_id, title, description, rating, category, release_date)
-- TITLE_COPY(copy_id, title_id, status)
-- RENTAL(book_date, copy_id, member_id, title_id, act_ret_date, exp_ret_date)
-- RESERVATION(res_date, member_id, title_id)