

import processing.serial.*;
Serial port;
OpenNFCSense4P nfcs;

boolean debug = false;

int frameID = 0;
int lastFID = 0;

int N = 6;
int A = 6;
int W = 7;
int H = 8;
float K_H = 1.732/2;
float unit = 25; //mm
float coilW = 22.5;
float coilH = 22.5;
float hGap = 10;
float vGap = 10;
int IDBitNum = 4;
int coilNum = 16;

int[][] coilUID = new int[coilNum][IDBitNum];
float[] locID = {4, 0, 1, 5, 6, 2, 3, 7, 12, 8, 9, 13, 14, 10, 11, 15};
float[] locX = {0, 0, 1, 1, 2, 2, 3, 3, 0, 0, 1, 1, 2, 2, 3, 3};
float[] locY = {1, 0, 0, 1, 1, 0, 0, 1, 3, 2, 2, 3, 3, 2, 2, 3};

ArrayList<Integer> PiVec = new ArrayList<Integer>();
ArrayList<Integer> PjVec = new ArrayList<Integer>();
ArrayList<Integer> PiCell = new ArrayList<Integer>();
ArrayList<Integer> PjCell = new ArrayList<Integer>();
ArrayList<Float> ijAngle = new ArrayList<Float>();
ArrayList[] sheetID = new ArrayList[N];
ArrayList[] sheetCell = new ArrayList[N];
ArrayList[][] sheetPiVec = new ArrayList[N][A];
ArrayList[][] sheetPjVec = new ArrayList[N][A];
ArrayList[][] sheetPiCell = new ArrayList[N][A];
ArrayList[][] sheetPjCell= new ArrayList[N][A];
PVector[] sheetLocA = new PVector[N];
int[][] sheetCoilID = new int[N][coilNum];
float[] sheetLastA = new float[N];
color[] colors = {#F79F1F,#A3CB38,#1289A7,#D980FA,#B53471,#0652DD};
float[][][] ttlTimer = new float[N][W][H];
