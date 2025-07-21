import processing.sound.*;

// Audio
SoundFile bgSound;
boolean soundPlayed = false;

// Variabel untuk animasi
float waveOffset = 0;
float cloudOffset = 0;
ArrayList<Cloud> clouds;

// Variabel untuk transisi cuaca
float timeOfDay = 0; // 0 = cerah, 1 = mendung gelap
float transitionSpeed = 0.01; // Kecepatan transisi (semakin kecil semakin lambat)

// Variabel untuk karakter
PImage characterImage;
float characterX, characterY;
float shakeAmount = 2.0; // Intensitas getaran
float shakeTimer = 0;

void setup() {
  size(1435, 780);
  
  // Load audio file
  bgSound = new SoundFile(this, "Sc4.mp3");
  
  // Load gambar karakter - GANTI NAMA FILE SESUAI GAMBAR ANDA
  characterImage = loadImage("ibumenangis.png"); // Ubah "character.png" dengan nama file gambar Anda
  
  // Posisi karakter di tengah layar, berada di pantai
  characterX = width / 2; // Sumbu X: tengah layar (717.5)
  characterY = 350; // Sumbu Y: di area pantai (antara laut dan pasir)
  
  // Inisialisasi awan
  clouds = new ArrayList<Cloud>();
  for (int i = 0; i < 5; i++) {
    clouds.add(new Cloud(random(width), random(50, 150), random(40, 80)));
  }
  
  // Putar audio saat program dimulai
  if (!soundPlayed) {
    bgSound.play();
    soundPlayed = true;
  }
}

void draw() {
  // Cek apakah audio masih berjalan
  if (soundPlayed && !bgSound.isPlaying()) {
    // Audio sudah selesai, bisa menambahkan aksi lain di sini jika diperlukan
    // Misalnya: println("Audio selesai diputar");
  }
  
  // Update transisi cuaca
  timeOfDay += transitionSpeed;
  if (timeOfDay > 1) {
    timeOfDay = 1; // Berhenti di kondisi paling gelap
  }
  
  // Langit dengan gradien yang berubah
  drawSky();
  
  // Awan bergerak dengan warna yang berubah
  drawClouds();
  
  // Matahari dengan intensitas yang berkurang
  drawSun();
  
  // Laut dengan warna yang meredup
  drawSea();
  
  // Pasir pantai dengan pencahayaan yang berkurang
  drawSand();
  
  // Gambar karakter dengan efek bergetar
  drawCharacter();
  
  // Update animasi
  waveOffset += 0.05;
  cloudOffset += 0.3;
  shakeTimer += 0.1;
}

void drawCharacter() {
  if (characterImage != null) {
    // Efek bergetar - getaran kecil dan halus
    float shakeX = sin(shakeTimer * 8) * shakeAmount;
    float shakeY = cos(shakeTimer * 12) * (shakeAmount * 0.7);
    
    // Gambar karakter dengan efek bergetar
    pushMatrix();
    translate(characterX + shakeX, characterY + shakeY);
    imageMode(CENTER);
    image(characterImage, 0, 0);
    popMatrix();
  }
}

void drawSky() {
  // Warna langit berubah dari cerah ke gelap
  for (int y = 0; y < 200; y++) {
    float inter = map(y, 0, 200, 0, 1);
    
    // Warna cerah (pagi)
    color brightTop = color(135, 206, 235);    // Biru langit cerah
    color brightBottom = color(255, 255, 200); // Kuning muda
    
    // Warna gelap (mendung)
    color darkTop = color(#292929);         // Abu-abu gelap
    color darkBottom = color(90, 90, 100);     // Abu-abu sedikit lebih terang
    
    // Interpolasi antara warna cerah dan gelap
    color currentTop = lerpColor(brightTop, darkTop, timeOfDay);
    color currentBottom = lerpColor(brightBottom, darkBottom, timeOfDay);
    
    color c = lerpColor(currentTop, currentBottom, inter);
    stroke(c);
    line(0, y, width, y);
  }
}

void drawClouds() {
  // Awan menjadi lebih gelap dan pekat
  float cloudAlpha = lerp(180, 220, timeOfDay); // Awan semakin solid
  float cloudGray = lerp(255, 120, timeOfDay);  // Awan berubah dari putih ke abu-abu
  
  fill(cloudGray, cloudGray, cloudGray, cloudAlpha);
  noStroke();
  
  for (Cloud cloud : clouds) {
    cloud.update();
    cloud.display();
  }
}

void drawSun() {
  // Matahari memudar saat mendung
  float sunAlpha = lerp(150, 20, timeOfDay);    // Matahari semakin redup
  float sunBrightness = lerp(255, 200, timeOfDay); // Warna matahari meredup
  
  fill(sunBrightness, sunBrightness, 0, sunAlpha);
  noStroke();
  ellipse(width - 100, 80, 60, 60);
  
  // Sinar matahari memudar
  float rayAlpha = lerp(100, 10, timeOfDay);
  stroke(sunBrightness, sunBrightness, 0, rayAlpha);
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
  // Laut berubah warna dari biru kehijauan cerah ke gelap
  color brightSea = color(0, 150, 150);  // Biru kehijauan cerah
  color darkSea = color(0, 80, 90);      // Biru kehijauan gelap
  
  color currentSeaColor = lerpColor(brightSea, darkSea, timeOfDay);
  fill(currentSeaColor);
  noStroke();
  rect(0, 200, width, 200);
  
  // Ombak dengan warna yang menyesuaikan
  color brightWave = color(0, 180, 180);
  color darkWave = color(0, 100, 110);
  color currentWaveColor = lerpColor(brightWave, darkWave, timeOfDay);
  
  fill(currentWaveColor);
  noStroke();
  beginShape();
  vertex(0, 200);
  
  for (int x = 0; x <= width; x += 10) {
    float wave = sin((x * 0.02) + waveOffset) * 8;
    vertex(x, 200 + wave);
  }
  
  vertex(width, 400);
  vertex(0, 400);
  endShape(CLOSE);
  
  // Buih ombak yang meredup
  float foamAlpha = lerp(150, 80, timeOfDay);
  fill(255, 255, 255, foamAlpha);
  for (int x = 0; x <= width; x += 15) {
    float wave = sin((x * 0.03) + waveOffset) * 5;
    ellipse(x, 280 + wave, 10, 5);
  }
}

void drawSand() {
  // Pasir dengan pencahayaan yang berkurang
  color brightSand = color(255, 227, 181);  // Pasir cerah
  color darkSand = color(180, 160, 130);    // Pasir gelap
  
  color currentSandColor = lerpColor(brightSand, darkSand, timeOfDay);
  fill(currentSandColor);
  noStroke();
  rect(0, 300, width, 500);
  
  // Tekstur pasir dengan warna yang menyesuaikan
  color brightTexture = color(240, 210, 160);
  color darkTexture = color(160, 140, 110);
  color currentTextureColor = lerpColor(brightTexture, darkTexture, timeOfDay);
  
  fill(currentTextureColor);
  for (int i = 0; i < 200; i++) {
    float x = random(width);
    float y = random(400, 780);
    ellipse(x, y, 2, 2);
  }
  
  // Detail pasir tambahan
  color brightDetail = color(230, 200, 150);
  color darkDetail = color(150, 130, 100);
  color currentDetailColor = lerpColor(brightDetail, darkDetail, timeOfDay);
  
  fill(currentDetailColor);
  for (int i = 0; i < 120; i++) {
    float x = random(width);
    float y = random(400, 780);
    ellipse(x, y, 1, 1);
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
    // Warna awan sudah diatur di drawClouds()
    // Awan terdiri dari beberapa lingkaran
    ellipse(x, y, size, size * 0.8);
    ellipse(x + size * 0.3, y, size * 0.8, size * 0.6);
    ellipse(x - size * 0.3, y, size * 0.8, size * 0.6);
    ellipse(x, y - size * 0.2, size * 0.6, size * 0.4);
  }
}

// Fungsi untuk reset animasi (tekan tombol 'r')
void keyPressed() {
  if (key == 'r' || key == 'R') {
    timeOfDay = 0; // Reset ke kondisi cerah
    // Reset audio juga jika ingin diputar ulang
    if (!bgSound.isPlaying()) {
      bgSound.play();
      soundPlayed = true;
    }
  }
}
