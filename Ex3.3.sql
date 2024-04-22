create database if not exists shop_management;
use shop_management;

-- Tạo bảng Customer
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

-- Tạo bảng Order
CREATE TABLE Orders (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- Tạo bảng Product
CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

-- Tạo bảng OrderDetail
CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES Orders (oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

insert into Customer
values (1,'Ngoc Quan',10),
(2,'Ngoc Oanh',20),
(3,'Hong Ha',50);

INSERT INTO Orders (oID, cID, oDate, oTotalPrice)
VALUES
    (1, 1, '2006-03-21', NULL),
    (2, 2, '2006-03-23', NULL),
    (3, 1, '2006-03-16', NULL);
    
INSERT INTO Product (pID, pName, pPrice)
VALUES
    (1, 'May Giat', 3),
    (2, 'Tu Lanh', 5),
    (3, 'Dieu Hoa', 7),
    (4, 'Quat', 1),
    (5, 'Bep Dien', 2);
    
INSERT INTO OrderDetail (oID, pID, odQTY)
VALUES
    (1, 1, 3),
    (1, 3, 7),
    (1, 4, 2),
    (2, 1, 1),
    (3, 1, 8),
    (3, 5, 4),
    (2, 3, 3);
    
-- Hiển thị các thông tin  gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order
select oId, oDate, oTotalPrice from Orders;

-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
SELECT
    c.cID,
    c.Name AS CustomerName,
    o.oID,
    p.pID,
    p.pName
FROM
    Customer c
    JOIN Orders o ON c.cID = o.cID
    JOIN OrderDetail od ON o.oID = od.oID
    JOIN Product p ON od.pID = p.pID;
    
    -- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT 
    c.cID, c.Name AS CustomerName
FROM
    Customer c
        LEFT JOIN
    Orders o ON c.cID = o.cID
WHERE
    o.cID IS NULL;

-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được 
-- tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice)
select o.oID as OrderId, o.oDate as Date, sum(od.odQTY*p.pPrice) as TotalPrice
from Orders o join OrderDetail od on o.oID=od.oID join Product p on od.pID=p.pID
group by o.oId,o.oDate;


