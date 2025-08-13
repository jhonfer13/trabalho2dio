-- =========================================
-- Banco de dados Oficina Mecânica
-- =========================================
CREATE DATABASE IF NOT EXISTS oficina;
USE oficina;

-- =========================
-- Tabela Clientes
-- =========================
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    CPF CHAR(11),
    CNPJ CHAR(15),
    Address VARCHAR(255),
    CONSTRAINT unique_CPF_client UNIQUE (CPF),
    CONSTRAINT unique_CNPJ_client UNIQUE (CNPJ),
    CONSTRAINT chk_client_type CHECK (
        (CPF IS NOT NULL AND CNPJ IS NULL) OR
        (CPF IS NULL AND CNPJ IS NOT NULL)
    )
);

-- =========================
-- Tabela Veículos
-- =========================
CREATE TABLE vehicles (
    idVehicle INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    Plate VARCHAR(10) NOT NULL,
    Model VARCHAR(50),
    Year INT,
    Color VARCHAR(20),
    CONSTRAINT fk_vehicle_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

-- =========================
-- Tabela Equipes
-- =========================
CREATE TABLE teams (
    idTeam INT AUTO_INCREMENT PRIMARY KEY,
    TeamName VARCHAR(50) NOT NULL
);

-- =========================
-- Tabela Mecânicos
-- =========================
CREATE TABLE mechanics (
    idMechanic INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(255),
    Specialty VARCHAR(50),
    idTeam INT,
    CONSTRAINT fk_mechanic_team FOREIGN KEY (idTeam) REFERENCES teams(idTeam)
);

-- =========================
-- Tabela Serviços
-- =========================
CREATE TABLE services (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL,
    LaborCost FLOAT NOT NULL
);

-- =========================
-- Tabela Peças
-- =========================
CREATE TABLE parts (
    idPart INT AUTO_INCREMENT PRIMARY KEY,
    PartName VARCHAR(100) NOT NULL,
    PartCost FLOAT NOT NULL
);

-- =========================
-- Tabela Ordens de Serviço (OS)
-- =========================
CREATE TABLE orders (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    idVehicle INT NOT NULL,
    idTeam INT NOT NULL,
    IssueDate DATE NOT NULL,
    DeliveryDate DATE,
    Status ENUM('Aberta','Em andamento','Concluída','Cancelada') DEFAULT 'Aberta',
    TotalValue FLOAT DEFAULT 0,
    CONSTRAINT fk_order_vehicle FOREIGN KEY (idVehicle) REFERENCES vehicles(idVehicle),
    CONSTRAINT fk_order_team FOREIGN KEY (idTeam) REFERENCES teams(idTeam)
);

-- =========================
-- Tabela OS-Serviço (Muitos para Muitos)
-- =========================
CREATE TABLE orderService (
    idOS INT NOT NULL,
    idService INT NOT NULL,
    Quantity INT DEFAULT 1,
    PRIMARY KEY (idOS, idService),
    CONSTRAINT fk_os_service_order FOREIGN KEY (idOS) REFERENCES orders(idOS),
    CONSTRAINT fk_os_service_service FOREIGN KEY (idService) REFERENCES services(idService)
);

-- =========================
-- Tabela OS-Peça (Muitos para Muitos)
-- =========================
CREATE TABLE orderPart (
    idOS INT NOT NULL,
    idPart INT NOT NULL,
    Quantity INT DEFAULT 1,
    PRIMARY KEY (idOS, idPart),
    CONSTRAINT fk_os_part_order FOREIGN KEY (idOS) REFERENCES orders(idOS),
    CONSTRAINT fk_os_part_part FOREIGN KEY (idPart) REFERENCES parts(idPart)
);

-- =========================
-- Mostrar todas as tabelas
-- =========================
SHOW TABLES;
