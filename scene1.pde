// Import library Sound
import processing.sound.*;

// Variabel untuk audio
SoundFile backgroundMusic;
SoundFile backSound; // Tambahkan ini untuk sound kedua

// Variabel untuk animasi
float waveOffset = 0;
float cloudOffset = 0;
ArrayList<Cloud> clouds;
ArrayList<Grass> grasses;
ArrayList<Rock> rocks;

// Variabel untuk karakter gambar pertama (bergerak)
PImage characterImg;
float characterX = 200; // Posisi X awal (kiri layar)
float characterY = 350; // Posisi Y (di depan rumah, sesuaikan jika perlu)
float walkSpeed = 2; // Kecepatan berjalan normal
boolean characterMoving = true;

// Variabel untuk gambar kedua (statis)
PImage secondImg;
float secondImgX = 900; // Posisi X tetap di sisi kanan
float secondImgY = 320; // Posisi Y sejajar dengan gambar pertama

void setup() {
  size(1435, 780);
  
  // Load dan putar audio
  backgroundMusic = new SoundFile(this, "Sc1.mp3");
  backgroundMusic.play(); // Putar sekali saja (tidak berulang)
  backgroundMusic.amp(5.0); // Volume penuh (100%)
  
  // Load dan putar backsound kedua
  backSound = new SoundFile(this, "soundsc1n2.wav"); // Ganti dengan nama file sound kamu
  backSound.amp(0.00001); // Set volume lebih kecil (0.3 = 30% dari volume penuh)
  backSound.loop(); // Putar berulang terus menerus sebagai backsound
  
  // Load gambar karakter pertama (ganti "character.png" dengan nama file gambar Anda)
  characterImg = loadImage("malinkecil.png");
  
  // Load gambar kedua (ganti dengan nama file gambar kedua Anda)
  secondImg = loadImage("ibumalin.png"); // Ganti dengan nama file gambar kedua
  
  // Inisialisasi awan
  clouds = new ArrayList<Cloud>();
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(random(width), random(50, 150), random(40, 80)));
  }
  
  // Inisialisasi rumput kecil (hindari area rumah: x 0-640)
  grasses = new ArrayList<Grass>();
  for (int i = 0; i < 12; i++) {
    float x = random(700, width - 50); // Hanya di sisi kanan, hindari area rumah
    grasses.add(new Grass(x, random(480, 580), random(8, 15)));
  }
  // Tambah rumput kecil di sisi kiri jauh dari rumah
  for (int i = 0; i < 8; i++) {
    float x = random(50, 200); // Sisi kiri jauh
    grasses.add(new Grass(x, random(500, 600), random(6, 12)));
  }
  
  // Tambah semak-semak besar di pojok kiri bawah
  for (int i = 0; i < 5; i++) {
    float x = random(20, 300); // Pojok kiri
    float y = random(720, 780); // Dekat bagian bawah
    grasses.add(new Grass(x, y, random(40, 80)));
  }
  
  // Inisialisasi batu
  rocks = new ArrayList<Rock>();
  for (int i = 0; i < 20; i++) {
    rocks.add(new Rock(random(width), random(420, 470), random(8, 25)));
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
  
  // Pasir pantai
  drawSand();
  
  // Batu-batu kecil di pantai
  drawRocks();
  
  // Rumput
  drawGrasses();
  
  // Rumah - panggil fungsi untuk menggambar rumah
  drawHouse();
  
  // Gambar karakter bergerak (gambar pertama)
  drawWalkingCharacter();
  
  // Gambar kedua yang statis
  drawSecondImage();
  
  // Update animasi
  waveOffset += 0.05;
  cloudOffset += 0.3;
  
  // Update posisi karakter - berhenti di X = 1300
  if (characterMoving && characterX < 500) {
    characterX += walkSpeed;
  } else if (characterX >= 1300) {
    characterMoving = false; // Karakter berhenti
    characterX = 1300; // Pastikan posisi tepat di 1300
  }
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

void drawGrasses() {
  for (Grass grass : grasses) {
    grass.display();
  }
}

void drawHouse() {
  // Simpan transformasi saat ini
  pushMatrix();
  
  // Pindahkan koordinat untuk posisi rumah (sesuaikan sesuai keinginan)
  translate(0, 0); // Menggeser rumah ke posisi (500, 150)
  
  // ATAP KEDUA (DI BELAKANG, BERGESER KE KIRI)
  // Warna sedikit berbeda (lebih gelap atau terang, tergantung efek yang diinginkan)
  fill(255, 176, 56); // Misalnya, warna cokelat kemerahan yang lebih gelap
  strokeWeight(1);  // Ketebalan stroke
  float offsetX = 50; // Jarak pergeseran ke kiri
  float offsetY = 15; // Jarak pergeseran ke bawah (untuk efek kedalaman)
  triangle(
    450 - offsetX, 50 + offsetY,  // Kiri bawah: geser X ke kiri, Y ke bawah
    500 - offsetX, -80 + offsetY, // Atas: geser X ke kiri, Y ke bawah
    750 - offsetX, 70 + offsetY   // Kanan bawah: geser X ke kiri, Y ke bawah
  );
  // ATAP PERTAMA (DI DEPAN, POSISI ASLI)
  fill(255, 176, 56); // Warna merah asli
  strokeWeight(1);  // Ketebalan stroke
  triangle(
    450, 50,    // Kiri bawah
    500, -80,   // Atas
    750, 70     // Kanan bawah
  );
  
  // DINDING RUMAH (3x4 cm → 300x400 px)
  fill(173, 94, 60); // coklat muda
  rect(0, 0, 480, 500); // dinding (melayang sedikit)
  
  // --- Corak Garis-Garis Vertikal ---
  stroke(150, 80, 50); // Warna garis, sedikit lebih gelap dari dinding
  strokeWeight(2);     // Ketebalan garis
  // Loop untuk menggambar garis vertikal
  for (int x = 0; x <= 480; x += 20) {
    line(x, 0, x, 500);
  }
  noStroke();
  
  // === FRAME PINTU (trapesium siku-siku, lebih tinggi ke atas 30px) ===
  fill(144, 70, 0);
  quad(30, 490,    // Titik 1: Kiri Bawah (tetap)
       360, 490,   // Titik 2: Kanan Bawah (tetap)
       360, 90,    // Titik 3: Kanan Atas (120 - 30 = 90)
       30, 40);    // Titik 4: Kiri Atas (70 - 30 = 40)
  
  // === PINTU (trapesium siku-siku, lebih tinggi ke atas 30px, mengikuti frame) ===
  fill(#FFB167); 
  quad(50, 470,    // Titik 1: Kiri Bawah (tetap)
       340, 470,   // Titik 2: Kanan Bawah (tetap)
       340, 120,   // Titik 3: Kanan Atas (150 - 30 = 120)
       50, 70);    // Titik 4: Kiri Atas (100 - 30 = 70)
 
  // PAGAR DALAM
  fill(#392512);
  rect(3, 370, 30, 100);
  rect(50, 370, 30, 100);
  rect(150, 370, 30, 100);
  rect(205, 370, 30, 100);
  rect(260, 370, 30, 100);
  rect(430, 370, 30, 100);
  rect(480, 370, 30, 100);
  rect(530, 370, 30, 100);
  rect(530, 370, 30, 100);
  rect(580, 370, 30, 100);
 
  // PAGAR
  fill(120, 70, 20);
  rect(0, 340, 100, 30);
  rect(130, 340, 160, 30);
  rect(430, 340, 180, 30);
 
  // TIANG
  fill(120, 70, 20);
  rect(90, 0, 40, 600); // kiri
  rect(0, 470, 600, 30);
  rect(600, 30, 40, 580); // kanan
  
  // TANGGA (pakai beberapa balok kecil seperti jajar genjang)
  fill(160, 90, 30);
  rect(280, 500, 180, 15); // tangga atas
  rect(285, 530, 180, 15); // tangga tengah
  rect(290, 560, 180, 15); // tangga bawah
  rect(295, 590, 180, 15); // tangga bawah
  
  // Kembalikan transformasi
  popMatrix();
}

void drawWalkingCharacter() {
  if (characterImg != null && (characterMoving || characterX <= 1300)) {
    // Gambar karakter di posisi yang ditentukan
    // Parameter: gambar, posisiX, posisiY, lebar, tinggi
    image(characterImg, characterX, characterY, 350, 400);
    
    // Opsional: Tambah bayangan sederhana di bawah karakter
    fill(0, 0, 0, 50);
    noStroke();
    ellipse(characterX + 250, characterY + 360, 80, 20);
  }
}

// Fungsi untuk menggambar gambar kedua yang statis
void drawSecondImage() {
  if (secondImg != null) {
    // Gambar kedua di posisi tetap
    // Parameter: gambar, posisiX, posisiY, lebar, tinggi
    image(secondImg, secondImgX, secondImgY, 350, 400);
    
    // Opsional: Tambah bayangan sederhana di bawah gambar kedua
    fill(0, 0, 0, 50);
    noStroke();
    ellipse(secondImgX + 175, secondImgY + 380, 80, 20);
  }
}

// Fungsi untuk kontrol karakter dengan tombol (opsional)
void keyPressed() {
  // Tekan spasi untuk mulai/berhenti karakter
  if (key == ' ') {
    if (characterX >= 1300) {
      // Reset ke posisi awal jika sudah sampai tujuan
      characterX = 100;
      characterMoving = true;
    } else {
      // Toggle gerak/berhenti
      characterMoving = !characterMoving;
    }
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

// Kelas untuk rumput (berbentuk semak-semak)
class Grass {
  float x, y, size;
  color grassColor;
  ArrayList<PVector> grassBlades;
  
  Grass(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    // Variasi warna hijau untuk rumput
    this.grassColor = color(random(40, 80), random(120, 180), random(30, 70));
    
    // Buat beberapa helai rumput dalam semak
    grassBlades = new ArrayList<PVector>();
    for (int i = 0; i < 8; i++) {
      float bladeX = random(-size/2, size/2);
      float bladeHeight = random(size * 0.8, size * 1.2);
      grassBlades.add(new PVector(bladeX, bladeHeight));
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    // Gambar dasar semak (bentuk oval di bawah)
    fill(red(grassColor) - 20, green(grassColor) - 20, blue(grassColor) - 20, 120);
    noStroke();
    ellipse(0, size * 0.3, size * 1.2, size * 0.4);
    
    // Gambar helai-helai rumput
    stroke(grassColor);
    strokeWeight(1.5);
    for (PVector blade : grassBlades) {
      // Helai rumput melengkung (lebih kecil)
      noFill();
      beginShape();
      vertex(blade.x, 0);
      vertex(blade.x + random(-2, 2), -blade.y * 0.3);
      vertex(blade.x + random(-3, 3), -blade.y * 0.7);
      vertex(blade.x + random(-2, 2), -blade.y);
      endShape();
    }
    
    // Tambahan detail semak dengan ellipse kecil-kecil
    noStroke();
    fill(grassColor, 150);
    for (int i = 0; i < 4; i++) {
      float detailX = random(-size * 0.4, size * 0.4);
      float detailY = random(-size * 0.8, -size * 0.2);
      ellipse(detailX, detailY, random(2, 5), random(3, 6));
    }
    
    popMatrix();
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
    // Variasi warna abu-abu untuk batu
    this.rockColor = color(random(80, 120), random(80, 120), random(80, 120), 180);
  }
  
  void display() {
    fill(rockColor);
    noStroke();
    
    // Batu berbentuk ellipse dengan sedikit variasi
    ellipse(x, y, size, size * 0.8);
    
    // Tambahan detail untuk membuat batu terlihat lebih natural
    fill(red(rockColor) - 20, green(rockColor) - 20, blue(rockColor) - 20, 120);
    ellipse(x + size * 0.1, y - size * 0.1, size * 0.6, size * 0.5);
  }
}
