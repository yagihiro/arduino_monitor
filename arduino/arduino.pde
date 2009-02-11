/*
 * Arduino monitor
 * 
 */
#include <Ethernet.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 10, 177 };

Server server(80);

void setup() {
  Ethernet.begin(mac, ip);
  server.begin();
}

void loop() {
  Client client = server.available();
  if (client) {
    // an http request ends with a blank line
    boolean current_line_is_blank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        if (c == '\n' && current_line_is_blank) {
          // output all pin value as json. 
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: application/json; charset=utf-8");
          client.println();
          client.print("{\"analogs\": [");
          for (int i = 0; i < 6; i++) {
            client.print(analogRead(i));
            if (i != 5) client.print(",");
          }
          client.print("], \"digitals\": [");
          for (int i = 0; i < 14; i++) {
            client.print(digitalRead(i));
            if (i != 13) client.print(",");
          }
          client.print("]}");
          break;
        }
        if (c == '\n') {
          // we're starting a new line
          current_line_is_blank = true;
        } else if (c != '\r') {
          // we've gotten a character on the current line
          current_line_is_blank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    client.stop();
  }
}
