-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2024 at 01:13 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `carsdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `branchid` varchar(20) NOT NULL,
  `city` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`branchid`, `city`, `address`, `phone_number`) VALUES
('ATH001', 'ATHENS', 'Kifisou 34, Maroussi', '2100009001');

-- --------------------------------------------------------

--
-- Table structure for table `car`
--

CREATE TABLE `car` (
  `type` varchar(50) NOT NULL,
  `number_of_seats` int(11) NOT NULL,
  `number_of_doors` int(11) NOT NULL,
  `conventionality` double NOT NULL,
  `gasoline_powered` double NOT NULL,
  `diesel_powered` double NOT NULL,
  `electric` double NOT NULL,
  `hybrid` double NOT NULL,
  `rental_price_per_day` decimal(10,2) NOT NULL,
  `carid` varchar(17) NOT NULL,
  `branch_branchid` varchar(20) NOT NULL,
  `availability` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `car`
--

INSERT INTO `car` (`type`, `number_of_seats`, `number_of_doors`, `conventionality`, `gasoline_powered`, `diesel_powered`, `electric`, `hybrid`, `rental_price_per_day`, `carid`, `branch_branchid`, `availability`) VALUES
('mid', 4, 4, 1, 1, 0, 0, 0, 15.00, 'toyota', 'keratsini', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `license_number` varchar(50) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `mobile_number` varchar(20) NOT NULL,
  `customerid` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`first_name`, `last_name`, `email`, `license_number`, `phone_number`, `mobile_number`, `customerid`) VALUES
('mia', 'papa', 'miapapa@gmail.com', '23456', '2104329268', '6930974526', 'CU01'),
('vasilis', 'gionis', 'vasgio@gmail.com', '12345', '6930909090', '210232323233', 'CU02');

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `pickup_location` varchar(15) NOT NULL,
  `pickup_date` date NOT NULL,
  `pickup_time` time NOT NULL,
  `return_location` varchar(15) DEFAULT NULL,
  `return_date` date NOT NULL,
  `return_time` time NOT NULL,
  `car_type` varchar(50) DEFAULT NULL,
  `costumer_email` varchar(100) NOT NULL,
  `costumer_license_number` varchar(100) NOT NULL,
  `costumer_mobile_number` varchar(30) NOT NULL,
  `costumer_phone_number` varchar(30) NOT NULL,
  `reservationid` varchar(20) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `customer_customerid` varchar(20) NOT NULL,
  `car_carid2` varchar(17) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`pickup_location`, `pickup_date`, `pickup_time`, `return_location`, `return_date`, `return_time`, `car_type`, `costumer_email`, `costumer_license_number`, `costumer_mobile_number`, `costumer_phone_number`, `reservationid`, `total_price`, `customer_customerid`, `car_carid2`) VALUES
('a', '2024-01-01', '10:00:00', 'b', '2024-01-02', '10:00:00', 'mid', 'miapapa@gmail.com', '23456', '6930974526', '2104329268', 'i3', 15.00, 'CU01', 'toyota');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`branchid`);

--
-- Indexes for table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`carid`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reservationid`),
  ADD UNIQUE KEY `renting_car__idx` (`costumer_email`,`costumer_license_number`,`costumer_mobile_number`,`costumer_phone_number`),
  ADD KEY `reservation_car_fk` (`car_carid2`),
  ADD KEY `reservation_customer_fk` (`customer_customerid`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `branch`
--
ALTER TABLE `branch`
  ADD CONSTRAINT `fk_car_branch` FOREIGN KEY (`branchid`) REFERENCES `car` (`branch_branchid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_car_fk` FOREIGN KEY (`car_carid2`) REFERENCES `car` (`carid`),
  ADD CONSTRAINT `reservation_customer_fk` FOREIGN KEY (`customer_customerid`) REFERENCES `customer` (`customerid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
