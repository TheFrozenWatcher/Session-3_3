create database quanlybanhang;
use quanlybanhang;

create table NhaCungCap(
MaNCC varchar(5) primary key not null,
TenNCC varchar(50) not null,
DiaChi varchar(50) not null,
DienThoai varchar(15) not null,
Email varchar(30) not null,
Website varchar(30) not null
);
create table NhanVien(
MaNV varchar(4) not null primary key,
HoTen varchar(30) not null,
GioiTinh bit not null,
DiaChi varchar(50) not null,
NgaySinh datetime,
DienThoai varchar(15),
Email text,
NoiSinh varchar(20),
NgayVaoLam datetime,
MaNQL varchar(4));

CREATE TABLE PhieuNhap (
    SoPN VARCHAR(5) PRIMARY KEY NOT NULL,
    MaNV VARCHAR(4) NOT NULL,
    MaNCC VARCHAR(5) NOT NULL,
    NgayNhap DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    GhiChu TEXT
);


create table LoaiSP(
MaloaiSP varchar(4) primary key not null,
TenloaiSP varchar(30) not null,
GhiChu varchar(100)
);

create table SanPham(
MaSP varchar(4) not null primary key,
MaloaiSP varchar(4) not null,
TenSP varchar(50) not null,
Donvitinh varchar(20) not null,
GhiChu text
);

 create table CTPhieuNhap(
MaSP varchar(4),
SoPN varchar(5),
Soluong smallint default 0,
GiaNhap real not null check (GiaNhap>=0)
);

create table KhachHang(
MaKH varchar(4) primary key not null,
TenKH varchar(30) not null,
DiaChi varchar(50),
SoDT varchar(15) unique,
NgaySinh datetime
);
CREATE TABLE PhieuXuat (
    SoPX VARCHAR(5) PRIMARY KEY,
    MaNV VARCHAR(4),
    MaKH VARCHAR(4),
    NgayBan DATETIME,
    GhiChu TEXT
);

DELIMITER $$
CREATE TRIGGER trg_PhieuXuat_BeforeInsert
BEFORE INSERT ON PhieuXuat
FOR EACH ROW
BEGIN
    IF NEW.NgayBan < CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'NgayBan phải lớn hơn hoặc bằng ngày hiện tại.';
    END IF;
END$$
DELIMITER ;

create table CTPhieuXuat(
MaSP varchar(4),
SoPX varchar(5),
Soluong smallint check (Soluong>0),
GiaBan real not null check (GiaBan>=0));

-- Adding foreign key constraint to PhieuNhap table
ALTER TABLE PhieuNhap
ADD CONSTRAINT FK_PhieuNhap_MaNV
FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);

ALTER TABLE PhieuNhap
ADD CONSTRAINT FK_PhieuNhap_MaNCC
FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC);

-- Adding foreign key constraint to SanPham table
ALTER TABLE SanPham
ADD CONSTRAINT FK_SanPham_MaloaiSP
FOREIGN KEY (MaloaiSP) REFERENCES LoaiSP(MaloaiSP);

-- Adding foreign key constraint to CTPhieuNhap table
ALTER TABLE CTPhieuNhap
ADD CONSTRAINT FK_CTPhieuNhap_MaSP
FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP);

ALTER TABLE CTPhieuNhap
ADD CONSTRAINT FK_CTPhieuNhap_SoPN
FOREIGN KEY (SoPN) REFERENCES PhieuNhap(SoPN);

-- Adding foreign key constraint to PhieuXuat table
ALTER TABLE PhieuXuat
ADD CONSTRAINT FK_PhieuXuat_MaNV
FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);

ALTER TABLE PhieuXuat
ADD CONSTRAINT FK_PhieuXuat_MaKH
FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH);

-- Adding foreign key constraint to CTPhieuXuat table
ALTER TABLE CTPhieuXuat
ADD CONSTRAINT FK_CTPhieuXuat_MaSP
FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP);

ALTER TABLE CTPhieuXuat
ADD CONSTRAINT FK_CTPhieuXuat_SoPX
FOREIGN KEY (SoPX) REFERENCES PhieuXuat(SoPX);

INSERT INTO NhaCungCap (MaNCC, TenNCC, DiaChi, DienThoai, Email, Website)
VALUES 
    ('NCC01', 'Supplier A', '123 Supplier Street', '0123456789', 'supplierA@example.com', 'www.supplierA.com'),
    ('NCC02', 'Supplier B', '456 Provider Avenue', '9876543210', 'supplierB@example.com', 'www.supplierB.com'),
    ('NCC03', 'Supplier C', '789 Vendor Road', '1112223333', 'supplierC@example.com', 'www.supplierC.com'),
    ('NCC04', 'Supplier D', '321 Distributor Lane', '4445556666', 'supplierD@example.com', 'www.supplierD.com'),
    ('NCC05', 'Supplier E', '555 Supplier Street', '7778889999', 'supplierE@example.com', 'www.supplierE.com');

INSERT INTO NhanVien (MaNV, HoTen, GioiTinh, DiaChi, NgaySinh, DienThoai, Email, NoiSinh, NgayVaoLam, MaNQL)
VALUES
    ('NV01', 'John Doe', 1, '123 Main Street', '1990-01-15', '0123456789', 'john@example.com', 'New York', '2022-01-01', NULL),
    ('NV02', 'Alice Smith', 0, '456 Elm Street', '1992-05-20', '9876543210', 'alice@example.com', 'Los Angeles', '2022-01-15', NULL),
    ('NV03', 'Michael Johnson', 1, '789 Oak Street', '1988-08-10', '5556667777', 'michael@example.com', 'Chicago', '2022-02-01', NULL),
    ('NV04', 'Emily Brown', 0, '321 Pine Street', '1995-11-25', '3334445555', 'emily@example.com', 'Houston', '2022-02-15', NULL),
    ('NV05', 'David Wilson', 1, '555 Maple Street', '1993-03-05', '9998887777', 'david@example.com', 'Boston', '2022-03-01', NULL);

INSERT INTO KhachHang (MaKH, TenKH, DiaChi, SoDT, NgaySinh)
VALUES
    ('KH01', 'Customer A', '123 Customer Street', '1112223333', '1985-06-10'),
    ('KH02', 'Customer B', '456 Client Avenue', '4445556666', '1990-09-15'),
    ('KH03', 'Customer C', '789 Patron Road', '7778889999', '1982-12-20'),
    ('KH04', 'Customer D', '321 Member Lane', '0001112222', '1993-03-25'),
    ('KH05', 'Customer E', '555 Buyer Street', '3334445555', '1988-05-30'),
    ('KH10', 'Customer F', '369 Automation Street', '11111333335555', '1988-05-30');

INSERT INTO LoaiSP (MaloaiSP, TenloaiSP, GhiChu)
VALUES
    ('L001', 'Electronics', 'Category for electronic products'),
    ('L002', 'Clothing', 'Category for clothing items'),
    ('L003', 'Books', 'Category for books and printed materials'),
    ('L004', 'Furniture', 'Category for furniture and home decor'),
    ('L005', 'Groceries', 'Category for food and grocery items');

INSERT INTO SanPham (MaSP, MaloaiSP, TenSP, Donvitinh, GhiChu)
VALUES
    ('SP01', 'L001', 'Smartphone', 'Piece', 'High-end smartphone model'),
    ('SP02', 'L001', 'Laptop', 'Piece', 'Powerful laptop for professionals'),
    ('SP03', 'L002', 'T-shirt', 'Piece', 'Casual cotton t-shirt'),
    ('SP04', 'L002', 'Jeans', 'Piece', 'Classic denim jeans'),
    ('SP05', 'L003', 'Novel', 'Piece', 'Bestselling fiction novel');

INSERT INTO PhieuNhap (SoPN, MaNV, MaNCC, NgayNhap, GhiChu)
VALUES
    ('PN1', 'NV01', 'NCC01', '2024-04-19 09:00:00', 'First entry'),
    ('PN2', 'NV02', 'NCC02', '2024-04-18 10:00:00', 'Second entry');

INSERT INTO CTPhieuNhap (MaSP, SoPN, Soluong, GiaNhap)
VALUES
    ('SP01', 'PN1', 10, 5000000),
    ('SP02', 'PN1', 5, 8000000),
    ('SP03', 'PN2', 8, 3000000),
    ('SP04', 'PN2', 12, 2000000);

INSERT INTO PhieuXuat (SoPX, MaNV, MaKH, NgayBan, GhiChu)
VALUES
    ('PX1', 'NV03', 'KH01', '2024-04-19 11:00:00', 'First sales'),
    ('PX2', 'NV04', 'KH02', '2024-04-19 12:00:00', 'Second sales');

INSERT INTO CTPhieuXuat (MaSP, SoPX, Soluong, GiaBan)
VALUES
    ('SP01', 'PX1', 15, 6000000),
    ('SP02', 'PX1', 8, 9000000),
    ('SP04', 'PX1', 10, 7000000),
    ('SP03', 'PX2', 20, 4500000),
    ('SP04', 'PX2', 10, 7000000),
    ('SP05', 'PX2', 5, 3500000);


-- Bài 3: Dùng lệnh INSERT thêm dữ liệu vào các bảng:
-- 1. Thêm 2 Phiếu nhập trong tháng hiện hành. Mỗi phiếu nhập có 2 sản phẩm.
-- (Tùy chọn các thông tin liên quan còn lại)
-- 2. Thêm 2 Phiếu xuất trong ngày hiện hành. Mỗi phiếu xuất có 3 sản phẩm.
-- (Tùy chọn các thông tin liên quan còn lại)
-- 3. Thêm 1 nhân viên mới (Tùy chọn các thông tin liên quan còn lại)
INSERT INTO PhieuNhap (SoPN, MaNV, MaNCC, NgayNhap, GhiChu)
VALUES ('PN3', 'NV01', 'NCC01', NOW(), 'Phiếu nhập số 1'),
       ('PN4', 'NV02', 'NCC02', NOW(), 'Phiếu nhập số 2');
INSERT INTO CTPhieuNhap (MaSP, SoPN, Soluong, GiaNhap)
VALUES ('SP01', 'PN3', 10, 500000),
       ('SP02', 'PN3', 5, 800000),
       ('SP03', 'PN4', 8, 300000),
       ('SP04', 'PN4', 12, 200000);
INSERT INTO PhieuXuat (SoPX, MaNV, MaKH, NgayBan, GhiChu)
VALUES ('PX3', 'NV03', 'KH05', NOW(), 'Phiếu xuất số 1'),
       ('PX4', 'NV04', 'KH04', NOW(), 'Phiếu xuất số 2');
INSERT INTO CTPhieuXuat (MaSP, SoPX, Soluong, GiaBan)
VALUES ('SP01', 'PX3', 15, 6000000),
       ('SP02', 'PX3', 8, 9000000),
       ('SP04', 'PX3', 10, 7000000),
       ('SP05', 'PX4', 20, 4500000),
       ('SP01', 'PX4', 10, 7000000),
       ('SP03', 'PX4', 5, 3500000);

insert into SanPham value ('SP15', 'L001', 'Iphone 6', 'Phone', 'Apple Smartphone');

-- Bài 4: Dùng lệnh UPDATE cập nhật dữ liệu các bảng

UPDATE KhachHang
SET SoDT = '0123456789'
WHERE MaKH = 'KH10';

update NhanVien
set DiaChi = '153 Seasame Street'
where MaNV= 'NV05';

