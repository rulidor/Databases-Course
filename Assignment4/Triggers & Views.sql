CREATE VIEW ConstructorEmployeeOverFifty AS
select Employee.EID, FirstName, LastName, BirthDate, Door, Number, StreetName, City, CompanyName, SalaryPerDay
from Employee, ConstructorEmployee 
WHERE Employee.EID = ConstructorEmployee.EID AND
(Employee.BirthDate <= '1970-1-1')
;

CREATE VIEW ApartmentNumberInNeighborhood AS
SELECT NID, (SELECT COUNT( *) FROM apartment
AS a WHERE a.NID = n.NID) AS ApartmentNumber FROM Neighborhood
AS n
;

CREATE TRIGGER DeleteProject AFTER DELETE ON Project
BEGIN
DELETE FROM ProjectConstructorEmployee WHERE old.PID = ProjectConstructorEmployee.PID;
DELETE FROM ConstructorEmployee WHERE ConstructorEmployee.EID NOT IN (SELECT ProjectConstructorEmployee.EID FROM ProjectConstructorEmployee);
DELETE FROM Employee WHERE Employee.EID NOT IN (SELECT ConstructorEmployee.EID FROM ConstructorEmployee);
END;


CREATE TRIGGER MaxManger_BeforInsert BEFORE INSERT ON Department
BEGIN
SELECT
CASE WHEN new.ManagerID = (SELECT ManagerID FROM OfficialEmployee, Department
WHERE Department.ManagerID = OfficialEmployee.EID
group by ManagerID
HAVING COUNT(ManagerID > 2))
THEN RAISE(ABORT, 'An Employee cannot manage more than one department simultaneously') 
END;
END;


CREATE TRIGGER MaxManger_BeforUpdate BEFORE UPDATE ON Department
BEGIN
SELECT
CASE WHEN new.ManagerID = (SELECT ManagerID FROM OfficialEmployee, Department
WHERE Department.ManagerID = OfficialEmployee.EID
group by ManagerID
HAVING COUNT(ManagerID > 2))
THEN RAISE(ABORT, 'An Employee cannot manage more than one department simultaneously') 
END;
END;