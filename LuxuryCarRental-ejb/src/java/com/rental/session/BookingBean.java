package com.rental.session;

import com.rental.entity.Bookings;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TemporalType;

@Stateless
public class BookingBean implements BookingBeanLocal {

    @PersistenceContext(unitName = "LuxuryCarRental-ejbPU")
    private EntityManager em;

    @Override
    public void createBooking(Bookings booking) {
        em.persist(booking);
    }

    @Override
    public List<Bookings> getBookingsByUser(int userId) {
        return em.createQuery("SELECT b FROM Bookings b WHERE b.userId.userId = :uid", Bookings.class)
                .setParameter("uid", userId)
                .getResultList();
    }

    @Override
    public boolean isCarAvailable(int carId, java.util.Date startDate, java.util.Date endDate) {
        // Check if any existing booking overlaps with the requested dates
        long conflictCount = (long) em.createQuery(
                "SELECT COUNT(b) FROM Bookings b WHERE b.carId.carId = :cid "
                + "AND ((b.startDate <= :end AND b.endDate >= :start))")
                .setParameter("cid", carId)
                .setParameter("start", startDate, TemporalType.DATE)
                .setParameter("end", endDate, TemporalType.DATE)
                .getSingleResult();

        return conflictCount == 0;
    }

    @Override
    public void cancelBooking(int bookingId) {
        Bookings b = em.find(Bookings.class, bookingId);
        if (b != null) {
            b.setBookingStatus("CANCELLED");
            em.merge(b);
        }
    }

    @Override
    public List<Bookings> getAllBookings() {
        // Orders by newest first
        return em.createQuery("SELECT b FROM Bookings b ORDER BY b.createdAt DESC", Bookings.class).getResultList();
    }

    @Override
    public void updateBookingStatus(int id, String status) {
        Bookings b = em.find(Bookings.class, id);
        if (b != null) {
            b.setBookingStatus(status);
            em.merge(b);

            // OPTIONAL: If status is 'RETURNED', you could automatically make the car AVAILABLE again here
            // But for this simple system, we assume availability is purely date-based, so no extra code needed.
        }
    }
}
