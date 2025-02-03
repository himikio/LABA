-- �������� ������� "���_�����"
CREATE TABLE ���_����� (
    id_����_����� INT PRIMARY KEY IDENTITY(1,1),
    ��������_����_����� NVARCHAR(100) NOT NULL
);

-- �������� ������� "�����_����������"
CREATE TABLE �����_���������� (
    id_�����_���������� INT PRIMARY KEY IDENTITY(1,1),
    ������ NVARCHAR(100) NOT NULL,
    ����� NVARCHAR(100) NOT NULL,
    ����� NVARCHAR(255) NOT NULL,
    ����������_������� DECIMAL(10, 2) NOT NULL,
    ���_��_���������� INT NOT NULL
);

-- �������� ������� "�����"
CREATE TABLE ����� (
    id_����� INT PRIMARY KEY IDENTITY(1,1),
    �����_����� NVARCHAR(50) NOT NULL,
    id_�����_���������� INT FOREIGN KEY REFERENCES �����_����������(id_�����_����������),
    id_����_����� INT FOREIGN KEY REFERENCES ���_�����(id_����_�����),
    ���_��_��� INT NOT NULL,
    ���_��_������� INT NOT NULL,
    ���_��_���������� INT NOT NULL
);

-- �������� ������� "�������"
CREATE TABLE ������� (
    id_������� INT PRIMARY KEY IDENTITY(1,1),
    ��������_������� NVARCHAR(100) NOT NULL,
    id_����� INT FOREIGN KEY REFERENCES �����(id_�����),
    �������������� NVARCHAR(MAX)
);

-- �������� ������� "����������"
CREATE TABLE ���������� (
    id_���������� INT PRIMARY KEY IDENTITY(1,1),
    ��������_���������� NVARCHAR(100) NOT NULL,
    id_����� INT FOREIGN KEY REFERENCES �����(id_�����),
    �������������� NVARCHAR(MAX)
);

-- �������� ������� "����"
CREATE TABLE ���� (
    id_���� INT PRIMARY KEY IDENTITY(1,1),
    �����_���� NVARCHAR(50) NOT NULL,
    id_����� INT FOREIGN KEY REFERENCES �����(id_�����)
);

-- �������� ������� "������_������"
CREATE TABLE ������_������ (
    id_�������_������� INT PRIMARY KEY IDENTITY(1,1),
    ������� NVARCHAR(100) NOT NULL,
    ��� NVARCHAR(100) NOT NULL,
    �������� NVARCHAR(100),
    ������ NVARCHAR(50),
    id_���� INT FOREIGN KEY REFERENCES ����(id_����)
);

-- ������������ � ���� ������ master
USE master;
GO

-- �������� ������ ������� � ��������� �����
CREATE SERVER AUDIT ServerAudit
TO FILE (FILEPATH = 'C:\log')
WITH (ON_FAILURE = CONTINUE); -- ���������� ������ ��� �������

-- ��������� ������
ALTER SERVER AUDIT ServerAudit
WITH (STATE = ON);
GO

-- �������� ������������ ������ �������
CREATE SERVER AUDIT SPECIFICATION ServerAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (FAILED_LOGIN_GROUP),
ADD (BACKUP_RESTORE_GROUP),
ADD (DATABASE_CHANGE_GROUP)
WITH (STATE = ON)

-- �������� ������������ ������ ���� ������
CREATE DATABASE AUDIT SPECIFICATION DatabaseAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (INSERT, UPDATE, DELETE ON ������_������ BY public)
WITH (STATE = ON);
GO

-- �������� ������� ������
SELECT *FROM sys.fn_get_audit_file('C:\log\*.sqlaudit', DEFAULT, DEFAULT);