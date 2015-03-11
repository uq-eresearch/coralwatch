package org.coralwatch.portlets;


public class BleachingRiskPortlet extends SimplePortlet {

  @Override
  String include() {
    return "/data/bleaching-risk/bleaching.html";
  }

}
