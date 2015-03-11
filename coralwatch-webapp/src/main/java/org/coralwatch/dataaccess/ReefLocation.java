package org.coralwatch.dataaccess;


public class ReefLocation {

  private final String reef;

  private final String country;

  private final double lat;

  private final double lng;

  public ReefLocation(String reef, String country, double latitude, double longitude) {
    this.reef = reef;
    this.country = country;
    this.lat = latitude;
    this.lng = longitude;
  }

  public double getLatitude() {
    return lat;
  }

  public double getLongitude() {
    return lng;
  }

  public String getReef() {
    return reef;
  }

  public String getCountry() {
    return country;
  }

}
