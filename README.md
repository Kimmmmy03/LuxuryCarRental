# Luxury Car Rental

An enterprise Java EE web application that digitises the operations of a luxury vehicle rental service. Customers can browse the exclusive fleet, reserve a car for a chosen period with automatic cost calculation, and track their booking history. Administrators manage the fleet inventory and supervise rental approvals end-to-end.

This project was developed for **ISB37804 – Reuse and Component-Based Development** under the **Bachelor of Information Technology (Hons) in Software Engineering** programme at **Universiti Kuala Lumpur (UniKL)**.

---

## Team

- Khairul Aqif Danial bin Khairul Nizam
- Akmal Hakimi bin Abd Rashid
- Nur Husna Batrisya binti Mohd Zuhaili

**Lecturer:** Dr. Azizah Rahmat

---

## Problem Statement

Manual or file-based car rental processes suffer from several recurring problems that this system is built to address:

1. **Availability conflicts** – without real-time validation, the same vehicle can be double-booked for overlapping dates.
2. **Inefficient fleet management** – tracking vehicle availability via spreadsheets or paper records is error-prone and slow.
3. **Calculation errors** – manual computation of rental cost from daily rate and duration introduces mistakes.
4. **Lack of transparency** – customers cannot view their booking history or current status (Pending, Approved, Rejected) in real time.

---

## Features

### Customer
- Self-service registration and secure login
- Browse the exclusive fleet with model details, daily rates, and images
- Select a vehicle and reserve it for a chosen date range
- Automatic total-cost calculation based on duration × daily rate
- View personal booking history and cancel pending reservations

### Administrator
- Role-based admin dashboard
- Add, edit, and delete vehicles in the fleet (with unique licence-plate validation)
- Review every booking ordered by most recent first
- Approve, reject, or mark bookings as **Returned**

---

## Technology Stack

| Layer                | Technology                                       |
|----------------------|--------------------------------------------------|
| Language             | Java 8                                           |
| Platform             | Jakarta EE 8 (Java EE 8)                         |
| Application Server   | GlassFish 5.1                                    |
| Web Tier             | Servlet 4.0, JSP, JSTL, HTML, CSS                |
| Business Tier        | Stateless Session Beans (EJB 3.2)                |
| Persistence          | JPA 2.2 (EclipseLink) with JTA transactions      |
| Database             | Apache Derby (Java DB), network mode on port 1527|
| Build Tool           | Apache Ant (NetBeans-generated build scripts)    |
| IDE                  | Apache NetBeans                                  |

The architecture follows a classical multi-tier Java EE pattern: JSP views on the client side, Servlets and EJBs on the server side, and JPA entities mapped to a relational Derby database.

---

## Project Structure

The repository is a NetBeans Enterprise Application composed of three sibling projects:

```
LuxuryCarRental/                  # EAR assembly project
├── build.xml
├── nbproject/
├── lib/
│
├── LuxuryCarRental-ejb/          # EJB module — entities and session beans
│   └── src/java/com/rental/
│       ├── entity/
│       │   ├── Users.java
│       │   ├── Cars.java
│       │   └── Bookings.java
│       └── session/
│           ├── UserBean.java     /  UserBeanLocal.java
│           ├── CarBean.java      /  CarBeanLocal.java
│           └── BookingBean.java  /  BookingBeanLocal.java
│
└── LuxuryCarRental-war/          # Web module — servlets and JSP views
    ├── src/java/com/rental/web/
    │   ├── LoginServlet.java
    │   ├── RegisterServlet.java
    │   ├── HomeServlet.java
    │   ├── CarServlet.java
    │   ├── BookingServlet.java
    │   ├── MyBookingsServlet.java
    │   ├── AdminBookingServlet.java
    │   └── AppConfig.java        # Sets default JVM time zone
    └── web/
        ├── login.jsp / register.jsp
        ├── home.jsp
        ├── booking_form.jsp / booking_preview.jsp / booking_success.jsp
        ├── my_bookings.jsp
        ├── admin_dashboard.jsp / admin_bookings.jsp / edit_car.jsp
        └── css/style.css
```

---

## Architecture Overview

The system is split into three cooperating tiers:

1. **Presentation tier** — JSP pages styled with a shared CSS file. Servlets in `com.rental.web` act as front controllers, dispatching requests to the appropriate JSP or redirecting after each POST to prevent duplicate submissions.
2. **Business tier** — Stateless Session Beans in `com.rental.session` encapsulate all business operations (registration, authentication, fleet CRUD, booking lifecycle, availability checks). Each bean is exposed to the web tier through a `@Local` interface and injected via `@EJB`.
3. **Persistence tier** — JPA entities in `com.rental.entity` are mapped to Derby tables. The persistence unit `LuxuryCarRental-ejbPU` (defined in `LuxuryCarRental-ejb/src/conf/persistence.xml`) uses JTA, and the schema is auto-generated on first deployment.

The JDBC data source is declared programmatically via `@DataSourceDefinition` on `UserBean` (JNDI: `java:global/jdbc/rental_db`), so no manual GlassFish resource configuration is required.

### Domain Model

| Entity      | Key Fields                                                                                                         |
|-------------|--------------------------------------------------------------------------------------------------------------------|
| `Users`     | `userId`, `fullName`, `email`, `password`, `role` (`ADMIN` / `CUSTOMER`), `phoneNumber`, `driverLicenseNumber`     |
| `Cars`      | `carId`, `brand`, `model`, `licensePlate`, `dailyRate`, `status`, `imageUrl`                                       |
| `Bookings`  | `bookingId`, `startDate`, `endDate`, `totalCost`, `bookingStatus`, `createdAt`, plus `@ManyToOne` `Cars` and `Users`|

Booking statuses follow the lifecycle: `PENDING` → `APPROVED` / `REJECTED` / `CANCELLED` → `RETURNED`. A `@OneToMany(cascade = ALL)` relationship from `Cars` and `Users` to `Bookings` ensures referential consistency on deletion.

---

## Getting Started

### Prerequisites

- JDK 8
- Apache NetBeans (with the Java EE bundle)
- GlassFish Server 5.1 (registered in NetBeans)
- Apache Derby / Java DB (bundled with GlassFish)

### Database Setup

1. Start the Derby network server on port `1527` (NetBeans → *Services* → *Databases* → *Java DB* → *Start Server*).
2. Create a database named `rental_db` with username `app` and password `app` — these credentials are referenced by the `@DataSourceDefinition` in `UserBean.java`.
3. No schema scripts are required. JPA will auto-create the `USERS`, `CARS`, and `BOOKINGS` tables on first deployment (`javax.persistence.schema-generation.database.action=create`).
4. After the first deployment, insert at least one administrator account, for example via the Derby SQL console:

   ```sql
   INSERT INTO USERS (FULL_NAME, EMAIL, PASSWORD, ROLE)
   VALUES ('Administrator', 'admin@luxerental.com', 'admin123', 'ADMIN');
   ```

### Running in NetBeans

1. Open the `LuxuryCarRental` project in NetBeans (NetBeans will automatically resolve the `-ejb` and `-war` sub-projects).
2. Right-click the EAR project → **Clean and Build**.
3. Right-click the EAR project → **Run**. NetBeans will deploy the EAR to GlassFish and launch the application in your browser.

### Running from the Command Line (Ant)

From the EAR project root:

```bash
ant -f LuxuryCarRental dist     # Build the EAR
ant -f LuxuryCarRental run      # Deploy and launch
ant -f LuxuryCarRental clean    # Clean build artefacts
```

The application will be available at:

```
http://localhost:8080/LuxuryCarRental-war/
```

The default landing page is `login.jsp`. Customers can self-register, while the administrator account must be created manually as shown above.

---

## Usage

### Customer Flow
1. Register an account or log in with existing credentials.
2. Browse the fleet on the home page.
3. Click **Book Now** on a vehicle, choose pickup and return dates.
4. Review the calculated cost on the preview page and confirm the booking.
5. Track all reservations on **My Bookings** and cancel any that are still pending.

### Administrator Flow
1. Log in with an account that has the `ADMIN` role.
2. From the dashboard, add new vehicles, edit existing entries, or remove vehicles from the fleet.
3. Open **Manage Bookings** to approve, reject, or mark bookings as returned.

---

## Configuration Notes

- **Time zone** – `AppConfig` (a `@WebListener`) sets the JVM default time zone to `Asia/Kuala_Lumpur` at startup so date handling stays consistent.
- **Session management** – HTTP sessions store the authenticated `Users` entity under the attribute key `user`, with a 30-minute timeout (`web.xml`).
- **Routing** – Most servlets self-register through `@WebServlet` annotations; only `LoginServlet` and `CarServlet` are mapped explicitly in `web.xml`.
- **Currency precision** – Vehicle daily rates and booking totals are stored as `BigDecimal` to preserve monetary precision.

---

## Future Enhancements

Identified in the project report as next-step improvements:

1. **Online payment integration** – wire the booking flow to a real payment gateway (FPX, PayPal, Stripe) so a confirmed payment moves a booking from `PENDING` to `CONFIRMED` automatically.
2. **Direct image uploads** – let administrators upload vehicle images from their machine instead of typing in filenames manually.
3. **Visual calendar picker** – integrate a date-picker such as Flatpickr that greys out dates on which a vehicle is already booked, eliminating availability conflicts before they happen.
4. **Search and filtering** – add price-range, brand, and availability filters on the fleet browsing page to scale beyond a small catalogue.

---

## Acknowledgements

Developed as coursework for **ISB37804 – Reuse and Component-Based Development**, Bachelor of Information Technology (Hons) in Software Engineering, **Universiti Kuala Lumpur**.
