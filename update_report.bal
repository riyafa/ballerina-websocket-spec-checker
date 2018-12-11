import ballerina/http;

string ws_uri = "ws://localhost:9001";
public function main() {
    http:WebSocketClient wsClientEp = new(ws_uri + "/updateReports?agent=ballerinax");
}