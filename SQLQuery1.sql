CREATE DATABASE QuanLyQuanCafe
GO

USE QuanLyQuanCafe
GO

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood	
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL default N'Bàn chưa có tên',
	status NVARCHAR(100) NOT NULL default N'Trống'	-- TRỐNG \\ CÓ NGƯỜI
)
GO

CREATE TABLE Account
(
	UserName Nvarchar(100) primary key, 
	displayName NVARCHAR(100) NOT NULL default N'Member',
	password nvarchar(1000) NOT NULL default 0,
	type int NOT NULL default 0 -- 1: admin \\ 0:staff
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL default N'Chưa đặt tên'
)
GO

create table Food
(
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(100) NOT NULL default N'Chưa đặt tên',
	idCategory INT NOT NULL,
	price float not null default 0

	foreign key (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY PRIMARY KEY,
	DateCheckIn Date not null default getdate(),
	DateCheckOut Date,
	idTable Int not null,
	status int not null default 0 -- 1: thanh toán, 2: chưa thanh toán

	FOREIGN KEY (IDTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id int identity primary key,
	idBill int not null,
	idFood int not null,
	count int not null default 0

	FOREIGN KEY (IdBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (IdFood) REFERENCES dbo.Food(id)
)
GO

INSERT INTO dbo.Account 
		(UserName ,
		 displayName ,
		 passWord ,
		 type
		)
VALUES  ( N'nhatping' ,
		  N'XuanNhat' ,
		  N'123' ,
		  1
		)
INSERT INTO dbo.Account
		(UserName ,
		 DisPlayName ,
		 PassWord ,
		 Type
		)
VALUES  ( N'phuonganh' ,
		  N'PhuongAnh' ,
		  N'234' ,
		  0
		)
Go

CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS
BEGIN
	SELECT * from dbo.Account WHERE UserName = @userName
END
GO

EXEC dbo.USP_GetAccountByUserName @userName = N'Nhatping'

GO

----CREATE PROC USP_Login
----@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
	END
	GO

--thêm bàn
DECLARE @i INT = 1

WHILE @i <= 21
BEGIN
	INSERT dbo.TableFood ( name)VALUES ( N'BÀN ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END
GO



CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO

UPDATE dbo.TableFood SET status = N'Có người' WHERE ID = 107134

EXEC dbo.USP_GetTableList


--thêm category
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'HẢI SẢN'
		)
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'NÔNG SẢN')
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'LÂM SẢN')
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'SẢN SẢN')
INSERT dbo.FoodCategory
		( name )
VALUES  ( N'NƯỚC')

--THÊM món ăn
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Mực một nắng nướng sa tế',
		1,
		120000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Nghêu hấp sả', 1 , 50000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Dú dê nướng sữa', 2 , 70000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Heo rừng nướng muối ớt', 3 , 60000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Cơm chiên Mushi', 4 , 40000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'7UP', 5 , 15000)
INSERT dbo.Food
		(name, idCategory, price)
VALUES	(N'Cà phê', 5 , 12000)

--thêm bill
INSERT dbo.Bill
		(DateCheckIn ,
		DateCheckOut ,
		idTable,
		status
		)
VALUES  (GETDATE() ,
		NULL ,
		107129 ,
		0
		)

INSERT dbo.Bill
		(DateCheckIn ,
		DateCheckOut ,
		idTable,
		status
		)
VALUES  (GETDATE() ,
		NULL ,
		107130 ,
		0
		)
INSERT dbo.Bill
		(DateCheckIn ,
		DateCheckOut ,
		idTable,
		status
		)
VALUES  (GETDATE() ,
		 GETDATE() ,
		107132 ,
		1
		)

--THÊM Bill Info
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(10,
		 54,
		 2
		 )
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(10,
		 57,
		 4
		 )
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(10,
		 59,
		 1
		 )
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(11,
		 54,
		 2
		 )
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(11,
		 59,
		 2
		 )
INSERT dbo.BillInfo
		( idBill, idFood, count )
VALUES	(12,
		 58,
		 2
		 )

GO

create PROC USP_InsertBill
@idTable INT
AS
BEGIN
	INSERT dbo.Bill
			(DateCheckIn , 
			DateCheckOut ,
			idTable , 
			status,
			discount
			)
	VALUES ( GETDATE() ,
			NULL  ,
			@idTable ,
			0,
			0
			)
END
GO

create PROC USP_InsertBillInfo
@idBill INT, @idFood INT, @count INT
AS
BEGIN

	DECLARE @isExitsBillInfo INT;
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM dbo.BillInfo AS b 
	WHERE idBill = @idBill AND idFood = @idFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE dbo.BillInfo SET count = @foodCount + @count WHERE  idFood = @idFood
		ELSE
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT dbo.BillInfo
		( idBill, idFood, count )
		VALUES	(@idBill,
		 @idFood,
		 @count
		 )
	END
END 
GO

DELETE dbo.BillInfo

DELETE dbo.Bill

alter TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfo FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = idBill FROM Inserted

	DECLARE @idTable INT

	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill and status = 0

	DECLARE @count INT 
	SELECT @count = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idBill

	if (@count > 0)
	BEGIN	

	PRINT @idTable
		PRINT @idBill
		PRINT @count

		UPDATE dbo.TableFood SET status = N'Có người' WHERE id = @idTable
		
	END
	else
	BEGIN
	PRINT @idTable
		PRINT @idBill
		PRINT @count
	UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
	END
END
GO

Create TRIGGER UTG_UpdateBill
ON dbo.Bill FOR UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = id FROM Inserted

	DECLARE @idTable INT

	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill 

	DECLARE @count int = 0

	SELECT @count = COUNT(*) FROM dbo.Bill WHERE idTable = @idTable and status = 0

	IF (@count = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
END
GO

Alter table dbo.Bill
ADD discount INT

update dbo.Bill SET discount = 0
GO

alter PROC USP_SwitchTable
@idTable1 INT, @idTable2 int
AS BEGIN

		DECLARE @idFirstBill int
		DECLARE @idSeconrdBill int

		DECLARE @isFirstTablEmty INT = 1
		DECLARE @isSecondTablEmty INT = 1


		SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 and status = 0
		SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 and status = 0

		PRINT @idFirstBill
		PRINT @idSeconrdBill
		PRINT '-----------'

		IF (@idFirstBill IS null)
		BEGIN
			PRINT'0000001'
			INSERT dbo.Bill
					(DateCheckIn , 
					DateCheckOut , 
					idTable , 
					status
					)
			VALUES	(GETDATE() ,
					NULL ,
					@idTable1 ,
					0
					)
			SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 and status = 0

		END





		SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
		PRINT @idFirstBill
		PRINT @idSeconrdBill
		PRINT '-----------'

		IF (@idSeconrdBill IS null)
		BEGIN

			PRINT'0000002'
			INSERT dbo.Bill
					(DateCheckIn , 
					DateCheckOut , 
					idTable , 
					status
					)
			VALUES	(GETDATE() ,
					NULL ,
					@idTable2 ,
					0
					)
			SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 and status = 0
			
		END

		SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill

		PRINT @idFirstBill
		PRINT @idSeconrdBill
		PRINT '-----------'

		SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill

		UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill

		UPDATE dbo.BillInfo SET idBill = @idFirstBill WhERE id IN (SELECT * FROM IDBillInfoTable)
		DROP TABLE IDBillInfoTable

		IF (@isFirstTablEmty = 0)
			update dbo.TableFood set status = N'Trống' WHERE id = @idTable2

		IF (@isSecondTablEmty = 0)
			update dbo.TableFood set status = N'Trống' WHERE id = @idTable1
END
GO

ALTER TABLE dbo.Bill ADD totalPrice FLOAT

DELETE dbo.BillInfo
DELETE dbo.Bill


GO

create PROC USP_GetListBillByDate
@checkIn date, @checkOut date
AS
BEGIN
	SELECT t.name AS [Tên bàn], b.totalPrice as [Tổng tiền], DateCheckIn as [Ngày vào], DateCheckOut[Ngày ra], discount as [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut and b.status = 1
	and t.id = b.idTable 
END
GO



CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0

	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE USERName = @userName and PassWord = @password

	IF (@isRightPass = 1)
	BEGIN
		if (@newPassword = null or @newPassword = '')
		BEGIN
			UPDATE DBO.Account SET DisplayName = @displayName where UserName = @userName
		END
		ELSE
			UPDATE dbo.Account set DisplayName = @displayName, Password = @newPassword where UserName = @userName
	END
END
GO

CREATE TRIGGER UTG_DeleteBillInfo
ON dbo.BillInfo FOR DELETE
AS
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill int
	SELECT @idBillInfo = id, @idBill = Deleted.idBill FROM Deleted

	DECLARE @idTable int
	select @idTable = idTable from dbo.Bill where id = @idBill

	DECLARE @count int = 0

	SELECT @count = COUNT(*) FROM dbo.BillInfo as bi, dbo.Bill as b where b.id = bi.idBill and b.id = @idBill and b.status = 0

	IF (@count = 0)
		UPDATE dbo.TableFood set status = N'Trống' WHERE id = @idTable
END
GO


CREATE FUNCTION [dbo].[GetUnsignString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END


go

alter PROC USP_GetListBillByDateAndPage
@checkIn date, @checkOut date, @page int
AS
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT =  @pageRows 
	DECLARE @exceptRows int = (@page - 1) * @pageRows

	;WITH BillShow as ( SELECT b.ID, t.name AS [Tên bàn], b.totalPrice as [Tổng tiền], DateCheckIn as [Ngày vào], DateCheckOut[Ngày ra], discount as [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut and b.status = 1
	and t.id = b.idTable )

	SELECT TOP (@selectRows) * from BillShow where id not in (select TOP (@exceptRows) id from BillShow)
END
GO 

create PROC USP_GetNumBillByDate
@checkIn date, @checkOut date
AS
BEGIN
	SELECT COUNT (*)
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut and b.status = 1
	and t.id = b.idTable 
END
GO