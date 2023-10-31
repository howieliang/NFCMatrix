void drawCells() {
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(12); 
  fill(52);
  for (int j = 0; j < coilNum; j++) {
    if (sheetCoilID[j]>=0) {
      int id = sheetCoilID[j];
      if(ttlTimer[id]>0){ 
        if(!debug) text(id, (coilX[j]+.5)*coilW, (coilY[j]+.5)*coilH);
        else text(id+":"+ttlTimer[id], (coilX[j]+.5)*coilW, (coilY[j]+.5)*coilH);
      }else{
        sheetCoilID[j] = -1;
      }
    }
  }
  popStyle();
}
