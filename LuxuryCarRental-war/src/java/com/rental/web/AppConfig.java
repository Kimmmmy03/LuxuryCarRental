package com.rental.web;

import java.util.TimeZone;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppConfig implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Force the whole app to use Malaysia Time
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
        System.out.println("✅ System TimeZone set to: Asia/Kuala_Lumpur");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do when stopping
    }
}