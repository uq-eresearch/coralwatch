package org.coralwatch.resources;

import org.restlet.resource.Resource;
import org.restlet.resource.Variant;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;
import org.restlet.data.MediaType;
import org.restlet.ext.freemarker.TemplateRepresentation;
import org.coralwatch.app.CoralwatchApplication;
import freemarker.template.Configuration;
import freemarker.cache.ClassTemplateLoader;

import java.util.Map;
import java.util.HashMap;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 4:21:09 PM
 */
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
