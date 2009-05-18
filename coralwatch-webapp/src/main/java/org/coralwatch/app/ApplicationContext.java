package org.coralwatch.app;

import java.util.Properties;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.io.InputStream;
import java.io.IOException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 12:08:38 PM
 */
public class ApplicationContext implements Configuration {

    private final int httpPort;
    private final String baseUrl;

    public ApplicationContext() throws InitializationException {
         Properties properties = new Properties();
         InputStream resourceAsStream = null;
         try {
             resourceAsStream = ApplicationContext.class.getResourceAsStream("/coralwatch.properties");
             if (resourceAsStream == null) {
                 throw new InitializationException("Configuration file not found, please ensure " +
                         "there is a 'pronto.properties' on the classpath");
             }
             properties.load(resourceAsStream);
         } catch (IOException ex) {
             throw new InitializationException("Failed to load configuration properties", ex);
         } finally {
             if (resourceAsStream != null) {
                 try {
                     resourceAsStream.close();
                 } catch (IOException ex) {
                     // so what?
                 }
             }
         }
         // try to load additional developer-specific settings
         File devPropertiesFile = new File("local/coralwatch.properties");
         if (devPropertiesFile.isFile()) {
             InputStream fileInputStream = null;
             try {
                 fileInputStream = new FileInputStream(devPropertiesFile);
                 properties.load(fileInputStream);
             } catch (FileNotFoundException ex) {
                 // should never happen since we checked before
             } catch (IOException ex) {
                 throw new InitializationException("Failed to load development configuration properties", ex);
             } finally {
                 if (fileInputStream != null) {
                     try {
                         fileInputStream.close();
                     } catch (IOException ex) {
                         // so what?
                     }
                 }
             }

         }
//         final String persistenceUnitName = getProperty(properties, "persistenceUnitName");
//         final EntityManagerFactory emf = Persistence.createEntityManagerFactory(persistenceUnitName);
//         Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
//
//             public void run() {
//                 emf.close();
//             }
//         }));


         this.httpPort = Integer.valueOf(getProperty(properties, "httpPort", "8181"));
         this.baseUrl = getProperty(properties, "baseUrl", null);
     }

    @Override
    public int getHttpPort() {
        return httpPort;
    }

    @Override
    public String getBaseUrl() {
        return baseUrl;
    }


    private static String getProperty(Properties properties, String propertyName) throws InitializationException {
        return getProperty(properties, propertyName, false);
    }

    private static String getProperty(Properties properties, String propertyName, boolean allowEmpty) throws InitializationException {
        String result = properties.getProperty(propertyName);
        if (result == null && (allowEmpty || !result.isEmpty())) {
            throw new InitializationException(String.format("Failed to load required property '%s', " +
                    "please check configuration", propertyName));
        }
        return result;
    }

    private static String getProperty(Properties properties, String propertyName, String defaultValue) {
        String result = properties.getProperty(propertyName);
        if (result == null) {
            result = defaultValue;
            Logger.getLogger(ApplicationContext.class.getName()).log(
                    Level.INFO,
                    String.format("No value for property '%s' found, falling back to default of '%s'", propertyName, defaultValue));
        }
        return result;
    }    
}
