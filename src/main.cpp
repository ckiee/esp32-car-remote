#include <Arduino.h>
#include <WiFi.h>
const int right0 = 27;
const int right1 = 26;
const int left0 = 25;
const int left1 = 33;
const int diagPin = 34;
const int pins[] = {right0, right1, left0, left1};
#include "wifi_creds.h"
/* Includes:
 *
const char *ssid = "<ssid>";
const char *password = "<pw>";
 * */

WiFiServer sock(3333);

void setup() {
  Serial.begin(115200);
  pinMode(diagPin, INPUT);

  for (int i = 0; i <= 3; i++) {
    pinMode(pins[i], OUTPUT);
    ledcSetup(i, 50, 8); // 50hz, 8 bit res
    ledcWrite(i, 0);
    ledcAttachPin(pins[i], i);
  };

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  if (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.printf("WiFi connection failed: %x\n", WiFi.waitForConnectResult());
    return;
  }

  sock.begin();

  Serial.print("IP Address: ");
  Serial.print(WiFi.localIP());
  Serial.printf(":%d [tcp]\n", 3333);
}

void loop() {
  WiFiClient client = sock.available();
  if (client) {
    while (client.connected()) {
      if (client.available()) { // More data
        uint8_t buf[4] = {0, 0, 0, 0};
        client.read(buf, sizeof(buf));

        // no combinations of ON,ON per side
        if (buf[0] && buf[1])
          return;
        if (buf[2] && buf[3])
          return;

        for (int i = 0; i <= 3; i++) {
          Serial.printf("write(%d, %d)\n", i, buf[i]);
          ledcWrite(i, buf[i]);
        }

        uint8_t response[1] = {(uint8_t)analogRead(diagPin)};
        client.write(response, sizeof(response));
      }
      if (digitalRead(diagPin)) {
        // If the driver chip is mad, we wanna stop moving for a bit.
        for (int i = 0; i <= 3; i++) {
          ledcWrite(i, 255);
          sleep(2);
        }
      }
    }
  }
}
