import java.sql.*;
import java.util.Scanner;

public class carAppDB {

    public static void main(String[] args) {
        try (Connection conn = dbInterface.connect();
             Scanner sc = new Scanner(System.in)) {

            int choice;
            do {
                choice = printMenu(sc);
                switch (choice) {
                    case 1:
                        insertCar(conn, sc);
                        break;
                    case 2:
                        updateCar(conn, sc);
                        break;
                    case 3:
                        insertCustomer(conn, sc);
                        break;
                    case 4:
                        updateCustomer(conn, sc);
                        break;
                    case 5:
                        insertReservation(conn, sc);
                        break;
                    case 6:
                        updateReservation(conn, sc);
                        break;
                    case 7:
                        retrieveCarsByBranch(conn, sc);
                        break;
                    case 8:
                        retrieveRentedCarsByStore(conn, sc);
                        break;
                    case 9:
                        retrieveAvailableCarsByCriteria(conn, sc);
                        break;
                    case 10:
                        deleteCar(conn, sc);
                        break;
                    case 11:
                    	getReciept(conn, sc);
                    	break;
                    case 12:
                        System.out.println("Exiting...");
                        break;

                    default:
                        System.out.println("Invalid choice. Please try again.");
                }
            } while (choice != 12);
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
        }
    }

    private static int printMenu(Scanner sc) {//εδω ειναι το μενου μας το οποιο οπαρουσιαζει καθε δυνατη επιλογη στον χρηστη, εκ των οποιων οι περισσοτερες λειτουργιες εμφανιζονται στον τιτλο τους 
    	
        int choice;
        do {
            System.out.print("\nWelcome to the main menu!\n" +
                    "[1] Insert car\n" +
                    "[2] Update car\n" +
                    "[3] Insert customer\n" +
                    "[4] Update customer\n" +
                    "[5] Insert reservation\n" +
                    "[6] Update reservation\n" +
                    "[7] Retrieve cars by store\n" +
                    "[8] Retrieve rented cars by store\n" +
                    "[9] Retrieve available cars by criteria\n" +
                    "[10] Delete car\n" +
                    "[11] Get Reciept for reservation\n" +
                    "[12] Exit\n" +
                    "Enter your choice:\n");
            while (!sc.hasNextInt()) {
                System.out.print("Invalid input. Please enter a number between 1 and 11: ");
                sc.next();
            }
            choice = sc.nextInt();
        } while (choice < 1 || choice > 12);
        sc.nextLine(); // consume newline
        return choice;
    }

    private static void insertCar(Connection conn, Scanner sc) {//εδω γινονται οι απαραιτητοι ελεγχοι και εισχωρησεις τιμων στο querry car οταν παταμε την εντολη inster car 
        try {
  
            System.out.print("Enter car type (small/mid/big): ");
            String type = getValidatedCarType(sc);

            System.out.print("Enter number of seats: ");
            int numberOfSeats = getIntInput(sc);

            System.out.print("Enter number of doors: ");
            int numberOfDoors = getIntInput(sc);

            System.out.print("Enter conventionality (true/false): ");
            boolean conventionality = getValidatedBooleanInput(sc);

            System.out.print("Enter gasoline powered (true/false): ");
            boolean gasolinePowered = getValidatedBooleanInput(sc);

            System.out.print("Enter diesel powered (true/false): ");
            boolean dieselPowered = getValidatedBooleanInput(sc);

            System.out.print("Enter electric (true/false): ");
            boolean electric = getValidatedBooleanInput(sc);

            System.out.print("Enter hybrid (true/false): ");
            boolean hybrid = getValidatedBooleanInput(sc);

            System.out.print("Enter rental price per day: ");
            double rentalPricePerDay = getDoubleInput(sc);
            
            System.out.print("Enter car ID: ");
            String carID = sc.nextLine().trim();
            while (carID.isEmpty()) {
                System.out.print("Car ID cannot be empty. Enter car ID: ");
                carID = sc.nextLine().trim();
            }
  
            System.out.print("Enter branch ID: ");
            String branchID = sc.nextLine().trim();
            while (branchID.isEmpty()) {
                System.out.print("Branch ID cannot be empty. Enter branch ID: ");
                branchID = sc.nextLine().trim();
            }
           boolean isitavailable=true;
            String query = "INSERT INTO Car (type, number_of_seats, number_of_doors, conventionality, gasoline_powered, diesel_powered, electric, hybrid, rental_price_per_day, carID,  branch_branchid, availability) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
   
            pstmt.setString(1, type);
            pstmt.setInt(2, numberOfSeats);
            pstmt.setInt(3, numberOfDoors);
            pstmt.setBoolean(4, conventionality);
            pstmt.setBoolean(5, gasolinePowered);
            pstmt.setBoolean(6, dieselPowered);
            pstmt.setBoolean(7, electric);
            pstmt.setBoolean(8, hybrid);
            pstmt.setDouble(9, rentalPricePerDay);
            pstmt.setString(10, carID);
            pstmt.setString(11, branchID);
            pstmt.setBoolean(12, isitavailable);
            
            pstmt.executeUpdate();
            System.out.println("Car inserted successfully.");
        } catch (SQLException e) {
            System.out.println("Error inserting car: " + e.getMessage());
        }
    }

    private static void updateCar(Connection conn, Scanner sc) {//εδω περα ενημερωνουμε το car λιγο πολυ με τον ιδιο τροπο που το εισχωρουμε (ο ιδιος τροπος θα χερησιμοποιηθει και στον customer και στο reservation)
        try {
        	
            System.out.print("Enter car ID to update: ");
            String carID = sc.nextLine();
           
            	if (!isCarIdValid(conn, carID)) { 
                System.out.println("Car ID not found. Available cars for update:\n");
                retrieveAllCars(conn);
            	}
            	
            System.out.print("Enter new branch ID: ");
            String branchID = sc.nextLine();

            System.out.print("Enter new car type (small/mid/big): ");
            String type = getValidatedCarType(sc);

            System.out.print("Enter new number of seats: ");
            int numberOfSeats = getIntInput(sc);

            System.out.print("Enter new number of doors: ");
            int numberOfDoors = getIntInput(sc);

            System.out.print("Enter new conventionality (true/false): ");
            boolean conventionality = getValidatedBooleanInput(sc);

            System.out.print("Enter new gasoline powered (true/false): ");
            boolean gasolinePowered = getValidatedBooleanInput(sc);

            System.out.print("Enter new diesel powered (true/false): ");
            boolean dieselPowered = getValidatedBooleanInput(sc);

            System.out.print("Enter new electric (true/false): ");
            boolean electric = getValidatedBooleanInput(sc);

            System.out.print("Enter new hybrid (true/false): ");
            boolean hybrid = getValidatedBooleanInput(sc);

            System.out.print("Enter new rental price per day: ");
            double rentalPricePerDay = getDoubleInput(sc);

            String query = "UPDATE Car SET branch_branchID = ?, type = ?, number_of_seats = ?, number_of_doors = ?, conventionality = ?, gasoline_powered = ?, diesel_powered = ?, electric = ?, hybrid = ?, rental_price_per_day = ? WHERE carID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, branchID);
            pstmt.setString(2, type);
            pstmt.setInt(3, numberOfSeats);
            pstmt.setInt(4, numberOfDoors);
            pstmt.setBoolean(5, conventionality);
            pstmt.setBoolean(6, gasolinePowered);
            pstmt.setBoolean(7, dieselPowered);
            pstmt.setBoolean(8, electric);
            pstmt.setBoolean(9, hybrid);
            pstmt.setDouble(10, rentalPricePerDay);
            pstmt.setString(11, carID);

            pstmt.executeUpdate();
            System.out.println("Car updated successfully.");
        } catch (SQLException e) {
            System.out.println("Error updating car: " + e.getMessage());
        }
    }

    private static void insertCustomer(Connection conn, Scanner sc) {//οπως και στο car ετσι και εδω δημιουργουμε νεο customer με τα απαραιτητα στοιχεια
        try {
            System.out.print("Enter customer ID: ");
            String customerID = sc.nextLine();

            System.out.print("Enter customer first name: ");
            String firstName = sc.nextLine();

            System.out.print("Enter customer last name: ");
            String lastName = sc.nextLine();

            System.out.print("Enter customer email: ");
            String email = sc.nextLine();

            System.out.print("Enter customer license number: ");
            String licenseNumber = sc.nextLine();

            System.out.print("Enter customer phone number: ");
            String phone = sc.nextLine();

            System.out.print("Enter customer mobile number: ");
            String mobile = sc.nextLine();

            String query = "INSERT INTO Customer (customerID, first_name, last_name, email, license_number, phone_number, mobile_number) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, customerID);
            pstmt.setString(2, firstName);
            pstmt.setString(3, lastName);
            pstmt.setString(4, email);
            pstmt.setString(5, licenseNumber);
            pstmt.setString(6, phone);
            pstmt.setString(7, mobile);

            pstmt.executeUpdate();
            System.out.println("Customer inserted successfully.");
        } catch (SQLException e) {
            System.out.println("Error inserting customer: " + e.getMessage());
        }
    }

    private static void updateCustomer(Connection conn, Scanner sc) {//εδω περα ενημερωνουμε το customer με τον ιδιο τροπο που ενημερωνουμε το car
        try {
            System.out.print("Enter customer ID to update: ");
            String customerID = sc.nextLine();

            if (!doesCustomerExist(conn, customerID)) {
                System.out.println("Customer ID not found.Available customers for update:\n ");
                retrieveAllCustomers(conn);
                return;
                }
            

            System.out.print("Enter new customer first name: ");
            String firstName = sc.nextLine();

            System.out.print("Enter new customer last name: ");
            String lastName = sc.nextLine();

            System.out.print("Enter new customer email: ");
            String email = sc.nextLine();

            System.out.print("Enter new customer license number: ");
            String licenseNumber = sc.nextLine();

            System.out.print("Enter new customer phone number: ");
            String phone = sc.nextLine();

            System.out.print("Enter new customer mobile number: ");
            String mobile = sc.nextLine();

            String query = "UPDATE Customer SET first_name = ?, last_name = ?, email = ?, license_number = ?, phone_number = ?, mobile_number = ? WHERE customerID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, licenseNumber);
            pstmt.setString(5, phone);
            pstmt.setString(6, mobile);
            pstmt.setString(7, customerID);

            pstmt.executeUpdate();
            System.out.println("Customer updated successfully.");
        } catch (SQLException e) {
            System.out.println("Error updating customer: " + e.getMessage());
        }
    }
    
    private static void insertReservation(Connection conn, Scanner sc) {//στο reservation κανουμε αρκετα πραγματα. 1ον θα παρουμε τα στοιχεια απο τον πελατη για τον οποιο γινεται το reservation και τα αποθηκευουμε για να τα βαλουμε στο reservation table, 
    																	//2ον το ιδιο κανουμε και για το αμαξι καθως με το price per day βγαζουμε εναν πολυ ωραιο αλγοριθμο ο οποιος υπολογιζει ακριβεστατα το ποσο κοστιζει καθολη την διαρκεια ενικοισης το αμαξι (υποθετουμε οτι ο χρονος εχει 12*31 μερες (ζουμε σε εναλλακτικη γη))
    																	//τελος εισαγουμε ολα τα απαραιτητα στοιχεια στο table και ενημερωνουμε την τιμη availability του car απο true σε false για να δηλωσουμε οτι το αμαξι ειναι πλεοπν ενοικιασμενο (σουπερ ντουπερ σος μεταβλητη που θα χρησιμοποιηθει και αργοτερα)
        try {
        	System.out.print("Enter reservation ID: ");
            String reservationID = sc.nextLine();
            String customerType;
            while (true) {
                System.out.println("Is this for an existing customer or a new customer? (existing/new)");
                customerType = sc.nextLine().toLowerCase();
                if (customerType.equals("existing") || customerType.equals("new")) {
                    break;
                } else {
                    System.out.println("Invalid input. Please enter 'existing' or 'new'.");
                }
            }
            String customerID;
            if (customerType.equals("existing")) {
                customerID = getExistingCustomerID(conn, sc);
            } else {
                customerID = insertNewCustomerAndGetID(conn, sc);
                
            }
            
            // Retrieve customer details
            String customerEmail=null;
            String customerLicenseNumber = null;
            String customerMobileNumber=null;
            String customerPhoneNumber=null;

        
            try (PreparedStatement customerStmt = conn.prepareStatement("SELECT email, license_number, mobile_number,  	phone_number, customerid FROM Customer WHERE customerid = ?")) {
                customerStmt.setString(1, customerID);
                try (ResultSet rs = customerStmt.executeQuery()) {
                    if (rs.next()) {
                    	customerEmail = rs.getString("email");
                    	customerLicenseNumber = rs.getString("license_number");
                    	customerMobileNumber = rs.getString("mobile_number");
                    	customerPhoneNumber = rs.getString("phone_number");

                    }
                }
            }

            System.out.print("Enter car ID: ");
            String carID = sc.nextLine().trim();

            if (!doesCarExist(conn, carID)) {
                System.out.println("Car ID not found. Here is a list of the available cars:\n");
                retrieveAllCars(conn);
                return;
            }

            // Retrieve car details
            String carType=null;
            String rentingCarID=null;
            double carprice = 0;
            try (PreparedStatement carStmt = conn.prepareStatement("SELECT carid,rental_price_per_day,type FROM Car WHERE carid = ?")) {
                carStmt.setString(1, carID);
                try (ResultSet rs = carStmt.executeQuery()) {
                    if (rs.next()) {
                        rentingCarID = rs.getString("carid");
                       carprice=rs.getDouble("rental_price_per_day");
                       carType=rs.getString("type");
                    }
                }
            }

            System.out.print("Enter pickup date (YYYY-MM-DD): ");
            String pickupDate = sc.nextLine();
            while (pickupDate.isEmpty()) {
                pickupDate = sc.nextLine().trim();
            }
           	System.out.print("Enter return date (YYYY-MM-DD): ");
        	String returnDate = sc.nextLine();
            while (returnDate.isEmpty()) {
                returnDate = sc.nextLine().trim();
            }
            double rentingprice = 0;
            boolean flagOfDate=true;
            while (flagOfDate==true) {//ελεγχος εγκυροτητας για να δουμε αν οι ημερομηνιες του return date δεν ειναι πριν το pickupdate γιατι δεν μπορουμε να επιστρεωουμε καποιο αμαξι στο παρελθον (εκτος και αν ειναι delorean) 
            	String[] parts = pickupDate.split("-");
            	int pickupYear = Integer.parseInt(parts[0]);
            	int pickupMonth = Integer.parseInt(parts[1]);
            	int pickupDay = Integer.parseInt(parts[2]);
            
            	String[] returnparts = returnDate.split("-");
            	int returnYear = Integer.parseInt(returnparts[0]);
            	int returnMonth = Integer.parseInt(returnparts[1]);
            	int returnDay = Integer.parseInt(returnparts[2]);
            	
            	if ((pickupYear > returnYear) || (((pickupYear<=returnYear) && (pickupMonth>returnMonth)) || ((pickupYear==returnYear) && (pickupMonth<=returnMonth)&&(pickupDay>returnDay)))||(returnMonth>12 || pickupMonth>12)||(returnDay>31 || pickupDay>31) || (returnYear<2024 || pickupYear<2024)){
            		System.out.print("Invalid date, pick up date can't be after the date of return \n");
                    System.out.print("Enter new pickup date (YYYY-MM-DD): ");
                    pickupDate = sc.nextLine().trim();
                   	System.out.print("Enter new return date (YYYY-MM-DD): ");
                	returnDate = sc.nextLine();
            	}else{
            		if(returnYear>pickupYear) {
            			int daysRemainingAfterPickUpYear=((12-pickupMonth)*31)+(31-pickupDay);
            			if((pickupYear+1)==returnYear) {
            				rentingprice=(daysRemainingAfterPickUpYear+(returnMonth*31)+returnDay)*carprice;
            			}else {
            				rentingprice=((daysRemainingAfterPickUpYear)+(returnYear-(pickupYear+1)*12*31)+returnMonth*31+returnDay)*carprice;
            			}
          
            		}else {
            			rentingprice=((returnMonth-pickupMonth)*31+(returnDay-pickupDay))*carprice;
            		}
            
            		flagOfDate=false;
            	}
            	
            }
            
            System.out.print("Enter pickup time (HH:MM:SS): ");
            String pickupTime = sc.nextLine();

            System.out.print("Enter return time (HH:MM:SS): ");
            String returnTime = sc.nextLine();

            System.out.print("Enter pickup location: ");
            String pickupLocation = sc.nextLine();

            System.out.print("Enter return location: ");
            String returnLocation = sc.nextLine();
            

            String query = "INSERT INTO Reservation (reservationid, customer_customerid, car_carid2, pickup_date, return_date, pickup_time, return_time, pickup_location, return_location, car_type, costumer_license_number,costumer_email,costumer_mobile_number,costumer_phone_number,total_price) VALUES (?,?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, reservationID);
            pstmt.setString(2, customerID);
            pstmt.setString(3, carID);
            pstmt.setString(4, pickupDate);
            pstmt.setString(5, returnDate);
            pstmt.setString(6, pickupTime);
            pstmt.setString(7, returnTime);
            pstmt.setString(8, pickupLocation);
            pstmt.setString(9, returnLocation);
            pstmt.setString(10, carType);
			pstmt.setString(11, customerLicenseNumber);
			pstmt.setString(12, customerEmail);
			pstmt.setString(13,customerMobileNumber);
			pstmt.setString(14, customerPhoneNumber);
			pstmt.setDouble(15, rentingprice);
  

            pstmt.executeUpdate();
            String updateCarQuery = "UPDATE car SET availability = false WHERE carid = ?";
            PreparedStatement updateCarStmt = conn.prepareStatement(updateCarQuery);
            updateCarStmt.setString(1, carID);
            updateCarStmt.executeUpdate();
            System.out.println("Reservation inserted successfully.");
            

        } catch (SQLException e) {
            System.out.println("Error inserting reservation: " + e.getMessage());
        }
    }

    private static String getExistingCustomerID(Connection conn, Scanner sc) {//μεθοδος που χρησιμοποιειται για να παρουμε το id υπαρχον πελατη για ελεγχους
        while (true) {
            System.out.print("Enter customer ID: ");
            String customerID = sc.nextLine();
            if (isCustomerIdValid(conn, customerID)) {
                return customerID;
            } else {
                System.out.println("Invalid customer ID. Here is a list of the existing customers:\n");
                retrieveAllCustomers(conn);
            }
        }
    }

    private static boolean isCustomerIdValid(Connection conn, String customerID) {//μεθοδος επαληθευσης ενος πελατη 
        try {
            String query = "SELECT COUNT(*) FROM Customer WHERE customerID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, customerID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error validating customer ID: " + e.getMessage());
        }
        return false;
    }
    
    private static String insertNewCustomerAndGetID(Connection conn, Scanner sc) {//εδω εχουμε μια method η οποια την χρησιμοποιουμε στο reservation για να εισαγουμε on the spot νεο πελατη αμα δεν υπαρχει και να παρουμε το id του 
        try {
        	 System.out.print("Enter customer ID: ");
             String customerID = sc.nextLine();

             System.out.print("Enter customer first name: ");
             String firstName = sc.nextLine();

             System.out.print("Enter customer last name: ");
             String lastName = sc.nextLine();

             System.out.print("Enter customer email: ");
             String email = sc.nextLine();

             System.out.print("Enter customer license number: ");
             String licenseNumber = sc.nextLine();

             System.out.print("Enter customer phone number: ");
             String phone = sc.nextLine();

             System.out.print("Enter customer mobile number: ");
             String mobile = sc.nextLine();

             String query = "INSERT INTO Customer (customerID, first_name, last_name, license_number, email, phone_number, mobile_number) VALUES (?, ?, ?, ?, ?, ?, ?)";
             PreparedStatement pstmt = conn.prepareStatement(query);
             pstmt.setString(1, customerID);
             pstmt.setString(2, firstName);
             pstmt.setString(3, lastName);
             pstmt.setString(4, email);
             pstmt.setString(5, licenseNumber);
             pstmt.setString(6, phone);
             pstmt.setString(7, mobile);

             pstmt.executeUpdate();
             System.out.println("Customer inserted successfully.");
         } catch (SQLException e) {
             System.out.println("Error inserting customer: " + e.getMessage());
         }return null;
    }

    private static void updateReservation(Connection conn, Scanner sc) {//με τον ιδιο τροπο απλα βαζουμε μεσα και την ενημερωση του availability του αμαξιου αμα επιλεξουμε νεο αμαξι και το ενημερωνουμε
        try {
            System.out.print("Enter reservation ID to update: ");
            String reservationID = sc.nextLine();

            if (!doesReservationExist(conn, reservationID)) {
                System.out.println("Reservation ID not found. Returning to main menu.");
                return;
            }
            
            String customerType;
            while (true) {
                System.out.println("Is this for an existing customer or a new customer? (existing/new)");
                customerType = sc.nextLine().toLowerCase();
                if (customerType.equals("existing") || customerType.equals("new")) {
                    break;
                } else {
                    System.out.println("Invalid input. Please enter 'existing' or 'new'.");
                }
            }
            String customerID;
            if (customerType.equals("existing")) {
                customerID = getExistingCustomerID(conn, sc);
            } else {
                customerID = insertNewCustomerAndGetID(conn, sc);
                
            }
            
            // Retrieve customer details
            String customerEmail=null;
            String customerLicenseNumber = null;
            String customerMobileNumber=null;
            String customerPhoneNumber=null;

        
            try (PreparedStatement customerStmt = conn.prepareStatement("SELECT email, license_number, mobile_number,  	phone_number, customerid FROM Customer WHERE customerid = ?")) {
                customerStmt.setString(1, customerID);
                try (ResultSet rs = customerStmt.executeQuery()) {
                    if (rs.next()) {
                    	customerEmail = rs.getString("email");
                    	customerLicenseNumber = rs.getString("license_number");
                    	customerMobileNumber = rs.getString("mobile_number");
                    	customerPhoneNumber = rs.getString("phone_number");

                    }
                }
            }

            System.out.print("Enter car ID: ");
            String carID = sc.nextLine().trim();

            if (!doesCarExist(conn, carID)) {
                System.out.println("Car ID not found. Here is a list of the available cars:\n");
                retrieveAllCars(conn);
                return;
            }
            

            // Retrieve car details
            String carType=null;
            String rentingCarID=null;
            double carprice = 0;
            try (PreparedStatement carStmt = conn.prepareStatement("SELECT carid,rental_price_per_day,type FROM Car WHERE carid = ?")) {
                carStmt.setString(1, carID);
                try (ResultSet rs = carStmt.executeQuery()) {
                    if (rs.next()) {
                        rentingCarID = rs.getString("carid");
                       carprice=rs.getDouble("rental_price_per_day");
                       carType=rs.getString("type");
                    }
                }
            }

            System.out.print("Enter pickup date (YYYY-MM-DD): ");
            String pickupDate = sc.nextLine();
            while (pickupDate.isEmpty()) {
                pickupDate = sc.nextLine().trim();
            }
           	System.out.print("Enter return date (YYYY-MM-DD): ");
        	String returnDate = sc.nextLine();
            while (returnDate.isEmpty()) {
                returnDate = sc.nextLine().trim();
            }
            double rentingprice = 0;
            boolean flagOfDate=true;
            while (flagOfDate==true) {//ελεγχος εγκυροτητας για να δουμε αν οι ημερομηνιες του return date δεν ειναι πριν το pickupdate γιατι δεν μπορουμε να επιστρεωουμε καποιο αμαξι στο παρελθον (εκτος και αν ειναι delorean) 
            	String[] parts = pickupDate.split("-");
            	int pickupYear = Integer.parseInt(parts[0]);
            	int pickupMonth = Integer.parseInt(parts[1]);
            	int pickupDay = Integer.parseInt(parts[2]);
            
            	String[] returnparts = returnDate.split("-");
            	int returnYear = Integer.parseInt(returnparts[0]);
            	int returnMonth = Integer.parseInt(returnparts[1]);
            	int returnDay = Integer.parseInt(returnparts[2]);
            	
            	if ((pickupYear > returnYear) || (((pickupYear<=returnYear) && (pickupMonth>returnMonth)) || ((pickupYear==returnYear) && (pickupMonth<=returnMonth)&&(pickupDay>returnDay)))||(returnMonth>12 || pickupMonth>12)||(returnDay>31 || pickupDay>31) || (returnYear<2024 || pickupYear<2024)){
            		System.out.print("Invalid date, pick up date can't be after the date of return \n");
                    System.out.print("Enter new pickup date (YYYY-MM-DD): ");
                    pickupDate = sc.nextLine().trim();
                   	System.out.print("Enter new return date (YYYY-MM-DD): ");
                	returnDate = sc.nextLine();
            	}else{
            		if(returnYear>pickupYear) {
            			int daysRemainingAfterPickUpYear=((12-pickupMonth)*31)+(31-pickupDay);
            			if((pickupYear+1)==returnYear) {
            				rentingprice=(daysRemainingAfterPickUpYear+(returnMonth*31)+returnDay)*carprice;
            			}else {
            				rentingprice=((daysRemainingAfterPickUpYear)+(returnYear-(pickupYear+1)*12*31)+returnMonth*31+returnDay)*carprice;
            			}
          
            		}else {
            			rentingprice=((returnMonth-pickupMonth)*31+(returnDay-pickupDay))*carprice;
            		}
            
            		flagOfDate=false;
            	}
            	
            }
            System.out.print("Enter pickup time (HH:MM:SS): ");
            String pickupTime = sc.nextLine();

            System.out.print("Enter return time (HH:MM:SS): ");
            String returnTime = sc.nextLine();

            System.out.print("Enter pickup location: ");
            String pickupLocation = sc.nextLine();

            System.out.print("Enter return location: ");
            String returnLocation = sc.nextLine();
            

            String query = "UPDATE Reservation SET customer_customerid=?, car_carid2=?, pickup_date=?, return_date=?, pickup_time=?, return_time=?, pickup_location=?, return_location=?, car_type=?, costumer_license_number=?, costumer_email=?, costumer_mobile_number=?, costumer_phone_number=?, total_price=? WHERE reservationid = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, customerID);
            pstmt.setString(2, carID);
            pstmt.setString(3, pickupDate);
            pstmt.setString(4, returnDate);
            pstmt.setString(5, pickupTime);
            pstmt.setString(6, returnTime);
            pstmt.setString(7, pickupLocation);
            pstmt.setString(8, returnLocation);
            pstmt.setString(9, carType);
			pstmt.setString(10, customerLicenseNumber);
			pstmt.setString(11, customerEmail);
			pstmt.setString(12,customerMobileNumber);
			pstmt.setString(13, customerPhoneNumber);
			pstmt.setDouble(14, rentingprice);
            pstmt.setString(15, reservationID);
            pstmt.executeUpdate();
            String updateCarQuery = "UPDATE car SET availability = false WHERE carid = ?";
            PreparedStatement updateCarStmt = conn.prepareStatement(updateCarQuery);
            updateCarStmt.setString(1, carID);
            updateCarStmt.executeUpdate();
            System.out.println("Reservation updated successfully.");
        } catch (SQLException e) {
            System.out.println("Error updating reservation: " + e.getMessage());
        }
    }

    private static void retrieveCarsByBranch(Connection conn, Scanner sc) {//εδω περα για καθε branchid που εχει καθε αμαξι εμφανιζει οσα αμαξια εχουν το ιδιο branchid ανεξαρτητως availability
        try {
            System.out.print("Enter branch ID: ");
            String branchID = sc.nextLine();

            String query = "SELECT * FROM Car WHERE branch_branchid = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, branchID);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                System.out.println("Car ID: " + rs.getString("carID"));
                System.out.println("Car Type: " + rs.getString("type"));
                System.out.println("Number of Seats: " + rs.getInt("number_of_seats"));
                System.out.println("Number of Doors: " + rs.getInt("number_of_doors"));
                System.out.println("Conventionality: " + rs.getBoolean("conventionality"));
                System.out.println("Gasoline Powered: " + rs.getBoolean("gasoline_powered"));
                System.out.println("Diesel Powered: " + rs.getBoolean("diesel_powered"));
                System.out.println("Electric: " + rs.getBoolean("electric"));
                System.out.println("Hybrid: " + rs.getBoolean("hybrid"));
                System.out.println("Rental Price per Day: " + rs.getDouble("rental_price_per_day"));
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving cars by store: " + e.getMessage());
        }
    }

    private static void retrieveRentedCarsByStore(Connection conn, Scanner sc) {//λιγο παρομοιως τροπος με το retrieveCarsByBRanch απλα εδω περα τσεκαρουμε και το availability των αμαξιων
        try {
            System.out.print("Enter store ID: ");
            String storeID = sc.nextLine();

            String query = "SELECT * FROM Car WHERE branch_branchid = ? AND carID IN (SELECT carID FROM Reservation WHERE availability=0)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, storeID);

            ResultSet rs = pstmt.executeQuery();
            System.out.println("The rented cars of the specific store are the following ones and cant be used at the moment:\n");
            while (rs.next()) {
                System.out.println("Car ID: " + rs.getString("carID"));
                System.out.println("Car Type: " + rs.getString("type"));
                System.out.println("Number of Seats: " + rs.getInt("number_of_seats"));
                System.out.println("Number of Doors: " + rs.getInt("number_of_doors"));
                System.out.println("Conventionality: " + rs.getBoolean("conventionality"));
                System.out.println("Gasoline Powered: " + rs.getBoolean("gasoline_powered"));
                System.out.println("Diesel Powered: " + rs.getBoolean("diesel_powered"));
                System.out.println("Electric: " + rs.getBoolean("electric"));
                System.out.println("Hybrid: " + rs.getBoolean("hybrid"));
                System.out.println("Rental Price per Day: " + rs.getDouble("rental_price_per_day"));
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving rented cars by store: " + e.getMessage());
        }
    }

    private static void retrieveAvailableCarsByCriteria(Connection conn, Scanner sc) {//ο χρηστης ζηταει να δει συγκεκριμενα αμαξια, με συγκεκριμενο τυπο, τιμη και την τοποθεσια απο την οποια θα ηθελε να το παραλαβει και το συστημα του δινει επιλογες συγκεκριμενες με αυτες που ζηταει 
        try {
            System.out.print("Enter car type (small/mid/big): ");
            String type = getValidatedCarType(sc);

            System.out.print("Enter rental price per day: ");
            double rentalPricePerDay = getDoubleInput(sc);
            sc.nextLine();
            System.out.print("Enter the location where you will take it from: ");
            String place=sc.nextLine();
			
            String query = "SELECT * FROM Car WHERE type = ? AND rental_price_per_day <= ? AND branch_branchid=? AND availability=1";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, type);
            pstmt.setDouble(2, rentalPricePerDay);
            pstmt.setString(3,  place);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                System.out.println("Car ID: " + rs.getString("carID"));
                System.out.println("Car Type: " + rs.getString("type"));
                System.out.println("Number of Seats: " + rs.getInt("number_of_seats"));
                System.out.println("Number of Doors: " + rs.getInt("number_of_doors"));
                System.out.println("Conventionality: " + rs.getBoolean("conventionality"));
                System.out.println("Gasoline Powered: " + rs.getBoolean("gasoline_powered"));
                System.out.println("Diesel Powered: " + rs.getBoolean("diesel_powered"));
                System.out.println("Electric: " + rs.getBoolean("electric"));
                System.out.println("Hybrid: " + rs.getBoolean("hybrid"));
                System.out.println("Rental Price per Day: " + rs.getDouble("rental_price_per_day"));
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving available cars by criteria: " + e.getMessage());
        }
    }

    private static void deleteCar(Connection conn, Scanner sc) {//εδω περα διαγραφουμε αμαξια απο το car table

        try {
            System.out.print("Enter car ID to delete: ");
            String carID = sc.nextLine();
            if (!isCarIdValid(conn, carID)) { 
                System.out.println("Car ID not found. Available cars for deletion:\n");
                retrieveAllCars(conn);
                return;   
            }
            
            String query = "DELETE FROM Car WHERE carID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, carID);

            pstmt.executeUpdate();
            System.out.println("Car deleted successfully.");
        } catch (SQLException e) {
            System.out.println("Error deleting car: " + e.getMessage());
        }
    }
    //παρακατω υπαρχουν διαφοροι μεθοδοι που κατασκευαστηκαν για διαφορους ελεγχους εγκυροττηας για την ομαλη λειτουργια του προγραμματος
    private static boolean doesCarExist(Connection conn, String carID) throws SQLException {//εδω περα ελεγζουμε αν το αμαξι υπαρχει 
        String query = "SELECT 1 FROM Car WHERE carID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, carID);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private static boolean doesCustomerExist(Connection conn, String customerID) throws SQLException {//εδω περα ελεγζουμε αν ο πελατης υπαρχει
        String query = "SELECT customerID FROM Customer WHERE customerID = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, customerID);

        ResultSet rs = pstmt.executeQuery();
        return rs.next();
    }

    private static boolean doesReservationExist(Connection conn, String reservationID) throws SQLException {//εδω περα ελεγζουμε αν η κρατηση υπαρχει
        String query = "SELECT reservationID FROM Reservation WHERE reservationID = ?";
        PreparedStatement pstmt = conn.prepareStatement(query);
        pstmt.setString(1, reservationID);

        ResultSet rs = pstmt.executeQuery();
        return rs.next();
    }

    private static void retrieveAllCars(Connection conn) {//εδω περνουμε ολες τις λιστες με τα αμαξια χρησιμοποιειται στις retireve cars επιλογες του μενου
        try {
            String query = "SELECT * FROM Car";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                System.out.println("Car ID: " + rs.getString("carID"));
                System.out.println("Car Type: " + rs.getString("type"));
                System.out.println("Number of Seats: " + rs.getInt("number_of_seats"));
                System.out.println("Number of Doors: " + rs.getInt("number_of_doors"));
                System.out.println("Conventionality: " + rs.getBoolean("conventionality"));
                System.out.println("Gasoline Powered: " + rs.getBoolean("gasoline_powered"));
                System.out.println("Diesel Powered: " + rs.getBoolean("diesel_powered"));
                System.out.println("Electric: " + rs.getBoolean("electric"));
                System.out.println("Hybrid: " + rs.getBoolean("hybrid"));
                System.out.println("Rental Price per Day: " + rs.getDouble("rental_price_per_day"));
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving all cars: " + e.getMessage());
        }
    }
    
    private static void retrieveAllCustomers(Connection conn) {//ιδιο περιπου με το retireveallcars μονο που εδω γινεται για τους πελατες
        try {
            String query = "SELECT * FROM Customer";
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                System.out.println("Customer ID: " + rs.getString("customerID"));
                System.out.println("First Name: " + rs.getString("first_name"));
                System.out.println("Last Name: " + rs.getString("last_name"));
                System.out.println("Email: " + rs.getString("email"));
                System.out.println("License Number: " + rs.getString("license_number"));
                System.out.println("Phone Number: " + rs.getBoolean("phone_number"));
                System.out.println("Mobile Number: " + rs.getBoolean("mobile_number"));
                System.out.println();
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving all customers: " + e.getMessage());
        }
    }
    
    private static boolean isCarIdValid(Connection conn, String carID) {//τσεκαρουμε αν το carid ειναι valid δηλαδη αν μπορει να χρησιμοποιηθει 
        try {
            String query = "SELECT COUNT(*) FROM Car WHERE carID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, carID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error validating car ID: " + e.getMessage());
        }
        return false;
    }
    
    private static String getValidatedCarType(Scanner sc) {//ελεγχουμε αν ο χρηστης οταν επιλεγει car type αμα δε θα διαλεξει κατι εκτος απο τα τρια μεγεθη small mid and big
        String type;
        do {
            type = sc.nextLine().toLowerCase();
            if (!type.equals("small") && !type.equals("mid") && !type.equals("big")) {
                System.out.print("Invalid car type. Please enter small, mid, or big: ");
            }
        } while (!type.equals("small") && !type.equals("mid") && !type.equals("big"));
        return type;
    }
//παρακατω βλεπουμε μεθοδους που χρησιμοποιουνται απο την java για τα ειδη των input που λαμβανουμε κυριως για double int και boolean τιμεσ 
    private static double getDoubleInput(Scanner sc) {
        while (!sc.hasNextDouble()) {
            System.out.print("Invalid input. Please enter a valid number: ");
            sc.next();
        }
        return sc.nextDouble();
    }
    
    private static int getIntInput(Scanner sc) {
        while (!sc.hasNextInt()) {
            System.out.print("Invalid input. Please enter a valid number: ");
            sc.next();
        }
        int input = sc.nextInt();
        sc.nextLine(); // consume newline
        return input;
    }

    private static boolean getValidatedBooleanInput(Scanner sc) {
        while (true) {
            String input = sc.nextLine().trim().toLowerCase();
            if (input.equals("true") || input.equals("false")) {
                return Boolean.parseBoolean(input);
            } else {
                System.out.print("Invalid input. Please enter 'true' or 'false': ");
            }
        }
    }
    public static void getReciept(Connection conn, Scanner sc) throws SQLException {//το getReciept ηταν η τελευταια μεθοδος που φτιαξαμε η οποια εμανιζει στην οθιονη (δηλαδη στον χρηστη) ολα τα στοιχεια της κρατησης που εκανε εφοσον ουσιαστικα πρωτα εχει δει τα αμαξια ειτε απο sotre ειτε με criteria και εμφανιζει κιολας και το τελικο ποσο που θα χριεαστει να δωσει ως μια μορφη αποδειξης 
    	System.out.print("Insert the reservation ID for which you want to recieve the reciept: ");
    	String reservationid=sc.nextLine();
    	String recemail=null;
    	String reclinum=null;
    	String recmoph=null;
    	String recphnu=null;
    	String recname=null;
    	String reccustomerid=null;
    	double reciept=0;
    	 try (PreparedStatement reservStmt = conn.prepareStatement("SELECT customer_customerid, total_price,costumer_email, costumer_license_number,costumer_mobile_number ,costumer_phone_number FROM Reservation WHERE reservationid = ?")) {
             reservStmt.setString(1, reservationid);
             try (ResultSet rs = reservStmt.executeQuery()) {
                 if (rs.next()) {
                	 reccustomerid=rs.getString("customer_customerid");
                	 reciept=rs.getDouble("total_price");
                	 recemail=rs.getString("costumer_email");
                	 reclinum=rs.getString("costumer_license_number");
                	 recmoph=rs.getString("costumer_mobile_number");
                	 recphnu=rs.getString("costumer_phone_number");
             }
             }
             
    	 } 
    	 try (PreparedStatement customerStmt = conn.prepareStatement("SELECT first_name, last_name FROM Customer WHERE customerid = ?")) {
             customerStmt.setString(1, reccustomerid);
             try (ResultSet rs = customerStmt.executeQuery()) {
                 if (rs.next()) {
                     String firstName = rs.getString("first_name");
                     String lastName = rs.getString("last_name");
                     recname = firstName + " " + lastName;
                 }
             }
    	 }
    	    String receiptMessage = String.format(
    	            "The total amount of the specific reservation is: %.2f\n" +
    	            "Customer Name: %s\n" +
    	            "Customer Email: %s\n" +
    	            "Customer License Number: %s\n" +
    	            "Customer Mobile Phone: %s\n" +
    	            "Customer Phone Number: %s\n",
    	            reciept, recname, recemail, reclinum, recmoph, recphnu
    	        );
    	 System.out.println(receiptMessage);
  
    }
}




