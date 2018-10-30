
class Tumiki{
  float x, y, z;
  int size,n;
  
  Tumiki(float _x, float _y,float _z, int _size){
    x = _x;
    y = _y;
    z = _z;
    size = _size;
    n = 1;
  }
  //積み木の描画
  void display(){
    pushMatrix();
    translate(x,y,z);
    for(int i =0;i<n;i++){
      fill(255,255,255);
      translate(0,-size,0);
      box(size);
    }
    popMatrix();
  }
  //積み木を積む
  void stack(int num){
    if(num + n < 10) n += num;
  }
  //積み木を0にする
  void nothing(){
    n = 0;
  }
}
