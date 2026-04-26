package com.rental.session;

import com.rental.entity.Cars;
import java.util.List;
import javax.ejb.Local;

@Local
public interface CarBeanLocal {
    void addCar(Cars car);
    void updateCar(Cars car);
    void deleteCar(int carId);
    boolean isLicensePlateExists(String plate);
    Cars findCarById(int id);
    List<Cars> getAllCars();
}
