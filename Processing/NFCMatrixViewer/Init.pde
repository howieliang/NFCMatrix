void initNFCMat() {
  sheetID = new ArrayList<Integer>();
  sheetCell = new ArrayList<Integer>();
  sheetCoilID = new int[coilNum];
  for (int tagID=0; tagID<tagNum; tagID++) {
      ttlTimer[tagID]=0;
  }
}

void updateTTLTimer() {
  for (int tagID=0; tagID<tagNum; tagID++) {
      if (ttlTimer[tagID]>0) ttlTimer[tagID] -= 1;
      //else ttlTimer[tagID] = 0;
  }
}

void updateNFCMat() {
  //reset
  sheetID.clear();
  sheetCell.clear();
  //update
  for (int coilID=0; coilID<coilNum; coilID++) {
    int tagID = nfcs.searchID(nfcs.id_db, nfcs.IDtoLong(coilUID[coilID]));   
    if (tagID>=0) { 
      sheetID.add(tagID);
      sheetCell.add(coilID);
      sheetCoilID[coilID] = tagID;
      ttlTimer[tagID] = TTL_TIMER;
    }
  }
}
