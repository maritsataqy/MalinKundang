// Import library Sound
import processing.sound.*;

// Variabel untuk audio
SoundFile sound;

// Variabel untuk animasi
float waveOffset = 0;
float cloudOffset = 0;
ArrayList<Cloud> clouds;

// Variabel untuk gambar dan animasi
PImage img1, img2, img3;
float img2YOffset = 0;      // Untuk animasi naik-turun gambar kedua
float img1ShakeOffset = 0;  // Untuk animasi bergetar gambar pertama
float shakeAmount = 1;      // Intensitas getar (kecil)
float bounceAmount = 10;    // Intensitas naik-turun

// Posisi dan ukuran gambar (bisa diubah sesuai kebutuhan)
float img1X = 300;    // Gambar 1 (kiri) - posisi X
float img1Y = 250;    // Gambar 1 (kiri) - posisi Y dasar
float img2X = 717;    // Gambar 2 (tengah) - posisi X (tengah layar: 1435/2 = 717.5)
float img2Y = 200;    // Gambar 2 (tengah) - posisi Y dasar
float img3X = 1000;   // Gambar 3 (kanan) - posisi X
float img3Y = 200;    // Gambar 3 (kanan) - posisi Y

// Ukuran gambar (bisa diubah untuk mengecilkan/membesarkan)
float imgWidth = 300;   // Lebar gambar (ubah sesuai kebutuhan)
float imgHeight = 400;  // Tinggi gambar (ubah sesuai kebutuhan)
float img3Width = 30;   // Lebar gambar (ubah sesuai kebutuhan)
float img3Height = 40;  // Tinggi gambar (ubah sesuai kebutuhan)

void setup() {
  size(1435, 780);
  
  // Load audio
  sound = new SoundFile(this, "Sc3.mp3");
  
  // Putar audio sekali (tidak loop)
  sound.play();
  
  // Load gambar (ganti dengan nama file gambar Anda)
  img1 = loadImage("ibuterjatuh.png");  // Ganti dengan nama file gambar pertama
  img2 = loadImage("durhakabgt.png");  // Ganti dengan nama file gambar kedua
  img3 = loadImage("apasih.png");  // Ganti dengan nama file gambar ketiga
  
  // Inisialisasi awan
  clouds = new ArrayList<Cloud>();
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(random(width), random(50, 150), random(40, 80)));
  }
}

void draw() {
  // Langit dengan gradien (dari kode kedua)
  drawSky();
  
  // Awan bergerak (dari kode kedua)
  drawClouds();
  
  // Matahari (dari kode kedua)
  drawSun();
  
  // Laut dengan ombak (dari kode kedua)
  drawSea();
  
  //Kapal sisi belakang orang
  drawBack();
  
  // Kapal sisi depan orang
  drawFront();
  
  // Gambar dengan animasi
  drawImages();
  
  // Update animasi
  updateAnimations();
}

void drawImages() {
  // Gambar 1 (kiri) - dengan sedikit bergetar
  if (img1 != null) {
    float shakeX = random(-shakeAmount, shakeAmount);
    float shakeY = random(-shakeAmount, shakeAmount);
    image(img1, img1X + shakeX, img1Y + shakeY, imgWidth, imgHeight);
  }
  
  // Gambar 2 (tengah) - dengan animasi naik-turun
  if (img2 != null) {
    image(img2, img2X, img2Y + img2YOffset, imgWidth, imgHeight);
  }
  
  // Gambar 3 (kanan) - tanpa animasi
  if (img3 != null) {
    image(img3, img3X, img3Y, imgWidth, imgHeight);
  }
}

void updateAnimations() {
  // Update animasi laut dan awan
  waveOffset += 0.05;
  cloudOffset += 0.3;
  
  // ANIMASI NAIK-TURUN GAMBAR KEDUA (gambar tengah)
  // Menggunakan sin() untuk gerakan naik-turun yang smooth
  img2YOffset = sin(millis() * 0.001) * bounceAmount;
  
  // ANIMASI BERGETAR GAMBAR PERTAMA (gambar kiri)
  // Animasi bergetar sudah diimplementasi di dalam drawImages()
  // menggunakan random() untuk gerakan acak kecil
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

void drawBack() {
  //KAPAL SISI BELAKANG ORANG (dari kode pertama)
  
  //kuning cerah panjang belakang
  fill(#fce73f);
  rect(0, 335, width, 5); // kiri
  
  //kuning atasnya
  fill(#dba62b);
  rect(0, 340, 1435, 20);
  
  
  //yg coklat
  fill(#80562c);
  rect(0, 360, 1435, 120);
  
  //frame coklat
  fill(#794f2a);
  rect(0, 360, 1435, 20);
  rect(120, 360, 15, 130);
  rect(620, 360, 15, 130);
  rect(1120, 360, 15, 130);
  
  
  //garis" yg coklat
  fill(#6b4626);
  rect(30, 360, 3, 120);
  rect(180, 360, 3, 120);
  rect(250, 360, 3, 120);
  rect(320, 360, 3, 120);
  rect(390, 360, 3, 120);
  rect(460, 360, 3, 120);
  rect(530, 360, 3, 120);
  rect(680, 360, 3, 120);
  rect(750, 360, 3, 120);
  rect(820, 360, 3, 120);
  rect(890, 360, 3, 120);
  rect(960, 360, 3, 120);
  rect(1030, 360, 3, 120);
  rect(1180, 360, 3, 120);
  rect(1250, 360, 3, 120);
  rect(1320, 360, 3, 120);
  rect(1390, 360, 3, 120);
  
  
  //kuning tiang tinggi
  fill(#cd8300);
  rect(100, 360, 20, 150);
  rect(600, 360, 20, 150);
  rect(1100, 360, 20, 150);
  
  //kuning di atas tiang
  fill(#cb6d0a);
  rect(100, 360, 20, 20);
  rect(600, 360, 20, 20);
  rect(1100, 360, 20, 20);
  
  
  //Lantai kapal
  fill(#c99c65);
  rect(0, 480, 1435, 300);
  
  // Garis-garis horizontal di lantai
  stroke(#a0824f); // Warna garis (coklat lebih gelap dari lantai)
  strokeWeight(2); // Ketebalan garis
  
  // Menggambar garis horizontal dengan jarak 40 pixel
  for (int y = 520; y < 780; y += 40) { // Mulai dari y=520, sampai y=780, dengan jarak 40
    line(0, y, 1435, y); // Garis dari kiri ke kanan layar
  }
  
  noStroke(); 
}

void drawFront() {
  // Kapal sisi dekat layar 
  //sisi tengah
  fill(#cb982a);
  rect(480, 695, 30, 150); //kiri
  rect(950, 695, 30, 150);
  
  // rect kecil
  fill(#bd8e29);
  rect(480, 695, 30, 30); //kiri
  rect(950, 695, 30, 30);
  
  
  //kuning cerah panjang depan
  fill(#fce73f);
  rect(0, 655, 550, 10); // kiri
  rect(920, 655, 550, 10);
  
  //kuning gelap panjang
  fill(#dba62b);
  rect(0, 665, 550, 30); // kiri
  rect(920, 665, 550, 30);
  
  //frame bawah
  fill(#80562c);
  rect(0, 695, 480, 180); // kiri
  rect(980, 695, 480, 100);
  
  // coklat bawah muda
  fill(#9b6132); 
  rect(0, 715, 460, 100);
  rect(1000, 715, 460, 100);
}

// Fungsi untuk kontrol keyboard (opsional)
void keyPressed() {
  // Jika ingin menambah kontrol manual
  if (key == 's' || key == 'S') {
    if (sound.isPlaying()) {
      sound.stop();
    } else {
      sound.play();
    }
  }
  
  // Tombol untuk pause/resume
  if (key == 'p' || key == 'P') {
    if (sound.isPlaying()) {
      sound.pause();
    } else {
      sound.play();
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
