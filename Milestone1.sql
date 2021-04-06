drop database if exists DAT602_one;
create database DAT602_one;
use DAT602_one;

drop procedure if exists createdb;
delimiter //
create procedure createdb()
begin

    CREATE TABLE `account` (
	  `username` varchar(50) NOT NULL,
	  `password` varchar(500) NOT NULL,
      `Is_Admin` bit NOT NULL,
      `status` varchar(50) NOT NULL,
      `Wrong_Password_Attempts` int,
      `Score` integer,
	  PRIMARY KEY (`username`)
	);

    CREATE TABLE `Game` (
		`GameID` INT NOT NULL,
        `Player_Count` INT NOT NULL,
        `size` INT NOT NULL,
        PRIMARY KEY (`GameID`),
        FOREIGN KEY (`Host`) REFERENCES `account`(`username`)
	);
        
	CREATE TABLE `Tile` (
		`Position` INT NOT NULL,
        `colourR` int NOT NULL DEFAULT 0,
        `colourG` int NOT NULL DEFAULT 0,
        `colourB` int NOT NULL DEFAULT 0,
        `X` INT NOT NULL,
        `Y` INT NOT NULL,
        `Is_Home` varchar(50),
        primary key (`Position`),
        FOREIGN KEY (`GameID`) REFERENCES `Game`(`GameID`)
	);
    
    CREATE TABLE `Character` (
		`CharacterID` INT NOT NULL,
		`name` varchar(50) NOT NULL,
        `trail_colour` varchar(10),
        `trail_strength` int NOT NULL,
        `speed` int NOT NULL,
        `active_power_up` varchar(50),
        PRIMARY KEY (`CharacterID`),
        FOREIGN KEY (`AccountUsername`) REFERENCES `Account`(`Username`),
        FOREIGN KEY (`GameID`) REFERENCES `Game`(`GameID`)
    );
    
    CREATE TABLE `Asset` (
		`Gives_Score` INT NOT NULL,
		`texture` varchar(50) NOT NULL,
        PRIMARY KEY (`Gives_Score`)
	);
    
    CREATE TABLE `Chat` (
		FOREIGN KEY (`GameID`) REFERENCES `Game`(`GameID`),
		`Typer` varchar(50) NOT NULL,
        `Messages` varchar(50),
        PRIMARY KEY (`GameID`)
	);

	ALTER TABLE `Account`
	ADD FOREIGN KEY (`Current_Game`) REFERENCES `Game`(`GameID`); 
 
	ALTER TABLE `Character`
	ADD FOREIGN KEY (`Last_Position`) REFERENCES `Tile`(`Position`); 
    
	ALTER TABLE `Tile`
	ADD FOREIGN KEY (`Asset`) REFERENCES `Asset`(`Gives_Score`); 
    
end //
delimiter ;

drop procedure if exists showTeamName;
delimiter //
create procedure showTeamName( IN pID INT)
begin
	select Name
	from tblTeam
	where ID = pID;
end //

delimiter ;

call createdb();

drop procedure if exists checkLogin;
delimiter $$
create procedure checkLogin(in pName varchar(50), in pPassword varchar(500))
begin
    declare proposedUID int default null;
  
	select `ID` 
	from 
		`user`
	where 
		 `username` = pName and 
		 `password` = pPassword
	 into proposedUID;
     
     if proposedUID is NULL then
         select 'Invalid Password' as 'Message', -1 as `Value`;
	 else
		select 'Valid Password' as 'Message', proposedUID as `Value`;
	 end if;
     
end $$
delimiter ;









