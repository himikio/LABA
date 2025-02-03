-- —оздание таблицы "вид_войск"
CREATE TABLE вид_войск (
    id_вида_войск INT PRIMARY KEY IDENTITY(1,1),
    название_вида_войск NVARCHAR(100) NOT NULL
);

-- —оздание таблицы "места_дислокации"
CREATE TABLE места_дислокации (
    id_места_дислокации INT PRIMARY KEY IDENTITY(1,1),
    страна NVARCHAR(100) NOT NULL,
    город NVARCHAR(100) NOT NULL,
    адрес NVARCHAR(255) NOT NULL,
    занимаема€_площадь DECIMAL(10, 2) NOT NULL,
    кол_во_сооружений INT NOT NULL
);

-- —оздание таблицы "части"
CREATE TABLE части (
    id_части INT PRIMARY KEY IDENTITY(1,1),
    номер_части NVARCHAR(50) NOT NULL,
    id_места_дислокации INT FOREIGN KEY REFERENCES места_дислокации(id_места_дислокации),
    id_вида_войск INT FOREIGN KEY REFERENCES вид_войск(id_вида_войск),
    кол_во_рот INT NOT NULL,
    кол_во_техники INT NOT NULL,
    кол_во_вооружений INT NOT NULL
);

-- —оздание таблицы "техника"
CREATE TABLE техника (
    id_техники INT PRIMARY KEY IDENTITY(1,1),
    название_техники NVARCHAR(100) NOT NULL,
    id_части INT FOREIGN KEY REFERENCES части(id_части),
    характеристики NVARCHAR(MAX)
);

-- —оздание таблицы "вооружени€"
CREATE TABLE вооружени€ (
    id_вооружени€ INT PRIMARY KEY IDENTITY(1,1),
    название_вооружени€ NVARCHAR(100) NOT NULL,
    id_части INT FOREIGN KEY REFERENCES части(id_части),
    характеристики NVARCHAR(MAX)
);

-- —оздание таблицы "роты"
CREATE TABLE роты (
    id_роты INT PRIMARY KEY IDENTITY(1,1),
    номер_роты NVARCHAR(50) NOT NULL,
    id_части INT FOREIGN KEY REFERENCES части(id_части)
);

-- —оздание таблицы "личный_состав"
CREATE TABLE личный_состав (
    id_личного_состава INT PRIMARY KEY IDENTITY(1,1),
    фамили€ NVARCHAR(100) NOT NULL,
    им€ NVARCHAR(100) NOT NULL,
    отчество NVARCHAR(100),
    звание NVARCHAR(50),
    id_роты INT FOREIGN KEY REFERENCES роты(id_роты)
);

-- ѕереключение в базу данных master
USE master;
GO

-- —оздание аудита сервера с указанным путем
CREATE SERVER AUDIT ServerAudit
TO FILE (FILEPATH = 'C:\log')
WITH (ON_FAILURE = CONTINUE); -- ѕродолжать работу при ошибках

-- ¬ключение аудита
ALTER SERVER AUDIT ServerAudit
WITH (STATE = ON);
GO

-- —оздание спецификации аудита сервера
CREATE SERVER AUDIT SPECIFICATION ServerAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (FAILED_LOGIN_GROUP),
ADD (BACKUP_RESTORE_GROUP),
ADD (DATABASE_CHANGE_GROUP)
WITH (STATE = ON)

-- —оздание спецификации аудита базы данных
CREATE DATABASE AUDIT SPECIFICATION DatabaseAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (INSERT, UPDATE, DELETE ON личный_состав BY public)
WITH (STATE = ON);
GO

-- ѕросмотр записей аудита
SELECT *FROM sys.fn_get_audit_file('C:\log\*.sqlaudit', DEFAULT, DEFAULT);