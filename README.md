# Stress tests for _mqtt_ API

## Running

To build the test you should use builder on `agent.nut`. The **IOT_HUB_CONNECTION** variable should be set in environment with correct Azure Auth Token.

## Test Description 

### [CreateClientTest](./src/test1.nut)

Opens/closes _mqtt_ clients in a loop

### [ConnectDisconnectTest](./src/test2.nut)

Connects/disconnects the client in a loop

### [Device2CloudTest](./src/test3.nut)

Simple messaging test

### [SubscribeTest](./src/test.4.nut)

Simple application test with subscriptions and cloud2device messages