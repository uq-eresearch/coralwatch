package org.coralwatch.servlets.api;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

public class CountriesApiHandler {

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws Exception {
    // TODO cleanup, read this from the countrylist.jsp instead of copying it into this file
    String[] countries = new String[] {"Afghanistan","Albania","Algeria","American Samoa","Andorra",
        "Angola","Anguilla","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia",
        "Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium",
        "Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Brazil",
        "Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada",
        "Cape Verde","Cayman Islands","Central African Republic","Chad","Chile","China","Colombia",
        "Comoros","Congo, Republic of","Cook Islands","Costa Rica","Croatia","Cuba","Cyprus",
        "Czech Republic","Democratic Republic of the Congo","Denmark","Djibouti","Dominica",
        "Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea",
        "Estonia","Ethiopia","Fiji","Finland","France","French Polynesia","Gabon","Georgia",
        "Germany","Ghana","Greece","Grenada","Guadeloup","Guam","Guatemala","Guinea",
        "Guinea-Bissau","Guyana","Haiti","Holy See","Honduras","Hong Kong SAR","Hungary","Iceland",
        "India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Ivory Coast","Jamaica","Japan",
        "Jordan","Kazakhstan","Kenya","Kiribati","Korea, Democratic People's Republic Of",
        "Korea, Republic Of","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho",
        "Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar",
        "Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania",
        "Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat",
        "Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherland",
        "Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria",
        "Niue","Northern Mariana Islands","Norway","Oman","Pakistan","Palau",
        "Palestinian National Authority","Panama","Papua New Guinea","Paraguay","Peru","Philippines",
        "Pitcairn","Poland","Portugal","Qatar","Romania","Russian Federation","Rwanda",
        "Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Samoa",
        "San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles",
        "Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa",
        "Spain","Sri Lanka","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan",
        "Tajikistan","Tanzania","Thailand","The Gambia","Timor-Leste","Togo","Tokelau","Tonga",
        "Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Tuvalu","Uganda","Ukraine",
        "United Arab Emirates","United Kingdom","United States of America","Uruguay","Uzbekistan",
        "Vanuatu","Venezuela","Vietnam","Wallis and Futuna Islands","Yemen","Yugoslavia",
        "Zambia","Zimbabwe"};
    final Gson gson = new Gson();
    response.setContentType("application/json; charset=utf-8");
    response.getWriter().write(gson.toJson(countries));
  }
}
