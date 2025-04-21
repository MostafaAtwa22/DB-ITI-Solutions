-- Part-1: Use ITI DB

-- 1)
Select * 
From Student 
Where st_Age is not null

-- 2)
Select Distinct Ins_Name 
from Instructor

-- 3)
Select s.St_Id, s.St_Fname + ' ' + s.St_Lname as 'full name', d.Dept_Name
from Student s join Department d
On s.Dept_Id = d.Dept_Id

-- 4)
Select s.St_Fname + ' ' + s.St_Lname as 'full name', d.Dept_Name
from Student s Left join Department d
On s.Dept_Id = d.Dept_Id

-- 5.
Select s.St_Fname + ' ' + s.St_Lname as 'full name', cr.Crs_Name
from Student s join Stud_Course c
on s.St_Id = c.St_Id
join Course cr on cr.Crs_Id = c.Crs_Id 
Where c.Grade is not null

-- 6.
Select t.Top_Name, count(c.Crs_Id)
from Course c join Topic t
On c.Top_Id = t.Top_Id
group by t.Top_Name
order by COUNT(c.Crs_Id) DESC

-- 7.
Select Max(Salary), Min(Salary)
from Instructor

-- 8.
Select Ins_Name, Salary
from Instructor
where Salary < (Select Avg(Salary) from Instructor)


-- 9.
Select d.Dept_Name
from Department d Join Instructor i
on d.Dept_Id = i.Dept_Id
Where d.Dept_Id = (Select d.Dept_Id 
				   Where i.Salary = (Select Min(Salary) From Instructor))

-- 10.
Select salary
from (Select *, ROW_NUMBER() over(order by salary DESC) As RN 
			From Instructor) As newtable
Where RN <= 2

-- 11.
Select Ins_Name, Coalesce(Salary, 1000)
from Instructor

-- 12. 
Select AVG(Salary)
from Instructor


-- 13.
Select s.St_Fname, sup.St_Id, sup.St_Fname + ' ' + sup.St_Lname
from student s join student sup
on s.St_super = sup.St_Id

-- 14.
Select Dept_Id, IsNULL(salary, 0)
from (Select *, 
		ROW_NUMBER() over (partition by [Dept_Id] order by salary DESC) As RN
		from Instructor) As newTable
Where RN < 3


-- 15.
Select st_Fname
from (Select *,
		ROW_NUMBER() Over (partition by [Dept_Id] Order by newID()) As RN
		from Student) As newtable
where RN = 1
