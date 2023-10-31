void drawTagSheets() {
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 0*H*K_H*unit);
    fill(255);
    noStroke();
    rect(0, 0, W*unit, H*K_H*unit);
    popMatrix();
  }
  for (int i = 4; i < sheetID.length; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 0*H*K_H*unit);
    fill(255);
    noStroke();
    rect(0, 0, W*unit, 5*K_H*unit);
    popMatrix();
  }
}


void drawRawData() {
  for (int i = 0; i < sheetID.length; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 0*H*K_H*unit);
    for (int w=0; w<W; w++) {
      for (int h=0; h<H; h++) {
        int id = h*W+w;
        PVector p = getLocation(id, 0, 0);
        fill(200, ttlTimer[i][w][h]*255);
        ellipse(p.x, p.y, unit, unit);
      }
    }
    for (int j = 0; j<sheetID[i].size(); j++) {
      int id = (int)sheetID[i].get(j);
      PVector p = getLocation(id%(W*H), 0, 0);
      fill(0);
      ellipse(p.x, p.y, 5, 5);
      text(id, p.x, p.y);
    }
    popMatrix();
  }
}

void drawRawFeatures() {
  for (int i = 0; i < sheetID.length; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 0*H*K_H*unit);
    for (int a = 0; a < A; a++) {
      stroke(colors[a]);
      for (int n = 0; n < sheetPiVec[i][a].size(); n++) {
        int IDN = (int)sheetPiVec[i][a].get(n) % (W*H);
        int IDM = (int)sheetPjVec[i][a].get(n) % (W*H);
        PVector pi = getLocation(IDN, 0, 0); 
        PVector pj = getLocation(IDM, 0, 0);
        line(pi.x, pi.y, pj.x, pj.y);
      }
    }
    popMatrix();
  }
}

void drawCells() {
  pushStyle();
  textAlign(CENTER, CENTER);
  fill(255);
  for (int i = 0; i < sheetID.length; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 1*H*K_H*unit);
    for (int j = 0; j < coilNum; j++) {
      if (sheetCoilID[i][j]>=0) {
        text(sheetCoilID[i][j], (locX[j]+.5)*coilW, (locY[j]+.5)*coilH);
      }
      for (int a = 0; a < A; a++) {
        stroke(colors[a]);
        pushMatrix();
        for (int n = 0; n < sheetPiVec[i][a].size(); n++) {
          int CellN = (int)sheetPiCell[i][a].get(n);
          int CellM = (int)sheetPjCell[i][a].get(n);
          line((locX[CellN]+.5)*coilW, (locY[CellN]+.5)*coilH, (locX[CellM]+.5)*coilW, (locY[CellM]+.5)*coilH);
        }
        popMatrix();
      }
    }
    popMatrix();
  }
  popStyle();
}

void drawResults() {
  for (int i = 0; i < sheetID.length; i++) {
    pushMatrix();
    translate(i*(W*unit+hGap), 1*H*K_H*unit + 4*coilH);
    String s = "";
    int thld = 0;
    float ma = 0;
    float n_feature = 0;
    float angleDiff = 0;
    float weightedA = 0;
    float totalWeights = 0;
    sheetLocA[i] = new PVector();
    float n_loc = 0;
    for (int a = 0; a < A; a+=2) {
      n_feature = sheetPiVec[i][a].size();
      ma = 0;
      s = "";
      stroke(colors[a]);
      angleDiff = a*PI*0.167;
      for (int n = 0; n < sheetPiVec[i][a].size(); n++) {
        int CellN = (int)sheetPiCell[i][a].get(n);
        int CellM = (int)sheetPjCell[i][a].get(n);
        PVector pic = new PVector((locX[CellN])*coilW, (locY[CellN])*coilH);
        PVector pjc = new PVector((locX[CellM])*coilW, (locY[CellM])*coilH);
        float angle = atan2(pic.y-pjc.y, pic.x-pjc.x);
        angle -= angleDiff;
        if (angle< -PI) angle = TWO_PI+angle;
        if (angle> PI) angle = TWO_PI-angle;
        s+= nf(degrees(angle), 0, 1)+",";
        ma+=angle;
      }
      if (n_feature>thld) { 
        ma /= n_feature;
        //pushMatrix();
        //translate(0, H*K_H*unit+a*coilH);
        //pushStyle();
        //fill(0);
        //textSize(14);
        //textAlign(LEFT, TOP);
        //text((int)n_feature+":"+nf(degrees(ma), 0, 2)+"|"+s, 10, 24);
        //popStyle();
        //popMatrix();
        weightedA += ma * (n_feature-thld);
        totalWeights += (n_feature-thld);
      }
    }
    weightedA /= totalWeights;

    for (int w=0; w<W; w++) {
      for (int h=0; h<H; h++) {
        int id = h*W+w;
        PVector p = getLocation(id, 0, 0);
        if (ttlTimer[i][w][h] > 0.5){ 
          sheetLocA[i].add(p);
          ++n_loc;
        }
      }
    }
    //for (int j = 0; j<sheetID[i].size(); j++) {
    //  //int id = (int)sheetID[i].get(j);
    //  //int c = (int)sheetCell[i].get(j);
    //  //PVector p = getLocationA(id%(W*H), (locX[c]-1.5)*coilW, (locY[c]-1.5)*coilH, weightedA);
    //  //PVector p = getLocation(id%(W*H), (locX[c]-1.5)*coilW, (locY[c]-1.5)*coilH);
    //  //fill(255, 0, 0);
    //  //ellipse(p.x, p.y, 5, 5);
    //  //text(id, p.x, p.y);
    //  //sheetLocA[i].add(p);

    //}
    if (n_loc>0) {
      sheetLocA[i].div(n_loc);
      sheetLastA[i] = weightedA;
      PVector sheet = new PVector (sheetLocA[i].x, sheetLocA[i].y);
      fill(0, 128, 255, 128);
      noStroke();
      ellipse(sheet.x, sheet.y, 30, 30);
      arc(sheet.x, sheet.y, 40, 40, -PI, sheetLastA[i] );

      //if (n_feature>1) {
        
      //}
    }
    popMatrix();
  }
}
