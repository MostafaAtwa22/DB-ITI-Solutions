-- 1.
Alter Function FMonth(@Date Date)
returns varchar(20)
As
begin
	Declare @Name varchar(20) = DATENAME(month,@Date)
	return @Name
end

Select dbo.FMonth('01-01-2003')

-- 2.
Create or alter Function FRange (@x int, @y int)
RETURNS @t TABLE (val int)
As
begin 
	Declare @n int = @x + 1;
	While @n < @y
	begin
		insert into @t
		values(@n)
		set @n += 1;
	end
return 
end

select * from FRange(10, 20)

-- 3.
Create or Alter Function Ex3 (@Id int)
returns table
As
return
(
	select d.Dept_Name, CONCAT(s.St_Fname, ' ', s.St_Lname) As [Full Name]
	from Student s join Department d
	on s.Dept_Id = d.Dept_Id and s.St_Id  = @Id
)

select * from Ex3 (10)

-- 4.
Create Function Ex4 (@id int)
returns @t table (message varchar(max))
As
begin
	declare @f varchar(max), @l varchar(max) 
	Select @f = St_Fname, @l = St_Lname 
	from Student
	where St_Id = @id

	if (@f is NULL and @l is Null)
		insert into @t
		values('First name & last name are null')
	else if (@f is NULL)
		insert into @t
		values('First name is null')
	else if (@l is Null)
		insert into @t
		values('last name is null')
	else
		insert into @t
		values('First name & last name are not null')
return
end

select * from dbo.Ex4(130)

-- 5.
Create Function Ex5 (@id int)
returns table
As
return
(
	select d.Dept_Name, i.Ins_Name, d.Manager_hiredate 
	from Instructor i join Department d
	on d.Dept_Manager = i.Ins_Id
	where d.Dept_Manager = @id
)

select * from Ex5(12)

-- 6.
Create or Alter Function Ex6(@Format varchar(max))
returns @t Table (Name varchar(50))
As
begin
	if (@Format = 'first name')
		insert into @t
		select IsNULL(St_Fname, '_') 
		From Student
	else if (@Format = 'last name')
		insert into @t
		select ISNULL(St_Lname, '_') 
		From Student
	else if (@Format = 'full name')
		insert into @t
		select IsNULL(St_Fname, '_') + ' ' + ISNULL(St_Lname, '_')
		From Student
	Else
		insert into @t
		select 'Unvalid option'
return
end

Select * from dbo.studentInfo('full name')

-- 7.
Select St_Id,left(St_Fname, len(st_fname) - 1)
from Student

