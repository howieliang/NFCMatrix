/*========================================================================== 
 //  OpenNFCSense4P (v2) - Open NFCSense API for Processing Language
 //  Copyright (C) 2021 Dr. Rong-Hao Liang
 //    This program is free software: you can redistribute it and/or modify
 //    it under the terms of the GNU General Public License as published by
 //    the Free Software Foundation, either version 3 of the License, or
 //    (at your option) any later version.
 //
 //    This program is distributed in the hope that it will be useful,
 //    but WITHOUT ANY WARRANTY; without even the implied warranty of
 //    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 //    GNU General Public License for more details.
 //
 //    You should have received a copy of the GNU General Public License
 //    along with this program.  If not, see <https://www.gnu.org/licenses/>.
 //==========================================================================*/
// e0_App_Boilerplate.pde:
// This software works with a microcontroller running Arduino code and connected to an RC522 NFC/RFID Reader
// OpenNFCSense API Github repository: https://github.com/howieliang/OpenNFCSense
// NFCSense Project website: https://ronghaoliang.page/NFCSense/

boolean debug = false;

void setup() {
  size(600, 600);
  frameRate(60);
  nfcs = new OpenNFCSense4P("tagProfileA.csv"); //Initialize OpenNFCSense with the tag profiles (*.csv) in /data
  
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]); //print the serial port
  port = new Serial(this, Serial.list()[Serial.list().length-1], 115200); //for Mac and Linux 
  // port = new Serial(this, Serial.list()[0], 115200); // for PC
  port.bufferUntil('\n');           // arduino ends each data packet with a carriage return 
  port.clear();                     // flush the Serial buffer
  
  initNFCMat();
}

void draw() {
  nfcs.updateNFCBits();             //update the features of current bit
  if (frameID>lastFrameID) {
    updateNFCMat();
    updateTTLTimer();
    background(255);
    drawCells();
    lastFrameID = frameID;
  }
  if (debug) printCurrentTag();
}

//print the current tag read by the reader
void printCurrentTag() {
  if (nfcs.rfid[0]<0) println("No tag");
  else println(nfcs.rfid[0], ",", nfcs.rfid[1], ",", nfcs.rfid[2], ",", nfcs.rfid[3]);
}
