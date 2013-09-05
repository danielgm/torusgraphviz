/**
 * Seamless graph visualization-looking thing.
 */

int nodeCount = 200;
float density = 0.02;
float edgeDistance = 30;
float charge = 10;
float attraction = 0.01;

/** Keep track of each node. */
Node nodes[];

/** Keep track of edges between nodes. */
Boolean adjacency[];

int kx, ky;
PVector pa, pb;
float r, dx, dy, d, dx2, dy2, d2;

int drawMode;

void setup() {
  size(800, 600);
  ellipseMode(RADIUS);
  
  nodes = new Node[nodeCount];
  for (int i = 0; i < nodeCount; i++) {
    nodes[i] = new Node(
      width * random(1), height * random(1));
  }
  
  adjacency = new Boolean[nodeCount * nodeCount];
  for (int a = 0; a < nodeCount; a++) {
    for (int b = 0; b < nodeCount; b++) {
      adjacency[a * nodeCount + b] = a < b ? random(1) < density : false;
    }
  }
  
  drawMode = 0;
}

void draw() {
  if (drawMode != 0) return;
  
  background(70, 78, 90);
  
  // Calculate forces acting on each node.
  for (int a = 0; a < nodeCount; a++) {
    Node na = nodes[a];
    na.a.x = 0;
    na.a.y = 0;
    
    for (int b = 0; b < nodeCount; b++) {
      if (a == b) continue;
      
      Node nb = nodes[b];
      pa = na.p;
      pb = nb.p;
      
      dx = pb.x - pa.x;
      dy = pb.y - pa.y;
      d = sqrt(dx * dx  +  dy * dy);
      
      // From the other side.
      kx = 0;
      ky = 0;
      
      if (abs(pb.x - pa.x) > width/2) {
        kx = pb.x > pa.x ? 1 : -1;
      }
      if (abs(pb.y - pa.y) > height/2) {
        ky = pb.y > pa.y ? 1 : -1;
      }
      
      dx2 = pb.x - pa.x - kx * width;
      dy2 = pb.y - pa.y - ky * height;
      d2 = sqrt(dx2 * dx2  +  dy2 * dy2);
      
      if (d2 < d) {
        dx = dx2;
        dy = dy2;
        d = d2;
      }
      
      // Repulsion.
      r = charge / d / d;
      na.a.x -= dx * r;
      na.a.y -= dy * r;
      
      // Attraction.
      if (a < b ? adjacency[a * nodeCount + b] : adjacency[b * nodeCount + a]
        && d > edgeDistance) {
          na.a.x += (d - edgeDistance) * dx / d * attraction;
          na.a.y += (d - edgeDistance) * dy / d * attraction;
      }
    }
  }
  
  // Move nodes.
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].step();
  }
  
  // Draw edges.
  stroke(255, 24);
  for (int a = 0; a < nodeCount; a++) {
    for (int b = 0; b < nodeCount; b++) {
      if (adjacency[a * nodeCount + b]) {
        pa = nodes[a].p;
        pb = nodes[b].p;
        
        kx = 0;
        ky = 0;
        
        if (abs(pb.x - pa.x) > width/2) {
          kx = pb.x > pa.x ? 1 : -1;
        }
        if (abs(pb.y - pa.y) > height/2) {
          ky = pb.y > pa.y ? 1 : -1;
        }
        
        line(pa.x, pa.y, pb.x - kx * width, pb.y - ky * height);
        if (kx != 0 || ky != 0) {
          line(pa.x + kx * width, pa.y + ky * height, pb.x, pb.y);
        }
        if (kx != 0 && ky != 0) {
          // Cutting across corners.
          line(pa.x, pa.y + ky * height, pb.x - kx * width, pb.y);
          line(pa.x + kx * width, pa.y, pb.x, pb.y - ky * height);
        }
      }
    }
  }
      
  // Draw nodes.
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].draw(drawMode);
  }
}

void keyReleased() {
  if (key == ' ') {
    for (int i = 0; i < nodeCount; i++) {
      nodes[i].p.x = width * random(1);
      nodes[i].p.y = height * random(1);
      nodes[i].v.x = 0;
      nodes[i].v.y = 0;
    }
    
    adjacency = new Boolean[nodeCount * nodeCount];
    for (int a = 0; a < nodeCount; a++) {
      for (int b = 0; b < nodeCount; b++) {
        adjacency[a * nodeCount + b] = a < b ? random(1) < density : false;
      }
    }
  }
  else if (key == 't') {
    drawMode = 1 - drawMode;
    if (drawMode == 1) {
      background(70, 78, 90);
      
      // Draw edges.
      stroke(255, 24);
      for (int a = 0; a < nodeCount; a++) {
        for (int b = 0; b < nodeCount; b++) {
          if (adjacency[a * nodeCount + b]) {
            pa = nodes[a].p;
            pb = nodes[b].p;
            
            kx = 0;
            ky = 0;
            
            if (abs(pb.x - pa.x) > width/2) {
              kx = pb.x > pa.x ? 1 : -1;
            }
            if (abs(pb.y - pa.y) > height/2) {
              ky = pb.y > pa.y ? 1 : -1;
            }
            
            line(pa.x, pa.y, pb.x - kx * width, pb.y - ky * height);
            if (kx != 0 || ky != 0) {
              line(pa.x + kx * width, pa.y + ky * height, pb.x, pb.y);
            }
            if (kx != 0 && ky != 0) {
              // Cutting across corners.
              line(pa.x, pa.y + ky * height, pb.x - kx * width, pb.y);
              line(pa.x + kx * width, pa.y, pb.x, pb.y - ky * height);
            }
          }
        }
      }
          
      // Draw nodes.
      for (int i = 0; i < nodeCount; i++) {
        nodes[i].draw(drawMode);
      }
    }
  }
  else if (key == 's') {
    save("screenshot.png");
    println("Saved.");
  }
}

