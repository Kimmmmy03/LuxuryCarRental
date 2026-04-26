package com.rental.session;

import com.rental.entity.Users;
import javax.annotation.sql.DataSourceDefinition;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

// This creates the connection pool automatically without XML files
@DataSourceDefinition(
    name = "java:global/jdbc/rental_db",
    className = "org.apache.derby.jdbc.ClientDataSource",
    user = "app",
    password = "app",
    databaseName = "rental_db",
    serverName = "localhost",
    portNumber = 1527
)

@Stateless
public class UserBean implements UserBeanLocal {

    // This injects the database connection automatically
    @PersistenceContext(unitName = "LuxuryCarRental-ejbPU")
    private EntityManager em;

    @Override
    public void registerUser(Users user) {
        // "persist" means save to database
        em.persist(user); 
    }

    @Override
    public Users login(String email, String password) {
        try {
            // JPQL Query (Java Persistence Query Language) - works on Objects, not Tables
            TypedQuery<Users> query = em.createQuery(
                "SELECT u FROM Users u WHERE u.email = :email AND u.password = :password", 
                Users.class);
            
            query.setParameter("email", email);
            query.setParameter("password", password);
            
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null; // Login failed
        }
    }
}