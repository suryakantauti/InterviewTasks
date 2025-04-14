Create Database InterviewTask;
Use InterviewTask;

--LoginUser table
Create table LoginUser(UserId int primary key identity(1,1), Username varchar(60) not null,
Password varchar(50) not null, EmpId int references Employee(EmpId), Role varchar(30), IsActive bit);
Insert into LoginUser values('suryakant', '$urya123', 1, 'Admin', 1), 
('onkar', 'Onkar77', 2, 'Developer', 1);
Select * from LoginUser;

Create table Employee(EmpID int primary key identity(1,1), Name varchar(60) not null, 
DOB date, Sex varchar(10), Phone varchar(20), Address varchar(100), ImagePath varchar(255));
Insert into Employee values
('Suryakant Auti', '2002-02-25', 'Male', '8208790129', 'Balaji Nagar, Pune', '~/Assets/suryakant.jpg'),
('Onkar Funde', '1998-07-12', 'Male', '9876545623', 'Narayan Doho, Ahilyanagar', '~/Assets/onkar.jpg'),
('Vaibhav Wandhekar', '2003-01-26', 'Male', '7744870152', 'Nagapur, Ahilyanagar', '~/Assets/vaibhav.jpg'),
('Vishal Khedkar', '2003-11-06', 'Male', '8754567893', 'Beed, Ahilyanagar', '~/Assets/vishal.jpg');
Select * from Employee;

--Stored Procedures
Create proc SPUserExists @Username varchar(60), @Password varchar(50) as Begin
Select l.Role, e.Name, e.Phone from LoginUser l join Employee e on l.EmpId = e.EmpId
where l.Username = @Username and l.Password = @Password and l.IsActive = 1; End;

Exec SPUserExists 'suryakant', '$urya123';

--SPGetAllEmployee
Create proc SPGetAllEmployee as Begin Select * from Employee; End;
Exec SPGetAllEmployee;

--SPInsertEmployee
Create proc SPInsertEmployee @Name varchar(60), @DOB date, @Sex varchar(10), 
@Phone varchar(20), @Address varchar(100), @ImagePath varchar(255)
as Begin Insert into Employee values(@Name, @DOB, @Sex, @Phone, @Address, @ImagePath); End;
Exec SPInsertEmployee 'Sanket Rohokale', '2005-07-23', 'Male', '9876543123', 
'Bhalwani, Ahilyanagar', '~/Assets/sanket.jpg';

--SPGetEmployeeById
Create proc SPGetEmployeeById @EmpId int as Begin Select * from Employee where EmpId = @EmpId; End;
Exec SPGetEmployeeById 2;

--SPEditEmployee
Create proc SPEditEmployee @EmpId int, @Name varchar(60), @DOB date, @Sex varchar(10), 
@Phone varchar(20), @Address varchar(100), @ImagePath varchar(255)
as Begin Update Employee Set Name = @Name, DOB = @DOB, Sex = @Sex, Phone = @Phone, 
Address = @Address, ImagePath = @ImagePath where EmpId = @EmpId; End;

Exec SPEditEmployee 3, 'Rutuja Pawar', '2004-08-12', 'Female', '9876543784', 
'Hiware Bazar, Ahilyanagar', '~/Assets/rutuja.jpg';

--SPDeleteEmployee
Create proc SPDeleteEmployee @EmpId int as Begin Delete from Employee where EmpId = @EmpId; End;
Exec SPDeleteEmployee 4;
