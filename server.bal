import ballerina/log;
import ballerina/http;

@http:WebSocketServiceConfig {
    maxFrameSize: 1000000000
}
service on new http:WebSocketListener(9001) {
    resource function onText(http:WebSocketCaller caller, string text, boolean finalFrame) {
        var err = caller->pushText(text, finalFrame=finalFrame);
        if (err is error) {
            log:printError("Error sending text", err = err);
        }
    }
    resource function onBinary(http:WebSocketCaller caller, byte[] b, boolean finalFrame) {
        var err = caller->pushBinary(b, finalFrame=finalFrame);
        if (err is error) {
            log:printError("Error sending binary", err = err);
        }

    }
    resource function onPing(http:WebSocketCaller caller, byte[] data) {
        var err = caller->pong(data);
        if (err is error) {
            log:printError("Error sending pong", err = err);
        }
    }

    resource function onError(http:WebSocketCaller caller, error err) {
        log:printError("Error occurred: ", err = err);
    }
    resource function onClose(http:WebSocketCaller caller, int statusCode, string reason) {
        log:printInfo(string `Client left with {{statusCode}} because {{reason}}`);
    }
}
