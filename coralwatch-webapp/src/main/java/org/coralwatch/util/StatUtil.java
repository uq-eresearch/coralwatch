package org.coralwatch.util;

import org.coralwatch.app.CoralwatchApplication;

public class StatUtil {
    public static int getNumberOfUsers() {
        return CoralwatchApplication.getConfiguration().getUserDao().getAll().size();
    }

    public static int getNumberOfSurveys() {
        return CoralwatchApplication.getConfiguration().getSurveyDao().getAll().size();
    }
}
