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

float a = 0;
float lastA = 0;

void setup() {
  size(1200, 600);              //Start a 800x600 px canvas (using P2D renderer)
  frameRate(60);
  nfcs = new OpenNFCSense4P("tagProfile.csv", 250, 500, 2000); //Initialize OpenNFCSense with the tag profiles (*.csv) in /data
  initSerial();          
  initNFCMat();
}

void draw() {
  nfcs.updateNFCBits();             //update the features of current bit
  //frame update
  if (frameID>lastFID) {
    int tempFID = frameID;
    resetNFCMat();
    updateNFCMat();
    updateTTLTimer();
    featureExtration();
    lastFID = tempFID;
  }

  //DRAW
  background(200);                  
  textSize(12);
  translate(hGap, vGap);

  pushMatrix();
  drawTagSheets();
  translate(0, 1*H*K_H*unit + 4*coilH);
  drawTagSheets();
  popMatrix();

  pushMatrix();
  translate(5, 10);
  drawRawData();
  drawRawFeatures();
  popMatrix();

  pushMatrix();
  translate((W*unit-4*coilH)/2, 0);
  drawCells();
  popMatrix();

  pushMatrix();
  translate(5, 10);
  drawResults();
  popMatrix();
  //Raw Data
}


PVector getLocation(int id, float offX, float offY) {
  float x = -1;
  float y = -1;
  if (id>=0) {
    float iX = (id % W);
    float iY = (id / W);
    if (iY % 2 ==0) {
      x = iX*unit;
      y = iY*unit*K_H;
    } else {
      x = (iX+0.5)*unit;
      y = iY*unit*K_H;
    }
    return new PVector(x-offX, y-offY, id);
  } else { 
    return new PVector(-1, -1, -1);
  }
}

PVector getLocationA(int id, float offX, float offY, float a) {
  float x = -1;
  float y = -1;
  if (id>=0) {
    id%=(W*H);
    float iX = (id % W);
    float iY = (id / W);
    if (iY % 2 ==0) {
      x = iX*unit;
      y = iY*unit*K_H;
    } else {
      x = (iX+0.5)*unit;
      y = iY*unit*K_H;
    }
    return new PVector(x- (offX*cos(a)-offY*sin(a)), y-(offX*sin(a)+offY*cos(a)), id);
  } else { 
    return new PVector(-1, -1, -1);
  }
}

/*Initialize the serial port*/
void initSerial() {             
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]); //print the serial port
  port = new Serial(this, Serial.list()[Serial.list().length-1], 115200); //for Mac and Linux 
  // port = new Serial(this, Serial.list()[0], 115200); // for PC
  port.bufferUntil('\n');           // arduino ends each data packet with a carriage return 
  port.clear();                     // flush the Serial buffer
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) >= 'A' && inData.charAt(0) <= 'P') {
    int j = inData.charAt(0)-'A';
    String[] v = split(trim(inData.substring(1)), ',');
    for (int i = 0; i < IDBitNum; i++) {
      int id= int(v[i]);
      nfcs.rfid[i] = (id>255?-1:id);
      coilUID[j][i]=nfcs.rfid[i];
    }
    //if (coilUID[j][0]>-1) println(inData.charAt(0));
    if (j==(coilNum-1)) ++frameID;
  }
  return;
}

//print the current tag read by the reader
void printCurrentTag() {
  if (nfcs.rfid[0]<0) println("No tag");
  else println(nfcs.rfid[0], ",", nfcs.rfid[1], ",", nfcs.rfid[2], ",", nfcs.rfid[3]);
}


//filtX = (lRate) * filtX + (1-lRate) *(mp.x/n);
//filtY = (lRate) * filtY + (1-lRate) *(mp.y/n);
//for (int j = 0; j < 16; j++) {
//  fill(0);
//  for (int i = 0; i < 4; i++) {
//    text(coilUID[j][i], (i+1)*50, (j+1)*40);
//  }
//}
//float n = IDLoc.size();

//if (n>2) {
//  //filtX = (lRate) * filtX + (1-lRate) *(mp.x/n);
//  //filtY = (lRate) * filtY + (1-lRate) *(mp.y/n);
//  fill(0, 0, 255);
//  ellipse(mp.x/n, mp.y/n, 10, 10);
//}
//arc(mp.x/n, mp.y/n, 20, 20, -PI, p_ma);
//fill(0, 255, 0, 200);
//ellipse(filtX, filtY, 15, 15);
