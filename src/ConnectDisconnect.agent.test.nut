class ConnectDisconnectTest extends TestBase {

    constructor(authToken) {
        _create(authToken);

        imp.wakeup(1, _run.bindenv(this));
    }

    function _run() {
        if (client == null) return;
        _connect();
    }

    function _disconnected() {
        print("Disconnected");
    }

    function _onconnected(rc) {
        print("OnConnected " + rc);

        if (rc == 0) {
            _disconnect();
        } else {
            print("Critical error. Test aborted");
        }
    }

    function _disconnect() {;
        base._disconnect();

        // try to avoid IP address ban
        imp.wakeup(::irand(10), _run.bindenv(this));
    }

    function _typeof() {
        return "ConnectDisconnectTest";
    }
}
