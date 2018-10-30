import ddf.minim.*;
import processing.opengl.*;
//final 
final int bx = 5;//ボードサイズ
final int by = 5;
final int bz = 5;
final float BnsT = 5;//ボーナス加算の時間（秒）
final float inity = 300;

//game
int score = 0;//点数
int minus = 0;//減点
long t_start;//タイム計測開始
float t;//解答タイム
float tsum;//合計解答タイム
int state;//状態遷移変数
//class
Board bd = new Board();
Mycamera cm;
MyPlayer mp;

//clearRect　クリアー処理
int crx,cry;//Rect Size
float distT;
int ansT; //正解の仕分け -1:fail 1:correct 2:good

void setup() {
  size(600, 600, P3D);
  frameRate(60);
  //初期化
  cm = new Mycamera();
  bd = new Board();
  //mp = new MyPlayer(new Minim(this));
  //mp.tick.loop();
  
  //ボードの初期化
  bd.set(bx, bz);
  //タイムの初期化
  t_start = millis();
  state = 1;//ゲームスタート


}

void draw() {
  background(255);
  if(state == 1){
    //state = 1　メインループ 
    t =(millis() - t_start) / 1000.0;//経過時間を取得
    fill(cCol);
    bd.show();
    cmCtr();
    txCtr();
  }else if(state == 2){
    //state = 2 クリア処理ループ
    //bd.show();
    clearRect();
    distT += 1.0/5.0;//1.0 / x ; xフレーム内で処理させる。
    cmCtr();
    txCtr();
    if(distT >= 1.0){
      state = 0;
      background(255);//1フレーム　ホワイトアウトを挟む/演出
    }
  }else if(state == 0){
    //state = 0 ボード初期化処理
    bd.restart();
    //mp.tick.loop();
    t_start = millis();
    state = 1;
  }
}

void keyPressed() {
  switch(key) {
    case '1':
      getScore(1);
      break;
    case '2':
      getScore(2);
      break;
    case '3':
      getScore(3);
      break;
    case '4':
      getScore(4);
      break;
    default:
      break;
  }   
}
//クリア処理
void pclear() {
  tsum += t;
  //mp.tick.pause();
  state = 2;//クリア処理の状態
  crx = width;
  cry = height; 
  distT = 0;
}

//クリア演出、四角形の描画
void clearRect(){
  fill(128,128,128);
  pushMatrix();
  camera();
  //distT が１になると画面中心で四角形が消滅する。
  rect((width / 2) * distT,(height / 2) * distT,
    crx * (1 - distT),cry * (1 - distT));
  popMatrix();
}

void cmCtr() {
  /**ほんとはベクトルで計算するべき,
   **キューブサイズや範囲を可変にした場合困る
   **ポジションは左奥下端から右手前上端からスカラー倍して求める。
   **視点については、左奥下端を見る（やや上？）    */
  cm.setEye(0, bd.groundY, -bz*bd.size);
  cm.setPos((bx)*bd.size, bd.groundY*0.3, 125);
}

void txCtr() {
  pushMatrix();
  camera();
  textSize(20);
  text("How much blocks in view?", 70, height*0.75, 80);
  fill(255,0,0);
  if(ansT == 0){
    text("How much blocks in view?"+bd.count,70,height*0.70,80);//debug行
  }else if(ansT == 2){
    text("You got a Bonus Score + 5!!", 70, height*0.70, 105);
  }else if(ansT == -1){
    //解答を間違えたとき
    text("Miss! ( Score - 3!! )", 70, height*0.70, 105);    
  }else{
    text("You got a Score + 2!!", 70, height*0.70, 105);  
  }
  popMatrix();
  txAns();
  txScore();
}
//スコアとタイム表示
void txAns() {
  int nans = bd.ans.length;
  pushMatrix();
  camera();
  textSize(25);
  fill(0);
  //解答と対応したキーを表示
  for (int i = 0; i < nans; i++) {
    text(i+1, 90 + i * width / 6, height*0.8, 80);
  }
  //回答用意
  for (int i = 0; i < nans; i++) {
    if (bd.pans[i] == false) {
      fill(0);
      text(bd.ans[i], 90 + i * width / 6, height*0.85, 80);
    } else {
      fill(255, 0, 0);
      text("×", 90 + i * width / 6, height*0.85, 80);
    }
  }
  popMatrix();
}
//スコアとタイム表示
void txScore() {
  pushMatrix();
  camera();
  textSize(25);
  fill(0);
  text("SCORE : " + (score + minus), 90, height*0.90, 80);
  text("Time : "+ ((int)t) + "s("+ (int)tsum +"s)", width/2, height*0.90, 80);
  popMatrix();
}
//回答の採点処理
void getScore(int a) {
  if (bd.pans[a-1] == false) {//すでに解答済みであれば処理なし 
    boolean c = bd.pAns(a);//a番と解答された
    if (c) {
      score += 2;
      if(t <= BnsT && ansT != -1){//不正解せず、ボーナス時間内に回答ができた。
        score += 3;
        ansT = 2;
        //mp.good.rewind();
        //mp.good.play();
      }else{
        ansT = 1;
        //mp.correct.rewind();
        //mp.correct.play();
     }
     pclear();
    } else {
      minus -= 3; 
      ansT = -1;//間違えた
      //mp.fail.rewind();
      //mp.fail.play();
    }
  }
}
