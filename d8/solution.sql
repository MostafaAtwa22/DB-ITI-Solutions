-- 1. 
Create Proc sp1 
With Encryption
As
	Select d.Dept_Name, count(s.St_Id)
	from Student s join Department d
	on s.Dept_Id = d.Dept_Id
	group by d.Dept_Name

Exec sp1


-- 2.
USE Company_SD_Full
GO
Alter proc sp2 @PNo int
with Encryption
As
	declare @name varchar(max)  
	select @name = pname from Project
	declare @num int
	Select @num = count(w.[ESSn])
	from [dbo].[Project] p join [dbo].[Works_for] w on p.[Pnumber] = w.[Pno]
	Join [dbo].[Employee] e on e.[SSN] = w.[ESSn]
	Where p.Pnumber = @PNo
	Group By p.[Pname]

	if (@num >= 3)
		Select 'The number of employees in the project ' + @name + ' is 3 or more'
	else
		Select p.[Pname], e.[Fname], e.[Lname]
		from [dbo].[Project] p join [dbo].[Works_for] w on p.[Pnumber] = w.[Pno]
		Join [dbo].[Employee] e on e.[SSN] = w.[ESSn] 
		Where p.Pnumber = @PNo

Exec Sp2 300

-- 3.
Create Proc SP3 @oldEmp int, @newEmp int, @pNo int
with Encryption 
As
	update Works_for
	set ESSn = @newEmp
	Where Pno = @pNo and ESSn = @oldEmp

Exec sp3 968574, 112233, 300


-- 4.
Alter Table Project
Add Buadet money 

Create Trigger TP
On Project 
after update 
As
	Select * from inserted
	select * from deleted
	select USER_NAME(), GETDATE()
	
update Project
set Buadet = 500000
Where Pnumber = 100


-- 5.
Create Trigger Tdep 
On [dbo].[Departments]
instead of insert
As
	select ' cant insert a new record in that table'

insert into [dbo].[Departments]
Values ('DP4', 40, 968574, GETDATE())


-- 6.
Create Trigger TMarch1 
On employee
After insert
As
	if (FORMAT(GETDATE(), 'mmmm') = 'March')
	begin
		Delete from Employee
		Where SSN = (Select SSN from deleted)
	end

Create Trigger TMarch2
On employee
instead of insert
As
	if (FORMAT(GETDATE(), 'mmmm') != 'March')
	begin
		Insert into Employee 
		select * from deleted
	end

-- 7.
Create Table History
(
	_user varchar(20),
	_date date,
	note varchar(max)
)

alter TRIGGER t7
ON Student
AFTER INSERT
AS
BEGIN
	DECLARE @name VARCHAR(500);
	SELECT @name = [St_Fname] + ' ' +  [St_Lname] FROM inserted;
	INSERT INTO History
	VALUES (SUSER_SNAME(), GETDATE(), 'The student ' + @name + ' is a new student');
END;

INSERT INTO Student(St_ID, St_Fname, St_Lname, St_Address, St_Age, Dept_Id, St_super)
VALUES (100, 'Tanjiro', 'Kamado', 'Cairo', 21, 40, 1);


-- 9.
select * from Student
for XML Raw ('Student'), elements xsinil, root('Students')

-- 10.
-- A)
select d.Dept_Name, count(i.Ins_Id) As 'Number of Instractors'
from Department d join Instructor i
on d.Dept_Id = i.Dept_Id
Group by d.Dept_Name
For XML Auto , elements xsinil, root('Dept_Inst')

-- B)
select d.Dept_Name "@Dept_Name"
from Department d 
For XML path('Dept_Inst')


-- 11.
-- Step 1: Create the customers table
CREATE TABLE customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    Zipcode NVARCHAR(10),
    OrderID NVARCHAR(50),
    Product NVARCHAR(50)
);

-- Step 2: Declare the XML variable
DECLARE @docs XML = 
'<customers>
    <customer FirstName="Bob" Zipcode="91126">
        <order ID="12221">Laptop</order>
    </customer>
    <customer FirstName="Judy" Zipcode="23235">
        <order ID="12221">Workstation</order>
    </customer>
    <customer FirstName="Howard" Zipcode="20009">
        <order ID="3331122">Laptop</order>
    </customer>
    <customer FirstName="Mary" Zipcode="12345">
        <order ID="555555">Server</order>
    </customer>
</customers>';

-- Step 3: Prepare the document for OPENXML
DECLARE @idoc INT;
EXEC sp_xml_preparedocument @idoc OUTPUT, @docs;

-- Step 4: Insert data into the customers table
INSERT INTO customers (FirstName, Zipcode, OrderID, Product)
SELECT
    customer.FirstName,
    customer.Zipcode,
    customer.OrderID,
    customer.Product
FROM OPENXML(@idoc, '/customers/customer', 2)
WITH (
    FirstName NVARCHAR(50) '@FirstName',
    Zipcode NVARCHAR(10) '@Zipcode',
    OrderID NVARCHAR(50) 'order/@ID',
    Product NVARCHAR(50) 'order'
) AS customer;

-- Step 5: Remove the prepared document
EXEC sp_xml_removedocument @idoc;

-- Step 6: Verify the inserted data
SELECT * FROM customers;