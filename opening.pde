// Variabel untuk animasi
float waveOffset = 0;
float cloudOffset = 0;
ArrayList<Cloud> clouds;
ArrayList<Rock> rocks;
ArrayList<PalmTree> palmTrees;
PFont titleFont; // Variabel untuk font

void setup() {
  size(1435, 780);
  
  // Load font PT Serif Bold dari file .vlw
  titleFont = loadFont("PTSerif-Bold-200.vlw"); // Ganti dengan nama file .vlw yang Anda buat
  
  // Inisialisasi awan
  clouds = new ArrayList<Cloud>();
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(random(width), random(50, 150), random(40, 80)));
  }
  
  // Inisialisasi batu
  rocks = new ArrayList<Rock>();
  for (int i = 0; i < 20; i++) {
    rocks.add(new Rock(random(width), random(420, 470), random(8, 25)));
  }
  
  // Inisialisasi pohon kelapa
  palmTrees = new ArrayList<PalmTree>();
  // Pohon kelapa di sebelah kiri
  palmTrees.add(new PalmTree(120, 450, 250, -0.3)); // Tinggi diperbarui
  palmTrees.add(new PalmTree(250, 450, 230, 0.1));  // Tinggi diperbarui
  
  // Pohon kelapa di sebelah kanan
  palmTrees.add(new PalmTree(width - 120, 450, 245, 0.2)); // Tinggi diperbarui
  palmTrees.add(new PalmTree(width - 280, 450, 235, -0.1)); // Tinggi diperbarui
}

void draw() {
  // Langit dengan gradien
  drawSky();
  
  // Awan bergerak
  drawClouds();
  
  // Matahari
  drawSun();
  
  // Laut dengan ombak
  drawSea();
  
  // Pasir pantai
  drawSand();
  
  // Batu-batu kecil di pantai
  drawRocks();
  
  // Pohon kelapa
  drawPalmTrees();
  
  // Judul di tengah
  drawTitle();
  
  // Update animasi
  waveOffset += 0.05;
  cloudOffset += 0.3;
}

void drawTitle() {
  // Set font dan warna
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  
  // Warna teks dengan outline untuk kontras yang baik
  // Outline hitam
  fill(0);
  text("Malin", width/2 + 2, height/2 - 80 + 2);      // Ubah dari -45 ke -80
  text("Kundang", width/2 + 2, height/2 + 80 + 2);    // Ubah dari +45 ke +80
  
  // Teks utama berwarna putih
  fill(#ffffff);
  text("Malin", width/2, height/2 - 80);               // Ubah dari -45 ke -80
  text("Kundang", width/2, height/2 + 80);   
}

void drawSky() {
  // Gradien langit dari biru muda ke kuning muda
  for (int y = 0; y < 300; y++) {
    float inter = map(y, 0, 300, 0, 1);
    color c = lerpColor(color(135, 206, 235), color(255, 255, 200), inter);
    stroke(c);
    line(0, y, width, y);
  }
}

void drawClouds() {
  fill(255, 255, 255, 180);
  noStroke();
  
  for (Cloud cloud : clouds) {
    cloud.update();
    cloud.display();
  }
}

void drawSun() {
  fill(255, 255, 0, 150);
  noStroke();
  ellipse(width - 100, 80, 60, 60);
  
  // Sinar matahari
  stroke(255, 255, 0, 100);
  strokeWeight(2);
  for (int i = 0; i < 12; i++) {
    float angle = i * TWO_PI / 12;
    float x1 = (width - 100) + cos(angle) * 40;
    float y1 = 80 + sin(angle) * 40;
    float x2 = (width - 100) + cos(angle) * 55;
    float y2 = 80 + sin(angle) * 55;
    line(x1, y1, x2, y2);
  }
}

void drawSea() {
  // Laut dengan warna biru kehijauan
  fill(0, 150, 150);
  noStroke();
  rect(0, 300, width, 150);
  
  // Ombak animasi
  fill(0, 180, 180);
  noStroke();
  beginShape();
  vertex(0, 300);
  
  for (int x = 0; x <= width; x += 10) {
    float wave = sin((x * 0.02) + waveOffset) * 8;
    vertex(x, 300 + wave);
  }
  
  vertex(width, 450);
  vertex(0, 450);
  endShape(CLOSE);
  
  // Ombak kecil di tepi pantai
  fill(255, 255, 255, 150);
  for (int x = 0; x <= width; x += 15) {
    float wave = sin((x * 0.03) + waveOffset) * 5;
    ellipse(x, 445 + wave, 10, 5);
  }
}

void drawSand() {
  // Pasir pantai
  fill(#ffe3b5);
  noStroke();
  rect(0, 450, width, 400);
  
  // Tekstur pasir
  fill(240, 210, 160);
  for (int i = 0; i < 100; i++) {
    float x = random(width);
    float y = random(450, 600);
    ellipse(x, y, 2, 2);
  }
}

void drawRocks() {
  for (Rock rock : rocks) {
    rock.display();
  }
}

void drawPalmTrees() {
  for (PalmTree palm : palmTrees) {
    palm.display();
  }
}

// Kelas untuk awan
class Cloud {
  float x, y, size;
  float speed;
  
  Cloud(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.speed = random(0.2, 0.8);
  }
  
  void update() {
    x += speed;
    if (x > width + size) {
      x = -size;
    }
  }
  
  void display() {
    fill(255, 255, 255, 180);
    noStroke();
    
    // Awan terdiri dari beberapa lingkaran
    ellipse(x, y, size, size * 0.8);
    ellipse(x + size * 0.3, y, size * 0.8, size * 0.6);
    ellipse(x - size * 0.3, y, size * 0.8, size * 0.6);
    ellipse(x, y - size * 0.2, size * 0.6, size * 0.4);
  }
}

// Kelas untuk batu kecil
class Rock {
  float x, y, size;
  color rockColor;
  
  Rock(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.rockColor = color(random(80, 120), random(80, 120), random(80, 120), 180);
  }
  
  void display() {
    fill(rockColor);
    noStroke();
    ellipse(x, y, size, size * 0.8);
    fill(red(rockColor) - 20, green(rockColor) - 20, blue(rockColor) - 20, 120);
    ellipse(x + size * 0.1, y - size * 0.1, size * 0.6, size * 0.5);
  }
}

// ===================================================================
// KELAS POHON KELAPA
// ===================================================================

class PalmTree {
  float x, baseY;
  float height;
  float curve;  
  color trunkColor;
  
  PalmTree(float x, float baseY, float height, float curve) {
    this.x = x;
    this.baseY = baseY;
    this.height = height;
    this.curve = curve;
    this.trunkColor = color(101, 67, 33);
  }
  
  void display() {
    drawTrunk();
    drawPalmLeaves();
    drawCoconuts();
  }
  
  void drawTrunk() {
    stroke(trunkColor);
    noFill();
    for (int i = 0; i <= height; i++) {
      float t = i / height;
      float currentX = x + (t * t) * curve * 60;
      float currentY = baseY - i;
      strokeWeight(map(t, 0, 1, 15, 6));
      point(currentX, currentY);
    }
    
    stroke(red(trunkColor) - 30, green(trunkColor) - 30, blue(trunkColor) - 30);
    strokeWeight(1.5);
    for (int i = 0; i < height; i += 15) {
      float t = i / height;
      float currentX = x + (t * t) * curve * 60;
      float currentY = baseY - i;
      float trunkWidth = map(t, 0, 1, 15, 6);
      line(currentX - trunkWidth/2, currentY, currentX + trunkWidth/2, currentY);
    }
  }
  
  void drawPalmLeaves() {
    float t = 1.0;
    float topX = x + (t * t) * curve * 60;
    float topY = baseY - height;
    
    // Daun di sisi kanan (melengkung ke atas)
    for (int i = 0; i < 4; i++) {
      // Sesuaikan rentang sudut untuk mengarah ke atas
      // Sudut ini memungkinkan daun menyebar ke atas dengan lengkungan yang baik
      float angle = map(i, 0, 4, -PI/2 - 0.7, PI/2 + 0.7); // Rentang sudut diperlebar
      float leafLength = random(100, 140); 
      float leafEndX = topX + cos(angle) * leafLength;
      float leafEndY = topY + sin(angle) * leafLength;
      drawSinglePalmLeaf(topX, topY, leafEndX, leafEndY, leafLength);
    }
    
    // Daun di sisi kiri (melengkung ke atas)
    for (int i = 0; i < 4; i++) {
      // Sesuaikan rentang sudut untuk mengarah ke atas
      // Sudut ini memungkinkan daun menyebar ke atas dengan lengkungan yang baik
      float angle = map(i, 0, 4, PI/2 - 0.7, 3*PI/2 + 0.7); // Rentang sudut diperlebar
      float leafLength = random(100, 140); 
      float leafEndX = topX + cos(angle) * leafLength;
      float leafEndY = topY + sin(angle) * leafLength;
      drawSinglePalmLeaf(topX, topY, leafEndX, leafEndY, leafLength);
    }
  }

  void drawSinglePalmLeaf(float startX, float startY, float endX, float endY, float length) {
    float ctrlX = (startX + endX) / 2;
    // Ini adalah kunci utama: nilai NEGATIF yang lebih BESAR
    // akan menarik titik kontrol ke atas, membuat lengkungan semakin kuat.
    float ctrlY = (startY + endY) / 2 - length * 1.0; // Faktor negatif ditingkatkan menjadi 1.0 atau lebih
    
    // Menggambar pelepah utama secara manual menggunakan vertex (kurva Bezier)
    noFill();
    strokeWeight(3);
    stroke(20, 100, 20); // Warna hijau gelap untuk pelepah
    beginShape();
    for (float t = 0; t <= 1.0; t += 0.02) {
      float oneMinusT = 1 - t;
      float x = pow(oneMinusT, 2) * startX + 2 * oneMinusT * t * ctrlX + pow(t, 2) * endX;
      float y = pow(oneMinusT, 2) * startY + 2 * oneMinusT * t * ctrlY + pow(t, 2) * endY;
      vertex(x, y);
    }
    endShape();
    
    // Gambar helai-helai daun kecil di sepanjang pelepah
    strokeWeight(1.5);
    stroke(50, 180, 50); // Warna hijau lebih terang untuk helai daun
    int numSegments = 40; // Tambah jumlah segmen untuk helai daun lebih rapat dan detail
    for (int i = 1; i < numSegments; i++) {
      float t = i / float(numSegments);
      
      float oneMinusT = 1 - t;
      float currentX = pow(oneMinusT, 2) * startX + 2 * oneMinusT * t * ctrlX + pow(t, 2) * endX;
      float currentY = pow(oneMinusT, 2) * startY + 2 * oneMinusT * t * ctrlY + pow(t, 2) * endY;
      
      float tangentX = 2 * oneMinusT * (ctrlX - startX) + 2 * t * (endX - ctrlX);
      float tangentY = 2 * oneMinusT * (ctrlY - startY) + 2 * t * (endY - ctrlY);
      // Sudut tegak lurus terhadap kurva untuk mengikuti lengkungan ke atas
      float angle = atan2(tangentY, tangentX) + HALF_PI; 
      
      float segmentLength = 30 * (1 - t * 0.7); // Panjang helai daun, semakin ke ujung semakin pendek
                                                 // Mengurangi t * 0.7 agar helai di ujung tidak terlalu pendek
      
      line(currentX, currentY, currentX + cos(angle) * segmentLength, currentY + sin(angle) * segmentLength);
      line(currentX, currentY, currentX - cos(angle) * segmentLength, currentY - sin(angle) * segmentLength);
    }
  }
  
  void drawCoconuts() {
    float t = 1.0;
    float topX = x + (t * t) * curve * 60;
    float topY = baseY - height + 10; // Posisi buah kelapa sedikit di bawah ujung batang
    
    fill(87, 62, 42); // Warna coklat untuk kelapa
    noStroke();
    
    // Gambar beberapa kelapa
    ellipse(topX + 5, topY, 15, 15);
    ellipse(topX - 8, topY + 5, 15, 15);
    ellipse(topX, topY + 10, 15, 15);
  }
}
