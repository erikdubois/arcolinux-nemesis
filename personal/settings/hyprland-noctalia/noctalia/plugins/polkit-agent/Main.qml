import QtQuick
import Quickshell
import Quickshell.Services.Polkit
import qs.Commons

Item {
    id: root
    property var pluginApi: null

    PolkitAgent {
        id: agent
        
        onIsActiveChanged: {
            if (isActive) {
                openWindow()
            } else {
                closeWindow()
            }
        }
    }

    property var window: null

    function openWindow() {
        if (agent.flow === null) {
            Logger.w("polkit-agent: Cannot open window, agent.flow is null");
            return;
        }
        if (window === null) {
            var component = Qt.createComponent("PolkitWindow.qml");
            if (component.status === Component.Ready) {
                window = component.createObject(root, {
                    flow: agent.flow,
                    pluginApi: root.pluginApi
                });
                if (window !== null) {
                    window.visible = true;
                }
            }
            component.destroy();
        } else {
            window.flow = agent.flow;
            window.pluginApi = root.pluginApi;
            window.visible = true;
        }
    }

    function closeWindow() {
        if (window !== null) {
            window.destroy();
            window = null;
        }
    }
}
