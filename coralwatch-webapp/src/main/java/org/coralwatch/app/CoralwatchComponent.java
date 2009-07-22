package org.coralwatch.app;

import org.restlet.Component;
import org.restlet.data.Protocol;


public class CoralwatchComponent extends Component {

    public CoralwatchComponent() {
        getServers().add(Protocol.HTTP, CoralwatchApplication.getConfiguration().getHttpPort());
        getClients().add(Protocol.CLAP);
        getDefaultHost().attach(new CoralwatchApplication());
    }
}