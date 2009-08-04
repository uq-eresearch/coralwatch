package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.AccessDeniedResource;
import au.edu.uq.itee.maenad.restlet.CachingDirectory;
import au.edu.uq.itee.maenad.restlet.StyleResource;
import au.edu.uq.itee.maenad.restlet.SubmissionErrorResource;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.model.FrameDataProvider;
import org.coralwatch.resources.AboutResource;
import org.coralwatch.resources.DashboardResource;
import org.coralwatch.resources.DataDownloadResource;
import org.coralwatch.resources.EducationResource;
import org.coralwatch.resources.FrontpageResource;
import org.coralwatch.resources.GoingGreenResource;
import org.coralwatch.resources.GraphsResource;
import org.coralwatch.resources.KitRequestListResource;
import org.coralwatch.resources.KitRequestResource;
import org.coralwatch.resources.LinksResource;
import org.coralwatch.resources.LoginResource;
import org.coralwatch.resources.LogoutResource;
import org.coralwatch.resources.MapResource;
import org.coralwatch.resources.PostSignUpResource;
import org.coralwatch.resources.ReefListResource;
import org.coralwatch.resources.ReefResource;
import org.coralwatch.resources.SurveyListResource;
import org.coralwatch.resources.SurveyRecordResource;
import org.coralwatch.resources.SurveyResource;
import org.coralwatch.resources.UserListResource;
import org.coralwatch.resources.UserResource;
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
        getContext().getAttributes().put(FrameDataProvider.class.getName(),
                new org.coralwatch.resources.FrameDataProvider());
        getContext().getAttributes().put(AccessPolicy.class.getName(),
                new CoralwatchAccessPolicy());
        // TODO the current solution is very fragile since every bit of code that
        //      refers to a base URL has to know about the pattern. There should
        //      (and might) be a way to solve this problem on the Restlet level.
        //      A lot is solved by attaching it to the AbstractFreemarkerResource,
        //      but there are many more spots where this pattern is used.
        String baseUrl = configuration.getBaseUrl();
        if (baseUrl != null) {
            getContext().getAttributes().put("baseUrl", baseUrl);
        }
        router.attachDefault(FrontpageResource.class);
        router.attach("/about", AboutResource.class);
        router.attach("/map", MapResource.class);
        router.attach("/graphs", GraphsResource.class);
        router.attach("/education", EducationResource.class);
        router.attach("/goinggreen", GoingGreenResource.class);
        router.attach("/links", LinksResource.class);
        router.attach("/dashboard", DashboardResource.class);
        router.attach("/users", UserListResource.class);
        router.attach("/users/{id}", UserResource.class);
        router.attach("/surveys", SurveyListResource.class);
        router.attach("/surveys/{id}", SurveyResource.class);
        router.attach("/record", SurveyRecordResource.class);
        router.attach("/login", LoginResource.class);
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