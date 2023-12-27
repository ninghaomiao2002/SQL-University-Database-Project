CREATE DATABASE IF NOT EXISTS university_system;
USE university_system;
-- ----------------------------
-- Drop potential tables called student
-- ----------------------------
DROP TABLE IF EXISTS `module selection`;
DROP TABLE IF EXISTS `appointment booking`;
DROP TABLE IF EXISTS `lecture info`;
DROP TABLE IF EXISTS `student`;
DROP TABLE IF EXISTS `module`;
DROP TABLE IF EXISTS `lecturer`;
DROP TABLE IF EXISTS `appointment`;
DROP TABLE IF EXISTS `tutor`;
-- ----------------------------
-- Table structure for student
-- ----------------------------
CREATE TABLE `student`  (
  `Student Number` int NOT NULL,
  `Gender` VARCHAR(6) NOT NULL,
  `First Name` VARCHAR(30) NOT NULL,
  `Last Name` VARCHAR(30) NOT NULL,
  `Email Address` VARCHAR(20) NOT NULL,
  `Phone Number` VARCHAR(20) NULL DEFAULT NULL,
  `Address` VARCHAR(255) NULL DEFAULT NULL,
  `Stream` VARCHAR(255) NOT NULL DEFAULT 'General Engineering',
  PRIMARY KEY (`Student Number`)
);
ALTER TABLE `student` ADD CONSTRAINT Gender_Con CHECK(Gender="Male" or Gender="Female");
ALTER TABLE `student` ADD CONSTRAINT Student_Phone_Number_Con CHECK(CHAR_LENGTH(`Phone Number`) = 10 or CHAR_LENGTH(`Phone Number`) = 0);
ALTER TABLE `student` ADD CONSTRAINT Student_Number_Con CHECK(CHAR_LENGTH(`Student Number`) = 8);
-- ----------------------------
-- Table structure for lecturer
-- ----------------------------
CREATE TABLE `lecturer`  (
  `Lecturer ID` VARCHAR(255) NOT NULL,
  `First Name` VARCHAR(255) NOT NULL,
  `Last Name` VARCHAR(255) NOT NULL,
  `PPSN` VARCHAR(255) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Phone Number` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`Lecturer ID`)
);
ALTER TABLE `lecturer` ADD CONSTRAINT Lecturer_Phone_Number_Con CHECK(CHAR_LENGTH(`Phone Number`) = 10 or CHAR_LENGTH(`Phone Number`) = 0);
ALTER TABLE `lecturer` ADD CONSTRAINT PPSN_Con CHECK(CHAR_LENGTH(PPSN) = 8 or CHAR_LENGTH(PPSN) = 9);
ALTER TABLE `lecturer` ADD CONSTRAINT lecturer_ID_Con_1 CHECK(CHAR_LENGTH(`LEcturer ID`) = 4);
-- ----------------------------
-- Table structure for modules
-- ----------------------------
CREATE TABLE `module`  (
  `Module ID` VARCHAR(255) NOT NULL,
  `Module Name` VARCHAR(255) NOT NULL,
  `ECT` INT NOT NULL,
  `Lecturer ID` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Module ID`),
	FOREIGN kEY (`Lecturer ID`) REFERENCES `lecturer`(`Lecturer ID`)
);
ALTER TABLE `module` ADD CONSTRAINT ECT_Con CHECK(ECT="5" or ECT="10" or ECT="30");
ALTER TABLE `module` ADD CONSTRAINT Lecture_ID_Con CHECK(CHAR_LENGTH(`Lecturer ID`) = 4);
-- ----------------------------
-- Table structure for modules selection
-- ----------------------------
CREATE TABLE `module selection`  (
  `Student Number` INT NOT NULL,
  `Module ID` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Student Number`, `Module ID`),
	FOREIGN kEY (`Student Number`) REFERENCES student(`Student Number`),
	FOREIGN kEY (`Module ID`) REFERENCES module(`Module ID`)
);
ALTER TABLE `module selection` ADD CONSTRAINT Student_Number_Con_3 CHECK(CHAR_LENGTH(`Student Number`) = 8);
-- ----------------------------
-- Table structure for lecture info
-- ----------------------------
CREATE TABLE `lecture info`  (
  `Module ID` VARCHAR(255) NOT NULL,
  `Lecture Room` VARCHAR(255) NULL DEFAULT 'Online',
  `Lecture ID` VARCHAR(255) NOT NULL,
  `Lecture Duration` INT NOT NULL,
  `Lecture Time` DATETIME NOT NULL,
  PRIMARY KEY (`Lecture ID`),
	FOREIGN kEY (`Module ID`) REFERENCES Module(`Module ID`)
);
ALTER TABLE `lecture info` ADD CONSTRAINT `Lecture_Duration_Con` CHECK(`Lecture Duration`="1" or `Lecture Duration`="2" OR `Lecture Duration`="3");
-- ----------------------------
-- Table structure for appointment
-- ----------------------------
CREATE TABLE `appointment`  (
  `Appointment ID` INT NOT NULL,
  `Location` VARCHAR(255) NOT NULL DEFAULT 'Online',
  `Time` DATETIME NOT NULL,
  PRIMARY KEY (`Appointment ID`)
);
-- ----------------------------
-- Table structure for tutor
-- ----------------------------
CREATE TABLE `tutor`  (
  `Tutor ID` INT NOT NULL,
  `First Name` VARCHAR(255) NOT NULL,
  `Last Name` VARCHAR(255) NOT NULL,
  `Department` VARCHAR(255) NOT NULL,
  `Office Location` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Tutor ID`)
);
ALTER TABLE `tutor` ADD CONSTRAINT Tutor_ID_Con_1 CHECK(CHAR_LENGTH(`Tutor ID`) = 5);
-- ----------------------------
-- Table structure for appointment bookings
-- ----------------------------
CREATE TABLE `appointment booking`  (
  `Appointment ID` INT NOT NULL,
  `Tutor ID` INT NOT NULL,
  `Student Number` INT NOT NULL,
  PRIMARY KEY (`Appointment ID`, `Tutor ID`, `Student Number`),
	FOREIGN kEY (`Appointment ID`) REFERENCES appointment(`Appointment ID`),
	FOREIGN kEY (`Tutor ID`) REFERENCES tutor(`Tutor ID`),
	FOREIGN kEY (`Student Number`) REFERENCES student(`Student Number`)
);
ALTER TABLE `appointment booking` ADD CONSTRAINT Tutor_ID_Con CHECK(CHAR_LENGTH(`Tutor ID`) = 5);
ALTER TABLE `appointment booking` ADD CONSTRAINT Student_Number_Con_2 CHECK(CHAR_LENGTH(`Student Number`) = 8);
-- ----------------------------
-- ----------------------------
-- Trigger for maximum_ECT
-- If a student already has more than 30 ECTs, we could not add more module on him
-- ----------------------------
-- ----------------------------
DROP TRIGGER IF EXISTS `maximum_ECT`;
CREATE TRIGGER `maximum_ECT`
BEFORE INSERT ON `module selection`
FOR EACH ROW
BEGIN
  DECLARE student_ECT INT;
  DECLARE new_module_ECT INT;

  SELECT SUM(module.ECT) INTO student_ECT
  FROM student
  JOIN `module selection` ON student.`Student Number` = `module selection`.`Student Number`
  JOIN module ON `module selection`.`Module ID` = module.`Module ID`
	WHERE student.`Student Number` = NEW.`Student Number`;

  SELECT ECT INTO new_module_ECT
  FROM module
  WHERE `Module ID` = NEW.`Module ID`;

  IF student_ECT + new_module_ECT > 30 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot insert. Maximum ECT reached';
  END IF;
END;


-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (19336847, 'Male', 'Mike', 'Lee', 'leem@tcd.ie', NULL, 'Finglas, Dublin 11', 'Electronic Engineering');
INSERT INTO `student` VALUES (19336861, 'Male', 'Ninghao', 'Miao', 'miaon@tcd.ie', '0834660069', 'Scholarstown, Dublin 16', 'Electronic Engineering and Computer Engineering');
INSERT INTO `student` VALUES (20334789, 'Female', 'Ashly', 'Carr', 'carra@tcd.ie', NULL, 'Sandyford, Dublin 18', 'Biomedical Engineering');
INSERT INTO `student` VALUES (20336089, 'Male', 'Cian', 'Wade', 'wadec@tcd.ie', NULL, NULL, 'Computer Engineering');
INSERT INTO `student` VALUES (20336489, 'Male', 'Curry', 'Stephen', 'stepc@tcd.ie', NULL, 'College Green, Dublin 2', 'Mechanical Engineering');
INSERT INTO `student` VALUES (20336947, 'Male', 'Vincent', 'Liu', 'liuv3@tcd.ie', '0856987450', NULL, 'Civil Engineering');
-- ----------------------------
-- Records of lecturer
-- ----------------------------
INSERT INTO `lecturer` VALUES ('0016', 'Samuel', 'Clark', '2468777HA', 'clarks@tcd.ie', '0854713697');
INSERT INTO `lecturer` VALUES ('0132', 'Walter', 'Lucas', '2369458G', 'lucasw@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0145', 'Jaime', 'Roberts', '1697854CA', 'robertsj@tcd.ie', '');
INSERT INTO `lecturer` VALUES ('0147', 'John', 'Brown', '1658097GT', 'brownj@tcd.ie', '0864559784');
INSERT INTO `lecturer` VALUES ('0169', 'Cian', 'Kerry', '1469874KW', 'kerryc@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0312', 'Rachelle', 'Lara', '1964780CA', 'larar@tcd.ie', '0833146987');
INSERT INTO `lecturer` VALUES ('0427', 'Viv', 'Livingston', '1969634G', 'livingstonv@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0438', 'James', 'Smith', '2365897JA', 'smithj@tcd.ie', '0834665589');
INSERT INTO `lecturer` VALUES ('0476', 'Wade', 'Williams', '2648476CA', 'williamw@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0487', 'Lucy', 'Green', '2036478GA', 'greenl@tcd.ie', '0875469877');
INSERT INTO `lecturer` VALUES ('0547', 'Mark', 'Thomas', '2564799G', 'thomasm@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0597', 'Robin', 'Cook', '2369745FA', 'cookr@tcd.ie', '0856947856');
INSERT INTO `lecturer` VALUES ('0625', 'Craig', 'Howard', '1647896H', 'howardc@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0647', 'Vivian', 'Baker', '2306478GA', 'bakerv@tcd.ie', NULL);
INSERT INTO `lecturer` VALUES ('0687', 'Perry', 'Davis', '1347598GA', 'davisp@tcd.ie', '0831269714');
INSERT INTO `lecturer` VALUES ('0689', 'Shane', 'Woodward', '2064789CA', 'woowards@tcd.ie', NULL);
-- ----------------------------
-- Records of modules
-- ----------------------------
INSERT INTO `module` VALUES ('CEU44A031', 'Environmental Engineering', 5, '0147');
INSERT INTO `module` VALUES ('CEU44A15', 'Hydraulics & Hydrology', 5, '0438');
INSERT INTO `module` VALUES ('CEU44A51', 'Geotechnical Engineering', 5, '0169');
INSERT INTO `module` VALUES ('CEU44A61', 'Structures', 5, '0476');
INSERT INTO `module` VALUES ('CEU44E01', 'Management for Engineers', 5, '0547');
INSERT INTO `module` VALUES ('CEU44E03', 'Research Method', 5, '0625');
INSERT INTO `module` VALUES ('CSU44D01', 'Infomation Management', 5, '0687');
INSERT INTO `module` VALUES ('EEU44C01', 'Integrated Systems Design', 5, '0016');
INSERT INTO `module` VALUES ('EEU44C05', 'Digital Signal Processing', 5, '0132');
INSERT INTO `module` VALUES ('EEU44C16', 'Deep Learning and its Applications', 10, '0597');
INSERT INTO `module` VALUES ('EEU44E03', 'Research Method', 5, '0145');
INSERT INTO `module` VALUES ('MEU44B04', 'Heat Transfer', 5, '0438');
INSERT INTO `module` VALUES ('MEU44B07', 'COMPUTER AIDED DESIGN', 5, '0016');
INSERT INTO `module` VALUES ('MEU44B13', 'Fluid Mechanics', 5, '0487');
INSERT INTO `module` VALUES ('MEU44B17', 'Multibody Dynamics', 5, '0487');
INSERT INTO `module` VALUES ('MEU44BM1', 'Introductory Cell and Molecular Biology', 5, '0647');
INSERT INTO `module` VALUES ('MEU44BM4', 'Research Method', 5, '0312');
INSERT INTO `module` VALUES ('MEU44BM5', 'Biomechanics', 5, '0689');
INSERT INTO `module` VALUES ('MEU44BM6', 'Biomaterials', 5, '0689');
INSERT INTO `module` VALUES ('MEU44E03', 'Research Method', 5, '0427');
-- ----------------------------
-- Records of modules selection
-- ----------------------------
INSERT INTO `module selection` VALUES (19336847, 'CEU44E01');
INSERT INTO `module selection` VALUES (19336847, 'EEU44C05');
INSERT INTO `module selection` VALUES (19336847, 'EEU44C16');
INSERT INTO `module selection` VALUES (19336847, 'EEU44E03');
INSERT INTO `module selection` VALUES (19336861, 'CEU44E01');
INSERT INTO `module selection` VALUES (19336861, 'CSU44D01');
INSERT INTO `module selection` VALUES (19336861, 'EEU44C05');
INSERT INTO `module selection` VALUES (19336861, 'EEU44C16');
INSERT INTO `module selection` VALUES (19336861, 'EEU44E03');
INSERT INTO `module selection` VALUES (20334789, 'CEU44E01');
INSERT INTO `module selection` VALUES (20334789, 'EEU44C05');
INSERT INTO `module selection` VALUES (20334789, 'MEU44BM1');
INSERT INTO `module selection` VALUES (20334789, 'MEU44BM4');
INSERT INTO `module selection` VALUES (20334789, 'MEU44BM5');
INSERT INTO `module selection` VALUES (20334789, 'MEU44BM6');
INSERT INTO `module selection` VALUES (20336089, 'CEU44E01');
INSERT INTO `module selection` VALUES (20336089, 'CSU44D01');
INSERT INTO `module selection` VALUES (20336089, 'EEU44C05');
INSERT INTO `module selection` VALUES (20336089, 'EEU44C16');
INSERT INTO `module selection` VALUES (20336089, 'EEU44E03');
INSERT INTO `module selection` VALUES (20336489, 'CEU44E01');
INSERT INTO `module selection` VALUES (20336489, 'MEU44B04');
INSERT INTO `module selection` VALUES (20336489, 'MEU44B07');
INSERT INTO `module selection` VALUES (20336489, 'MEU44B13');
INSERT INTO `module selection` VALUES (20336489, 'MEU44B17');
INSERT INTO `module selection` VALUES (20336489, 'MEU44E03');
INSERT INTO `module selection` VALUES (20336947, 'CEU44A031');
INSERT INTO `module selection` VALUES (20336947, 'CEU44A15');
INSERT INTO `module selection` VALUES (20336947, 'CEU44A51');
INSERT INTO `module selection` VALUES (20336947, 'CEU44A61');
INSERT INTO `module selection` VALUES (20336947, 'CEU44E01');
INSERT INTO `module selection` VALUES (20336947, 'CEU44E03');
-- ----------------------------
-- Records of lecture info
-- ----------------------------
INSERT INTO `lecture info` VALUES ('CEU44A031', 'Glodsmith', 'CEU44A031A1', 1, '2023-12-04 14:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A031', 'M19, Arts Building', 'CEU44A031A2', 1, '2023-11-03 09:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A031', 'M19, Arts Building', 'CEU44A031A3', 1, '2024-01-09 10:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A15', 'M20, Arts Building', 'CEU44A15A1', 1, '2023-11-16 10:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A15', 'Online', 'CEU44A15A2', 2, '2023-11-15 11:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A15', 'M19, Arts Building', 'CEU44A15A3', 2, '2024-01-18 15:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A51', 'M17, Arts Building', 'CEU44A51A1', 1, '2023-10-22 11:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A51', 'M17, Arts Building', 'CEU44A51A2', 1, '2023-10-25 10:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A51', 'Glodsmith', 'CEU44A51A3', 1, '2024-01-15 10:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A61', 'Online', 'CEU44A61A1', 2, '2023-11-09 11:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A61', 'M19, Arts Building', 'CEU44A61A2', 1, '2023-10-25 09:00:00');
INSERT INTO `lecture info` VALUES ('CEU44A61', 'Online', 'CEU44A61A3', 1, '2024-01-12 09:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E01', 'M20, Arts Building', 'CEU44E01A1', 1, '2023-10-25 12:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E01', 'Online', 'CEU44E01A2', 1, '2023-12-19 11:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E01', 'M19, Arts Building', 'CEU44E01A3', 1, '2024-01-09 14:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E03', 'Online', 'CEU44E03A1', 2, '2023-11-02 16:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E03', 'Glodsmith', 'CEU44E03A2', 1, '2023-10-18 14:00:00');
INSERT INTO `lecture info` VALUES ('CEU44E03', 'Online', 'CEU44E03A3', 2, '2024-01-17 09:00:00');
INSERT INTO `lecture info` VALUES ('CSU44D01', 'M20, Arts Building', 'CSU44D01A1', 1, '2023-10-26 12:00:00');
INSERT INTO `lecture info` VALUES ('CSU44D01', 'M17, Arts Building', 'CSU44D01A2', 2, '2023-10-16 11:00:00');
INSERT INTO `lecture info` VALUES ('CSU44D01', 'M17, Arts Building', 'CSU44D01A3', 1, '2024-01-24 13:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C01', 'Online', 'EEU44C01A1', 1, '2023-11-16 09:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C01', 'Online', 'EEU44C01A2', 1, '2023-10-20 11:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C01', 'Online', 'EEU44C01A3', 3, '2024-01-23 16:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C05', 'Glodsmith', 'EEU44C05A1', 1, '2023-11-05 13:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C05', 'M19, Arts Building', 'EEU44C05A2', 2, '2023-11-24 16:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C05', 'Glodsmith', 'EEU44C05A3', 1, '2024-01-25 13:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C16', 'M17, Arts Building', 'EEU44C16A1', 2, '2023-10-31 09:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C16', 'M17, Arts Building', 'EEU44C16A2', 1, '2023-12-21 13:00:00');
INSERT INTO `lecture info` VALUES ('EEU44C16', 'M17, Arts Building', 'EEU44C16A3', 1, '2024-01-26 12:00:00');
INSERT INTO `lecture info` VALUES ('EEU44E03', 'Glodsmith', 'EEU44E03A1', 1, '2023-11-30 13:00:00');
INSERT INTO `lecture info` VALUES ('EEU44E03', 'M19, Arts Building', 'EEU44E03A2', 2, '2023-12-18 14:00:00');
INSERT INTO `lecture info` VALUES ('EEU44E03', 'Online', 'EEU44E03A3', 1, '2024-01-26 15:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B04', 'Online', 'MEU44B04A1', 2, '2023-11-02 17:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B04', 'Online', 'MEU44B04A2', 1, '2023-12-19 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B04', 'M17, Arts Building', 'MEU44B04A3', 2, '2024-01-26 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B07', 'M20, Arts Building', 'MEU44B07A1', 1, '2023-11-20 14:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B07', 'M19, Arts Building', 'MEU44B07A2', 1, '2023-12-08 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B07', 'Online', 'MEU44B07A3', 1, '2024-01-12 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B13', 'Glodsmith', 'MEU44B13A1', 2, '2023-11-02 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B13', 'Glodsmith', 'MEU44B13A2', 1, '2023-12-18 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B13', 'Glodsmith', 'MEU44B13A3', 2, '2024-02-02 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B17', 'M17, Arts Building', 'MEU44B17A1', 1, '2023-10-19 13:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B17', 'M17, Arts Building', 'MEU44B17A2', 2, '2023-12-19 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44B17', 'Online', 'MEU44B17A3', 1, '2024-02-06 13:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM1', 'M20, Arts Building', 'MEU44BM1A1', 2, '2023-11-01 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM1', 'Online', 'MEU44BM1A2', 2, '2023-12-15 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM1', 'M17, Arts Building', 'MEU44BM1A3', 2, '2024-02-05 12:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM4', 'Glodsmith', 'MEU44BM4A1', 1, '2023-10-23 16:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM4', 'M19, Arts Building', 'MEU44BM4A2', 2, '2023-12-05 11:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM4', 'Glodsmith', 'MEU44BM4A3', 1, '2024-02-13 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM5', 'Online', 'MEU44BM5A1', 2, '2023-10-09 09:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM5', 'M17, Arts Building', 'MEU44BM5A2', 1, '2023-12-18 16:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM5', 'M17, Arts Building', 'MEU44BM5A3', 1, '2024-02-09 13:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM6', 'Glodsmith', 'MEU44BM6A1', 1, '2023-10-31 16:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM6', 'M19, Arts Building', 'MEU44BM6A2', 1, '2023-11-24 09:00:00');
INSERT INTO `lecture info` VALUES ('MEU44BM6', 'M19, Arts Building', 'MEU44BM6A3', 1, '2024-02-07 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44E03', 'M20, Arts Building', 'MEU44E03A1', 2, '2023-11-15 12:00:00');
INSERT INTO `lecture info` VALUES ('MEU44E03', 'Online', 'MEU44E03A2', 1, '2023-11-27 10:00:00');
INSERT INTO `lecture info` VALUES ('MEU44E03', 'Glodsmith', 'MEU44E03A3', 1, '2024-02-07 10:00:00');
-- ----------------------------
-- Records of appointment
-- ----------------------------
INSERT INTO `appointment` VALUES (2023111601, '4028, AAP', '2023-11-16 16:00:00');
INSERT INTO `appointment` VALUES (2023111901, 'Online', '2023-11-19 11:00:00');
INSERT INTO `appointment` VALUES (2023112501, 'Online', '2023-11-25 10:00:00');
INSERT INTO `appointment` VALUES (2023112502, '4022, AAP', '2023-11-25 14:00:00');
INSERT INTO `appointment` VALUES (2023112801, '4030, AAP', '2023-11-28 15:00:00');
INSERT INTO `appointment` VALUES (2023120601, 'Online', '2023-12-06 11:00:00');
INSERT INTO `appointment` VALUES (2023121501, 'Online', '2023-12-15 16:00:00');
INSERT INTO `appointment` VALUES (2023121701, 'Online', '2023-12-17 12:00:00');
INSERT INTO `appointment` VALUES (2023121702, '4022, AAP', '2023-12-17 11:00:00');
INSERT INTO `appointment` VALUES (2023121801, '4021, AAP', '2023-12-18 11:00:00');
-- ----------------------------
-- Records of tutor
-- ----------------------------
INSERT INTO `tutor` VALUES (10232, 'John', 'White', 'Engineering', '3002, AAP');
INSERT INTO `tutor` VALUES (12478, 'Robert', 'Cha', 'Computer Science', '3017, AAP');
INSERT INTO `tutor` VALUES (13654, 'Mary', 'Hown', 'Computer Science', '3002, AAP');
INSERT INTO `tutor` VALUES (13695, 'Susan', 'Liu', 'Engineering', '3004, AAP');
INSERT INTO `tutor` VALUES (16458, 'Ann', 'Gates', 'Engineering', '3004, AAP');
-- ----------------------------
-- Records of appointment bookings
-- ----------------------------
INSERT INTO `appointment booking` VALUES (2023111601, 10232, 19336847);
INSERT INTO `appointment booking` VALUES (2023111901, 12478, 20336089);
INSERT INTO `appointment booking` VALUES (2023112501, 13654, 19336861);
INSERT INTO `appointment booking` VALUES (2023112502, 16458, 20334789);
INSERT INTO `appointment booking` VALUES (2023112801, 13654, 19336861);
INSERT INTO `appointment booking` VALUES (2023120601, 10232, 20334789);
INSERT INTO `appointment booking` VALUES (2023121501, 13695, 19336847);
INSERT INTO `appointment booking` VALUES (2023121701, 16458, 20336089);
INSERT INTO `appointment booking` VALUES (2023121702, 13695, 20336489);
INSERT INTO `appointment booking` VALUES (2023121801, 13695, 20336947);
-- ----------------------------
-- Create and grant to user administrator
-- ----------------------------
DROP USER IF EXISTS 'administrator' @'localhost';
CREATE USER 'administrator' @'localhost' IDENTIFIED BY 'passwordadministrator';
GRANT ALL ON university_system.* TO 'administrator' @'localhost';
-- ----------------------------
-- Create and grant to user clarks@tcd.ie
-- ----------------------------
DROP USER IF EXISTS 'clarks@tcd.ie' @'localhost';
CREATE USER 'clarks@tcd.ie' @'localhost' IDENTIFIED BY 'passwordclarks';
# grant partial authorisation to lecturer
GRANT SELECT(`Student Number`),SELECT(`First Name`),SELECT(`Last Name`), SELECT(`Email Address`),SELECT(`Gender`),SELECT(`Phone Number`) ON university_system.student TO 'clarks@tcd.ie' @'localhost';
GRANT SELECT ON university_system.module to 'clarks@tcd.ie' @'localhost';
GRANT SELECT(`First Name`),SELECT(`Last Name`),SELECT(`Email`), SELECT(`Lecturer ID`), SELECT(`Phone Number`) ON university_system.lecturer TO 'clarks@tcd.ie' @'localhost';
GRANT SELECT ON university_system.`lecture info` TO 'clarks@tcd.ie' @'localhost';
GRANT SELECT ON university_system.tutor TO 'clarks@tcd.ie' @'localhost';
GRANT SELECT ON university_system.`module selection` TO 'clarks@tcd.ie' @'localhost';
GRANT INSERT, UPDATE ON university_system.`lecture info` TO 'clarks@tcd.ie' @'localhost';
-- ----------------------------
-- Create and grant to user miaon@tcd.ie' @'localhost
-- ----------------------------
DROP USER IF EXISTS 'miaon@tcd.ie' @'localhost';
create user 'miaon@tcd.ie' @'localhost' IDENTIFIED BY 'passwordmiaon';
GRANT SELECT ON university_system.student TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT ON university_system.module TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT(`First Name`),SELECT(`Last Name`),SELECT(`Email`), SELECT(`Lecturer ID`) ON university_system.lecturer TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT ON university_system.`lecture info` TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT ON university_system.tutor TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT ON university_system.appointment TO 'miaon@tcd.ie' @'localhost';
GRANT SELECT ON university_system.`module selection` TO 'miaon@tcd.ie' @'localhost';
-- ----------------------------
-- ----------------------------
-- Log into administrator account
-- Username: administrator
-- Password: passwordadministrator
-- ----------------------------
-- ----------------------------
# Sorting for administrator with `First Name`
SELECT * FROM student ORDER BY `First Name`;
# Sorting for administrator with `Student Number`
SELECT * FROM student ORDER BY `Student Number`;
-- ----------------------------
-- Altering Tables Example 1
-- ----------------------------
# Delete a module selection
DELETE FROM `module selection`
WHERE `Student Number` = 19336861 AND `Module ID` = 'CSU44D01';
# Below code is for check the status for the above altering command
SELECT * FROM `module selection`
WHERE `Student Number` = 19336861;
# Insert into the tables
INSERT INTO `module selection` (`Student Number`, `Module ID`)
VALUES (19336861, 'MEU44B17');
# Below code is for check the status for the above altering command
SELECT * FROM `module selection`
WHERE `Student Number` = 19336861;
# Update the `module selection`
UPDATE `module selection`
SET `Module ID` = 'CSU44D01'
WHERE `Student Number` = 19336861 AND `Module ID` = 'MEU44B17';
# below code is for check the status for the above altering command
SELECT * FROM `module selection`
WHERE `Student Number` = 19336861;
-- ----------------------------
-- Altering Tables Example 2
-- ----------------------------
DELETE FROM `appointment`
WHERE `Appointment ID` = 2023111701;
SELECT * FROM `appointment`;
# Insert into the tables
INSERT INTO `appointment` (`Appointment ID`, `Location`, `Time`)
VALUES (2023111701, 'XXXXXX', '2023-11-17 16:00:00');
# Below code is for check the status for the above altering command
SELECT * FROM `appointment`;
# Update the `module selection`
UPDATE `appointment`
SET `Location` = 'Trinity Berkely Library'
WHERE `Appointment ID` = 2023111701;
# below code is for check the status for the above altering command
SELECT * FROM `appointment`;
-- ----------------------------
-- Creating Views for `Student Modules Table`
-- ----------------------------
# Create a table with students names, email addresses, module names, lecturer names and lecturer email addresses
DROP VIEW IF EXISTS `Student Modules Table`;
CREATE VIEW `Student Modules Table` AS
SELECT student.`First Name` AS `Student First Name`, student.`Last Name` AS `Student Last Name`, student.`Stream` AS `Student Stream`, student.`Email Address` AS `Student Email`, module.`Module Name`, lecturer.`First Name` AS `Lecturer First Name`,lecturer.`Last Name` AS `Lecturer Last Name`, lecturer.Email AS `Lecturer Email`
FROM student
JOIN `module selection` ON student.`Student Number` = `module selection`.`Student Number`
JOIN module ON `module selection`.`Module ID` = module.`Module ID`
JOIN lecturer ON lecturer.`Lecturer ID` = module.`Lecturer ID`;
SELECT * FROM `Student Modules Table`;
-- ----------------------------
-- Creating Views for `Student General Timetable`
-- ----------------------------
# Create a general timetable for all students
DROP VIEW IF EXISTS `Student General Timetable`;
CREATE VIEW `Student General Timetable` AS
SELECT module.`Module Name`, `lecture info`.`Lecture Room`, `lecture info`.`Lecture Duration`, `lecture info`.`Lecture Time`, lecturer.`First Name`, lecturer.`Last Name`
FROM `lecture info`, module, lecturer
WHERE lecturer.`Lecturer ID` = module.`Lecturer ID` AND `lecture info`.`Module ID` = module.`Module ID`;
SELECT * FROM `Student General Timetable`;
-- ----------------------------
-- Creating Views for `Student Tutor Appointment`
-- ----------------------------
# Create a tutor appointment timetable for students
DROP VIEW IF EXISTS `Student Tutor Appointment`;
CREATE VIEW `Student Tutor Appointment` AS
SELECT student.`First Name` AS `Student First Name`, student.`Last Name` AS `Student Last Name`, student.`Email Address`, appointment.Location, appointment.Time, tutor.`First Name` AS `Tutor First Name`, tutor.`Last Name` AS `Tutor Last Name`
FROM student, tutor, appointment, `appointment booking`
WHERE student.`Student Number` = `appointment booking`.`Student Number` AND `appointment booking`.`Tutor ID` = tutor.`Tutor ID` AND `appointment booking`.`Appointment ID` = appointment.`Appointment ID`;
SELECT * FROM `Student Tutor Appointment`;
-- ----------------------------
-- Creating Views for `Lecturer Timetable`
-- ----------------------------
# Create a a time table for lecturers
DROP VIEW IF EXISTS `Lecturer Timetable`;
CREATE VIEW `Lecturer Timetable` AS
SELECT lecturer.`First Name`, lecturer.`Last Name`, module.`Module Name`, `lecture info`.`Lecture Room`, `lecture info`.`Lecture Time`, `lecture info`.`Lecture Duration`
FROM lecturer
JOIN module ON module.`Lecturer ID` = lecturer.`Lecturer ID`
JOIN `lecture info` ON module.`Module ID` = `lecture info`.`Module ID`;
SELECT * FROM `Lecturer Timetable`;
-- ----------------------------
-- Retrieving information from the database
-- As I have use join and other statement in creating four views so I just have two examples here
-- ----------------------------
# module selection by a specific student 'Ninghao Miao'
SELECT student.`First Name` AS `Student First Name`, student.`Last Name` AS `Student Last Name`, student.`Email Address`, module.`Module Name`
FROM student
JOIN `module selection` ON student.`Student Number` = `module selection`.`Student Number`
JOIN module on `module selection`.`Module ID` = module.`Module ID`
WHERE student.`Student Number` = 19336861;
# appointment booked by student for a specific tutor 'John White'
SELECT student.`First Name` AS `Student First Name`, student.`Last Name` AS `Student Last Name`, student.`Email Address`, appointment.Location, appointment.Time, tutor.`First Name` AS `Tutor First Name`, tutor.`Last Name` AS `Tutor Last Name`
FROM student, tutor, appointment, `appointment booking`
WHERE student.`Student Number` = `appointment booking`.`Student Number` AND `appointment booking`.`Tutor ID` = tutor.`Tutor ID` AND `appointment booking`.`Appointment ID` = appointment.`Appointment ID` AND tutor.`Tutor ID` = 10232;
-- ----------------------------
-- Check the if Trigger `maximum_ECT` works
-- ----------------------------
# Check the if Trigger `maximum_ECT` works
# `Student Number` = 19336861 already has 30 ECTs so below code won'r work
INSERT INTO `module selection` (`Student Number`, `Module ID`)
VALUES (19336861, 'MEU44B04');
SELECT * FROM `module selection`
WHERE `module selection`.`Student Number` = 19336861;
# if we delete one module and then add back, the trigger will not take effect
DELETE FROM `module selection`
WHERE `Student Number` = 19336861 AND `Module ID` = 'EEU44C05';
INSERT INTO `module selection` (`Student Number`, `Module ID`)
VALUES (19336861, 'EEU44C05');
SELECT * FROM `module selection`
WHERE `module selection`.`Student Number` = 19336861;
-- ----------------------------
-- ----------------------------
-- Log into sample lecturer account
-- username: clarks@tcd.ie
-- password: passwordclarks
-- ----------------------------
-- ----------------------------
# check lecturers' lecture details
USE university_system;
SELECT lecturer.`First Name`, lecturer.`Last Name`, `lecture info`.`Lecture Room`, `lecture info`.`Lecture Duration`, `lecture info`.`Lecture Time`, module.`Module Name`
FROM module, lecturer, `lecture info`
WHERE lecturer.`Lecturer ID` = module.`Lecturer ID` AND module.`Module ID` = `lecture info`.`Module ID` AND lecturer.`Email` LIKE CONCAT(SUBSTRING_INDEX(USER(), '@', 2));
-- ----------------------------
-- ----------------------------
-- Log into sample student account
-- username: miaon@tcd.ie
-- password: passwordmiaon
-- ----------------------------
-- ----------------------------
# check modules for the log-in student account(miaon@tcd.ie)
USE university_system;
SELECT student.`First Name`, student.`Last Name`, student.`Student Number`, module.`Module Name`, module.ECT
FROM student, module, `module selection`
WHERE student.`Student Number` = `module selection`.`Student Number` AND `module selection`.`Module ID` = module.`Module ID` AND student.`Email Address` LIKE CONCAT(SUBSTRING_INDEX(USER(), '@', 2));
# check students timetable with lecturers details for the log-in student account(miaon@tcd.ie)
SELECT student.`First Name`, student.`Last Name`, module.`Module Name`, `lecture info`.`Lecture Room`, `lecture info`.`Lecture Duration`, `lecture info`.`Lecture Time`, lecturer.`First Name`, lecturer.`Last Name`
FROM student, `module selection`, `lecture info`, module, lecturer
WHERE student.`Student Number` = `module selection`.`Student Number` AND `module selection`.`Module ID` = `lecture info`.`Module ID` AND student.`Email Address` LIKE CONCAT(SUBSTRING_INDEX(USER(), '@', 2)) AND lecturer.`Lecturer ID` = module.`Lecturer ID` AND module.`Module ID` = `module selection`.`Module ID`;

