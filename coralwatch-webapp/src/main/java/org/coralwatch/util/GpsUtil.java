package org.coralwatch.util;

public class GpsUtil {

    public static final int LAT = 0;
    public static final int LONG = 1;

    public static String formatGpsValue(float value, int type) {
        String direction = "";
        if (type == LAT) {
            if (value > 0) {
                direction = "N";
            } else {
                direction = "S";
            }
        } else {
            if (value > 0) {
                direction = "E";
            } else {
                direction = "W";
            }
        }
        float absValue = Math.abs(value);
        int degree = (int) absValue;
        int minutes = (int) ((absValue - degree) * 60);
        int seconds = Math.round((((absValue - degree) * 60) - minutes) * 60);

        return degree + "&deg; " + minutes + "&apos; " + seconds + "&quot; " + direction;
    }
}
