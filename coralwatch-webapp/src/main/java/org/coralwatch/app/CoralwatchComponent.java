package org.coralwatch.app;

import org.restlet.Component;
import org.restlet.data.Protocol;

/**
 * @autho alabri
 * Date: 18/05/2009
 * Time: 12:00:50 PM
 */
public class CoralwatchComponent extends Component {

    public CoralwatchComponent() {
        getServers().add(Protocol.HTTP, CoralwatchApplication.getConfiguration().getHttpPort());
        getClients().add(Protocol.CLAP);
        getDefaultHost().attach(new CoralwatchApplication());
    }
}