package org.coralwatch.resources;

import au.edu.uq.itee.maenad.restlet.ModifiableEntityResource;
import au.edu.uq.itee.maenad.restlet.errorhandling.InitializationException;
import au.edu.uq.itee.maenad.restlet.errorhandling.NoDataFoundException;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionError;
import au.edu.uq.itee.maenad.restlet.errorhandling.SubmissionException;
import au.edu.uq.itee.maenad.util.BCrypt;
import org.coralwatch.app.CoralwatchApplication;
import org.coralwatch.dataaccess.UserDao;
import org.coralwatch.model.UserImpl;
import org.restlet.data.Form;
import org.restlet.resource.Variant;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


public class UserResource extends ModifiableEntityResource<UserImpl, UserDao, UserImpl> {
    private static final Logger LOGGER = Logger.getLogger(UserResource.class.getName());

    public UserResource() throws InitializationException {
        super(CoralwatchApplication.getConfiguration().getUserDao());
    }

    @Override
    protected void fillDatamodel(Map<String, Object> datamodel) throws NoDataFoundException {
        super.fillDatamodel(datamodel);
        UserImpl userImpl = (UserImpl) datamodel.get(getTemplateObjectName());
        datamodel.put("conductedSurveys", getDao().getSurveyEntriesCreated(userImpl));
        String emailHash = createMD5Hash(userImpl.getEmail());
        datamodel.put("gravatarUrl", "http://www.gravatar.com/avatar/" + emailHash + "?s=80&d=wavatar");
    }

    private static String createMD5Hash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(input.getBytes("UTF-8"));
            return bytesToString(hash);
        } catch (NoSuchAlgorithmException e) {
            // should really not happen since MD5 should be there
            LOGGER.log(Level.SEVERE, "Failed to find MD5 codec", e);
        } catch (UnsupportedEncodingException e) {
            // should really not happen since UTF-8 is guaranteed
            LOGGER.log(Level.SEVERE, "Failed to find UTF-8 encoding", e);
        }
        assert false : "We failed to MD5 encode a string.";
        return null;
    }

    private static String bytesToString(byte[] bytes) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < bytes.length; i++) {
            byte b = bytes[i];
            String hex = Integer.toHexString(0x00FF & b);
            if (hex.length() == 1) {
                sb.append("0");
            }
            sb.append(hex);
        }
        return sb.toString();
    }


    @Override
    protected void updateObject(UserImpl userImpl, Form form) throws SubmissionException {
        List<SubmissionError> errors = new ArrayList<SubmissionError>();
        String newDisplayName = form.getFirstValue("displayName");
        if ((newDisplayName == null) || newDisplayName.length() < 6) {
            errors.add(new SubmissionError("No display name was provided. A display name of at least 6 characters must be supplied."));
        } else {
            userImpl.setDisplayName(newDisplayName);
        }
        String newPassword = form.getFirstValue("password");
        if ((newPassword != null) && (!newPassword.isEmpty())) {
            if (newPassword.length() < 6) {
                errors.add(new SubmissionError("No password was provided. A password of at least 6 characters must be supplied."));
            } else if (!newPassword.equals(form.getFirstValue("password2"))) {
                errors.add(new SubmissionError("Passwords don't match"));
            } else {
                userImpl.setPasswordHash(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            }
        }

        String email = form.getFirstValue("email");
        if ((email == null) || email.isEmpty()) {
            errors.add(new SubmissionError("No email was provided. An email address must be supplied."));
        } else {
            userImpl.setEmail(email);
        }

        if (!errors.isEmpty()) {
            throw new SubmissionException(errors);
        }
    }

    @Override
    protected boolean getAllowed(UserImpl userImpl, Variant variant) {
        //Only logged in users and super users can edit profiles
        //Logged in users can only edit their own profile
        long id = Long.valueOf((String) getRequest().getAttributes().get("id"));
        UserDao dao = getDao();
        UserImpl userObj = dao.load(id);
        return getAccessPolicy().getAccessLevelForInstance(userImpl, userObj).canRead();
    }

}