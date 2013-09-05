
class Node {
  public PVector p;
  public PVector v;
  public PVector a;

  public float radius;

  Node(float px, float py) {
    p = new PVector(px, py);
    v = new PVector(0, 0);
    a = new PVector(0, 0);

    radius = random(0.4, 2);
  }

  public void step() {
    v.x += a.x;
    v.y += a.y;

    v.x *= 0.8;
    v.y *= 0.8;

    p.x += v.x;
    p.y += v.y;

    if (p.x < 0) p.x = width;
    if (p.x > width) p.x = 0;
    if (p.y < 0) p.y = height;
    if (p.y > height) p.y = 0;
  }

  public void draw(int drawMode) {
    noStroke();
    
    if (drawMode == 1) {
      fill(240, 4);
      for (int r = (int) radius * 8; r > 0; r--) {
        ellipse(p.x, p.y, r, r);
      }
    }

    fill(240);
    ellipse(p.x, p.y, radius, radius);
  }
}

