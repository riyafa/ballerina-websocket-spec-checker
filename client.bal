import ballerina/io;
import ballerina/log;
import ballerina/http;

int currentCaseId = 0;
int caseCounts = 0;
string ws_uri = "ws://localhost:9001";
public function main() {
    openWebSocket(ws_uri + "/getCaseCount");
}
function openWebSocket(string url) {
    http:WebSocketClient wsClientEp = new(url, config = {callbackService: basic});
}
service basic = @http:WebSocketServiceConfig {
    maxFrameSize: 1000000000
}
service {
    resource function onText(http:WebSocketClient caller, string text, boolean finalFrame) {
        if (currentCaseId == 0){
            var val = int.constructFrom(text);
            if (val is int){
                caseCounts = <@untainted>val;
            }
            log:printInfo("case counts: " + text);
        } else {
            var result = caller->pushText(text, finalFrame = finalFrame);
            
                if (result is error) {
                    log:printError("Error sending text response", err = result);
                    if (caller.isOpen()){
                        log:printInfo("In onText resource");
                        var err = caller->close(); if (err is error) 
                        {
                            log:printError("Error closing connection", err = err);
                             }
                        execute();
                    }
                }
            
            

        }
    }
    resource function onBinary(http:WebSocketClient caller, byte[] b, boolean finalFrame) {
        var result = caller->pushBinary(b, finalFrame = finalFrame);
            if (result is error) {
                log:printError("Error sending binary response", err = result);
                if (caller.isOpen()){
                    log:printInfo("In onBinary resource");
                    var err = caller->close(); 
                    if (err is error) { 
                         log:printError("Error closing connection", err = err) ;
                         }
                    execute();
                }
            }
        
        

    }
    resource function onClose(http:WebSocketClient caller, int statusCode, string reason) {
        log:printInfo("In onClose resource");
        execute();
    }
    resource function onError(http:WebSocketClient caller, error err) {
        log:printError("In onError resource", err = err);
        execute();
    }
    resource function onIdleTimeout(http:WebSocketClient caller) {
        log:printInfo("onIdleTimout hit");
        if (caller.isOpen()){
            log:printInfo("In onIdleTimout resource");
            var err = caller->close();
            if (err is error) { 
                log:printError("Error closing connection", err = err) ;
                }
            execute();
        }
    }
};

function execute() {
    currentCaseId = currentCaseId + 1;
    if (currentCaseId <= caseCounts) {
        log:printInfo("Executing test case " + currentCaseId.toString() + "/" + caseCounts.toString());
        openWebSocket(ws_uri + "/runCase?case=" + currentCaseId.toString() + "&agent=ballerinax");
    } else if (currentCaseId == caseCounts + 1) {
        openWebSocket(ws_uri + "/updateReports?agent=ballerinax");
    }
}
