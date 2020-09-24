USE master;

DROP DATABASE IF EXISTS EzekielsDb;

CREATE DATABASE EzekielsDb;

USE EzekielsDb;


-- User/Account Table
CREATE TABLE Account
(
	userId		INT				NOT NULL PRIMARY KEY,
	name		NVARCHAR (40)	NOT NULL,
	phone		NVARCHAR (40)	NULL,
	address		NVARCHAR (40)	NULL,
	email		NVARCHAR (40)	NOT NULL,
	password	NVARCHAR (40)	NOT NULL
);

INSERT INTO Account (userId, name,					phone,					address,										email,							password)
	VALUES(			 0001,	'Patrick Toppin',		'(915) 801-6325',		'516 Fieldstone Dr., Gatesville, TX 76528',		'patrick.toppin@gmail.com',		'Password');
INSERT INTO Account (userId, name,					phone,					address,										email,							password)
	VALUES(			 0002,	'Andrea Toppin',		'(915) 345-5458',		'516 Fieldstone Dr., Gatesville, TX 76528',		'atopp81@gmail.com',			'ItsAPickle');
INSERT INTO Account (userId, name,					phone,					address,										email,							password)
	VALUES(			0003,	'Elizabeth Melendez',	'(915) 801-6328',		'229 Sunshine St., EL Paso, TX 77901',			'etoppin97@gmail.com',			'MyraCat');

SELECT * 
	FROM Account;
	

-- Credit Card Table
CREATE TABLE CreditCard
(
	userId		INT				NOT NULL,
		CONSTRAINT FK_CreditCard_Account
			FOREIGN KEY (userId)
			REFERENCES Account(userId),
	name		NVARCHAR (40)	NOT NULL,
	ccNumber	NVARCHAR (40)	NOT NULL,
	address		NVARCHAR (40)	NOT NULL,
	secCode		INT				NOT NULL
);

INSERT INTO CreditCard (userId,		name,					ccNumber,			address,									secCode)
	VALUES(				0001,		'Patrick Toppin',		'012345678910',		'516 Fieldstone Dr., Gatesville, TX 76528',	123);
INSERT INTO CreditCard (userId,		name,					ccNumber,			address,									secCode)
	VALUES(				0002,		'Andrea Toppin',		'987654321098',		'516 Fieldstone Dr., Gatesville, TX 76528',	987);
INSERT INTO CreditCard (userId,		name,					ccNumber,			address,									secCode)
	VALUES( 			0003,		'Elizabeth Melendez',	'432187651010',		'229 Sunshine St., EL Paso, TX 77901',		550);

SELECT *
	FROM dbo.Account AS A
		INNER JOIN dbo.CreditCard AS C
			ON A.userId = C.userId;


--Product Orders Table
CREATE TABLE ProductOrders
(
	orderId			INT				NOT NULL,
	productId		INT				NOT NULL,
			CONSTRAINT PK_Order_Product_ID
				PRIMARY KEY(orderId, productId),

	userId			INT				NOT NULL
		CONSTRAINT FK_ProductOrders_Account
			FOREIGN KEY (userId)
				REFERENCES Account(userId),

	orderPrice		MONEY			NOT NULL,
	productQty		INT				NOT NULL
);

INSERT INTO dbo.ProductOrders (orderId,		productId,	userId, orderPrice, productQty)
	VALUES(                    20200001,	0002,		0002,	6.50,		1	      ),
		  (                    20200001,	0001,		0002,	4.50,		1	      ),
		  (					   20200002,	0001,		0001,	4.50,		1		  );


SELECT *
	FROM dbo.Account AS A
		INNER JOIN dbo.ProductOrders AS PO
			ON A.userId = PO.userId;


-- Coffee Products Table
CREATE TABLE CoffeeProducts
(
	productId		INT				NOT NULL PRIMARY KEY,
	productName		NVARCHAR (40)	NOT NULL,
	drinkFamily		NVARCHAR (40)	NULL,
	supplyId		INT				NOT NULL
);

INSERT INTO CoffeeProducts (productId,  productName,			drinkFamily,	supplyId)
	VALUES  (               0001,		'House Coffee',			'Coffee',		0001	),
			(				0002,		'Caramel Cappachino',	'Cappachino',	0002	),
			(				0003,		'Decaf Coffee',			'Coffee',		0003	);

SELECT PO.userid, A.name, PO.orderid, CP.productname, CP.drinkFamily, PO.productQty
	FROM dbo.ProductOrders AS PO
		INNER JOIN dbo.CoffeeProducts AS CP
			ON PO.productId	= CP.productId
		INNER JOIN dbo.Account AS A
			ON A.userId = PO.userId;


-- Preferred Drink Table
CREATE TABLE PreferredDrink
(
	productId		INT				NOT NULL, -- FK, Coffee Products
		CONSTRAINT FK_PreferredDrink_CoffeeProducts
			FOREIGN KEY (productId)
			REFERENCES CoffeeProducts(productId),
	drinkFamily		NVARCHAR (40)	NULL,  
	userId			INT				NOT NULL,  -- FK, Account
		CONSTRAINT FK_PreferredDrink_Account
			FOREIGN KEY (userId)
			REFERENCES Account(userId),
	productName		NVARCHAR (40)	NOT NULL,
	amountOrdered	INT				NOT NULL
);

INSERT INTO PreferredDrink( productId,			drinkFamily,	userId, productName,			amountOrdered)
	VALUES
	(						0001,				'Coffee',		0001,	'House Coffee',			10			 ),
	(						0002,				'Cappachino',	0002,	'Caramel Cappachino',	3			 ),
	(						0003,				'Coffee',		0003,	'Decaffinated Coffee',	4			 );


SELECT * 
	FROM Account AS A
		INNER JOIN PreferredDrink AS P
			ON A.userId = P.userId
	WHERE A.userId BETWEEN 0001 AND 0003;

-- Foreign Keys MUST refer back to a Primary Key on the other table!
-- Foreign Keys can have duplicate values.  Primary Keys can not!