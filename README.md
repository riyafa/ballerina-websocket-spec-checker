# ballerina-websocket-spec-checker
For checking spec compliancy of Ballerina WebSocket implementation

- Install `virtualenv`
- Run autobahn test suite:
  ```
  virtualenv ~/wstest
  source ~/wstest/bin/activate
  pip install autobahntestsuite
  ```
  ## To test the server
  
- Start Ballerina WebSocket server:
  `ballerina run server.bal`
  
- Start autobahn client:
  ```
  cd ~
  mkdir test
  cd test
  wstest -m fuzzingclient
  ```

- Find the reports in `~/test/reports/servers`

## To test the client

- Start autobahn client:
  ```
  cd ~
  mkdir test
  cd test
  wstest -m fuzzingserver
  ```

- Start Ballerina WebSocket client:
  `ballerina run client.bal`
- Find the reports in `~/test/reports/clients`

Reports are hosted in the following locations:

http://riyafa.github.io/Riyafa-Abdul-Hameed--web-page/others/reports/servers/

http://riyafa.github.io/Riyafa-Abdul-Hameed--web-page/others/reports/clients/

**Note**: There is an issue with the `client.bal` used here because it tries to run tests in parallel which causes some tests
to be missing in the report.
