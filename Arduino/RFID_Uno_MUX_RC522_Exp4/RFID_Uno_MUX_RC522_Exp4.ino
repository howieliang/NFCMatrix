//*********************************************
// Arduino Codes for NFCSense,  which is based on
// - NXP MFRC522 NFC/RFID Reader (e.g., RFID RC522)
// - RFID.cpp Library (created by Dr. Leong and Miguel Balboa)
// for further information please check
// our website: https://ronghaoliang.page/NFCSense
// or contact Dr. Rong-Hao Liang (TU Eindhoven) via r.liang@tue.nl
//*********************************************
// Copyright <2021> Dr. Rong-Hao Liang
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#include <SPI.h>
#include "RFID.h"

// Define pin numbers for the MFRC522 module
#define SS_PIN 10
#define RST_PIN 9

// Define the number of bytes in the UID
#define UID_BYTEBUM 4

// Define the number of sensors
#define SENSOR_NUM 16

// Define the read rate (in Hz)
#define READ_RATE 250

long timer = micros(); // Timer for sending sensor data

RFID rfid(SS_PIN, RST_PIN);
int UID[UID_BYTEBUM]; 
char dataID[SENSOR_NUM] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'}; // Data label
int counter = 0;
int stored_last_ID[SENSOR_NUM * UID_BYTEBUM];

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Initialize SPI communication
  SPI.begin();

  // Initialize the RFID reader
  rfid.init();

  // Initialize UID array
  for (int i = 0 ; i < UID_BYTEBUM ; i++)  UID[i] = -1;

  // Set pins 4, 5, 6, and 7 as OUTPUT
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);

  // Set pins 4, 5, 6, and 7 to LOW
  digitalWrite(4, LOW);
  digitalWrite(5, LOW);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);

  // Initialize stored_last_ID array
  for (int i = 0; i < SENSOR_NUM; i++) {
    stored_last_ID[i] = -1;
  }
  counter = 0;
}

void loop() {
  // Check if it's time to send sensor data
  if ((micros() - timer >= (1000000 / READ_RATE))) { //Timer: send sensor data in every 10ms
    timer = micros();
    // Set the digital outputs based on the counter value
    // This appears to be setting a binary pattern on pins 4, 5, 6, and 7
    // to identify which sensor is being read
    // For example, counter = 0 sets all pins LOW (0000), counter = 1 sets pin 7 HIGH (1000), and so on.
    switch (counter) {
      case 0: digitalWrite(7, LOW); digitalWrite(6, LOW); digitalWrite(5, LOW); digitalWrite(4, LOW); break; // 0000
      case 1: digitalWrite(7, HIGH); digitalWrite(6, LOW); digitalWrite(5, LOW); digitalWrite(4, LOW); break; // 1000
      case 2: digitalWrite(7, LOW); digitalWrite(6, HIGH); digitalWrite(5, LOW); digitalWrite(4, LOW); break; // 0100
      case 3: digitalWrite(7, HIGH); digitalWrite(6, HIGH); digitalWrite(5, LOW); digitalWrite(4, LOW); break; // 1100
      case 4: digitalWrite(7, LOW); digitalWrite(6, LOW); digitalWrite(5, HIGH); digitalWrite(4, LOW); break; // 0010
      case 5: digitalWrite(7, HIGH); digitalWrite(6, LOW); digitalWrite(5, HIGH); digitalWrite(4, LOW); break; // 0010
      case 6: digitalWrite(7, LOW); digitalWrite(6, HIGH); digitalWrite(5, HIGH); digitalWrite(4, LOW); break; // 0110
      case 7: digitalWrite(7, HIGH); digitalWrite(6, HIGH); digitalWrite(5, HIGH); digitalWrite(4, LOW); break; // 1110
      case 8: digitalWrite(7, LOW); digitalWrite(6, LOW); digitalWrite(5, LOW); digitalWrite(4, HIGH); break; // 0001
      case 9: digitalWrite(7, HIGH); digitalWrite(6, LOW); digitalWrite(5, LOW); digitalWrite(4, HIGH); break; // 1001
      case 10: digitalWrite(7, LOW); digitalWrite(6, HIGH); digitalWrite(5, LOW); digitalWrite(4, HIGH); break; // 0101
      case 11: digitalWrite(7, HIGH); digitalWrite(6, HIGH); digitalWrite(5, LOW); digitalWrite(4, HIGH); break; // 1101
      case 12: digitalWrite(7, LOW); digitalWrite(6, LOW); digitalWrite(5, HIGH); digitalWrite(4, HIGH); break; // 0011
      case 13: digitalWrite(7, HIGH); digitalWrite(6, LOW); digitalWrite(5, HIGH); digitalWrite(4, HIGH); break; // 1011
      case 14: digitalWrite(7, LOW); digitalWrite(6, HIGH); digitalWrite(5, HIGH); digitalWrite(4, HIGH); break; // 0111
      case 15: digitalWrite(7, HIGH); digitalWrite(6, HIGH); digitalWrite(5, HIGH); digitalWrite(4, HIGH); break; // 1111
    }
    
    // Check if a card is detected
    if (rfid.isCard()) {
      if (rfid.readCardSerial()) {
        // Read the UID of the detected card
        for (int i = 0 ; i < UID_BYTEBUM ; i++)  UID[i] = rfid.serNum[i];
      }
    }
    else {
      // No card detected, set UID to 256 (absence)
      for (int i = 0 ; i < UID_BYTEBUM ; i++)  UID[i] = 256;
    }
    // Halt the RFID reader
    rfid.halt();
    
    // Send the data to processing
    sendDataToProcessingArray(dataID[counter], UID);
    
    // Increment the counter and reset if necessary
    counter += 1;
    if (counter > SENSOR_NUM) counter = 0;
  }

}

// Function to print UID in Serial Plotter
void printInSerialPlotter(int UID[]) { 
  for (int i = 0; i < UID_BYTEBUM; i++) {
    Serial.print(UID[i]);
    (i < (UID_BYTEBUM - 1) ? Serial.print(',') : Serial.println());
  }
}

// Function to send data to processing with a symbol
void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);  
  Serial.println(data);  
}

// Function to send data to processing with a symbol and an array of UID
void sendDataToProcessingArray(char symbol, int UID[]) {
  Serial.print(symbol); 
  Serial.print(UID[0]); 
  Serial.print(',');  
  Serial.print(UID[1]); 
  Serial.print(',');  
  Serial.print(UID[2]); 
  Serial.print(',');  
  Serial.print(UID[3]); 
  Serial.println();  
}
