package org.coralwatch.app;

import org.restlet.Component;
import org.restlet.data.Protocol;


public class CoralwatchComponent extends Component {

    public CoralwatchComponent() {
        getServers().add(Protocol.HTTP, CoralwatchApplication.getConfiguration().getHttpPort());
        getClients().add(Protocol.CLAP);
        getClients().add(Protocol.FILE);
        getDefaultHost().attach(new CoralwatchApplication());
    }

    public static void main(String[] args) throws Exception {
        Component component = new CoralwatchComponent();
        component.start();
    }
}