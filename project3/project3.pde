PImage imag1, imag2;
ArrayList<pixels> dots;
ArrayList<PVector> targets1, targets2;
int scaler = 4; 
int threshold = 210;
boolean imageToggled = false;
color col1, col2;

void setup() {
  size(50, 50, P2D);  
  
  imag1 = loadImage("sonic.png");
  imag2 = loadImage("gray.png");

  int w, h;
  if (imag1.width > imag2.width) {
    w = imag1.width;
  } else {
    w = imag2.width;
  }
  if (imag1.height > imag2.height) {
    h = imag1.height;
  } else {
    h = imag2.height;
  }
  surface.setSize(w, h);
  
  imag1.loadPixels();
  imag2.loadPixels();
  
  targets1 = new ArrayList<PVector>();
  targets2 = new ArrayList<PVector>();
  
  col1 = color(0, 127, 70, 80);
  col2 = color(0, 127, 200, 80);
  
  for (int x = 0; x < imag2.width; x += scaler) {
    for (int y = 0; y < imag2.height; y += scaler) {
      int loc = x + y * imag2.width;

      if (brightness(imag2.pixels[loc]) > threshold) {
        targets2.add(new PVector(x, y));
      }
    }
  }

  dots = new ArrayList<pixels>();

  for (int x = 0; x < imag1.width; x += scaler) {
    for (int y = 0; y < imag1.height; y += scaler) {
      int loc = x + y * imag1.width;
      
      if (brightness(imag1.pixels[loc]) > threshold) {
        int targetIndex = int(random(0, targets2.size()));
        targets1.add(new PVector(x, y));
        pixels dot = new pixels(x, y, col1, targets2.get(targetIndex));
        dots.add(dot);
      }
    }
  }
}

void draw() { 
  background(0);
  
  blendMode(ADD);
  
  boolean flipTargets = true;

  for (pixels dot : dots) {
    dot.run();
    if (!dot.ready) flipTargets = false;
  }
  
  if (flipTargets) {
    for (pixels dot : dots) {
      if (!imageToggled) {
        int targetIndex = int(random(0, targets1.size()));
        dot.targ = targets1.get(targetIndex);
        dot.col = col2;
      } else {
        int targetIndex = int(random(0, targets2.size()));
        dot.targ = targets2.get(targetIndex);
        dot.col = col1;
      }
    }
    imageToggled = !imageToggled;
  }
    
  surface.setTitle("" + frameRate);
}
