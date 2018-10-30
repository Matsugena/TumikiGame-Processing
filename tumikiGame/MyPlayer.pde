import ddf.minim.*;

  Minim minim; 
class MyPlayer{
  
  AudioPlayer correct;
  AudioPlayer fail;
  AudioPlayer tick;
  AudioPlayer good;
  
  MyPlayer(Minim _minim){
   minim = _minim; 
   setPlayer();
  }
  void setPlayer() {
    correct = minim.loadFile("correct.mp3");
    good = minim.loadFile("good.mp3");
    fail = minim.loadFile("fail.mp3");
    tick = minim.loadFile("tick.mp3");
  }
}
