-- [DQL]
-- 1) a.
select Dependent_name, Sex
from Dependent
Where sex = 'F'
union
select Fname + ' ' + Lname, Sex
from Employee
where sex = 'F'

-- 1) b.
select Dependent_name, Sex
from Dependent
Where sex = 'M'
union
select Fname + ' ' + Lname, Sex
from Employee
where sex = 'M'

-- 2)
select p.Pname, sum(wr.Hours)
from [dbo].[Works_for] wr join [dbo].[Project] p on p.Pnumber = wr.Pno
group by p.Pname;

-- 3)
select * 
from Departments d join Employee e
on d.Dnum = e.Dno
where e.SSN = (select min(ssn) from Employee where Dno is not null)


-- 4)
select d.Dname, min(e.Salary), max(e.Salary), AVG(e.Salary)
from Departments d join Employee e
on d.Dnum = e.Dno
group by d.Dname

-- 5)
select e.Lname
from Departments d join Employee e on e.SSN = d.MGRSSN
where d.MGRSSN not in(select Essn from Dependent)

-- 6)
select d.Dname, d.Dnum, COUNT(e.SSN)
from Departments d join Employee e on e.Dno = d.Dnum
group by d.Dname, d.Dnum
having AVG(e.Salary) < (select avg(Salary) from Employee)

-- 6)
select e.Fname, e.Lname, p.Pnumber, p.Pname 
from Project p join Works_for w on w.Pno = p.Pnumber
join Employee e on e.SSN = w.ESSn 
order by e.Dno, e.Fname, e.Lname

-- 7)
SELECT Fname, Lname, salary
FROM (
    SELECT Fname, Lname, salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
    FROM Employee
) AS ranked_salaries
WHERE salary_rank <= 2;


-- 8)
select distinct e.Fname + ' ' + e.Lname
from Employee e join Dependent d
on d.ESSN = e.SSN

-- 9)
Declare @t table (id int) 

insert into @t (id)
select e.SSN
from Employee e join Works_for w on e.SSN = w.ESSn
join Project p on p.Pnumber = w.Pno
where p.Pname = 'Al Rabwah'

update Employee 
set Salary += Salary * 0.3
where SSN in (select * from @t)

-- 10)
if exists (Select * from Dependent where ESSN is not null)
	select SSN, Fname
	from Employee