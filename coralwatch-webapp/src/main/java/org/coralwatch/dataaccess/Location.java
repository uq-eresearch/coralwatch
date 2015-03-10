package org.coralwatch.dataaccess;


public class Location {

  private final double lat;

  private final double lng;

  public Location(double latitude, double longitude) {
    this.lat = latitude;
    this.lng = longitude;
  }

  public double getLatitude() {
    return lat;
  }

  public double getLongitude() {
    return lng;
  }

}
