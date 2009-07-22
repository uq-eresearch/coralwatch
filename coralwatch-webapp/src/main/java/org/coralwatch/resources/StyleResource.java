package org.coralwatch.resources;

import freemarker.cache.ClassTemplateLoader;
import freemarker.template.Configuration;
import org.coralwatch.app.CoralwatchApplication;
import org.restlet.data.MediaType;
import org.restlet.ext.freemarker.TemplateRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.Resource;
import org.restlet.resource.ResourceException;
import org.restlet.resource.Variant;

import java.util.HashMap;
import java.util.Map;


public class StyleResource extends Resource {

    private final String templatePath = "/templates/";
    private final String templateName = "style.css";

    public StyleResource() {
        super();
        getVariants().add(new Variant(MediaType.TEXT_CSS));
    }

    @Override
    public Representation represent(Variant variant) throws ResourceException {
        if (MediaType.TEXT_CSS.equals(variant.getMediaType())) {
            final Configuration configuration = new Configuration();
            Map<String, Object> datamodel = new HashMap<String, Object>();
            String baseUrl = CoralwatchApplication.getConfiguration().getBaseUrl();
            if(baseUrl!= null) {
                datamodel.put("baseUrl", baseUrl);
            } else {
                datamodel.put("baseUrl", getRequest().getRootRef().toString());
            }
            configuration.setTemplateLoader(
                    new ClassTemplateLoader(this.getClass(), templatePath));
            return new TemplateRepresentation(templateName,
                    configuration, datamodel, MediaType.TEXT_CSS);
        }
        return null;
    }
}
