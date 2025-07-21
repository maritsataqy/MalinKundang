// Variabel untuk animasi

// Import library sound
import processing.sound.*;

// Variabel untuk audio
SoundFile audioFile;
SoundFile backSound; // Tambahkan ini untuk sound kedua

float waveOffset = 0;
float cloudOffset = 0;
ArrayList<Rock> rocks;
ArrayList<Cloud> clouds;

// Variabel untuk gambar
PImage gambar1, gambar2;

// Variabel untuk animasi gambar 1
float gambar1X = 600;  // Posisi awal gambar 1 (mulai dari kiri layar)
float gambar1Speed = 2; // Kecepatan gerakan gambar 1 (pixels per frame)
float gambar1StopX = 860; // Posisi X dimana gambar 1 akan berhenti
boolean gambar1Moving = true; // Status apakah gambar 1 masih bergerak

void setup() {
  size(1435, 780);
  
  // Load gambar (ganti dengan nama file gambar Anda)
  gambar1 = loadImage("malinpamit.png"); // atau .png
  gambar2 = loadImage("ibusedih.png"); // atau .png
  
  // Load file audio
  audioFile = new SoundFile(this, "Sc2.mp3");
  
  // Mainkan audio sekali (tidak loop)
  audioFile.play();
  
  // Load dan putar backsound kedua
  backSound = new SoundFile(this, "soundsc1n2.wav"); // Ganti dengan nama file sound kamu
  backSound.amp(0.00001); // Set volume lebih kecil 
  backSound.loop(); // Putar berulang terus menerus sebagai backsound
  
  println("Audio dimulai: Sc2.mp3");
  
  // Inisialisasi batu-batu kecil
  rocks = new ArrayList<Rock>();
  for (int i = 0; i < 25; i++) {
    rocks.add(new Rock(random(200, width-50), random(520, 650), random(15, 35)));
  }
  
  // Inisialisasi awan
  clouds = new ArrayList<Cloud>();
  for (int i = 0; i < 8; i++) {
    clouds.add(new Cloud(random(width), random(50, 200), random(40, 80)));
  }
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
  
   // Trapesium sama kaki
  drawTrapesiumSamaKaki();
  
  // Bagian dalam kapal
  drawInship();
  
  // Kapal (digambar setelah laut tapi sebelum pantai)
  drawShip();
  
    // Trapesium di atas kapal
  drawTrapesiumKapal();
  
  
  // Pasir pantai
  drawSand();
  
  // Jembatan (digambar setelah kapal)
  drawBridge();
  
  // Batu-batu kecil
  drawRocks();
  
  // Gambar yang dimuat
  drawLoadedImages();
  
  // Update animasi
  waveOffset += 0.05;
  cloudOffset += 0.3;
}

// Fungsi untuk menangani input keyboard
void keyPressed() {
  // Tekan 'r' atau 'R' untuk restart animasi gambar 1
  if (key == 'r' || key == 'R') {
    gambar1X = 100;        // Reset posisi ke awal
    gambar1Moving = true;   // Mulai gerakan lagi
    println("Animasi gambar 1 di-restart!");
  }
  
  // Tekan 's' atau 'S' untuk stop animasi gambar 1
  if (key == 's' || key == 'S') {
    gambar1Moving = false;
    println("Animasi gambar 1 dihentikan di X = " + gambar1X);
  }
}

void drawLoadedImages() {
  // Pastikan gambar sudah dimuat
  if (gambar1 != null && gambar2 != null) {
    
    // Update posisi gambar 1 (animasi bergerak dari kiri ke kanan)
    if (gambar1Moving && gambar1X < gambar1StopX) {
      gambar1X += gambar1Speed; // Gerakkan gambar ke kanan
      
      // Cek apakah sudah sampai posisi berhenti
      if (gambar1X >= gambar1StopX) {
        gambar1X = gambar1StopX; // Set tepat di posisi berhenti
        gambar1Moving = false;   // Hentikan gerakan
        println("Gambar 1 sudah berhenti di X = " + gambar1StopX);
      }
    }
    
    // GAMBAR 2 - Digambar PERTAMA (akan berada di belakang)
    // X = 1000, Y = 300 (di area pantai/bawah)  
    // Ukuran = 300x450 pixels
    image(gambar2, 1000, 300, 300, 450);
    
    // GAMBAR 1 - Digambar TERAKHIR (akan berada di depan)
    // Bergerak dari kiri ke kanan, berhenti di X = gambar1StopX
    // Y = 350 (di area langit/atas)
    // Ukuran = 300x400 pixels
    image(gambar1, gambar1X, 350, 300, 400);
    
    /* INFORMASI POSISI UNTUK ANDA:
     * 
     * SEKARANG GAMBAR 1 AKAN SELALU BERADA DI DEPAN GAMBAR 2
     * 
     * GAMBAR 1 (BERGERAK - DI DEPAN):
     * - Posisi X: Mulai dari 300, bergerak ke kanan dengan kecepatan 2 pixels/frame
     * - Berhenti di: X = 800 (bisa diubah dengan mengubah nilai gambar1StopX)
     * - Posisi Y: 350 (tetap, dari atas)
     * - Ukuran: 300 pixels lebar x 400 pixels tinggi
     * - Layer: DEPAN (digambar terakhir)
     * - Kecepatan: 2 pixels per frame (bisa diubah dengan mengubah gambar1Speed)
     * 
     * GAMBAR 2 (TETAP - DI BELAKANG): 
     * - Posisi X: 1000 (tetap, tidak bergerak)
     * - Posisi Y: 300 (dari atas)
     * - Ukuran: 300 pixels lebar x 450 pixels tinggi  
     * - Layer: BELAKANG (digambar pertama)
     * 
     * CARA MENGUBAH PENGATURAN:
     * - gambar1Speed: Ubah kecepatan gerakan (1=lambat, 5=cepat)
     * - gambar1StopX: Ubah posisi berhenti (contoh: 800, 1200, dll)
     * - gambar1X (posisi awal): Ubah posisi mulai (300 = mulai dari kiri)
     * 
     * UNTUK RESTART ANIMASI:
     * - Tekan tombol 'r' untuk restart gerakan gambar 1
     * 
     * LAYERING SYSTEM:
     * - Objek yang digambar pertama = layer belakang
     * - Objek yang digambar terakhir = layer depan
     * - Untuk mengubah layer, ubah urutan pemanggilan image()
     */
  }
}

void drawSky() {
  // Gradien langit dari biru muda ke kuning muda
  for (int y = 0; y < 450; y++) {
    float inter = map(y, 0, 450, 0, 1);
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
  ellipse(width - 150, 120, 80, 80);
  
  // Sinar matahari
  stroke(255, 255, 0, 100);
  strokeWeight(2);
  for (int i = 0; i < 12; i++) {
    float angle = i * TWO_PI / 12;
    float x1 = (width - 150) + cos(angle) * 50;
    float y1 = 120 + sin(angle) * 50;
    float x2 = (width - 150) + cos(angle) * 70;
    float y2 = 120 + sin(angle) * 70;
    line(x1, y1, x2, y2);
  }
}

void drawSea() {
  // Laut dengan warna biru kehijauan
  fill(0, 150, 150);
  noStroke();
  rect(0, 200, width, 300);
  
  // Ombak animasi
  fill(0, 180, 180);
  noStroke();
  beginShape();
  vertex(0, 450);
  
  for (int x = 0; x <= width; x += 10) {
    float wave = sin((x * 0.02) + waveOffset) * 8;
    vertex(x, 450 + wave);
  }
  
  vertex(width, 650);
  vertex(0, 650);
  endShape(CLOSE);
  
  // Ombak kecil di tepi pantai
  fill(255, 255, 255, 150);
  for (int x = 0; x <= width; x += 15) {
    float wave = sin((x * 0.03) + waveOffset) * 5;
    ellipse(x, 645 + wave, 10, 5);
  }
}

void drawTrapesiumSamaKaki() {
  // Rectangle paling bawah adalah: rect(0, 160, 330, 230)
  // Jadi rectangle ini berada di y=160 dengan lebar 330 dan tinggi 230
  
  // Parameter trapesium sama kaki
  float rectWidth = 460;        // Lebar rectangle di bawahnya
  float rectTopY = 145;         // Posisi Y atas rectangle
  
  float trapesiumHeight = 80;   // Tinggi trapesium
  float bottomWidth = rectWidth; // Lebar bawah trapesium = lebar rectangle
  float topWidth = 330;         // Lebar atas trapesium (lebih kecil untuk bentuk trapesium)
  
  // Parameter penggeser ke kiri (ubah nilai ini untuk menggeser)
  float geserKiri = 80;        // Nilai positif = geser ke kiri, negatif = geser ke kanan
  
  // Posisi trapesium tepat di atas rectangle
  float trapesiumBottomY = rectTopY;           // Tepat di atas rectangle
  float trapesiumTopY = trapesiumBottomY - trapesiumHeight;
  float trapesiumCenterX = (bottomWidth / 2) - geserKiri;    // Pusat horizontal dengan penggeser
  
  // Warna trapesium
  fill(#d68971);
  noStroke();
  
  // Menggambar trapesium sama kaki
  beginShape();
  
  // Titik kiri bawah
  vertex(trapesiumCenterX - bottomWidth/2, trapesiumBottomY);
  
  // Titik kanan bawah
  vertex(trapesiumCenterX + bottomWidth/2, trapesiumBottomY);
  
  // Titik kanan atas (sama kaki - simetris)
  vertex(trapesiumCenterX + topWidth/2, trapesiumTopY);
  
  // Titik kiri atas (sama kaki - simetris)
  vertex(trapesiumCenterX - topWidth/2, trapesiumTopY);
  
  endShape(CLOSE);
}


void drawInship() {
  fill(#e6d6a4);
  rect(0, 160, 330, 230);
  
  fill(#ad5464);
  rect(0, 145, 380, 20);
  
  fill(#1db3bc);
  rect(0, 210, 100, 100); // kaca
  rect(200, 210, 130, 100);
  
  fill(#a87e55);
  rect(190, 210, 15, 100);
  rect(100, 210, 15, 100);
  rect(0, 200, 115, 15); //kiri atas
  rect(0, 300, 115, 15);
  rect(190, 200, 140, 15); // kanan atas
  
  fill(#1d969f);
  rect(0, 215, 100, 15);
  rect(205, 215, 125, 15);
  
}

void drawShip() {
  // Kapal - setengah lingkaran
  float radius = 400;         // Ukuran diperbesar
  float centerX = width/7;    // Geser lebih kiri (dari width/3 ke width/4)
  float centerY = height/2; // Naik sedikit (dari height/2 ke height/2.5)
  
  fill(#b59368); // Warna coklat
  noStroke();    // Tanpa outline
  arc(centerX, centerY, radius*2, radius*2, 0, PI); // Setengah lingkaran bawah
  
  // Garis horizontal motif kayu untuk kapal
  stroke(#9d7c56); // Warna coklat lebih gelap untuk garis
  strokeWeight(1.5);
  
  noStroke(); // Matikan stroke untuk elemen selanjutnya
  
  // Parameter jendela
  float windowSize = 60;      // Ukuran jendela diperbesar dari 40 ke 60
  float windowY = centerY + 50; // Posisi Y jendela (di bawah sedikit dari pusat kapal)
  
  // Jendela pertama (geser lebih ke kanan)
  float window1X = centerX + 80;
  
  // Bayangan jendela pertama
  fill(#8b7355); // Warna coklat gelap untuk bayangan
  ellipse(window1X + 3, windowY + 3, windowSize + 4, windowSize + 4);
  
  // Frame jendela pertama (lingkaran luar)
  fill(#6b4e33); // Warna coklat tua untuk frame
  ellipse(window1X, windowY, windowSize + 8, windowSize + 8);
  
  // Kaca jendela pertama
  fill(#87ceeb); // Warna biru langit untuk kaca
  ellipse(window1X, windowY, windowSize, windowSize);
  
  // Efek refleksi pada kaca pertama
  fill(255, 255, 255, 100); // Putih transparan
  ellipse(window1X - 8, windowY - 8, windowSize/3, windowSize/3);
  
  // Jendela kedua (geser lebih ke kanan)
  float window2X = centerX + 200;
  
  // Bayangan jendela kedua
  fill(#8b7355); // Warna coklat gelap untuk bayangan
  ellipse(window2X + 3, windowY + 3, windowSize + 4, windowSize + 4);
  
  // Frame jendela kedua (lingkaran luar)
  fill(#6b4e33); // Warna coklat tua untuk frame
  ellipse(window2X, windowY, windowSize + 8, windowSize + 8);
  
  // Kaca jendela kedua
  fill(#87ceeb); // Warna biru langit untuk kaca
  ellipse(window2X, windowY, windowSize, windowSize);
  
  // Efek refleksi pada kaca kedua
  fill(255, 255, 255, 100); // Putih transparan
  ellipse(window2X - 8, windowY - 8, windowSize/3, windowSize/3);
}

void drawTrapesiumKapal() {
  // Parameter trapesium siku-siku
  float trapesiumWidth = 500;     // Lebar dasar trapesium
  float trapesiumHeight = 100;    // Tinggi trapesium
  float topWidth = 400;           // Lebar atas trapesium (lebih kecil dari dasar)
  
  // Posisi trapesium tepat di atas kapal
  float trapesiumCenterX = width/4.05;  // Sama dengan centerX kapal
  float trapesiumBottomY = height/2 - 0; // Di atas kapal (200 unit di atas pusat kapal)
  
  // Warna trapesium (bisa disesuaikan)
  fill(#b59368); // Warna coklat untuk layar kapal
  noStroke();
  
  // Menggambar trapesium siku-siku dengan siku-siku di kanan
  beginShape();
  
  // Titik kiri bawah
  vertex(trapesiumCenterX - trapesiumWidth/2, trapesiumBottomY);
  
  // Titik kanan bawah (siku-siku)
  vertex(trapesiumCenterX + trapesiumWidth/2, trapesiumBottomY);
  
  // Titik kanan atas (siku-siku)
  vertex(trapesiumCenterX + trapesiumWidth/2, trapesiumBottomY - trapesiumHeight);
  
  // Titik kiri atas (miring)
  vertex(trapesiumCenterX - topWidth/2, trapesiumBottomY - trapesiumHeight);
  
  endShape(CLOSE);
  
  // Garis horizontal motif kayu untuk trapesium
  stroke(#9d7c56); // Warna coklat lebih gelap untuk garis
  strokeWeight(1.5);
  
  // Menggambar garis horizontal dengan jarak 15 pixel dalam area trapesium
  for (float y = trapesiumBottomY; y >= trapesiumBottomY - trapesiumHeight; y -= 15) {
    // Hitung panjang garis berdasarkan bentuk trapesium
    float heightFromBottom = trapesiumBottomY - y;
    float ratio = heightFromBottom / trapesiumHeight;
    
    // Interpolasi lebar berdasarkan tinggi
    float currentWidth = trapesiumWidth - ratio * (trapesiumWidth - topWidth);
    float halfCurrentWidth = currentWidth / 2;
    
    // Untuk sisi kiri yang miring
    float leftEdge = trapesiumCenterX - halfCurrentWidth;
    
    // Untuk sisi kanan yang lurus
    float rightEdge = trapesiumCenterX + trapesiumWidth/2;
    
    line(leftEdge, y, rightEdge, y);
  }
  
  noStroke(); // Matikan stroke untuk elemen selanjutnya
  
  // Detail menempel di bagian miring (seperti bayangan atau lipatan layar)
  fill(#8b6f47); // Warna coklat lebih gelap
  noStroke();
  
  // Membuat bentuk segitiga yang mengikuti garis miring
  float detailWidth = 30; // Lebar detail yang menempel
  
  beginShape();
  // Titik kiri bawah detail (mengikuti garis miring)
  vertex(trapesiumCenterX - trapesiumWidth/2, trapesiumBottomY);
  
  // Titik kiri atas detail (mengikuti garis miring)
  vertex(trapesiumCenterX - topWidth/2, trapesiumBottomY - trapesiumHeight);
  
  // Titik dalam detail (parallel dengan garis miring)
  float deltaX = (trapesiumWidth - topWidth) / 2; // Perbedaan X antara atas dan bawah
  float slope = trapesiumHeight / deltaX; // Kemiringan garis miring
  
  // Titik detail atas (bergeser ke dalam)
  vertex(trapesiumCenterX - topWidth/2 + detailWidth, trapesiumBottomY - trapesiumHeight);
  
  // Titik detail bawah (bergeser ke dalam)
  vertex(trapesiumCenterX - trapesiumWidth/2 + detailWidth, trapesiumBottomY);
  
  endShape(CLOSE);
  
  // Detail di sisi atas trapesium (lebar atas)
  fill(#9d7c56); // Warna coklat medium untuk detail atas
  noStroke();
  
  float detailHeightTop = 15; // Tinggi detail yang menempel di sisi atas
  
  // Membuat detail horizontal di sisi atas
  beginShape();
  // Titik kiri atas detail
  vertex(trapesiumCenterX - topWidth/2, trapesiumBottomY - trapesiumHeight);
  
  // Titik kanan atas detail
  vertex(trapesiumCenterX + trapesiumWidth/2, trapesiumBottomY - trapesiumHeight);
  
  // Titik kanan bawah detail (bergeser ke bawah)
  vertex(trapesiumCenterX + trapesiumWidth/2, trapesiumBottomY - trapesiumHeight + detailHeightTop);
  
  // Titik kiri bawah detail (bergeser ke bawah)
  vertex(trapesiumCenterX - topWidth/2, trapesiumBottomY - trapesiumHeight + detailHeightTop);
  
  endShape(CLOSE);
}

void drawSand() {
  // Pasir pantai
  fill(255, 228, 181);
  noStroke();
  rect(0, 550, width, 250);
  
  // Tekstur pasir
  fill(240, 210, 160);
  for (int i = 0; i < 150; i++) {
    float x = random(width);
    float y = random(650, 780);
    ellipse(x, y, 2, 2);
  }
}

void drawBridge() {
  // Jembatan - Parameter Jajar Genjang Pertama (Horizontal)
  float alas1 = 200;
  float tinggi1 = 300;
  float geser1 = 100;
  float geserKiri1 = 720;
  float geserBawah1 = 200;
  
  // Parameter Jajar Genjang Kedua (Sisi Kanan Rendah + Rotasi 10°)
  float alas2 = 20;
  float tinggi2 = 300;
  float penurunanSisiKanan = 20; // Penurunan sisi kanan
  float sudutRotasi = 18; // Rotasi 18° searah jarum jam
  float geserKiri2 = -51;
  float geserBawah2 = 195;
  
  // Posisi pusat rotasi (titik tengah jajar genjang kedua)
  float pusatX = width/2 - geserKiri1 + alas1 + geserKiri2 + alas2/2;
  float pusatY = height/2 + geserBawah2 + penurunanSisiKanan/2;
  
  // Jajar Genjang Pertama (Tetap Horizontal)
  fill(#9a6e4b);
  noStroke();
  beginShape();
  vertex(width/2 - alas1/2 - geserKiri1, height/2 + tinggi1/2 + geserBawah1);
  vertex(width/2 - alas1/2 + geser1 - geserKiri1, height/2 - tinggi1/2 + geserBawah1);
  vertex(width/2 + alas1/2 + geser1 - geserKiri1, height/2 - tinggi1/2 + geserBawah1);
  vertex(width/2 + alas1/2 - geserKiri1, height/2 + tinggi1/2 + geserBawah1);
  endShape(CLOSE);
  
  // Garis-garis horizontal untuk jajar genjang pertama
  stroke(#7a5539); // Warna lebih gelap untuk garis
  strokeWeight(2);
  
  // Hitung batas atas dan bawah jajar genjang pertama
  float topY1 = height/2 - tinggi1/2 + geserBawah1;
  float bottomY1 = height/2 + tinggi1/2 + geserBawah1;
  
  // Gambar garis horizontal dengan jarak 25 pixel
  for (float y = topY1 + 30; y < bottomY1; y += 30) {
    // Hitung posisi X kiri dan kanan pada ketinggian y
    float progress = (y - topY1) / tinggi1; // Progress dari 0 (atas) ke 1 (bawah)
    
    // Interpolasi linear untuk mendapatkan posisi X kiri dan kanan
    float leftX = lerp(width/2 - alas1/2 + geser1 - geserKiri1, width/2 - alas1/2 - geserKiri1, progress);
    float rightX = lerp(width/2 + alas1/2 + geser1 - geserKiri1, width/2 + alas1/2 - geserKiri1, progress);
    
    line(leftX, y, rightX, y);
  }
  
  // Jajar Genjang Kedua (Rotasi 18° + Sisi Kanan Rendah)
  fill(#c8914e);
  noStroke();
  pushMatrix();
  translate(pusatX, pusatY); // Pindahkan origin ke pusat rotasi
  rotate(radians(sudutRotasi)); // Rotasi 18° searah jarum jam
  
  beginShape();
  // Titik relatif terhadap pusat rotasi
  // Kiri atas (setelah rotasi)
  vertex(-alas2/2, -tinggi2/2 - penurunanSisiKanan/2);
  // Kiri bawah
  vertex(-alas2/2, tinggi2/2 - penurunanSisiKanan/2);
  // Kanan bawah (lebih rendah)
  vertex(alas2/2, tinggi2/2 + penurunanSisiKanan/2);
  // Kanan atas (lebih rendah)
  vertex(alas2/2, -tinggi2/2 + penurunanSisiKanan/2);
  endShape(CLOSE);
  
  // Garis-garis horizontal untuk jajar genjang kedua (dalam koordinat yang dirotasi)
  stroke(#a67240); // Warna lebih gelap untuk garis
  strokeWeight(2);
  
  // Gambar garis horizontal dengan jarak 25 pixel di koordinat rotasi
  for (float localY = -tinggi2/2 + 30; localY < tinggi2/2; localY += 30) {
    // Hitung progress untuk interpolasi kemiringan
    float progress = (localY + tinggi2/2) / tinggi2;
    
    // Interpolasi untuk mendapatkan posisi X kiri dan kanan dengan penurunan sisi kanan
    float topOffset = -penurunanSisiKanan/2;
    float bottomOffset = penurunanSisiKanan/2;
    float currentOffset = lerp(topOffset, bottomOffset, progress);
    
    line(-alas2/2, localY + currentOffset, alas2/2, localY + currentOffset);
  }
  
  popMatrix();
}

void drawRocks() {
  fill(105, 105, 105);
  noStroke();
  
  for (Rock rock : rocks) {
    rock.display();
  }
}

// Kelas untuk batu-batu kecil
class Rock {
  float x, y, size;
  
  Rock(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void display() {
    fill(105, 105, 105);
    noStroke();
    ellipse(x, y, size, size * 0.7);
    
    // Bayangan batu
    fill(80, 80, 80);
    ellipse(x + 2, y + 2, size * 0.8, size * 0.5);
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
