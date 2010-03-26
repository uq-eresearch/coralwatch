package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.AccessDeniedResource;
import au.edu.uq.itee.maenad.restlet.CachingDirectory;
import au.edu.uq.itee.maenad.restlet.StyleResource;
import au.edu.uq.itee.maenad.restlet.SubmissionErrorResource;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.model.FrameDataProvider;
import org.coralwatch.resources.*;
import org.coralwatch.resources.testing.DataExchangeResource;
import org.coralwatch.resources.testing.ResetResource;
import org.restlet.Application;
import org.restlet.Directory;
import org.restlet.Restlet;
import org.restlet.Router;
import org.restlet.data.LocalReference;

public class CoralwatchApplication extends Application {

    private static final Configuration configuration;

    static {
        try {
            configuration = new ApplicationContext();
        } catch (InitializationException ex) {
            throw new RuntimeException("Failed to initialize application", ex);
        }
    }

    public static Configuration getConfiguration() {
        return configuration;
    }

    @Override
    public Restlet createRoot() {

        Router router = new Router(getContext());

        getContext().getAttributes().put(FrameDataProvider.class.getName(), new org.coralwatch.resources.FrameDataProvider());
        getContext().getAttributes().put(AccessPolicy.class.getName(), new CoralwatchAccessPolicy());

        String baseUrl = configuration.getBaseUrl();
        if (baseUrl != null) {
            getContext().getAttributes().put("baseUrl", baseUrl);
        }
//        router.attachDefault(FrontpageResource.class);
        router.attachDefault(MapResource.class);
//        router.attach("/map", MapResource.class);
        router.attach("/slate", SlateResource.class);
        router.attach("/dashboard", DashboardResource.class);
        router.attach("/users", UserListResource.class);
        router.attach("/users/{id}", UserResource.class);
        router.attach("/surveys", SurveyListResource.class);
        router.attach("/markers", MarkerResource.class);
        router.attach("/trustors", TrustSubTreeResource.class);
        router.attach("/surveys/{id}", SurveyResource.class);
        router.attach("/surveyrecord/{id}", SurveyRecordResource.class);
        router.attach("/surveyrecord", SurveyRecordListResource.class);
        router.attach("/usertrust/{id}", UserTrustResource.class);
        router.attach("/usertrust", UserTrustListResource.class);
        router.attach("/surveyrating/{id}", SurveyRatingResource.class);
        router.attach("/surveyrating", SurveyRatingListResource.class);
        router.attach("/login", LoginResource.class);
        router.attach("/oneoff", OneOffSubmissionResource.class);
        router.attach("/postsignup", PostSignUpResource.class);
        router.attach("/logout", LogoutResource.class);
        router.attach("/kit", KitRequestListResource.class);
        router.attach("/kit/{id}", KitRequestResource.class);
        router.attach("/reef", ReefListResource.class);
        router.attach("/reef/{id}", ReefResource.class);
        router.attach("/submissionError", SubmissionErrorResource.class);
        router.attach("/accessDenied", AccessDeniedResource.class);
        router.attach("/style.css", StyleResource.class);
        router.attach("/icons", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/icons")));
        router.attach("/javascript", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/javascript")));
        router.attach("/images", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/images")));

        if (getConfiguration().isTestSetup()) {
            router.attach("/reset", ResetResource.class);
            router.attach("/data", DataExchangeResource.class);
        } else {
            router.attach("/data", DataDownloadResource.class);
        }

        Directory downloadDirectory = new Directory(getContext(), "war:///files");
        router.attach("/download", downloadDirectory);

        setConnectorService(getConfiguration().getConnectorService());

        return router;
    }
}