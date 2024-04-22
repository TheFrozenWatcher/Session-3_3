create database if not exists QuanLySinhVien;
use QuanLySinhVien;



create table if not exists Students(
StudentId int primary key not null check (length(StudentId)<=4),
StudentName nvarchar(50) not null,
Age int check (age>0),
Email varchar(50) not null
);

create table if not exists Subjects(
SubjectId int primary key not null,
SubjectName nvarchar(50)
);

create table if not exists Classes(
ClassId int primary key not null check (length(ClassId)<=4),
ClassName nvarchar(50)
);

create table if not exists Marks(
Mark int check (Mark>=0 and Mark<=10),
StudentId int,
SubjectId int,
foreign key (StudentId) references Students(StudentId),
foreign key (SubjectId) references Subjects(SubjectId)

);
create table if not exists ClassStudent(
StudentId int,
ClassId int,
foreign key (StudentId) references Students(StudentId),
foreign key (ClassId) references Classes(ClassId),
primary key(StudentId,ClassId)
);

Insert into Students
values (1,'Nguyen Quang An', 18,'an@yahoo.com'),
(2,'Nguyen Cong Vinh',20,'vinh@gmail.com'),
(3,'Nguyen Van Quyen',19, 'quyen'),
(4,'Pham Thanh Binh', 25, 'binh@com'),
(5,'Nguyen Van Tai Em',30,'taiem@sport.com');

Insert into Classes
values(1,'C0706L'),
(2,'C0708G');

Insert into ClassStudent
values(1,1),
(2,1),
(3,2),
(4,2),
(5,2);

Insert into Subjects
values (1,'SQL'),
(2,'Java'),
(3,'C'),
(4,'Visual Basic');

Insert into Marks (Mark, SubjectId, StudentId) values
    (8, 1, 1),
    (4, 2, 1),
    (9, 1, 1),
    (7, 1, 3),
    (3, 1, 4),
    (5, 2,5),
    (8,3,3),
    (1,3,5),
    (3,2,4)    ;

-- Hiện tất cả học sinh
SELECT *
FROM Students;

-- Hiện tất cả môn học
select * from Subjects;

-- Tính điểm trung bình
select Students.StudentId,
Students.StudentName,
AVG(Marks.Mark) AS AverageMark
from Students join Marks on Students.StudentId=Marks.StudentId
group by Students.StudentId, Students.StudentName;

-- Lấy môn học có điểm cao nhất theo sinh viên

Select Students.StudentId,
Students.StudentName,
Subjects.SubjectName,
Marks.Mark
From Students join Marks on Students.StudentId= Marks.StudentId join Subjects on Marks.SubjectId=Subjects.SubjectId
Where (Marks.StudentId,Marks.Mark) in (
Select StudentId,max(Mark) as MaxMark from Marks group by StudentId
);

-- Đánh số thứ tự của điểm theo chiều giảm dần
SELECT
    Students.StudentId,
    Students.StudentName,
    Subjects.SubjectName,
    Marks.Mark,
    DENSE_RANK() over  (ORDER BY Marks.Mark DESC) AS RankOrder
FROM
    Students
    JOIN Marks ON Students.StudentId = Marks.StudentId
    JOIN Subjects ON Marks.SubjectId = Subjects.SubjectId
ORDER BY
    Marks.Mark, RankOrder;

  -- Thay đổi kiểu dữ liệu của cột SubjectName trong bảng Subjects thành varchar(max).

ALTER TABLE Subjects
modify COLUMN SubjectName varchar(255);

-- Cập  nhật thêm dòng chữ “ Đây là môn học “  vào trước các bản ghi trên cột SubjectName trong bảng Subjects.
Select SubjectId,
concat('Đây là môn học ', SubjectName) as ModifiedSubjectName
from Subjects;

-- Viết Check Constraint để kiểm tra độ tuổi nhập vào trong bảng Student yêu cầu Age >15 và Age < 50.

alter table Students
add constraint check_age check (age>15 and age<50);

-- Loại bỏ quan hệ giữa tất cả các bảng.
set FOREIGN_KEY_CHECKS=0;

-- Xóa học viên StudentID là 1.
delete from Students where StudentId=1;
select * from Students;


-- Trong bảng Student thêm một column Status có kiểu dữ liệu là Bit và có giá trị Default là 1.
alter table Students
add column Status bit default 1;
select * from Students;

-- Cập nhật giá trị Status trong bảng Student thành 0.
SET SQL_SAFE_UPDATES = 0;	
update Students set status=0;
select * from Students;
