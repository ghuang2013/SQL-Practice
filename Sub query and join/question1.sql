/*
1. Give an example of a foreign key constraint that involves the Dept relation. 
    Answer: Manageid is a foreign key. It references the primary key eid in the Emp table
2. Write the SQL statements required to create the preceding relations, including appropriate
versions of all primary and foreign key integrity constraints.
3. Define the Dept relation in SQL so that every department is guaranteed to have a manager.
*/
CREATE TABLE Emp(
    eid INTEGER NOT NULL,
    ename VARCHAR(35) NOT NULL,
    age INTEGER,
    salary REAL,
    PRIMARY KEY(eid)
);

CREATE TABLE Department( 
    did INTEGER NOT NULL, 
    dname VARCHAR(50) NOT NULL, 
    budger REAL, 
    manageid INTEGER NOT NULL,  #3 Answer
    PRIMARY KEY(did),
    FOREIGN KEY(manageid) REFERENCES Emp(eid) #1 Answer
    ON DELETE NO ACTION 
);

CREATE TABLE Works( 
    eid INTEGER, 
    did INTEGER, 
    pet_time INTEGER, 
    PRIMARY KEY(eid,did), 
    FOREIGN KEY(eid) REFERENCES Emp(eid), 
    FOREIGN KEY(did) REFERENCES Department(did) 
);

/*
4. Write an SQL statement to add John Doe as an employee with eid = 101, age = 32 and salary = 15,000.
*/
INSERT INTO emp 
            (eid, 
             ename, 
             age, 
             salary) 
VALUES     (101, 
            'john doe', 
            32, 
            15000); 

/*5. Write an SQL statement to give every employee a 10 percent raise.*/
UPDATE emp 
SET    salary = salary + salary * 0.1; 

/*6. Write an SQL statement to delete the Toy department. */
DELETE FROM department 
WHERE  dname = 'toy department'; 
