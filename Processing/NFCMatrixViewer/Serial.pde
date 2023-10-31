
void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) >= 'A' && inData.charAt(0) <= 'P') {
    int j = inData.charAt(0)-'A';
    String[] v = split(trim(inData.substring(1)), ',');
    for (int bitIndex = 0; bitIndex < IDBitNum; bitIndex++) {
      int id= int(v[bitIndex]);
      nfcs.rfid[bitIndex] = (id>255?-1:id);
      coilUID[j][bitIndex] = nfcs.rfid[bitIndex];
    }
    if (j==(coilNum-1)) ++frameID;
  }
  return;
}
