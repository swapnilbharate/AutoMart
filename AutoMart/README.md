# AutoMart - Second-Hand Car Marketplace

AutoMart is a complete Java Servlet, JSP, JDBC, and MySQL web application for browsing, searching, wishlisting, and managing second-hand vehicle listings.

## Eclipse and Tomcat setup

1. Open MySQL and run `database/automart_schema.sql`.
2. Update database credentials in `src/main/java/com/automart/util/DBConnection.java`.
3. Import the project in Eclipse as an existing Maven project.
4. Configure Apache Tomcat 9.x in Eclipse.
5. Run the project on Tomcat and open `http://localhost:8080/AutoMart/`.

## Demo login

- Admin: `admin@automart.com`
- Password: `admin123`

The password hash in the SQL file uses the app's MD5 hashing helper for easy classroom/demo setup. For production, replace it with BCrypt or Argon2.

## Main modules

- Home page with featured vehicles, latest vehicles, search, and filters.
- User registration, login, logout, session handling, and role-based redirects.
- User dashboard with profile management, wishlist, car browsing, car details, and dealer contact requests.
- Admin dashboard with vehicle CRUD, user management, inquiries, and dashboard statistics.
- Normalized MySQL schema with Users, Admin, Brands, Cars, VehicleImages, Wishlist, and ContactRequests.
