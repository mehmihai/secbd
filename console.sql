grant execute on DBMS_CRYPTO to SYSTEM;

drop table KEYS cascade constraints
/

drop table REVIEW cascade constraints
/

drop table RESTAURANT_PRODUCTS cascade constraints
/

drop table DRIVER_RATING cascade constraints
/

drop table ORDER_PRODUCTS cascade constraints
/

drop table PRODUCT cascade constraints
/

drop table ORDERS cascade constraints
/

drop table RESTAURANT cascade constraints
/

drop table CATEGORY cascade constraints
/

drop table CUSTOMER cascade constraints
/

drop table ADDRESS cascade constraints
/

drop table GEOGRAPHIC_LOCATION cascade constraints
/

drop table DRIVER cascade constraints
/

drop table USERS cascade constraints
/

drop table PROMO_CODE cascade constraints
/

CREATE TABLE CATEGORY (
    ID INTEGER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT CATEGORY_PK PRIMARY KEY (ID) ENABLE
);

CREATE TABLE GEOGRAPHIC_LOCATION (
    ID INTEGER NOT NULL,
    LATITUDE NUMBER(9,6) NOT NULL,
    LONGITUDE NUMBER(9,6) NOT NULL,
    CONSTRAINT GEOGRAPHIC_LOCATION_PK PRIMARY KEY (ID) ENABLE
);

CREATE TABLE ADDRESS (
    ID INTEGER NOT NULL,
    GEO_ID INTEGER NOT NULL,
    CITY VARCHAR2(20) NOT NULL,
    STREET VARCHAR2(20) NOT NULL,
    NR VARCHAR2(5) NOT NULL,
    CONSTRAINT ADDRESS_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT ADDRESS_GEO_ID_FK FOREIGN KEY (GEO_ID) REFERENCES GEOGRAPHIC_LOCATION (ID)
);

CREATE TABLE RESTAURANT (
    ID INTEGER NOT NULL,
    CATEGORY_ID INTEGER NOT NULL,
    ADDRESS_ID INTEGER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    DESCRIPTION VARCHAR2(150) NOT NULL,
    RATING NUMBER(3,1),
    CONSTRAINT RESTAURANT_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT RESTAURANT_CATEGORY_FK FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY (ID),
    CONSTRAINT RESTAURANT_ADDRESS_FK FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS (ID)
);

CREATE TABLE USERS (
    ID INTEGER NOT NULL,
    EMAIL VARCHAR2(20) NOT NULL,
    PASSWORD_HASH VARCHAR2(65) NOT NULL,
    CONSTRAINT USERS_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT UQ_USERS_EMAIL UNIQUE (EMAIL)
);

CREATE TABLE CUSTOMER (
    ID INTEGER NOT NULL,
    USER_ID INTEGER NOT NULL,
    ADDRESS_ID INTEGER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(10) NOT NULL,
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT CUSTOMER_USER_ID_FK FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
    CONSTRAINT CUSTOMER_ADDRESS_ID_FK FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS (ID)
);

CREATE TABLE REVIEW (
    ID INTEGER NOT NULL,
    RESTAURANT_ID INTEGER NOT NULL,
    CUSTOMER_ID INTEGER NOT NULL,
    REVIEW_TEXT VARCHAR2(150),
    RATING INTEGER NOT NULL,
    CONSTRAINT REVIEW_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT REVIEW_RESTAURANT_ID_FK FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANT (ID),
    CONSTRAINT REVIEW_CUSTOMER_ID_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (ID)
);

CREATE TABLE PRODUCT (
    ID INTEGER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    DESCRIPTION VARCHAR2(150) NOT NULL,
    PRICE DECIMAL(6,2) NOT NULL,
    CONSTRAINT PRODUCT_PK PRIMARY KEY (ID) ENABLE
);

CREATE TABLE RESTAURANT_PRODUCTS (
    RESTAURANT_ID INTEGER NOT NULL,
    PRODUCT_ID INTEGER NOT NULL,
    CONSTRAINT RESTAURANT_PRODUCTS_PK PRIMARY KEY (RESTAURANT_ID, PRODUCT_ID) ENABLE,
    CONSTRAINT RESTAURANT_PRODUCTS_RESTAURANT_ID_FK FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANT (ID),
    CONSTRAINT RESTAURANT_PRODUCTS_PRODUCT_ID_FK FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (ID)
);

CREATE TABLE DRIVER (
    ID INTEGER NOT NULL,
    USER_ID INTEGER NOT NULL,
    NAME VARCHAR2(20) NOT NULL,
    RATING NUMBER(3,1),
    SALARY VARCHAR(100) NOT NULL,
    CONSTRAINT DRIVER_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT DRIVER_USER_ID_FK FOREIGN KEY (USER_ID) REFERENCES USERS (ID)
);

create table KEYS (
    ID NUMBER PRIMARY KEY,
    KEY raw(16) NOT NULL,
    TABLE_NAME varchar2(30) not null
);

CREATE TABLE PROMO_CODE (
    ID INTEGER NOT NULL,
    CODE VARCHAR2(5) NOT NULL,
    VALUE INTEGER NOT NULL,
    CONSTRAINT PROMO_CODE_PK PRIMARY KEY (ID) ENABLE
);

CREATE TABLE ORDERS (
    ID INTEGER NOT NULL,
    RESTAURANT_ID INTEGER NOT NULL,
    CUSTOMER_ID INTEGER NOT NULL,
    DRIVER_ID INTEGER NOT NULL,
    PROMO_ID INTEGER NOT NULL,
    DATE_CREATED DATE NOT NULL,
    DATE_COMPLETED DATE,
    TOTAL_ORDER_PRICE DECIMAL(6,2) NOT NULL,
    CONSTRAINT ORDERS_PK PRIMARY KEY (ID) ENABLE,
    CONSTRAINT ORDERS_RESTAURANT_ID_FK FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANT (ID),
    CONSTRAINT ORDERS_CUSTOMER_ID_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (ID),
    CONSTRAINT ORDERS_DRIVER_ID_FK FOREIGN KEY (DRIVER_ID) REFERENCES DRIVER (ID),
    CONSTRAINT ORDERS_PROMO_ID_FK FOREIGN KEY (PROMO_ID) REFERENCES PROMO_CODE (ID)
);

CREATE TABLE DRIVER_RATING (
    ORDER_ID INTEGER NOT NULL,
    DRIVER_ID INTEGER NOT NULL,
    RATING NUMBER(3,1),
    CONSTRAINT DRIVER_RATING_PK PRIMARY KEY (ORDER_ID, DRIVER_ID) ENABLE,
    CONSTRAINT DRIVER_RATING_ORDER_ID_FK FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ID),
    CONSTRAINT DRIVER_RATING_DRIVER_ID_FK FOREIGN KEY (DRIVER_ID) REFERENCES DRIVER (ID)
);

CREATE TABLE ORDER_PRODUCTS (
    ORDER_ID INTEGER NOT NULL,
    PRODUCT_ID INTEGER NOT NULL,
    QUANTITY INTEGER NOT NULL,
    MENTIONS VARCHAR2(150),
    CONSTRAINT ORDER_PRODUCTS_PK PRIMARY KEY (ORDER_ID, PRODUCT_ID) ENABLE,
    CONSTRAINT ORDER_PRODUCTS_ORDER_ID_FK FOREIGN KEY (ORDER_ID) REFERENCES ORDERS (ID),
    CONSTRAINT ORDER_PRODUCTS_PRODUCT_ID_FK FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (ID)
);

INSERT INTO CATEGORY (ID, NAME) VALUES (1, 'RESTAURANT');
INSERT INTO CATEGORY (ID, NAME) VALUES (2, 'TERASA');
INSERT INTO CATEGORY (ID, NAME) VALUES (3, 'CLUB');

INSERT INTO GEOGRAPHIC_LOCATION (ID, LATITUDE, LONGITUDE) VALUES (1, 44.421460, 26.130510);
INSERT INTO GEOGRAPHIC_LOCATION (ID, LATITUDE, LONGITUDE) VALUES (2, 44.421460, 26.130510);
INSERT INTO GEOGRAPHIC_LOCATION (ID, LATITUDE, LONGITUDE) VALUES (3, 44.421460, 26.130510);
INSERT INTO GEOGRAPHIC_LOCATION (ID, LATITUDE, LONGITUDE) VALUES (4, 44.421460, 26.130510);
INSERT INTO GEOGRAPHIC_LOCATION (ID, LATITUDE, LONGITUDE) VALUES (5, 44.421460, 26.130510);

INSERT INTO ADDRESS (ID, GEO_ID, CITY, STREET, NR) VALUES (1, 1, 'BUCURESTI', 'ACADEMIEI', 20);
INSERT INTO ADDRESS (ID, GEO_ID, CITY, STREET, NR) VALUES (2, 2, 'BUCURESTI', 'ACADEMIEI', 27);
INSERT INTO ADDRESS (ID, GEO_ID, CITY, STREET, NR) VALUES (3, 3, 'BUCURESTI', 'ACADEMIEI', 33);
INSERT INTO ADDRESS (ID, GEO_ID, CITY, STREET, NR) VALUES (4, 4, 'BUCURESTI', 'ACADEMIEI', 88);
INSERT INTO ADDRESS (ID, GEO_ID, CITY, STREET, NR) VALUES (5, 5, 'BUCURESTI', 'ACADEMIEI', 22);

INSERT INTO RESTAURANT(ID, CATEGORY_ID, ADDRESS_ID, NAME, DESCRIPTION, RATING) VALUES (1, 1, 1, 'Restaurant1', 'asdasdasdas', 70);
INSERT INTO RESTAURANT(ID, CATEGORY_ID, ADDRESS_ID, NAME, DESCRIPTION, RATING) VALUES (2, 2, 2, 'Restaurant2', 'asdasdasdas', 80);
INSERT INTO RESTAURANT(ID, CATEGORY_ID, ADDRESS_ID, NAME, DESCRIPTION, RATING) VALUES (3, 3, 3, 'Restaurant3', 'asdasdasdas', 60);
INSERT INTO RESTAURANT(ID, CATEGORY_ID, ADDRESS_ID, NAME, DESCRIPTION, RATING) VALUES (4, 1, 4, 'Restaurant4', 'asdasdasdas', 70);
INSERT INTO RESTAURANT(ID, CATEGORY_ID, ADDRESS_ID, NAME, DESCRIPTION, RATING) VALUES (5, 1, 5, 'Restaurant5', 'asdasdasdas', 90);

INSERT INTO USERS (ID, EMAIL, PASSWORD_HASH ) VALUES(1 , 'asd1@asd.com', '123145');
INSERT INTO USERS (ID, EMAIL, PASSWORD_HASH ) VALUES(2 , 'asd2@asd.com', '234523');
INSERT INTO USERS (ID, EMAIL, PASSWORD_HASH ) VALUES(3 , 'asd3@asd.com', '235553');
INSERT INTO USERS (ID, EMAIL, PASSWORD_HASH ) VALUES(4 , 'asd4@asd.com', '213525');
INSERT INTO USERS (ID, EMAIL, PASSWORD_HASH ) VALUES(5 , 'asd5@asd.com', '231566');

INSERT INTO CUSTOMER (ID, USER_ID, ADDRESS_ID, NAME, PHONE) VALUES (1, 1, 1, 'Andrei', '0733222333');
INSERT INTO CUSTOMER (ID, USER_ID, ADDRESS_ID, NAME, PHONE) VALUES (2, 2, 2, 'Mihai', '0743222333');
INSERT INTO CUSTOMER (ID, USER_ID, ADDRESS_ID, NAME, PHONE) VALUES (3, 3, 3, 'Razvan', '0733255333');
INSERT INTO CUSTOMER (ID, USER_ID, ADDRESS_ID, NAME, PHONE) VALUES (4, 4, 4, 'Costin', '0733255377');
INSERT INTO CUSTOMER (ID, USER_ID, ADDRESS_ID, NAME, PHONE) VALUES (5, 5, 5, 'Gabi', '0766255377');

INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (1, 1, 1, 'BUN', 80);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (2, 2, 2, 'SLAB', 50);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (3, 3, 3, 'BUN', 90);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (4, 4, 4, 'BUN', 85);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (5, 5, 5, 'BUN', 88);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (6, 1, 1, 'BUN', 80);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (7, 2, 2, 'SLAB', 50);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (8, 3, 3, 'BUN', 90);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (9, 4, 4, 'BUN', 85);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (10, 5, 5, 'BUN', 88);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (11, 1, 1, 'BUN', 80);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (12, 2, 2, 'SLAB', 50);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (13, 3, 3, 'BUN', 90);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (14, 4, 4, 'BUN', 85);
INSERT INTO REVIEW (ID, RESTAURANT_ID, CUSTOMER_ID, REVIEW_TEXT, RATING) VALUES (15, 5, 5, 'BUN', 88);

INSERT INTO PRODUCT (ID, NAME, DESCRIPTION, PRICE) VALUES(1, 'CARTOFI', 'DESCRIERE PRODUS', 50);
INSERT INTO PRODUCT (ID, NAME, DESCRIPTION, PRICE) VALUES(2, 'PUI', 'DESCRIERE PRODUS', 30);
INSERT INTO PRODUCT (ID, NAME, DESCRIPTION, PRICE) VALUES(3, 'PORC', 'DESCRIERE PRODUS', 50);
INSERT INTO PRODUCT (ID, NAME, DESCRIPTION, PRICE) VALUES(4, 'SALATA', 'DESCRIERE PRODUS', 80);
INSERT INTO PRODUCT (ID, NAME, DESCRIPTION, PRICE) VALUES(5, 'CASCAVAL PANE', 'DESCRIERE PRODUS', 20);

INSERT INTO RESTAURANT_PRODUCTS (RESTAURANT_ID, PRODUCT_ID) VALUES (1, 1);
INSERT INTO RESTAURANT_PRODUCTS (RESTAURANT_ID, PRODUCT_ID) VALUES (2, 2);
INSERT INTO RESTAURANT_PRODUCTS (RESTAURANT_ID, PRODUCT_ID) VALUES (3, 3);
INSERT INTO RESTAURANT_PRODUCTS (RESTAURANT_ID, PRODUCT_ID) VALUES (4, 4);
INSERT INTO RESTAURANT_PRODUCTS (RESTAURANT_ID, PRODUCT_ID) VALUES (5, 5);

INSERT INTO DRIVER (ID, USER_ID, NAME, RATING, SALARY) VALUES (1, 1, 'Marcel', 50, 2000);
INSERT INTO DRIVER (ID, USER_ID, NAME, RATING, SALARY) VALUES (2, 2, 'Vasile',40, 2500);
INSERT INTO DRIVER (ID, USER_ID, NAME, RATING, SALARY) VALUES (3, 3, 'Ion', 72.5, 2700);
INSERT INTO DRIVER (ID, USER_ID, NAME, RATING, SALARY) VALUES (4, 4, 'Claudiu',30, 2700);
INSERT INTO DRIVER (ID, USER_ID, NAME, RATING, SALARY) VALUES (5, 5, 'Ovidiu',90, 2700);

INSERT INTO PROMO_CODE (ID, CODE, VALUE) VALUES (1, 'COD1', 50);
INSERT INTO PROMO_CODE (ID, CODE, VALUE) VALUES (2, 'COD2', 100);
INSERT INTO PROMO_CODE (ID, CODE, VALUE) VALUES (3, 'COD3', 20);
INSERT INTO PROMO_CODE (ID, CODE, VALUE) VALUES (4, 'COD4', 10);
INSERT INTO PROMO_CODE (ID, CODE, VALUE) VALUES (5, 'COD5', 25);

INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (1, 1, 1, 1, 1, to_date('10-MAY-20-08-10','DD-MON-RR-HH24-MI'), to_date('10-MAY-20-08-40','DD-MON-RR-HH24-MI'), 50);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (2, 2, 2, 2, 2, to_date('11-MAY-20-09-10','DD-MON-RR-HH24-MI'), to_date('11-MAY-20-09-40','DD-MON-RR-HH24-MI'), 30);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (3, 3, 3, 3, 3, to_date('12-MAY-20-10-20','DD-MON-RR-HH24-MI'), to_date('12-MAY-20-10-55','DD-MON-RR-HH24-MI'), 50);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (4, 4, 4, 4, 4, to_date('13-MAY-20-13-05','DD-MON-RR-HH24-MI'), to_date('13-MAY-20-13-35','DD-MON-RR-HH24-MI'), 80);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (5, 5, 5, 5, 5, to_date('14-MAY-20-14-05','DD-MON-RR-HH24-MI'), to_date('14-MAY-20-14-55','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (6, 1, 1, 1, 1, to_date('15-MAY-20-12-10','DD-MON-RR-HH24-MI'), to_date('15-MAY-20-13-10','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (7, 2, 2, 2, 3, to_date('16-MAY-20-15-30','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-16-10','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (8, 3, 3, 3, 4, to_date('16-MAY-20-18-00','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-18-45','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (9, 4, 4, 4, 5, to_date('16-MAY-20-15-30','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-16-30','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (10, 5, 5, 5, 5, to_date('17-MAY-20-14-15','DD-MON-RR-HH24-MI'), to_date('17-MAY-20-14-25','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (11, 1, 1, 1, 1, to_date('15-MAY-20-17-03','DD-MON-RR-HH24-MI'), to_date('15-MAY-20-17-58','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (12, 1, 2, 2, 3, to_date('16-MAY-20-11-25','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-12-05','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (13, 2, 3, 3, 4, to_date('16-MAY-20-12-20','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-13-00','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (14, 5, 4, 4, 5, to_date('16-MAY-20-15-20','DD-MON-RR-HH24-MI'), to_date('16-MAY-20-16-10','DD-MON-RR-HH24-MI'), 20);
INSERT INTO ORDERS (ID, RESTAURANT_ID, CUSTOMER_ID, DRIVER_ID, PROMO_ID, DATE_CREATED, DATE_COMPLETED, TOTAL_ORDER_PRICE) VALUES (15, 5, 5, 5, 5, to_date('17-MAY-20-18-10','DD-MON-RR-HH24-MI'), to_date('17-MAY-20-18-40','DD-MON-RR-HH24-MI'), 20);

INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (1, 1, 40);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (2, 2, 60);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (3, 3, 90);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (4, 4, 80);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (5, 5, 55);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (6, 1, 55);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (7, 1, 55);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (8, 3, 55);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (9, 4, 55);
INSERT INTO DRIVER_RATING (ORDER_ID, DRIVER_ID, RATING) VALUES (10, 5, 55);

INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (1, 1, 6, 'MENTION1');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (2, 2, 5, 'MENTION2');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (3, 3, 3, 'MENTION3');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (4, 4, 4, 'MENTION4');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (5, 2, 5, 'MENTION5');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (6, 3, 6, 'MENTION6');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (7, 5, 5, 'MENTION7');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (8, 2, 4, 'MENTION8');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (9, 3, 3, 'MENTION9');
INSERT INTO ORDER_PRODUCTS (ORDER_ID, PRODUCT_ID, QUANTITY, MENTIONS) VALUES (10, 4, 2, 'MENTION10');

CREATE SEQUENCE KEY_SECV INCREMENT BY 1 START WITH 1;

CREATE OR REPLACE PACKAGE CRYPT
AS
    PROCEDURE ENCRYPT_SALARY;
    PROCEDURE DECRYPT_SALARY;
END;

CREATE OR REPLACE PACKAGE BODY CRYPT
AS
     encryption_type    PLS_INTEGER := dbms_crypto.encrypt_aes128 + dbms_crypto.pad_pkcs5 + dbms_crypto.chain_cbc;

     encryption_key     RAW (16) := dbms_crypto.randombytes(16);

PROCEDURE ENCRYPT_SALARY as
    CURSOR C_CRYPT IS SELECT ID, SALARY from DRIVER;
    salary raw(100);
    salary_encrypted raw(100);
    i number := 1;

BEGIN

    dbms_output.put_line('ENCRYPTION KEY: ' || encryption_key);

    INSERT INTO KEYS VALUES(KEY_SECV.nextval, encryption_key, 'DRIVERS');

    FOR rec IN C_CRYPT LOOP
        salary :=utl_i18n.string_to_raw(rec.SALARY, 'AL32UTF8');
        salary_encrypted := dbms_crypto.encrypt(salary, encryption_type, encryption_key);

        UPDATE DRIVER SET SALARY = salary_encrypted WHERE ID = REC.ID;
        i := i + 1;

    END LOOP;
    COMMIT;
END;

PROCEDURE DECRYPT_SALARY AS
    CURSOR C_DECRYPT IS SELECT ID, SALARY from DRIVER;

    salary raw(100);
    salary_decrypted raw(100);
    i number := 1;

BEGIN

    dbms_output.put_line('ENCRYPTION KEY: ' || encryption_key);

    FOR ln IN C_DECRYPT LOOP
        salary :=utl_i18n.string_to_raw(ln.SALARY, 'AL32UTF8');
        salary_decrypted := dbms_crypto.decrypt(ln.SALARY, encryption_type, encryption_key);

        UPDATE DRIVER SET SALARY = utl_i18n.raw_to_char(salary_decrypted, 'AL32UTF8') WHERE ID = ln.ID;
        i := i + 1;

    END LOOP;
    COMMIT;
END;
END;

BEGIN
    crypt.ENCRYPT_SALARY();
END;

SELECT * FROM DRIVER;

BEGIN
    CRYPT.DECRYPT_SALARY();
end;

--AUDIT
SELECT VALUE FROM V$PARAMETER WHERE NAME='AUDIT_TRAIL';
