package com.rental.session;

import com.rental.entity.Bookings;
import java.util.List;
import javax.ejb.Local;

@Local
public interface BookingBeanLocal {

    void createBooking(Bookings booking);

    void cancelBooking(int bookingId);

    List<Bookings> getBookingsByUser(int userId);

    boolean isCarAvailable(int carId, java.util.Date startDate, java.util.Date endDate);

    List<Bookings> getAllBookings();

    void updateBookingStatus(int id, String status);
}
