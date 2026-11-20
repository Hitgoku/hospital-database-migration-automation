-- Creating table departments---
create table departments
(
	departmentID int auto_increment primary key,
    name varchar(50) not null
);

-- Creating table doctors---
create table doctors
(
	doctorID int auto_increment primary key,
    name varchar(50) ,
    specialization varchar(100),
    role varchar(50),
    departmentid int,
    foreign key (departmentid) references departments(departmentID)
);

-- Creating table patients
create table patients
(
	patientID int auto_increment primary key,
    name varchar(50) ,
    DOB date,
    gender varchar(1),
    phone varchar(12),
    check (gender in('m','f','o'))
);

-- Creating table Appointments
create table appointments
(
	appointmentID int auto_increment primary key,
    patientid int,
    doctorid int,
    appointmenttime datetime,
    status varchar(50),
    foreign key (patientid) references patients(patientID),
    foreign key (doctorid) references doctors(doctorID),
    check (status in ('Scheduled','Completed','Cancelled'))
)

SELECT * FROM appointments;

-- Creating table Prescription
create table Prescription
(
	PrescriptionID int auto_increment primary key,
    appointmentid int,
    medication varchar(100),
    dosage varchar(100),
    foreign key (appointmentid) references appointments(appointmentID)
)

-- Creating table Bill
create table Bill
(
	BillID int auto_increment primary key,
    appointmentid int,
    amount decimal(10,2),
    paid tinyint(1),
    billdate datetime default current_timestamp,
    foreign key (appointmentid) references appointments(appointmentID)
)

-- Creating table Labreports
create table Labrep
(
	LabrepID int auto_increment primary key,
    appointmentid int,
    reportdata text,
    createdAt datetime default current_timestamp,
    foreign key (appointmentid) references appointments(appointmentID)
)

-- Insertion in Database 



-- Insertion of values into department table

select * from hospital_data
select `Departments.DepartmentID` from hospital_data

-- select column_name from information_schema.columns
-- where table_schema='hospital_db'
-- and table_name='hospital_data'
-- and column_name like 'departments.%'

select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'departments.%'


insert into departments(departmentID,name)
select `Departments.DepartmentID`,`Departments.Name` from hospital_data
WHERE `Departments.DepartmentID` IS NOT NULL
AND `Departments.DepartmentID` <> '';

select * from departments
-- SELECT
--     COUNT(*) AS total_departments,
--     COUNT(DISTINCT departmentID) AS unique_departments
-- FROM departments;

-- Insertion of values into doctors table
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'doctors.%'

insert into doctors(departmentid,doctorID,name,role,specialization)
select`Doctors.DepartmentID`,`Doctors.DoctorID`,`Doctors.Name`,`Doctors.Role`,`Doctors.Specialization`
from hospital_data
WHERE `Doctors.DepartmentID` IS NOT NULL
AND `Doctors.DepartmentID` <> '';

select * from doctors

-- patients table
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'Patients.%'

insert into patients(DOB,gender,name,patientID,phone)
select STR_TO_DATE(
        `Patients.DateOfBirth`,
        '%d-%m-%Y'
    ),`Patients.Gender`,`Patients.Name`,`Patients.PatientID`,`Patients.Phone`
from hospital_data
WHERE `Patients.PatientID` IS NOT NULL
AND `Patients.PatientID` <> '';

select * from patients

appoinments table(Error)
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'Appointments.%'

INSERT INTO appointments(appointmentID,patientid,doctorid,appointmenttime,status)
SELECT
    `Appointments.AppointmentID`,
    `Appointments.PatientID`,
    `Appointments.DoctorID`,
    STR_TO_DATE(`Appointments.AppointmentTime`, '%d-%m-%Y %H:%i'),
    `Appointments.Status`
FROM hospital_data

select * from appointments


-- prescription table
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'Prescriptions.%'

INSERT INTO prescription (
    PrescriptionID,
    appointmentid,
    medication,
    dosage
    )
select`Prescriptions.PrescriptionID`,`Prescriptions.AppointmentID`,`Prescriptions.Medication`,`Prescriptions.Dosage`
from hospital_data
WHERE `Prescriptions.PrescriptionID` IS NOT NULL
AND `Prescriptions.PrescriptionID` <> ''

select * from prescription

-- Bill table
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'Bills.%'

INSERT INTO bill (amount,appointmentid,billdate,BillID,paid)
select`Bills.Amount`,`Bills.AppointmentID`,`Bills.BillDate`,`Bills.BillID`,`Bills.Paid`from hospital_data
WHERE `Bills.BillID` IS NOT NULL
AND `Bills.BillID` <> ''

select * from bill

-- Lab reports table
select concat('select',group_concat(concat('`',column_name,'`')), 'from hospital_data')
from information_schema.columns
where table_schema='hospital_db'
and table_name='hospital_data'
and column_name like 'LabReports.%'

INSERT INTO labrep (appointmentid,createdAt,reportdata,LabrepID)
select`LabReports.AppointmentID`,`LabReports.CreatedAt`,`LabReports.ReportData`,`LabReports.ReportID`from hospital_data
WHERE `LabReports.ReportID` IS NOT NULL
AND `LabReports.ReportID` <> ''

select * from labrep

-- Problem 4: Appointment scheduling
-- We need two business rules:
-- 1. Appointments cannot be scheduled in the past.
-- 2. A doctor cannot have overlapping appointments.
-- We can implement these through database-side validation using triggers and transactions.
-- An important industry consideration: a simple trigger checking whether an appointment exists is not enough 
--  to prevent simultaneous booking requests.
--  We must also handle concurrent transactions safely.

DELIMITER $$

DROP TRIGGER IF EXISTS chk_new_appointment$$
CREATE TRIGGER chk_new_appointment
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN

    -- Rule 1: Prevent past appointments
    IF NEW.appointmenttime < NOW() THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appointment cannot be in the past';

    END IF;


    -- Rule 2: Prevent double booking
    IF EXISTS (
        SELECT *
        FROM appointments
        WHERE doctorid = NEW.doctorid
        AND appointmenttime = NEW.appointmenttime
        AND status in('Scheduled')
    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Doctor already has an appointment at this time';

    END IF;

END $$

DELIMITER ;

INSERT INTO appointments
(appointmentID, patientid, doctorid, appointmenttime, status)
VALUES
(1003, 1, 1, '2025-01-01 10:00:00', 'Scheduled');

INSERT INTO appointments
(appointmentID, patientid, doctorid, appointmenttime, status)
VALUES
(1055, 2, 1, '2024-06-10 06:39:00', 'Scheduled');

SELECT * FROM appointments;

-- Problem 5: Role-based access
-- We will implement different permissions.
-- Role	Access
-- Senior Doctor	All patients belonging to their department
-- Doctor	Only their assigned patients
-- Billing Staff	Billing-related information
-- Lab Staff	Laboratory-related information
-- Admin	Authorized administrative access

-- We can use:
-- - Database roles and privileges.
-- - Views to restrict patient information.
-- - Stored procedures for controlled access.
-- - Authentication through hospital-approved credentials.
-- Important: Hiding records through a normal view alone is not sufficient 
-- if doctors can directly query the underlying tables. We must also restrict their underlying table permissions.
DROP PROCEDURE IF EXISTS view_doctor_data;
DELIMITER $$

CREATE PROCEDURE view_doctor_data(
    IN input_username VARCHAR(100),
    IN input_pass VARCHAR(100)
)

BEGIN

    DECLARE doc_role VARCHAR(100);
    DECLARE doc_dept INT;
    DECLARE doc_id INT;

    -- Step 1: Check doctor credentials

    SET doc_id = NULL;

    SELECT doctor_id
    INTO doc_id
    FROM doctor_credentials
    WHERE user_name = input_username
    AND password = input_pass
    LIMIT 1;

    -- Step 2: Validate credentials

    IF doc_id IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid username or password';

    END IF;

    -- Step 3: Get doctor role and department

    SELECT role, departmentid
    INTO doc_role, doc_dept
    FROM doctors
    WHERE doctorID = doc_id;

    -- Step 4: Check doctor role

    IF doc_role = 'senior' THEN

        -- Senior doctor: View department patients

        SELECT
			d.doctorID,
            p.patientID,
            p.name,
            p.gender,
            a.appointmenttime,
            pr.medication,
            pr.dosage,
            lb.reportdata

        FROM patients p

        INNER JOIN appointments a
            ON a.patientid = p.patientID

        INNER JOIN doctors d
            ON d.doctorID = a.doctorid

        LEFT JOIN prescription pr
            ON a.appointmentID = pr.appointmentid

        LEFT JOIN labrep lb
            ON a.appointmentID = lb.appointmentid

        WHERE d.departmentid = doc_dept;

    ELSE

        -- Regular doctor: View assigned patients

        SELECT
			a.doctorid,
            p.patientID,
            p.name,
            p.gender,
            a.appointmenttime,
            pr.medication,
            pr.dosage,
            lb.reportdata

        FROM patients p

        INNER JOIN appointments a
            ON a.patientid = p.patientID

        LEFT JOIN prescription pr
            ON a.appointmentID = pr.appointmentid

        LEFT JOIN labrep lb
            ON a.appointmentID = lb.appointmentid

        WHERE a.doctorid = doc_id;

    END IF;

END $$

DELIMITER ;

CALL view_doctor_data('doctor1', 'W3jzIANG');
CALL view_doctor_data('doctor4', 'ic0pFSn0');

-- Problem 6: Department-wise monthly revenue
-- For example, management wants to know how much revenue each department generated every month.

DROP PROCEDURE IF EXISTS monthly_revenue;

DELIMITER $$

CREATE PROCEDURE monthly_revenue(
    IN p_year INT,
    IN p_month INT
)
BEGIN

    SELECT
        de.name AS Department,
        SUM(b.amount) AS total_revenue

    FROM bill AS b

    INNER JOIN appointments AS a
        ON a.appointmentid = b.appointmentid

    INNER JOIN doctors AS d
        ON a.doctorid = d.doctorid

    INNER JOIN departments AS de
        ON de.departmentid = d.departmentid

    WHERE MONTH(b.billdate) = p_month
      AND YEAR(b.billdate) = p_year

    GROUP BY de.departmentid, de.name;

END $$

DELIMITER ;

CALL monthly_revenue(2025, 1);
CALL monthly_revenue(2025, 2);





























