package org.coralwatch.app.misc;

import au.edu.uq.itee.maenad.util.BCrypt;

public class PasswordGenerator {
    public static void main(String[] args) throws Exception {
        System.out.println(BCrypt.hashpw("password486", BCrypt.gensalt()));
    }
}
