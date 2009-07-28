package org.coralwatch.app;

import org.restlet.Component;
import org.restlet.data.Protocol;


public class CoralwatchComponent extends Component {

    public CoralwatchComponent() {
        getServers().add(Protocol.HTTP, CoralwatchApplication.getConfiguration().getHttpPort());
        // make sure to add protocols in web.xml, too
        getClients().add(Protocol.CLAP);
        getClients().add(Protocol.FILE);
        getDefaultHost().attach(new CoralwatchApplication());
    }

    public static void main(String[] args) throws Exception {
        Component component = new CoralwatchComponent();
        component.start();
    }
}