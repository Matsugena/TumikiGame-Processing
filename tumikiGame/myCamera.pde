class Mycamera{
  PVector eye,pos,dir;
  float arcx,arcy,arcz;
  Mycamera(){
    pos = new PVector();
    pos.x = 0;
    pos.y = 0;
    pos.z = 500;
    dir = new PVector();
    dir.x = 0.0;
    dir.y = 1.0;
    dir.z = 0.0;
    eye = new PVector();
  }
  //カメラのポジションリセット
  void reset(){
    camera(pos.x,pos.y,pos.z,
           eye.x,eye.y,eye.z,
           dir.x,dir.y,dir.z); 
  }
  //注視点の設定
  void setEye(float ex,float ey, float ez){
       eye = new PVector(ex,ey,ez);
       reset();
 }
 //カメラ位置の指定
 void setPos(float px,float py, float pz){
    pos.x = px;
    pos.y = py;
    pos.z = pz;
    reset();
 }
}
