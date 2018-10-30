final int cubesize = 50;
final color cCol =  color(255,255,255);


class Board{
  int bx , bz;
  int size;
  int cnum;
  int count;
  int[] ans = new int[4]; //回答候補を格納する。
  boolean[] pans = new boolean[4]; //プレイヤーの回答結果を格納する。
  float groundY = height * 0.8;
  Tumiki[][] bxs;
  
  Board(){
    size = cubesize;
    cnum = 4;
    count = 0;
  }
  
  //x*zの積み木を用意する
  void set(int x, int z){
    //初期化
    bx = x;
    bz = z;
    count = 0;
    bxs = new Tumiki[x][z];
    for(int _x = 0; _x < x; _x++){
     for(int _z = 0; _z < z; _z++){
       bxs[_x][_z] =  new Tumiki(_x * size,
          groundY,
          -(size + (_z * size)),
          size);
      //　手前に範囲が被る場合積み木を置かない
      if(_x == 0 || _z == z - 1) {
        //高さをランダムに設定する
        bxs[_x][_z].stack((int)random(5));
        //一番端の積み木が隠れる場合,高さを0以上にする
        if(_z == z - 1)
          if( bxs[_x][_z - 1].n > bxs[_x][_z].n )
            bxs[_x][_z].stack(bxs[_x][_z - 1].n - bxs[_x][_z].n);
      } else{
        bxs[_x][_z].nothing();
      }
      //正解をカウントする。
      count += bxs[_x][_z].n;
      ans();
     }
    }
  }
  //用意した積み木の描画
  void show(){
    directionalLight(255, 255, 255, -1, -0.5, -1);
    for(int x = 0; x <bxs.length; x++){
     for(int z = 0; z < bxs[x].length;z++){
         bxs[x][z].display();
     }
    }
  }
  //プレイヤーが回答する。
  //すでに回答済みであれば、falseを返す。
  boolean pAns(int a){
   if(ans[a - 1] == count){
     return true; //正解
   }else {
     pans[a - 1] = true;
     return false;
   }
  }
  //回答候補を用意する。
  void ans(){
    ans = new int[4];
    pans = new boolean[4];
    int a = (int)random(4); //正解の番号の添え字
    for(int i=0;i<ans.length;i++) ans[i] = count + i - a; 
    for(int i=0;i<pans.length;i++) pans[i] = false; 
  }
  void restart(){
    this.set(bx,bz);
  }
}
