/* 
========================================================
create Database and schemas 
========================================================
script purpose :
	This script creates a new databse name 'Datawarehouse' after checking if it already exists.if the 
	databse exists, it is dropped and recreated.Additionally,the script sets up three schemas within the 
	databse: 'bronze','silver'. and 'gold'


warning:
	Running this script will drop the entire 'DataWarehouse' databse if it exists.
	All data in the database will be permanently deleted.Proceed with caution
	and ensure you have proper backups before running this scrits

	*/

use master;
go

--drop and recreate the 'datawarehouse' databse  
if exists (select 1 from sys.databases where name = 'DataWarehouse')
Begin 
	Alter Database DataWarehouse set SINGLE_USER WITH ROOLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO



--Create database 'DataWarehouse'
create database DataWarehouse;
use datawarehouse;

--Create Schemas 
Create SCHEMA bronze;
GO 

CREATE SCHEMA silver;
GO 

CREATE SCHEMA gold;