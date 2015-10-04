CREATE TABLE Emp (
  eid    INTEGER NOT NULL,
  ename  CHAR(35),
  age    INTEGER,
  salary REAL,
  PRIMARY KEY (eid)
);

CREATE TABLE Department (
  did       INTEGER NOT NULL,
  budget    DOUBLE,
  managerid INTEGER,
  PRIMARY KEY (did)
);

CREATE TABLE Works (
  eid      INTEGER,
  did      INTEGER,
  pct_time INTEGER,
  PRIMARY KEY (eid, did),
  FOREIGN KEY (eid) REFERENCES Emp (eid),
  FOREIGN KEY (did) REFERENCES Department (did)
);

/* 1.   For each department with more than 20 full-time-equivalent employees (i.e., where the part-time and full-time employees add up to at least that many full-time employees), print the did together with the number of employees that work in that department.
 */
SELECT
  W.did,
  Count(DISTINCT W.eid)
FROM works W
GROUP BY W.did
HAVING (SELECT Sum(W2.pct_time)
        FROM works W2
        WHERE W2.did = W.did) >= 2000;

/* 2.   Find the enames of managers who manage the departments with the largest budgets.*/
SELECT E.ename
FROM department D
  INNER JOIN emp E
    ON D.managerid = E.eid
WHERE D.budget = (SELECT Max(D.budget)
                  FROM department D);

/* 3.	If a manager manages more than one department, he or she controls the sum of all the budgets for those departments. Find the managerids of managers who control more than $5 million. */
SELECT d.managerid
FROM department d
GROUP BY managerid
HAVING Sum(d.budget) > 5000000;

/* 4.	Find the managerids of managers who control the largest amounts.*/
SELECT d.managerid
FROM department d
GROUP BY managerid
HAVING Sum(d.budget) >= ALL (SELECT Sum(d.budget) AS SUM
                             FROM department d
                             GROUP BY managerid);