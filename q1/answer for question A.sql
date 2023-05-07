-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: May 07, 2023 at 10:47 AM
-- Server version: 8.0.30
-- PHP Version: 8.0.23

START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `acts.temp`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`db`@`localhost` FUNCTION `COUNT_CURRENT_MEMBER` (`StructID` INT) RETURNS INT NO SQL BEGIN
DECLARE COUNT_MEM INTEGER;
  SELECT COUNT(sm.MemID) INTO COUNT_MEM FROM acts_structure s
			JOIN acts_structmem sm ON s.StructID=sm.StructID
			WHERE sm.deletedAt IS NULL AND s.StructID= StructID;
  RETURN COUNT_MEM;
END$$

CREATE DEFINER=`db`@`localhost` FUNCTION `COUNT_MEM` (`StructID` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 NO SQL BEGIN
  DECLARE RET VARCHAR(50) DEFAULT "-";
	SELECT COUNT(sm.StructID) INTO RET
	FROM acts_structmem sm 
	WHERE sm.deletedAt IS NULL AND sm.StructID=StructID;     
  RETURN RET;
END$$

CREATE DEFINER=`db`@`localhost` FUNCTION `FIND_CHURCH` (`StructID` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 NO SQL BEGIN
 DECLARE RET VARCHAR(50) DEFAULT "-";
	SELECT ancester.StrucName  INTO RET
	FROM acts_structure child
	JOIN acts_structure ancester
	ON child.lft BETWEEN ancester.lft AND ancester.rgt
    WHERE child.StructID=StructID AND ancester.StrucClassID=11
	LIMIT 1;
RETURN RET;
END$$

CREATE DEFINER=`db`@`localhost` FUNCTION `LG_LEADER` (`StructID` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 NO SQL BEGIN
  DECLARE LL VARCHAR(50) DEFAULT "-";
     SELECT CONCAT('[',m.Nickname,'] ',m.Name,' ',m.Surname) INTO LL
	FROM acts_structure s
	JOIN acts_structmem sm ON s.StructID=sm.StructID
	JOIN acts_member m ON sm.MemID=m.MemID
	WHERE m.MemStatusID>=21 AND s.StructID=StructID AND sm.deletedAt IS NULL
	ORDER BY m.MemStatusID ASC
	LIMIT 1;
  RETURN LL;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `acts_structure`
--

CREATE TABLE `acts_structure` (
  `tree_root` int DEFAULT NULL,
  `StructID` int NOT NULL,
  `StrucName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `StrucClassID` int DEFAULT NULL,
  `ParentID` int DEFAULT NULL,
  `LinkID` int DEFAULT NULL,
  `lft` int DEFAULT NULL,
  `lvl` int DEFAULT NULL,
  `rgt` int DEFAULT NULL,
  `OldParentID` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OldChildID` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OldLeaderID` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `acts_structure_class`
--

CREATE TABLE `acts_structure_class` (
  `StrucClassID` int NOT NULL,
  `StrucName` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `name1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name2` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `acts_struct_student`
--

CREATE TABLE `acts_struct_student` (
  `StructMemID` int NOT NULL,
  `StructMemTypeID` smallint NOT NULL COMMENT '0=normal member,2=linked member',
  `StructMemStatus` smallint NOT NULL COMMENT '0=normal,2=moving,3=pending approval',
  `StructMemStatusRelateFrom` int DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `StructID` int DEFAULT NULL,
  `MemID` int DEFAULT NULL,
  `DeleteType` smallint DEFAULT NULL COMMENT '1=Deleted,2=Move2OtherStruct'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `acts_student_status`
--

CREATE TABLE `acts_student_status` (
  `MemStatusID` int NOT NULL,
  `StatusName` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `Name_1_short` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_1_long` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_2_short` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_2_long` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_3_short` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name_3_long` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `district`
--

CREATE TABLE `district` (
  `id` int NOT NULL,
  `province_id` int NOT NULL,
  `geography_id` int NOT NULL,
  `code` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_th` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `geography`
--

CREATE TABLE `geography` (
  `id` int NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `id` int NOT NULL,
  `code` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `permit_roles` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE `province` (
  `id` int NOT NULL,
  `geography_id` int NOT NULL,
  `code` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_th` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_en` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `id` int NOT NULL,
  `role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subdistrict`
--

CREATE TABLE `subdistrict` (
  `id` int NOT NULL,
  `district_id` int NOT NULL,
  `province_id` int NOT NULL,
  `geography_id` int NOT NULL,
  `code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_th` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name_en` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `email` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reqRole` json DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `MemID` int DEFAULT NULL,
  `ChurchID` int DEFAULT NULL,
  `TeacherID` int DEFAULT NULL,
  `StructID` int DEFAULT NULL,
  `WFLStructID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_course`
--

CREATE TABLE `wfl_course` (
  `CourseID` int NOT NULL,
  `CourseName` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NoOfStudents` smallint NOT NULL,
  `Price` double DEFAULT NULL,
  `TermID` int DEFAULT NULL,
  `TeacherID` int DEFAULT NULL,
  `SubjectID` int DEFAULT NULL,
  `TeacherAssistantID` int DEFAULT NULL,
  `StructID` int DEFAULT NULL,
  `ScheduleID` int DEFAULT NULL,
  `BookFee` double DEFAULT NULL,
  `AllowNewBelieverDummy` tinyint(1) NOT NULL,
  `is_not_check5_subjects` tinyint(1) NOT NULL,
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_creditnote`
--

CREATE TABLE `wfl_creditnote` (
  `CreditNoteID` int NOT NULL,
  `Fee` smallint DEFAULT NULL,
  `CreditNoteNo` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creditNoteDate` date DEFAULT '1000-01-01',
  `billTo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `InvoiceID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_creditnote_detail`
--

CREATE TABLE `wfl_creditnote_detail` (
  `CreditNoteDetailID` int NOT NULL,
  `rowOrder` smallint NOT NULL,
  `rowDetail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rowLinkID` int DEFAULT NULL,
  `Quantity` smallint NOT NULL,
  `unitPrice` decimal(10,0) NOT NULL,
  `amount` decimal(10,0) NOT NULL,
  `createdAt` date DEFAULT NULL,
  `updatedAt` date DEFAULT NULL,
  `CreditNoteID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_enrollment`
--

CREATE TABLE `wfl_enrollment` (
  `EnrollmentID` int NOT NULL,
  `MemID` int DEFAULT NULL,
  `CourseID` int DEFAULT NULL,
  `TermID` int DEFAULT NULL,
  `InvoiceID` int DEFAULT NULL,
  `Fee` smallint DEFAULT NULL,
  `BookFee` double DEFAULT NULL,
  `paid` tinyint(1) DEFAULT NULL,
  `attendant` smallint NOT NULL,
  `score_att` smallint NOT NULL,
  `score_HW1` smallint NOT NULL,
  `score_HW2` smallint NOT NULL,
  `score_exam` smallint NOT NULL,
  `score` smallint NOT NULL,
  `Grade` smallint NOT NULL COMMENT '0=NOT PASS/1=Pass',
  `at1` smallint DEFAULT NULL,
  `at2` smallint DEFAULT NULL,
  `at3` smallint DEFAULT NULL,
  `at4` smallint DEFAULT NULL,
  `at5` smallint DEFAULT NULL,
  `at6` smallint DEFAULT NULL,
  `at7` smallint DEFAULT NULL,
  `at8` smallint DEFAULT NULL,
  `at9` smallint DEFAULT NULL,
  `at10` smallint DEFAULT NULL,
  `at11` smallint DEFAULT NULL,
  `at12` smallint DEFAULT NULL,
  `remark` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `at13` smallint DEFAULT NULL,
  `atExam` smallint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_invoice`
--

CREATE TABLE `wfl_invoice` (
  `InvoiceID` int NOT NULL,
  `InvoiceNo` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `InvoiceDate` date DEFAULT '1000-01-01',
  `billTo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_invoicedetail`
--

CREATE TABLE `wfl_invoicedetail` (
  `InvoiceDetailID` int NOT NULL,
  `rowOrder` smallint NOT NULL,
  `rowDetail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rowLinkID` int DEFAULT NULL,
  `Quantity` smallint NOT NULL,
  `unitPrice` decimal(10,0) NOT NULL,
  `amount` decimal(10,0) NOT NULL,
  `createdAt` date DEFAULT NULL,
  `updatedAt` date DEFAULT NULL,
  `InvoiceID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_schedule`
--

CREATE TABLE `wfl_schedule` (
  `ScheduleID` int NOT NULL,
  `StructID` int DEFAULT NULL,
  `scheduleName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TeachDate1` date DEFAULT '1000-01-01',
  `TeachDate2` date DEFAULT '1000-01-01',
  `TeachDate3` date DEFAULT '1000-01-01',
  `TeachDate4` date DEFAULT '1000-01-01',
  `TeachDate5` date DEFAULT '1000-01-01',
  `TeachDate6` date DEFAULT '1000-01-01',
  `TeachDate7` date DEFAULT '1000-01-01',
  `TeachDate8` date DEFAULT '1000-01-01',
  `TeachDate9` date DEFAULT '1000-01-01',
  `TeachDate10` date DEFAULT '1000-01-01',
  `TeachDate11` date DEFAULT '1000-01-01',
  `TeachDate12` date DEFAULT '1000-01-01',
  `ExamDate` date DEFAULT '1000-01-01',
  `CeasePromotiondate` date DEFAULT '1000-01-01',
  `PromotionDiscount` smallint DEFAULT NULL,
  `TermID` int DEFAULT NULL,
  `TeachDate13` date DEFAULT '1000-01-01',
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_student`
--

CREATE TABLE `wfl_student` (
  `ChurchID` int DEFAULT NULL,
  `MemID` int NOT NULL,
  `Prefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Name` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Surname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Nickname` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sex` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Birthdate` date DEFAULT NULL,
  `Age` smallint DEFAULT NULL,
  `Phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Office` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OfficeAddress` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `Status2` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MemStatusID` int DEFAULT NULL,
  `EmergencyContact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Believe` tinyint(1) DEFAULT NULL,
  `BelieveDate` date DEFAULT NULL,
  `NewLife` tinyint(1) DEFAULT NULL,
  `NewLifeDate` date DEFAULT NULL,
  `Baptism` tinyint(1) DEFAULT NULL,
  `BaptismDate` date DEFAULT NULL,
  `ChurchMember` tinyint(1) DEFAULT NULL,
  `ChurchMemberDate` date DEFAULT NULL,
  `memo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `memoSpirit` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ShepherdID` int DEFAULT NULL,
  `SpouseID` int DEFAULT NULL,
  `FatherID` int DEFAULT NULL,
  `MotherID` int DEFAULT NULL,
  `SpiritMeter` smallint DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `AddPostal` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `OffPostal` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmergencyContactMobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SpiritualMode` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'NULL=normal H=HeartBox F=FlyBox',
  `add_sub_district_id` int DEFAULT NULL,
  `add_district_id` int DEFAULT NULL,
  `add_provinces_id` int DEFAULT NULL,
  `off_sub_district_id` int DEFAULT NULL,
  `off_district_id` int DEFAULT NULL,
  `off_provinces_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_subject`
--

CREATE TABLE `wfl_subject` (
  `SubjectID` int NOT NULL,
  `SubjectCode` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SubjectName` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SubjectCatID` int DEFAULT NULL,
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_subjectcategory`
--

CREATE TABLE `wfl_subjectcategory` (
  `SubjectCatID` int NOT NULL,
  `SubjectCatName` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_subjectprereq`
--

CREATE TABLE `wfl_subjectprereq` (
  `SubjectPrereqID` int NOT NULL,
  `AtChurchID` int DEFAULT NULL,
  `PrerequisiteSubjectID` int NOT NULL,
  `SubjectID` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_teacher`
--

CREATE TABLE `wfl_teacher` (
  `TeacherID` int NOT NULL,
  `TeacherName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `MemID` int DEFAULT NULL,
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wfl_term`
--

CREATE TABLE `wfl_term` (
  `TermID` int NOT NULL,
  `TermName` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `AtChurchID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `acts_structure`
--
ALTER TABLE `acts_structure`
  ADD PRIMARY KEY (`StructID`),
  ADD UNIQUE KEY `UNIQ_F2CBD1F0920BABBC` (`LinkID`),
  ADD KEY `IDX_F2CBD1F0A977936C` (`tree_root`),
  ADD KEY `IDX_F2CBD1F0D2F60E70` (`ParentID`),
  ADD KEY `IDX_F2CBD1F0B9974D03` (`StrucClassID`);

--
-- Indexes for table `acts_structure_class`
--
ALTER TABLE `acts_structure_class`
  ADD PRIMARY KEY (`StrucClassID`);

--
-- Indexes for table `acts_struct_student`
--
ALTER TABLE `acts_struct_student`
  ADD PRIMARY KEY (`StructMemID`),
  ADD KEY `IDX_EBA62F9CFB15F5A5` (`StructID`),
  ADD KEY `IDX_EBA62F9C7ABC4562` (`MemID`);

--
-- Indexes for table `acts_student_status`
--
ALTER TABLE `acts_student_status`
  ADD PRIMARY KEY (`MemStatusID`);

--
-- Indexes for table `district`
--
ALTER TABLE `district`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_31C15487E946114A` (`province_id`),
  ADD KEY `IDX_31C15487F091D9C7` (`geography_id`);

--
-- Indexes for table `geography`
--
ALTER TABLE `geography`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_4ADAD40BF091D9C7` (`geography_id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subdistrict`
--
ALTER TABLE `subdistrict`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_3A51E90EB08FA272` (`district_id`),
  ADD KEY `IDX_3A51E90EE946114A` (`province_id`),
  ADD KEY `IDX_3A51E90EF091D9C7` (`geography_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`),
  ADD UNIQUE KEY `UNIQ_8D93D64950D866E8` (`TeacherID`),
  ADD KEY `IDX_8D93D6497ABC4562` (`MemID`),
  ADD KEY `IDX_8D93D6499DC98488` (`ChurchID`),
  ADD KEY `IDX_8D93D649FB15F5A5` (`StructID`),
  ADD KEY `IDX_8D93D649F37D473` (`WFLStructID`);

--
-- Indexes for table `wfl_course`
--
ALTER TABLE `wfl_course`
  ADD PRIMARY KEY (`CourseID`),
  ADD KEY `IDX_2DE3EC09A63C52DE` (`TermID`),
  ADD KEY `IDX_2DE3EC0950D866E8` (`TeacherID`),
  ADD KEY `IDX_2DE3EC0987939680` (`SubjectID`),
  ADD KEY `IDX_2DE3EC09E2CD0DD5` (`TeacherAssistantID`),
  ADD KEY `IDX_2DE3EC09FB15F5A5` (`StructID`),
  ADD KEY `IDX_2DE3EC09C3762256` (`ScheduleID`),
  ADD KEY `IDX_2DE3EC09C756CDD0` (`AtChurchID`);

--
-- Indexes for table `wfl_creditnote`
--
ALTER TABLE `wfl_creditnote`
  ADD PRIMARY KEY (`CreditNoteID`),
  ADD UNIQUE KEY `UNIQ_F836C2364C22B3AB` (`CreditNoteNo`),
  ADD KEY `IDX_F836C23684E47E3A` (`InvoiceID`);

--
-- Indexes for table `wfl_creditnote_detail`
--
ALTER TABLE `wfl_creditnote_detail`
  ADD PRIMARY KEY (`CreditNoteDetailID`),
  ADD KEY `IDX_2D15C4A9AFDFDC2C` (`CreditNoteID`);

--
-- Indexes for table `wfl_enrollment`
--
ALTER TABLE `wfl_enrollment`
  ADD PRIMARY KEY (`EnrollmentID`),
  ADD UNIQUE KEY `unique_1mem_1term_1Course` (`MemID`,`TermID`,`CourseID`),
  ADD KEY `IDX_E47D23D7ABC4562` (`MemID`),
  ADD KEY `IDX_E47D23DAF7ECA` (`CourseID`),
  ADD KEY `IDX_E47D23D84E47E3A` (`InvoiceID`),
  ADD KEY `IDX_E47D23DA63C52DE` (`TermID`);

--
-- Indexes for table `wfl_invoice`
--
ALTER TABLE `wfl_invoice`
  ADD PRIMARY KEY (`InvoiceID`),
  ADD UNIQUE KEY `UNIQ_5B3FD94B671911BD` (`InvoiceNo`);

--
-- Indexes for table `wfl_invoicedetail`
--
ALTER TABLE `wfl_invoicedetail`
  ADD PRIMARY KEY (`InvoiceDetailID`),
  ADD KEY `IDX_7DDB1B284E47E3A` (`InvoiceID`);

--
-- Indexes for table `wfl_schedule`
--
ALTER TABLE `wfl_schedule`
  ADD PRIMARY KEY (`ScheduleID`),
  ADD KEY `IDX_CA4C56A4A63C52DE` (`TermID`),
  ADD KEY `IDX_CA4C56A4FB15F5A5` (`StructID`),
  ADD KEY `IDX_CA4C56A4C756CDD0` (`AtChurchID`);

--
-- Indexes for table `wfl_student`
--
ALTER TABLE `wfl_student`
  ADD PRIMARY KEY (`MemID`),
  ADD UNIQUE KEY `unique_idx_name_surname` (`Name`,`Surname`),
  ADD UNIQUE KEY `UNIQ_5B268148FDEF5E2B` (`SpouseID`),
  ADD KEY `IDX_5B26814849E60751` (`ShepherdID`),
  ADD KEY `IDX_5B268148BA91214C` (`MemStatusID`),
  ADD KEY `IDX_5B2681489567EAC3` (`FatherID`),
  ADD KEY `IDX_5B26814898328DC8` (`MotherID`),
  ADD KEY `IDX_5B2681489DC98488` (`ChurchID`),
  ADD KEY `IDX_5B2681484EFEC7C9` (`add_sub_district_id`),
  ADD KEY `IDX_5B268148E2CAFBF5` (`add_district_id`),
  ADD KEY `IDX_5B26814821F0060` (`add_provinces_id`),
  ADD KEY `IDX_5B268148B6B2A1B` (`off_sub_district_id`),
  ADD KEY `IDX_5B2681488E8B9266` (`off_district_id`),
  ADD KEY `IDX_5B2681486B7583F7` (`off_provinces_id`);

--
-- Indexes for table `wfl_subject`
--
ALTER TABLE `wfl_subject`
  ADD PRIMARY KEY (`SubjectID`),
  ADD KEY `IDX_3094F0758EC7DB93` (`SubjectCatID`),
  ADD KEY `IDX_3094F075C756CDD0` (`AtChurchID`);

--
-- Indexes for table `wfl_subjectcategory`
--
ALTER TABLE `wfl_subjectcategory`
  ADD PRIMARY KEY (`SubjectCatID`),
  ADD KEY `IDX_A154503FC756CDD0` (`AtChurchID`);

--
-- Indexes for table `wfl_subjectprereq`
--
ALTER TABLE `wfl_subjectprereq`
  ADD PRIMARY KEY (`SubjectPrereqID`),
  ADD KEY `IDX_586525C6C756CDD0` (`AtChurchID`),
  ADD KEY `IDX_586525C629C8F893` (`PrerequisiteSubjectID`),
  ADD KEY `IDX_586525C687939680` (`SubjectID`);

--
-- Indexes for table `wfl_teacher`
--
ALTER TABLE `wfl_teacher`
  ADD PRIMARY KEY (`TeacherID`),
  ADD KEY `IDX_7BAC68DAC756CDD0` (`AtChurchID`),
  ADD KEY `IDX_7BAC68DA7ABC4562` (`MemID`);

--
-- Indexes for table `wfl_term`
--
ALTER TABLE `wfl_term`
  ADD PRIMARY KEY (`TermID`),
  ADD KEY `IDX_6AEF9195C756CDD0` (`AtChurchID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `acts_structure`
--
ALTER TABLE `acts_structure`
  MODIFY `StructID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acts_structure_class`
--
ALTER TABLE `acts_structure_class`
  MODIFY `StrucClassID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acts_struct_student`
--
ALTER TABLE `acts_struct_student`
  MODIFY `StructMemID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `acts_student_status`
--
ALTER TABLE `acts_student_status`
  MODIFY `MemStatusID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `district`
--
ALTER TABLE `district`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `geography`
--
ALTER TABLE `geography`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permission`
--
ALTER TABLE `permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `province`
--
ALTER TABLE `province`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subdistrict`
--
ALTER TABLE `subdistrict`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_course`
--
ALTER TABLE `wfl_course`
  MODIFY `CourseID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_creditnote`
--
ALTER TABLE `wfl_creditnote`
  MODIFY `CreditNoteID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_creditnote_detail`
--
ALTER TABLE `wfl_creditnote_detail`
  MODIFY `CreditNoteDetailID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_enrollment`
--
ALTER TABLE `wfl_enrollment`
  MODIFY `EnrollmentID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_invoice`
--
ALTER TABLE `wfl_invoice`
  MODIFY `InvoiceID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_invoicedetail`
--
ALTER TABLE `wfl_invoicedetail`
  MODIFY `InvoiceDetailID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_schedule`
--
ALTER TABLE `wfl_schedule`
  MODIFY `ScheduleID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_student`
--
ALTER TABLE `wfl_student`
  MODIFY `MemID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_subject`
--
ALTER TABLE `wfl_subject`
  MODIFY `SubjectID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_subjectcategory`
--
ALTER TABLE `wfl_subjectcategory`
  MODIFY `SubjectCatID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_subjectprereq`
--
ALTER TABLE `wfl_subjectprereq`
  MODIFY `SubjectPrereqID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_teacher`
--
ALTER TABLE `wfl_teacher`
  MODIFY `TeacherID` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wfl_term`
--
ALTER TABLE `wfl_term`
  MODIFY `TermID` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `acts_structure`
--
ALTER TABLE `acts_structure`
  ADD CONSTRAINT `FK_F2CBD1F0920BABBC` FOREIGN KEY (`LinkID`) REFERENCES `acts_structure` (`StructID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_F2CBD1F0A977936C` FOREIGN KEY (`tree_root`) REFERENCES `acts_structure` (`StructID`) ON DELETE CASCADE ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_F2CBD1F0B9974D03` FOREIGN KEY (`StrucClassID`) REFERENCES `acts_structure_class` (`StrucClassID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_F2CBD1F0D2F60E70` FOREIGN KEY (`ParentID`) REFERENCES `acts_structure` (`StructID`) ON DELETE CASCADE ON UPDATE RESTRICT;

--
-- Constraints for table `acts_struct_student`
--
ALTER TABLE `acts_struct_student`
  ADD CONSTRAINT `FK_D3EB697C7ABC4562` FOREIGN KEY (`MemID`) REFERENCES `wfl_student` (`MemID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_D3EB697CFB15F5A5` FOREIGN KEY (`StructID`) REFERENCES `acts_structure` (`StructID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `district`
--
ALTER TABLE `district`
  ADD CONSTRAINT `FK_31C15487E946114A` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `FK_31C15487F091D9C7` FOREIGN KEY (`geography_id`) REFERENCES `geography` (`id`);

--
-- Constraints for table `province`
--
ALTER TABLE `province`
  ADD CONSTRAINT `FK_4ADAD40BF091D9C7` FOREIGN KEY (`geography_id`) REFERENCES `geography` (`id`);

--
-- Constraints for table `subdistrict`
--
ALTER TABLE `subdistrict`
  ADD CONSTRAINT `FK_3A51E90EB08FA272` FOREIGN KEY (`district_id`) REFERENCES `district` (`id`),
  ADD CONSTRAINT `FK_3A51E90EE946114A` FOREIGN KEY (`province_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `FK_3A51E90EF091D9C7` FOREIGN KEY (`geography_id`) REFERENCES `geography` (`id`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `FK_8D93D64950D866E8` FOREIGN KEY (`TeacherID`) REFERENCES `wfl_teacher` (`TeacherID`),
  ADD CONSTRAINT `FK_8D93D6497ABC4562` FOREIGN KEY (`MemID`) REFERENCES `wfl_student` (`MemID`),
  ADD CONSTRAINT `FK_8D93D6499DC98488` FOREIGN KEY (`ChurchID`) REFERENCES `acts_structure` (`StructID`),
  ADD CONSTRAINT `FK_8D93D649F37D473` FOREIGN KEY (`WFLStructID`) REFERENCES `acts_structure` (`StructID`),
  ADD CONSTRAINT `FK_8D93D649FB15F5A5` FOREIGN KEY (`StructID`) REFERENCES `acts_structure` (`StructID`);

--
-- Constraints for table `wfl_course`
--
ALTER TABLE `wfl_course`
  ADD CONSTRAINT `FK_2DE3EC0950D866E8` FOREIGN KEY (`TeacherID`) REFERENCES `wfl_teacher` (`TeacherID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_2DE3EC0987939680` FOREIGN KEY (`SubjectID`) REFERENCES `wfl_subject` (`SubjectID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_2DE3EC09A63C52DE` FOREIGN KEY (`TermID`) REFERENCES `wfl_term` (`TermID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_2DE3EC09C3762256` FOREIGN KEY (`ScheduleID`) REFERENCES `wfl_schedule` (`ScheduleID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_2DE3EC09C756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`),
  ADD CONSTRAINT `FK_2DE3EC09E2CD0DD5` FOREIGN KEY (`TeacherAssistantID`) REFERENCES `wfl_teacher` (`TeacherID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_2DE3EC09FB15F5A5` FOREIGN KEY (`StructID`) REFERENCES `acts_structure` (`StructID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_creditnote`
--
ALTER TABLE `wfl_creditnote`
  ADD CONSTRAINT `FK_F836C23684E47E3A` FOREIGN KEY (`InvoiceID`) REFERENCES `wfl_invoice` (`InvoiceID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_creditnote_detail`
--
ALTER TABLE `wfl_creditnote_detail`
  ADD CONSTRAINT `FK_2D15C4A9AFDFDC2C` FOREIGN KEY (`CreditNoteID`) REFERENCES `wfl_creditnote` (`CreditNoteID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_invoicedetail`
--
ALTER TABLE `wfl_invoicedetail`
  ADD CONSTRAINT `FK_7DDB1B284E47E3A` FOREIGN KEY (`InvoiceID`) REFERENCES `wfl_invoice` (`InvoiceID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_schedule`
--
ALTER TABLE `wfl_schedule`
  ADD CONSTRAINT `FK_CA4C56A4A63C52DE` FOREIGN KEY (`TermID`) REFERENCES `wfl_term` (`TermID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_CA4C56A4C756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`),
  ADD CONSTRAINT `FK_CA4C56A4FB15F5A5` FOREIGN KEY (`StructID`) REFERENCES `acts_structure` (`StructID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_student`
--
ALTER TABLE `wfl_student`
  ADD CONSTRAINT `FK_5B26814821F0060` FOREIGN KEY (`add_provinces_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `FK_5B26814849E60751` FOREIGN KEY (`ShepherdID`) REFERENCES `wfl_student` (`MemID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_5B2681484EFEC7C9` FOREIGN KEY (`add_sub_district_id`) REFERENCES `subdistrict` (`id`),
  ADD CONSTRAINT `FK_5B2681486B7583F7` FOREIGN KEY (`off_provinces_id`) REFERENCES `province` (`id`),
  ADD CONSTRAINT `FK_5B2681488E8B9266` FOREIGN KEY (`off_district_id`) REFERENCES `district` (`id`),
  ADD CONSTRAINT `FK_5B2681489567EAC3` FOREIGN KEY (`FatherID`) REFERENCES `wfl_student` (`MemID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_5B26814898328DC8` FOREIGN KEY (`MotherID`) REFERENCES `wfl_student` (`MemID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_5B2681489DC98488` FOREIGN KEY (`ChurchID`) REFERENCES `acts_structure` (`StructID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_5B268148B6B2A1B` FOREIGN KEY (`off_sub_district_id`) REFERENCES `subdistrict` (`id`),
  ADD CONSTRAINT `FK_5B268148BA91214C` FOREIGN KEY (`MemStatusID`) REFERENCES `acts_student_status` (`MemStatusID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_5B268148E2CAFBF5` FOREIGN KEY (`add_district_id`) REFERENCES `district` (`id`),
  ADD CONSTRAINT `FK_5B268148FDEF5E2B` FOREIGN KEY (`SpouseID`) REFERENCES `wfl_student` (`MemID`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `wfl_subject`
--
ALTER TABLE `wfl_subject`
  ADD CONSTRAINT `FK_3094F0758EC7DB93` FOREIGN KEY (`SubjectCatID`) REFERENCES `wfl_subjectcategory` (`SubjectCatID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `FK_3094F075C756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`);

--
-- Constraints for table `wfl_subjectcategory`
--
ALTER TABLE `wfl_subjectcategory`
  ADD CONSTRAINT `FK_A154503FC756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`);

--
-- Constraints for table `wfl_subjectprereq`
--
ALTER TABLE `wfl_subjectprereq`
  ADD CONSTRAINT `FK_586525C629C8F893` FOREIGN KEY (`PrerequisiteSubjectID`) REFERENCES `wfl_subject` (`SubjectID`),
  ADD CONSTRAINT `FK_586525C687939680` FOREIGN KEY (`SubjectID`) REFERENCES `wfl_subject` (`SubjectID`),
  ADD CONSTRAINT `FK_586525C6C756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`);

--
-- Constraints for table `wfl_teacher`
--
ALTER TABLE `wfl_teacher`
  ADD CONSTRAINT `FK_7BAC68DA7ABC4562` FOREIGN KEY (`MemID`) REFERENCES `wfl_student` (`MemID`),
  ADD CONSTRAINT `FK_7BAC68DAC756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`);

--
-- Constraints for table `wfl_term`
--
ALTER TABLE `wfl_term`
  ADD CONSTRAINT `FK_6AEF9195C756CDD0` FOREIGN KEY (`AtChurchID`) REFERENCES `acts_structure` (`StructID`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `Adjust Spirit Index +10%` ON SCHEDULE EVERY 1 WEEK STARTS '2019-01-22 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE acts_member m
JOIN acts_structmem sm ON sm.MemID=m.MemID AND sm.deletedAt IS NULL
SET m.SpiritMeter=IF(CONVERT(m.SpiritMeter,signed)+10>=100,100,CONVERT(m.SpiritMeter,signed)+10)
WHERE m.SpiritMeter<100 AND m.MemID IN
(
SELECT DISTINCT s.MemID 
FROM acts_stat s 
WHERE s.statdate = DATE_SUB(DATE(NOW()), INTERVAL DAYOFWEEK(NOW())-1 DAY) 
AND (s.church =1 OR s.lg = 1 OR shepherding=1) AND s.MemID>0  
)$$

CREATE DEFINER=`root`@`localhost` EVENT `Adjust Spirit Index -10%` ON SCHEDULE EVERY 1 WEEK STARTS '2019-01-22 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE acts_member m
JOIN acts_structmem sm ON sm.MemID=m.MemID AND sm.deletedAt IS NULL
SET m.SpiritMeter=IF(CONVERT(m.SpiritMeter,signed)-10<=0,0,CONVERT(m.SpiritMeter,signed)-10)
WHERE m.SpiritMeter>0 AND m.MemID NOT IN
(
SELECT DISTINCT s.MemID 
FROM acts_stat s 
WHERE s.statdate = DATE_SUB(DATE(NOW()), INTERVAL DAYOFWEEK(NOW())-1 DAY) 
AND (s.church =1 OR s.lg = 1 OR shepherding=1) AND s.MemID>0  
)$$

CREATE DEFINER=`root`@`localhost` EVENT `UPDATE AGE` ON SCHEDULE EVERY 1 DAY STARTS '2019-05-02 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE `acts_member` SET Age= YEAR(CURDATE())-YEAR(Birthdate)-IF(STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(Birthdate), '-', DAY(Birthdate)) ,'%Y-%c-%e') > CURDATE(), 1, 0) WHERE Birthdate!='1900-01-01' AND Birthdate IS NOT NULL$$

CREATE DEFINER=`root`@`localhost` EVENT `Update Attendant` ON SCHEDULE EVERY 1 WEEK STARTS '2020-02-03 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE wfl_enrollment 
SET attendant=IFNULL(at1,0)+IFNULL(at2,0)+IFNULL(at3,0)+IFNULL(at4,0)+IFNULL(at5,0)+IFNULL(at6,0)+IFNULL(at7,0)+IFNULL(at8,0)+IFNULL(at9,0)+IFNULL(at10,0)+IFNULL(at11,0)+IFNULL(at12,0)
WHERE attendant<>IFNULL(at1,0)+IFNULL(at2,0)+IFNULL(at3,0)+IFNULL(at4,0)+IFNULL(at5,0)+IFNULL(at6,0)+IFNULL(at7,0)+IFNULL(at8,0)+IFNULL(at9,0)+IFNULL(at10,0)+IFNULL(at11,0)+IFNULL(at12,0)$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
