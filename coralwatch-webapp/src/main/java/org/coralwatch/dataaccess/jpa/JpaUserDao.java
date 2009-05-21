package org.coralwatch.dataaccess.jpa;

import au.edu.uq.itee.maenad.dataaccess.jpa.EntityManagerSource;
import au.edu.uq.itee.maenad.dataaccess.jpa.JpaDao;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.User;


public class JpaUserDao extends JpaDao<User> implements UserDao {

    public JpaUserDao(EntityManagerSource entityManagerSource) {
        super(entityManagerSource);
    }

}
