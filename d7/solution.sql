--Use ITI DB
-- 1.
alter View V1 
with Encryption
As
	Select CONCAT(s.St_Fname, ' ', s.St_Lname) As 'full Name', c.Crs_Name, sc.Grade
	from Student s join Stud_Course sc on s.St_Id = sc.St_Id
	join Course c on c.Crs_Id = sc.Crs_Id
	where sc.Grade > 50

Select * from V1


-- 2.
Create View V2
With Encryption
As
	Select i.Ins_Name, t.Top_Name
	from Instructor i join Ins_Course ic on i.Ins_Id = ic.Ins_Id
	join Course c on c.Crs_Id = ic.Crs_Id 
	join Topic t on t.Top_Id = c.Top_Id
	join Department d  on d.Dept_Manager = i.Ins_Id

select * from V2
order by Ins_Name

-- 3.
Create View V3(Name, Department)
with Encryption
As
	select i.Ins_Name, d.Dept_Name
	from Instructor i join Department d
	on i.Dept_Id = d.Dept_Id
	where d.Dept_Name in ('SD', 'Java')

select * from V3

-- 4.
Create View V4
As
	select * from Student
	where St_Address in ('Alex', 'Cairo')

select * from V4

Update V4 set st_address = 'Tanta'
Where st_address = 'Alex' and St_Id = 1;


-- 5.
Use [Company_SD_Full]
Go
create View V5
As
	Select p.PName, count(w.ESSN) As 'number of Emps'
	from Project p join Works_for w on p.PNumber = w.PNO
	join Employee e on w.ESSN = e.SSN
	group by p.PName
Go
Select * from V5


-- 6.
create nonClustered index IndMGRDate
on Departments ([MgrStart Date])

-- 8.
Create Table [Daily Transactions]
(
	Did int,
	amount money
)
Go 
Insert into [Daily Transactions]
Values (1, 1000),
	   (2, 2000),
	   (3, 1000)
Go
Create Table [Last Transactions]
(
	lid int,
	amount money
)
Go 
Insert into [Last Transactions]
Values (1, 4000),
	   (4, 200),
	   (2, 10000)

Merge into [Last Transactions] As LT
using [Daily Transactions] As DT
on LT.lid = DT.Did
When matched then
	Update 
	set LT.amount = DT.amount
When not matched by target then
	insert 
	Values (DT.Did, DT.amount)
When not matched by source then
	Delete;

------------------------------------------------------------------
