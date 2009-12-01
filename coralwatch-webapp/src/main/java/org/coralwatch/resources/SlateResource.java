package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.AccessControlledResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import org.coralwatch.model.UserImpl;
import org.restlet.data.MediaType;
import org.restlet.ext.freemarker.TemplateRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.HashMap;
import java.util.Map;


public class SlateResource extends AccessControlledResource<UserImpl> {
    private final String templatePath = "/templates/";
    private final String templateName = "slate.html.ftl";

    public SlateResource() throws InitializationException {
        super();
        getVariants().add(new Variant(MediaType.TEXT_HTML));
    }

    @Override
    protected Representation protectedRepresent(Variant variant) throws ResourceException {
        if (MediaType.TEXT_HTML.equals(variant.getMediaType())) {
            final Configuration configuration = new Configuration();
            Map<String, Object> datamodel = new HashMap<String, Object>();
            String baseUrl = getBaseUrl();
            if (baseUrl != null) {
                datamodel.put("baseUrl", baseUrl);
            } else {
                datamodel.put("baseUrl", getRequest().getRootRef().toString());
            }
            configuration.setTemplateLoader(
                    new ClassTemplateLoader(this.getClass(), templatePath));
            return new TemplateRepresentation(templateName,
                    configuration, datamodel, MediaType.TEXT_HTML);
        }
        return null;
    }

    @Override
    protected boolean getAllowed(UserImpl user, Variant variant) throws ResourceException {
        return true;
    }
}
