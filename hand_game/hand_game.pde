class Cell extends Object {
  public int tl;
  public int tr;
  public int bl;
  public int br;
  
  public ArrayList<Cell> parents;
  
  public Cell() {
    parents = new ArrayList<Cell>();
  }
  
  public void addParent(Cell cell) {
    parents.add(cell);
  }
  
  public boolean isRoot() {
    return tl == 1 && tr == 1 && bl == 1 && br == 1;
  }
  
  public boolean isOrphan() {
    return parents.size() < 1;
  }
  
  public boolean bottomWinner() {
    return tl == 0 && tr == 0;
  }
  
  public boolean topWinner() {
    return bl == 0 && br == 0;
  }
  
  public boolean isOmega() {
    return bottomWinner() && topWinner();
  }
  
  public boolean topsTurn;
}

PFont font = createFont("Arial",16,true);
int n = 2;

Cell[][][][] cells;

int cell_size = 50;
int sub_size = cell_size+5;
int super_size = sub_size*n+10;

int sia, sib, sic, sid;

void drawArrowIfValid(int a, int s, int d, int f, int g, int h, int j, int k) {
  int tl = cells[g][h][j][k].tl;
  int tr = cells[g][h][j][k].tr;
  int bl = cells[g][h][j][k].bl;
  int br = cells[g][h][j][k].br;
  int tlo = cells[a][s][d][f].tl;
  int tro = cells[a][s][d][f].tr;
  int blo = cells[a][s][d][f].bl;
  int bro = cells[a][s][d][f].br;
  
  int dtl = tl-tlo;
  int dtr = tr-tro;
  int dbl = bl-blo;
  int dbr = br-bro;
  
  if (cells[a][s][d][f].isOrphan() && !cells[a][s][d][f].isRoot()) {
    return;
  }
  
  if (dtl != 0 && dtr == 0 && dbl == 0 && dbr == 0) {
    if ((tlo + bl) % n == tl || (tlo + br) % n == tl) {
      if (tlo != 0) {
        if (!cells[a][s][d][f].topsTurn) {
          cells[g][h][j][k].topsTurn = !cells[a][s][d][f].topsTurn;
          cells[g][h][j][k].addParent(cells[a][s][d][f]);
          arrow(a,s,d,f,g,h,j,k,true);
        }
      }
    }
  }
  
  if (dtr != 0 && dtl == 0 && dbl == 0 && dbr == 0) {
    if ((tro + bl) % n == tr || (tro + br) % n == tr) {
      if (tro != 0) {
        if (!cells[a][s][d][f].topsTurn) {
          cells[g][h][j][k].topsTurn = !cells[a][s][d][f].topsTurn;
          cells[g][h][j][k].addParent(cells[a][s][d][f]);
          arrow(a,s,d,f,g,h,j,k,true);
        }
      }
    }
  }
  
  if (dbl != 0 && dtl == 0 && dtr == 0 && dbr == 0) {
    if ((blo + tl) % n == bl || (blo + tr) % n == bl) {
      if (blo != 0) {
        if (cells[a][s][d][f].topsTurn) {
          cells[g][h][j][k].topsTurn = !cells[a][s][d][f].topsTurn;
          cells[g][h][j][k].addParent(cells[a][s][d][f]);
          arrow(a,s,d,f,g,h,j,k,false);
        }
      }
    }
  }
  
  if (dbr != 0 && dtl == 0 && dtr == 0 && dbl == 0) {
    if ((bro + tl) % n == br || (bro + tr) % n == br) {
      if (bro != 0) {
        if (cells[a][s][d][f].topsTurn) {
          cells[g][h][j][k].topsTurn = !cells[a][s][d][f].topsTurn;
          cells[g][h][j][k].addParent(cells[a][s][d][f]);
          arrow(a,s,d,f,g,h,j,k,false);
        }
      }
    }
  }
  
}

void arrow(int i, int j, int k, int l, int t, int f, int g, int h, boolean dom) {
  noFill();
  /*if (i != selectedIndexA) {
    return;
  }
  if (j != selectedIndexB) {
    return;
  }*/
  stroke(255,0,0);
  int origX = i*super_size+k*sub_size+cell_size/2;
  int origY = j*super_size+l*sub_size+cell_size/2;
  int destX = t*super_size+g*sub_size+cell_size/2;
  int destY = f*super_size+h*sub_size+cell_size/2;
  
  int deltaX = origX - destX != 0 ? origX - destX : origY - destY;
  int deltaY = origY - destY != 0 ? origY - destY : origX - destX;
  deltaX = abs(deltaX);
  deltaY = abs(deltaY);
  
  translate((origX+destX)/2-super_size/2*n,(origY+destY)/2-super_size/2*n);
  rotateX(HALF_PI);
  if (destX - origX == 0) {
    rotateY(HALF_PI);
  }
  if (dom) {
    stroke(0,0,255);
  }
  arc(0,0,deltaX,deltaY,0,PI);
  //sphere(10);
  if (destX - origX == 0) {
    rotateY(-HALF_PI);
  } 
  rotateX(-HALF_PI);
  translate(super_size/2*n-(origX+destX)/2,super_size/2*n-(origY+destY)/2);
}

public void cell(int x, int y, int w, int h, Cell cell) {
  fill(255);
  if (cell.bottomWinner()) {
    fill(100,100,255);
  }
  if (cell.topWinner()) {
    fill(255,100,100);
  }
  if (cell.isOmega()) {
    fill(255);
  }
  if (cell.isRoot()) {
    fill(255,255,100);
  }
  stroke(0);
  rect(x,y,w,h);
  fill(0);
  translate(0,0,1);
  text(cell.tl,x+w/4-w/5,y+h/4+w/5);
  text(cell.tr,x+3*(w/4)-w/5,y+h/4+w/5);
  text(cell.bl,x+w/4-w/5,y+3*(h/4)+w/5);
  text(cell.br,x+3*(w/4)-w/5,y+3*(h/4)+w/5);
  translate(0,0,-1);
}

void setup() {
  cells = new Cell[n][n][n][n];
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      for (int k = 0; k < n; k++) {
        for (int l = 0; l < n; l++) {
          cells[i][j][k][l] = new Cell();
          cells[i][j][k][l].topsTurn = true;
          cells[i][j][k][l].tl = (i+1)%n;
          cells[i][j][k][l].tr = (j+1)%n;
          cells[i][j][k][l].bl = (k+1)%n;
          cells[i][j][k][l].br = (l+1)%n;
        }
      }
    }
  }
  //selectedIndexA = selectedIndexB = 0;
  size(1340,800,P3D);
  frameRate(30);
  textFont(font,18);
}

void draw() {
  background(255);
  translate(700,400,0);
  rotateX(0.7);
  rotateZ((float)(mouseX-700)/100);
  //rotateX((float)(mouseY-400)/100);
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      for (int k = 0; k < n; k++) {
        for (int l = 0; l < n; l++) {
          translate(-super_size/2*n,-super_size/2*n);
          cell(i*super_size+k*sub_size,j*super_size+l*sub_size,cell_size,cell_size,cells[i][j][k][l]);
          translate(super_size/2*n,super_size/2*n);
        }
      }
    }
  }
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      for (int k = 0; k < n; k++) {
        for (int l = 0; l < n; l++) {
          
          for (int t = i; t < n; t++) {
            for (int f = j; f < n; f++) {
              for (int g = k; g < n; g++) {
                for (int h = l; h < n; h++) {
                  
                  drawArrowIfValid(i,j,k,l,t,f,g,h);
                
                }
              }
            }
          }
          
        }
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      //selectedIndexA++;
    } else if (keyCode == LEFT) {
      //selectedIndexA--;
    } else if (keyCode == DOWN) {
      //selectedIndexB++;
    } else if (keyCode == UP) {
      //selectedIndexB--;
    }
  } else {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        for (int k = 0; k < n; k++) {
          for (int l = 0; l < n; l++) {
            cells[i][j][k][l].topsTurn = !cells[i][j][k][l].topsTurn;
            cells[i][j][k][l].parents = new ArrayList<Cell>();
          }
        }
      }
    }
  }
}
