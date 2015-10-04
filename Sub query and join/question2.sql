CREATE TABLE Supplier(
    sid INTEGER,
    sname VARCHAR(100),
    address VARCHAR(150),
    PRIMARY KEY(sid)
);
    
CREATE TABLE Parts(
    pid INTEGER,
    pname VARCHAR(100),
    color VARCHAR(50),
    PRIMARY KEY(pid)
);

CREATE TABLE Catalog(
    sid INTEGER,
    pid INTEGER,
    cost REAL,
    PRIMARY KEY(sid,pid),
    FOREIGN KEY(sid) REFERENCES Supplier(sid),
    FOREIGN KEY(pid) REFERENCES Parts(pid)
);

/*
1. Find the pnames of parts for which there is some supplier.
*/
SELECT DISTINCT P.pname 
FROM   parts P 
WHERE  P.pid IN (SELECT C.pid 
                 FROM   catalog C); 
/*
2. Find the snames of suppliers who supply every part.
*/
SELECT S.sname 
FROM   supplier S 
WHERE  NOT EXISTS (SELECT P.pid 
                   FROM   parts P 
                   WHERE  P.pid NOT IN (SELECT C.pid 
                                        FROM   catalog C 
                                        WHERE  C.sid = S.sid)); 

/*
3. Find the snames of suppliers who supply every red part.
*/
SELECT S.sname 
FROM   supplier S 
WHERE  NOT EXISTS(/*this dosen't exist*/ 
                 SELECT P.pid 
                  FROM   parts P 
                  WHERE  P.color = 'red' /*a red part is not in that list*/ 
                         AND P.pid NOT IN(SELECT C.pid 
                                          /*display all red item this supplier supplys*/ 
                                          FROM   catalog C, 
                                                 parts P 
                                          WHERE  C.sid = S.sid 
                                                 AND P.pid = C.pid 
                                                 AND P.color = 'red')); 
/*
4. Find the pnames of parts supplied by Acme Widget Suppliers and no one else.
*/
SELECT P.pname 
FROM   parts P 
WHERE  P.pid IN (SELECT C.pid 
                 FROM   catalog C 
                        INNER JOIN supplier S 
                                ON S.sid = C.sid 
                 WHERE  S.sname = 'acme widget suppliers' 
                        AND C.pid NOT IN (SELECT C2.pid 
                                          FROM   catalog C2 
                                                 INNER JOIN supplier S 
                                                         ON S.sid = C2.sid 
                                          WHERE  S.sname <> 'acme widget suppliers')); 

/*
5. Find the sids of suppliers who supply only red parts.
*/
SELECT DISTINCT C.sid 
FROM   catalog C 
WHERE  C.sid NOT IN(SELECT C.sid 
                    FROM   catalog C 
                           INNER JOIN parts P 
                                   ON p.pid = C.pid 
                    WHERE  P.color <> 'red'); 
/*
6. Find the sids of suppliers who supply a red part and a green part.
*/
SELECT DISTINCT S.sid 
FROM   supplier S 
       INNER JOIN catalog C 
               ON S.sid = c.sid 
       INNER JOIN parts P 
               ON P.pid = C.pid 
WHERE  P.color = 'red' 
intersect 
SELECT DISTINCT S.sid 
FROM   supplier S 
       INNER JOIN catalog C 
               ON S.sid = c.sid 
       INNER JOIN parts P 
               ON P.pid = C.pid 
WHERE  P.color = 'green' 

/* mysql workaround */
SELECT S.sid 
FROM   supplier S 
       INNER JOIN catalog C 
               ON S.sid = c.sid 
       INNER JOIN parts P 
               ON P.pid = C.pid 
WHERE  P.color = 'red' 
       AND S.sid IN(SELECT S.sid 
                    FROM   supplier S 
                           INNER JOIN catalog C 
                                   ON S.sid = c.sid 
                           INNER JOIN parts P 
                                   ON P.pid = C.pid 
                    WHERE  P.color = 'green') 
GROUP  BY s.sid; 

/*
7. Find the sids of suppliers who supply a red part or a green part.
*/
SELECT S.sid 
FROM   supplier S 
       INNER JOIN catalog C 
               ON S.sid = c.sid 
       INNER JOIN parts P 
               ON P.pid = C.pid 
WHERE  P.color = 'red' 
        OR P.color = 'green' 
GROUP  BY S.sid; 