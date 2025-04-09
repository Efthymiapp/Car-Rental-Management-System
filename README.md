# 🚗 Car Rental System – Java & Database Project
This project was developed as part of my studies at the Department of Digital Systems, University of Piraeus. It involves designing and implementing a Car Rental System using Entity-Relationship modeling, relational database design, and a Java-based CLI application.

## 📌 Project Description
A car rental company operates a network of branches across various cities in Greece. Each branch offers passenger cars for rent. For each car, the following details are recorded:

- Type (e.g., small, medium, large)

- Number of seats

- Number of doors

- Whether it is automatic or manual

- Fuel type (petrol, diesel, electric, hybrid)

- Rental price per day

- A customer wishing to rent a car provides the following details:

- Pickup location (city and service point)

- Pickup date and time

- Return location (if different from the pickup location)

- Return date and time

- Desired car type (optional)

Once the customer selects a car from the list of available options, the system displays:

- All reservation details

- Total rental cost for the requested period

With the customer’s approval, the system proceeds to finalize the booking by entering:

- First name and last name

- Email address

- Driver’s license number

- Phone numbers (mobile and landline)

## 📊 Deliverables
1. Entity-Relationship Model (ERD)
Design an Entity-Relationship Model (ERM) to represent the system's data and workflow.

Convert the ERM into a Relational Model.

2. Database and Java Application
Implement the Relational Database.

Develop a Java application (CLI-based, no graphical interface required).

## The application includes a basic menu-driven interface and supports the following operations:

1. ✅ Insert & Update Operations
Add or update:

- Cars

- Customers

- Car rentals

2. 🔍 Query Operations
- Retrieve the list of all cars per branch, regardless of availability.

- Retrieve the list of cars currently rented from a specific branch.

Retrieve available cars based on customer input:

- Pickup location and time

- Return location and time

- Optional car type

3. 📄 Booking Execution
Perform and register car rental bookings in the system.

4. 🗑️ Deletion
Delete cars that are no longer available for rental due to retirement from the fleet.

5. 🛠️ Technologies Used
- Java (Console Application)

- MySQL or PostgreSQL (Relational Database)

- JDBC (Java Database Connectivity)
