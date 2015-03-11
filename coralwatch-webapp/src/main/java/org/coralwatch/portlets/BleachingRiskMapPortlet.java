package org.coralwatch.portlets;


public class BleachingRiskMapPortlet extends SimplePortlet {

  @Override
  String include() {
    return "/data/bleaching-risk/map.html";
  }

}
