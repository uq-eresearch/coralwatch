package org.coralwatch.app;

import au.edu.uq.itee.maenad.restlet.CachingDirectory;
import au.edu.uq.itee.maenad.restlet.auth.AccessPolicy;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.model.FrameDataProvider;
import org.coralwatch.resources.AboutResource;
import org.coralwatch.resources.EducationResource;
import org.coralwatch.resources.FrontpageResource;
import org.coralwatch.resources.GraphsResource;
import org.coralwatch.resources.LinksResource;
import org.coralwatch.resources.StyleResource;
import org.restlet.Application;
import org.restlet.Component;
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
        router.attach("/graphs", GraphsResource.class);
        router.attach("/education", EducationResource.class);
        router.attach("/links", LinksResource.class);
        router.attach("/style.css", StyleResource.class);
        router.attach("/icons", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/icons")));
        router.attach("/documents", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/documents")));
        router.attach("/javascript", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/javascript")));
        router.attach("/images", new CachingDirectory(getContext(),
                LocalReference.createClapReference(LocalReference.CLAP_THREAD, "/images")));
        return router;
    }

    public static void main(String[] args) throws Exception {
        Component component = new CoralwatchComponent();
        component.start();
    }

}