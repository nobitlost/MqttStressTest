class SubscribeTest extends TestBase {

    _reqCounter = 0;
    topic = "$iothub/twin/res/#";

    constructor(authToken) {
        _create(authToken);

        imp.wakeup(1, _connect.bindenv(this));
    }

    function _run() {
        local nextMethod = ::irand(100);

        if (nextMethod < 33) {
            getCurrentStatus();
        } else if (nextMethod > 66) {
            local status = { "field1" : ::irand(100) };
            updateStatus(http.jsonencode(status));
        } else {
            restart();
        }
    }

    function restart() {
        print("Resubsribing");
        client.unsubscribe(topic, _onunsubscribe.bindenv(this));
    }

    function updateStatus(status) {
        print("Updating status...");
        local topic   = "$iothub/twin/GET/?$rid=" + _reqCounter;
        local message = client.createmessage(topic, status);
        message.sendasync(onUpdateStatus.bindenv(this));
        _reqCounter++;
    }

    function getCurrentStatus() {
        print("Retrieving current status...");
        local topic   = "$iothub/twin/PATCH/properties/reported/?$rid=" + _reqCounter;
        local message = client.createmessage(topic, "");
        message.sendasync(onCurrentStatus.bindenv(this));
        _reqCounter++;
    }

    function onCurrentStatus(err) {
        print("onCurrentStatus: err=" + err);
        imp.wakeup(1, _run.bindenv(this));
    }

    function onUpdateStatus(err) {
        print("onUpdateStatus: err=" + err );
        imp.wakeup(1, _run.bindenv(this));
    }

    function _subscribe() {
        print("Subscribing");
        local qos = 0; // AT_MOST_ONCE
        client.subscribe(topic, 0, _onsubscribe.bindenv(this));
    }

    function _onsubscribe(rc, qos) {
        print("OnSubsribe " + rc + " " + qos);

        if (rc == 0) {
            _run();
        } else {
            print("Critical error. Could not subscribe");
        }
    }

    function _onunsubscribe(rc) {
        print("OnUnSubsribe: " + rc);

        if (rc == 0) {
            _subscribe();
        } else {
            print("Can't unsubscribe");
            print("Continue as SUBSCRIBED");
            imp.wakeup(1, _run.binenv(this));
        }
    }

    function _onconnected(rc) {
        print("OnConnected " + rc);

        if (rc == 0) {
            _subscribe();
        } else {
            print("Critical error. Test aborted");
        }
    }

    function _typeof() {
        return "SubscribeTest";
    }
}
