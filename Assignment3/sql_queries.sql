/*dor perez-204446025,lidor rubi-203269972*/

--Q1
 SELECT DISTINCT FirstName, SalaryPerDay, Name, Description
FROM Employee, ConstructorEmployee, ProjectConstructorEmployee, Project
WHERE Employee.EID = ConstructorEmployee.EID AND ConstructorEmployee.EID = ProjectConstructorEmployee.EID
AND ProjectConstructorEmployee.PID = Project.PID

--Q2
SELECT Employee.*,Department.Name
FROM Employee,OfficialEmployee,Department
WHERE Employee.EID = OfficialEmployee.EID AND OfficialEmployee.Department = Department.DID
UNION
SELECT DISTINCT Employee.*, Project.Name
FROM Employee,ConstructorEmployee,ProjectConstructorEmployee,Project
WHERE ProjectConstructorEmployee.PID = Project.PID and Employee.EID= ConstructorEmployee.EID AND ConstructorEmployee.EID = ProjectConstructorEmployee.EID AND ProjectConstructorEmployee.EndWorkingDate = 
(SELECT max(EndWorkingDate) FROM ProjectConstructorEmployee as emplo WHERE emplo.EID = ProjectConstructorEmployee.EID)

--Q3
SELECT Neighborhood.Name,count(Apartment.NID) AS counter
FROM Neighborhood,Apartment
WHERE Neighborhood.NID = Apartment.NID
GROUP BY Neighborhood.Name
ORDER BY COUNT(Apartment.NID)

--Q4
SELECT  Apartment.StreetName,Apartment.Number, Apartment.Door, LastName
FROM Apartment 
LEFT JOIN Resident on Resident.Door =Apartment.Door and Resident.Number  = Apartment.Number and Resident.StreetName = Apartment.StreetName 

--Q5
SELECT *
FROM ParkingArea
WHERE MaxPricePerDay = (SELECT min(ParkingArea.MaxPricePerDay)FROM ParkingArea)

--Q6
SELECT DISTINCT Car.ID, Car.CID
FROM Car , CarParking , ParkingArea
WHERE CarParking.AID = ParkingArea.AID  AND CAR.CID = CarParking.CID
AND ParkingArea.MaxPricePerDay = (SELECT min(ParkingArea.MaxPricePerDay)FROM ParkingArea)

--Q7
select  r.FirstName, r.LastName, r.RID
from Resident r inner join car c
on r.RID = c.id
inner join CarParking cp 
on cp.CID = c.CID
left join (select distinct r.RID, pa.AID 
			from (select distinct StreetName,NID from Apartment) a inner join Neighborhood n 
			on n.NID = a.NID
			inner join ParkingArea pa 
			on n.NID = pa.NID
			inner join Resident r
			on r.StreetName = a.StreetName) t2
on cp.AID = t2.AID and r.rid = t2.rid
group by r.FirstName, r.LastName
having sum(case when t2.AID is null then 1 else 0 end ) = 0

--Q8
select num_of_area_per_resident.FirstName, num_of_area_per_resident.LastName, num_of_area_per_resident.RID
from  (
select r.FirstName,r.LastName,r.RID, count(distinct cp.AID) as cnt
from Resident r inner join car c
on r.RID = c.id
inner join CarParking cp 
on cp.CID = c.CID
group by r.FirstName,r.LastName) num_of_area_per_resident
inner join
(select count(distinct AID)as cnt from ParkingArea) num_of_total_parking_area
on num_of_area_per_resident.cnt = num_of_total_parking_area.cnt

--Q9
CREATE VIEW r_ngbrhd
as select * from Neighborhood where name like 'r%' or name like 'R%'