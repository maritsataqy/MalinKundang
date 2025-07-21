// Import library Sound
import processing.sound.*;

// Variabel untuk audio
SoundFile audioFile;
boolean audioPlayed = false; // Flag untuk memastikan audio hanya diputar sekali

SoundFile backSound;
boolean backSoundStarted = true;

// Animasi Pantai dari Atas - Orientasi Vertikal dengan Transisi Gambar
// Variabel untuk animasi gelombang
float time = 0;
float waveSpeed = 0.02;
float waveHeight = 30;

// Warna-warna
color oceanColor = color(64, 224, 208);  // Turquoise
color sandColor = color(255, 218, 165);  // Sandy brown
color rockColor = color(89, 89, 89);     // Dark gray
color starfishColor = color(255, 99, 71); // Tomato red
color shellColor = color(72, 139, 139);   // Dark sea green

// Array untuk menyimpan posisi batu
ArrayList<PVector> rocks;
ArrayList<Float> rockSizes;

// Posisi bintang laut dan kerang
PVector starfish;
PVector shell;

// Variabel untuk gambar dan efek - DIUBAH UNTUK ANIMASI OTOMATIS
PImage img1;
float darkenProgress = 0;
boolean darkening = true;  // UBAH: Mulai animasi otomatis
float darkenSpeed = 0.01;  // UBAH: Lebih cepat dari 0.005 ke 0.02

// Posisi dan ukuran gambar (bisa diubah sesuai kebutuhan)
float imageX = 900;      // Posisi X gambar (tengah layar horizontal: 1435/2 = 717.5)
float imageY = 400;      // Posisi Y gambar (tengah layar vertikal: 780/2 = 390)
float imageWidth = 300;  // Lebar gambar yang ditampilkan (diperbesar dari 200)
float imageHeight = 400; // Tinggi gambar yang ditampilkan (diperbesar dari 150)

void setup() {
  size(1435, 780);
  
    // Load dan play audio
  audioFile = new SoundFile(this, "sc6.mp3");
  audioFile.play();
  audioFile.amp(5.0);
  audioPlayed = true;
  
    // Load dan play backsound
backSound = new SoundFile(this, "soundscene6.wav"); // ganti dengan nama file backsound kamu
backSound.amp(0.0000001); // volume lebih kecil 
backSound.loop(); // backsound akan loop terus
backSoundStarted = true;
  
  // Muat gambar - ganti dengan path gambar Anda
  // PENTING: Letakkan file gambar di folder "data" di dalam folder sketch
  img1 = loadImage("malindurhaka.png"); // Ganti dengan nama file gambar Anda
  
  // Cek apakah gambar berhasil dimuat
  if (img1 == null) {
    println("PERINGATAN: malindurhaka.png tidak ditemukan!");
  }
  
  // Inisialisasi posisi batu-batu
  rocks = new ArrayList<PVector>();
  rockSizes = new ArrayList<Float>();
  
  // Batu-batu kecil - tersebar di area pantai yang lebih besar (sisi kanan)
  for (int i = 0; i < 25; i++) {
    rocks.add(new PVector(random(width*0.35, width-50), random(50, height-50)));
    rockSizes.add(random(15, 30));
  }
  
  // Posisi bintang laut dan kerang - sekarang di area pantai sisi kanan
  starfish = new PVector(700, 400);
  shell = new PVector(1050, 300);
  
  // UBAH: Hilangkan instruksi, hanya info sederhana
  println("Animasi dimulai otomatis!");
}

void draw() {
  background(sandColor);
  
  // Putar audio hanya sekali di awal
  if (!audioPlayed && audioFile != null) {
    audioFile.play();
    audioPlayed = true;
    println("Audio mulai diputar...");
  }
  
  // Cek apakah audio masih playing (opsional, untuk debugging)
  if (audioFile != null && !audioFile.isPlaying() && audioPlayed) {
    // Audio sudah selesai, bisa tambahkan aksi lain di sini jika diperlukan
    // println("Audio selesai diputar");
  }
  
  // Gambar laut dengan gelombang
  drawOcean();
  
  // Gambar batu-batu
  drawRocks();
  
  // Gambar efek penggelapan gambar
  drawImageWithDarkenEffect();
  
  // Gambar bintang laut
  drawStarfish();
  
  // Gambar kerang
  drawShell();
  
  // Update efek penggelapan jika sedang aktif
  if (darkening) {
    darkenProgress += darkenSpeed;
    if (darkenProgress >= 1.0) {
      darkenProgress = 1.0;
      darkening = false;
      // UBAH: Hilangkan println agar tidak ada output berlebihan
    }
  }
  
  // Update waktu untuk animasi
  time += waveSpeed;
  
  // HAPUS: Semua teks instruksi di layar dihapus
}

void drawImageWithDarkenEffect() {
  // Hanya gambar jika gambar berhasil dimuat
  if (img1 != null) {
    pushMatrix();
    translate(imageX, imageY);
    
    // Gambar asli dengan efek penggelapan bertahap
    imageMode(CENTER);
    
    // Hitung tingkat penggelapan (0 = transparan/asli, 1 = sangat gelap)
    float darkness = darkenProgress;
    
    // Terapkan tint untuk efek penggelapan/abu-abu
    // Semakin besar darkenProgress, semakin gelap gambarnya
    float brightness = 255 * (1 - darkness * 0.7); // 0.7 = seberapa gelap maksimalnya
    tint(brightness, brightness, brightness); // RGB sama = efek abu-abu
    
    image(img1, 0, 0, imageWidth, imageHeight);
    
    // Reset tint
    noTint();
    
    popMatrix();
    
  } else {
    // Jika gambar tidak ditemukan, tampilkan placeholder
    fill(255, 0, 0, 100);
    rectMode(CENTER);
    rect(imageX, imageY, imageWidth, imageHeight);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("GAMBAR TIDAK\nDITEMUKAN", imageX, imageY - 10);
    text("Letakkan malindurhaka.png\ndi folder 'data'", imageX, imageY + 20);
    textAlign(LEFT);
  }
}

void drawOcean() {
  fill(oceanColor);
  noStroke();
  
  // Gambar laut dengan tepi bergelombang - sekarang di sisi kiri
  beginShape();
  
  // Sisi kiri atas
  vertex(0, 0);
  
  // Sisi kiri bawah
  vertex(0, height);
  
  // Tepi pantai dengan gelombang - sekarang vertikal di sisi kanan laut
  for (float y = height; y >= 0; y -= 10) {
    float baseX = width * 0.13; // Garis dasar pantai (laut 1/3, pantai 2/3)
    float waveX = sin(y * 0.01 + time) * waveHeight;
    float noiseX = noise(y * 0.005, time * 0.5) * 40;
    
    vertex(baseX + waveX + noiseX, y);
  }
  
  // Tutup ke atas
  vertex(width * 0.33, 0);
  
  endShape(CLOSE);
  
  // Tambahkan gelombang kecil di dalam laut
  fill(oceanColor);
  stroke(255, 255, 255, 100);
  strokeWeight(2);
  
  for (int i = 0; i < 5; i++) {
    beginShape();
    noFill();
    for (float y = 0; y <= height; y += 15) {
      float x = width * 0.25 - i * 30 + sin(y * 0.02 + time + i) * 20;
      vertex(x, y);
    }
    endShape();
  }
}

void drawRocks() {
  fill(rockColor);
  noStroke();
  
  for (int i = 0; i < rocks.size(); i++) {
    PVector rock = rocks.get(i);
    float size = rockSizes.get(i);
    
    // Gambar batu dengan bentuk organik
    drawOrganicRock(rock.x, rock.y, size);
  }
}

void drawOrganicRock(float x, float y, float size) {
  pushMatrix();
  translate(x, y);
  
  // Buat bentuk batu yang organik
  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.2) {
    float radius = size * (0.8 + 0.4 * noise(angle * 2, x * 0.01, y * 0.01));
    float px = cos(angle) * radius;
    float py = sin(angle) * radius;
    vertex(px, py);
  }
  endShape(CLOSE);
  
  // Tambahkan detail pada batu
  fill(rockColor - 20);
  beginShape();
  for (float angle = 0; angle < TWO_PI; angle += 0.3) {
    float radius = size * 0.3 * (0.8 + 0.4 * noise(angle * 3, x * 0.01, y * 0.01));
    float px = cos(angle) * radius;
    float py = sin(angle) * radius;
    vertex(px, py);
  }
  endShape(CLOSE);
  
  popMatrix();
}

void drawStarfish() {
  fill(starfishColor);
  noStroke();
  
  pushMatrix();
  translate(starfish.x, starfish.y);
  rotate(time * 0.1);
  
  // Gambar bintang laut dengan 5 lengan
  beginShape();
  for (int i = 0; i < 5; i++) {
    float angle = i * TWO_PI / 5;
    
    // Ujung lengan
    float outerX = cos(angle) * 25;
    float outerY = sin(angle) * 25;
    vertex(outerX, outerY);
    
    // Lekukan antara lengan
    float innerAngle = angle + PI / 5;
    float innerX = cos(innerAngle) * 10;
    float innerY = sin(innerAngle) * 10;
    vertex(innerX, innerY);
  }
  endShape(CLOSE);
  
  // Tambahkan titik-titik pada bintang laut
  fill(starfishColor - 40);
  for (int i = 0; i < 8; i++) {
    float angle = random(TWO_PI);
    float radius = random(5, 15);
    float dotX = cos(angle) * radius;
    float dotY = sin(angle) * radius;
    ellipse(dotX, dotY, 3, 3);
  }
  
  popMatrix();
}

void drawShell() {
  fill(shellColor);
  noStroke();
  
  pushMatrix();
  translate(shell.x, shell.y);
  
  // Gambar kerang spiral
  beginShape();
  for (float angle = 0; angle < TWO_PI * 2; angle += 0.1) {
    float radius = 15 * (1 - angle / (TWO_PI * 2));
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape();
  
  // Tambahkan garis-garis pada kerang
  stroke(shellColor - 30);
  strokeWeight(1);
  for (int i = 0; i < 5; i++) {
    float angle = i * TWO_PI / 5;
    float x1 = cos(angle) * 5;
    float y1 = sin(angle) * 5;
    float x2 = cos(angle) * 15;
    float y2 = sin(angle) * 15;
    line(x1, y1, x2, y2);
  }
  
  popMatrix();
}
