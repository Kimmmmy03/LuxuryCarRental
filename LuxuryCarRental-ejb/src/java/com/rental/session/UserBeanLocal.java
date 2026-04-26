/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.rental.session;

import com.rental.entity.Users;
import javax.ejb.Local;

@Local
public interface UserBeanLocal {
    
    void registerUser(Users user);
    Users login(String email, String password);
}
