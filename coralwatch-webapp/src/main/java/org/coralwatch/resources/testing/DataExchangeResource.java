package org.coralwatch.resources.testing;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.coralwatch.app.ApplicationContext;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.model.UserImpl;
import org.coralwatch.resources.DataDownloadResource;
import org.restlet.data.MediaType;
import org.restlet.ext.fileupload.RestletFileUpload;
import org.restlet.resource.Representation;
import org.restlet.resource.ResourceException;

import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.TechnicalSubmissionError;

public class DataExchangeResource extends DataDownloadResource {
    public DataExchangeResource() throws InitializationException {
        super();
        setModifiable(true);
    }

    @Override
    public void protectedAcceptRepresentation(Representation entity) throws ResourceException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        if (entity != null) {
            if (MediaType.MULTIPART_FORM_DATA.equals(entity.getMediaType(), true)) {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                factory.setSizeThreshold(1000240);

                RestletFileUpload upload = new RestletFileUpload(factory);
                List<FileItem> items;
                InputStream dataStream = null;
                boolean deleteData = false;
                try {
                    items = upload.parseRequest(getRequest());
                    for (FileItem fi : items) {
                        if (fi.getFieldName().equals("upfile")) {
                            Logger.getLogger(getClass().getName()).log(Level.INFO, "Found file");
                            dataStream = fi.getInputStream();
                        } else if (fi.getFieldName().equals("resetData")) {
                            deleteData = fi.getString().equalsIgnoreCase("true");
                        }
                    }
                    if (dataStream == null) {
                        errors.add(new SubmissionError("No file uploaded"));
                    } else {
                        if (deleteData) {
                            ((ApplicationContext) CoralwatchApplication.getConfiguration()).resetDatabase();
                        }
                        HSSFWorkbook workbook = new HSSFWorkbook(dataStream);
                        readSurveys(workbook);
                    }
                } catch (Exception e) {
                    Logger.getLogger(getClass().getName()).log(Level.INFO, "File upload failed", e);
                    errors
                            .add(new TechnicalSubmissionError("File upload failed (maybe the input could not be read)",
                                    e));
                } finally {
                    if (dataStream != null) {
                        try {
                            dataStream.close();
                        } catch (IOException e) {
                            // not much we can do here, just log the problem, otherwise ignore
                            Logger.getLogger(getClass().getName()).log(Level.WARNING,
                                    "Closing input stream from browser upload failed", e);
                        }
                    }
                }
            }
        } else {
            errors.add(new SubmissionError("No upload data found"));
        }
        if (!errors.isEmpty()) {
            getContext().getAttributes().put("errors", errors);
            String baseUrl = CoralwatchApplication.getConfiguration().getBaseUrl();
            if (baseUrl != null) {
                getResponse().redirectSeeOther(baseUrl + "/error");
            } else {
                getResponse().redirectSeeOther(getRequest().getRootRef().addSegment("error"));
            }
        }
    }

    private void readSurveys(HSSFWorkbook workbook) {
    }

    @Override
    protected boolean postAllowed(UserImpl user, Representation entity) {
        return user.isSuperUser();
    }
}
