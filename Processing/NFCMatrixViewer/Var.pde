import processing.serial.*;
Serial port;
OpenNFCSense4P nfcs;

int frameID = 0;
int lastFrameID = 0;
int tagNum = 56;
float coilW = 25;
float coilH = 25;
int IDBitNum = 4;
int coilNum = 16;
int TTL_TIMER = 3;

int[][] coilUID = new int[coilNum][IDBitNum];
float[] coilX = {0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3};
float[] coilY = {1, 0, 0, 1, 1, 0, 0, 1, 3, 2, 2, 3, 3, 2, 2, 3};;

ArrayList sheetID = new ArrayList();
ArrayList sheetCell = new ArrayList();
int[] sheetCoilID = new int[coilNum];
int[] ttlTimer = new int[tagNum];
