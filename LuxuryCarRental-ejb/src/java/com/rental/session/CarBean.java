package com.rental.session;

import com.rental.entity.Cars;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

@Stateless
public class CarBean implements CarBeanLocal {

    // We use the SAME Persistence Unit name as before
    @PersistenceContext(unitName = "LuxuryCarRental-ejbPU")
    private EntityManager em;

    @Override
    public void addCar(Cars car) {
        em.persist(car);
    }

    @Override
    public void updateCar(Cars car) {
        em.merge(car);
    }

    @Override
    public void deleteCar(int carId) {
        Cars c = em.find(Cars.class, carId);
        if (c != null) {
            em.remove(c);
        }
    }
    
    @Override
    public boolean isLicensePlateExists(String plate) {
    long count = (long) em.createQuery("SELECT COUNT(c) FROM Cars c WHERE c.licensePlate = :plate")
            .setParameter("plate", plate)
            .getSingleResult();
    return count > 0;
}

    @Override
    public Cars findCarById(int id) {
        return em.find(Cars.class, id);
    }

    @Override
    public List<Cars> getAllCars() {
        // "Cars" here refers to the Class name, not the table name
        return em.createQuery("SELECT c FROM Cars c", Cars.class).getResultList();
    }
   
}