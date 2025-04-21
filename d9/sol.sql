-- 1.
Declare C cursor 
for Select salary
from Employee
for update

Declare @salary int
Open c
fetch c into @salary

While @@FETCH_STATUS = 0
begin
	if @salary < 3000
		update Employee
		set Salary += @salary * 0.1
		where current of c
	else
		update Employee
		set Salary += @salary * 0.2
		where current of c
	fetch c into @salary
end
close c
Deallocate c
-------------------------------------------

-- 2.
Declare c cursor
for Select d.Dname, e.Fname
from Departments d join Employee e
on e.SSN = d.MGRSSN
for read only

Declare @dep varchar(20), @name varchar(20)
open c
fetch c into @dep, @name

while @@FETCH_STATUS = 0
begin
	select @dep, @name
	fetch c into @dep, @name
end
close c
deallocate c
------------------------------------------------

-- 3.
Declare c Cursor
for select ST_Fname
from Student
for read only

Declare @stName varchar(20), @FullName varchar(max) = ''
Open c
Fetch c into @stName

While @@FETCH_STATUS = 0
begin 
	set @FullName = CONCAT(@stName, ', ', @FullName)
	Fetch c into @stName
end
select @FullName
close c
deallocate c
------------------------------------------
BACKUP DATABASE ITI_BackUP
TO DISK = 'D:\programming\Backend\Database\ITI Exercies\d10\Day5'
