import processing.sound.*;

// Audio
SoundFile soundFile;
boolean audioStarted = false;

SoundFile backSound;
boolean backSoundStarted = true;

// Variabel untuk animasi
float waveOffset = 0;
float rainOffset = 0;
int lightningFrame = 0;
boolean showLightning = false;
int lightningTimer = 0;

void setup() {
  size(1435, 780);
  
  // Load dan play audio
  soundFile = new SoundFile(this, "sc5.mp3");
  soundFile.play();
  soundFile.amp(5.0);
  audioStarted = true;
  
  // Load dan play backsound
backSound = new SoundFile(this, "soundsc5.mp3"); // ganti dengan nama file backsound kamu
backSound.amp(0.0001); // volume lebih kecil (30% dari volume normal)
backSound.loop(); // backsound akan loop terus
backSoundStarted = true;
  
  // Hapus noLoop() untuk membuat animasi
}

void draw() {
  // Background gradient spektakuler - langit badai epik
  for (int i = 0; i < height * 0.6; i++) {
    float inter = map(i, 0, height * 0.6, 0, 1);
    color c = lerpColor(color(5, 10, 20), color(15, 25, 40), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Transisi ke laut yang lebih dramatis
  for (int i = (int)(height * 0.6); i < height; i++) {
    float inter = map(i, height * 0.6, height, 0, 1);
    color c = lerpColor(color(10, 35, 60), color(20, 50, 80), inter);
    stroke(c);
    line(0, i, width, i);
  }
  
  // Awan badai yang menakutkan
  fill(20, 30, 40, 140);
  noStroke();
  ellipse(300, 100, 400, 120);
  ellipse(150, 140, 300, 80);
  ellipse(450, 80, 250, 70);
  
  fill(10, 20, 30, 120);
  ellipse(700, 120, 350, 100);
  ellipse(850, 90, 280, 75);
  ellipse(600, 160, 200, 60);
  
  fill(5, 15, 25, 100);
  ellipse(500, 50, 180, 50);
  ellipse(900, 60, 160, 45);
  
  // Gelombang laut yang sangat dinamis - DENGAN ANIMASI
  noFill();
  
  // Gelombang raksasa (paling depan)
  stroke(30, 70, 110);
  strokeWeight(12);
  beginShape();
  for (int x = -150; x < width + 150; x += 6) {
    float y = height - 140 + sin(x * 0.012 + waveOffset) * 45 + cos(x * 0.020 + waveOffset * 0.5) * 20 + sin(x * 0.008 + waveOffset * 0.3) * 15;
    vertex(x, y);
  }
  endShape();
  
  // Gelombang besar
  stroke(40, 80, 120);
  strokeWeight(8);
  beginShape();
  for (int x = -150; x < width + 150; x += 6) {
    float y = height - 190 + sin(x * 0.015 + 1 + waveOffset * 0.8) * 35 + cos(x * 0.018 + waveOffset * 0.6) * 18;
    vertex(x, y);
  }
  endShape();
  
  // Gelombang menengah
  stroke(50, 90, 130);
  strokeWeight(6);
  beginShape();
  for (int x = -150; x < width + 150; x += 6) {
    float y = height - 240 + sin(x * 0.020 + 2 + waveOffset * 1.2) * 25 + cos(x * 0.025 + waveOffset * 0.9) * 12;
    vertex(x, y);
  }
  endShape();
  
  // Gelombang kecil (background)
  stroke(60, 100, 140);
  strokeWeight(4);
  beginShape();
  for (int x = -150; x < width + 150; x += 6) {
    float y = height - 290 + sin(x * 0.025 + 3 + waveOffset * 1.5) * 18 + cos(x * 0.030 + waveOffset * 1.1) * 8;
    vertex(x, y);
  }
  endShape();
  
  // Posisi kapal
  float shipX = width/2;
  float shipY = height - 280;
  
  // Bayangan kapal yang dramatis (diperbesar)
  fill(5, 25, 45, 100);
  noStroke();
  ellipse(shipX, shipY + 120, 330, 60);
  ellipse(shipX - 15, shipY + 127, 270, 37);
  
  // KAPAL YANG SANGAT DETAIL - MENGGUNAKAN RECT() (DIPERBESAR)
  
  // Hull kapal - menggunakan rect berlapis (diperbesar)
  fill(140, 90, 50);
  stroke(90, 70, 40);
  strokeWeight(3);
  
  // Hull utama dengan bentuk kapal menggunakan rect (diperbesar)
  rect(shipX - 150, shipY - 22, 300, 45, 22);
  rect(shipX - 142, shipY + 15, 285, 37, 15);
  rect(shipX - 135, shipY + 45, 270, 30, 12);
  rect(shipX - 127, shipY + 67, 255, 22, 7);
  
  // Deck kapal berlapis (diperbesar)
  fill(110, 80, 45);
  rect(shipX - 142, shipY - 22, 285, 22, 7);
  
  fill(90, 65, 35);
  rect(shipX - 135, shipY - 15, 270, 12, 4);
  
  // Detail papan kayu pada hull menggunakan rect (diperbesar)
  fill(120, 85, 50);
  noStroke();
  for (int i = 0; i < 8; i++) {
    float y = shipY + 7 + i * 9;
    rect(shipX - 120, y, 240, 6, 3);
  }
  
  // Paku-paku pada kapal (diperbesar)
  fill(60, 60, 60);
  for (int i = 0; i < 12; i++) {
    for (int j = 0; j < 6; j++) {
      float x = shipX - 120 + i * 20;
      float y = shipY + 15 + j * 10;
      rect(x, y, 4, 4);
    }
  }
  
  // Tiang kapal menggunakan rect (diperbesar)
  fill(80, 60, 30);
  rect(shipX - 12, shipY - 300, 24, 285, 4);
  
  // Tiang horizontal untuk layar (diperbesar)
  rect(shipX - 120, shipY - 270, 240, 12, 4);
  rect(shipX - 112, shipY - 180, 225, 10, 4);
  rect(shipX - 90, shipY - 105, 180, 9, 4);
  
  // Crow's nest (sarang gagak) (diperbesar)
  fill(70, 50, 25);
  rect(shipX - 18, shipY - 285, 36, 18, 3);
  
  // LAYAR MENGGUNAKAN RECT() (DIPERBESAR)
  
  // Layar utama (terbesar) - menggunakan rect (diperbesar)
  fill(255, 250, 240);
  stroke(220, 210, 200);
  strokeWeight(2);
  rect(shipX - 112, shipY - 258, 225, 82, 12);
  
  // Layar tengah (diperbesar)
  rect(shipX - 105, shipY - 168, 210, 60, 9);
  
  // Layar kecil (jib sail) (diperbesar)
  rect(shipX - 82, shipY - 93, 165, 60, 7);
  
  // Detail anyaman pada layar menggunakan line (diperbesar)
  stroke(200, 190, 180);
  strokeWeight(1);
  
  // Garis vertikal pada layar utama (diperbesar)
  for (int i = 0; i < 7; i++) {
    float x = shipX - 90 + i * 30;
    line(x, shipY - 255, x, shipY - 180);
  }
  
  // Garis horizontal pada layar utama (diperbesar)
  for (int i = 0; i < 4; i++) {
    float y = shipY - 247 + i * 22;
    line(shipX - 105, y, shipX + 105, y);
  }
  
  // Garis pada layar tengah (diperbesar)
  for (int i = 0; i < 6; i++) {
    float x = shipX - 82 + i * 27;
    line(x, shipY - 165, x, shipY - 112);
  }
  
  // Garis pada layar kecil (diperbesar)
  for (int i = 0; i < 5; i++) {
    float x = shipX - 60 + i * 24;
    line(x, shipY - 90, x, shipY - 37);
  }
  
  // Tali layar menggunakan line() (diperbesar)
  stroke(120, 80, 40);
  strokeWeight(3);
  
  // Tali utama (diperbesar)
  line(shipX - 112, shipY - 258, shipX - 12, shipY - 300);
  line(shipX + 112, shipY - 258, shipX + 12, shipY - 300);
  line(shipX - 105, shipY - 187, shipX - 12, shipY - 210);
  line(shipX + 105, shipY - 187, shipX + 12, shipY - 210);
  
  // Tali tambahan (diperbesar)
  strokeWeight(2);
  line(shipX - 82, shipY - 112, shipX - 12, shipY - 135);
  line(shipX + 82, shipY - 112, shipX + 12, shipY - 135);
  
  // Tali rigging (diperbesar)
  strokeWeight(1);
  line(shipX - 120, shipY - 270, shipX - 150, shipY + 22);
  line(shipX + 120, shipY - 270, shipX + 150, shipY + 22);
  line(shipX - 112, shipY - 180, shipX - 135, shipY + 30);
  line(shipX + 112, shipY - 180, shipX + 135, shipY + 30);
  
  // Bendera menggunakan rect (diperbesar)
  fill(200, 50, 50);
  noStroke();
  rect(shipX + 12, shipY - 300, 37, 22, 3);
  
  // SISTEM ANIMASI PETIR
  lightningTimer++;
  if (lightningTimer > 60) { // Petir muncul setiap 60 frame (1 detik)
    showLightning = true;
    lightningFrame = 0;
    lightningTimer = 0;
  }
  
  if (showLightning) {
    lightningFrame++;
    if (lightningFrame > 10) { // Petir terlihat selama 10 frame
      showLightning = false;
    }
  }
  
  // PETIR ANIMASI - hanya muncul ketika showLightning = true
  if (showLightning) {
    // Petir kiri - sangat dramatis
    stroke(255, 255, 180);
    strokeWeight(8);
    
    // Batang utama petir kiri
    line(150, 30, 140, 80);
    line(140, 80, 165, 110);
    line(165, 110, 130, 160);
    line(130, 160, 155, 190);
    line(155, 190, 120, 240);
    line(120, 240, 145, 270);
    line(145, 270, 110, 320);
    line(110, 320, 135, 350);
    line(135, 350, 100, 400);
    line(100, 400, 125, 430);
    
    // Cabang utama petir kiri
    strokeWeight(4);
    stroke(255, 255, 200);
    line(140, 80, 110, 95);
    line(110, 95, 120, 115);
    line(120, 115, 95, 130);
    
    line(165, 110, 190, 125);
    line(190, 125, 180, 145);
    line(180, 145, 205, 160);
    
    line(130, 160, 105, 175);
    line(105, 175, 115, 195);
    
    line(155, 190, 180, 205);
    line(180, 205, 170, 225);
    
    line(120, 240, 95, 255);
    line(95, 255, 105, 275);
    
    line(145, 270, 170, 285);
    line(170, 285, 160, 305);
    
    // Sub-cabang kecil
    strokeWeight(2);
    stroke(255, 255, 255);
    line(110, 95, 90, 105);
    line(190, 125, 210, 135);
    line(105, 175, 85, 185);
    line(180, 205, 200, 215);
    line(95, 255, 75, 265);
    line(170, 285, 190, 295);
    
    // Petir kanan - DIPINDAHKAN LEBIH KE KANAN (dari 980 menjadi 1180)
    stroke(255, 255, 180);
    strokeWeight(8);
    
    // Batang utama petir kanan
    line(1180, 40, 1170, 90);
    line(1170, 90, 1195, 120);
    line(1195, 120, 1160, 170);
    line(1160, 170, 1185, 200);
    line(1185, 200, 1150, 250);
    line(1150, 250, 1175, 280);
    line(1175, 280, 1140, 330);
    line(1140, 330, 1165, 360);
    line(1165, 360, 1130, 410);
    line(1130, 410, 1155, 440);
    
    // Cabang utama petir kanan
    strokeWeight(4);
    stroke(255, 255, 200);
    line(1170, 90, 1140, 105);
    line(1140, 105, 1150, 125);
    line(1150, 125, 1125, 140);
    
    line(1195, 120, 1220, 135);
    line(1220, 135, 1210, 155);
    line(1210, 155, 1235, 170);
    
    line(1160, 170, 1135, 185);
    line(1135, 185, 1145, 205);
    
    line(1185, 200, 1210, 215);
    line(1210, 215, 1200, 235);
    
    line(1150, 250, 1125, 265);
    line(1125, 265, 1135, 285);
    
    line(1175, 280, 1200, 295);
    line(1200, 295, 1190, 315);
    
    // Sub-cabang kecil
    strokeWeight(2);
    stroke(255, 255, 255);
    line(1140, 105, 1120, 115);
    line(1220, 135, 1240, 145);
    line(1135, 185, 1115, 195);
    line(1210, 215, 1230, 225);
    line(1125, 265, 1105, 275);
    line(1200, 295, 1220, 305);
    
    // Petir tengah (background)
    strokeWeight(4);
    stroke(255, 255, 200);
    line(600, 20, 590, 70);
    line(590, 70, 610, 100);
    line(610, 100, 580, 150);
    line(580, 150, 600, 180);
    line(600, 180, 570, 230);
    line(570, 230, 590, 260);
    
    // Cabang petir tengah
    strokeWeight(2);
    line(590, 70, 575, 80);
    line(610, 100, 625, 110);
    line(580, 150, 565, 160);
    line(600, 180, 615, 190);
    
    // EFEK CAHAYA PETIR MENGGUNAKAN LINE()
    
    // Cahaya kilat di sekitar petir
    strokeWeight(1);
    stroke(255, 255, 255, 80);
    for (int i = 0; i < 30; i++) {
      float x1 = 150 + random(-50, 50);
      float y1 = 30 + random(0, 400);
      float x2 = x1 + random(-20, 20);
      float y2 = y1 + random(5, 20);
      line(x1, y1, x2, y2);
    }
    
    // Cahaya kilat untuk petir kanan yang dipindahkan
    for (int i = 0; i < 30; i++) {
      float x1 = 1180 + random(-50, 50);
      float y1 = 40 + random(0, 400);
      float x2 = x1 + random(-20, 20);
      float y2 = y1 + random(5, 20);
      line(x1, y1, x2, y2);
    }
    
    // Cahaya petir di air
    fill(255, 255, 200, 50);
    noStroke();
    ellipse(150, height - 120, 150, 30);
    ellipse(1180, height - 120, 160, 35);
    ellipse(600, height - 140, 100, 20);
  }
  
  // PERCIKAN AIR MENGGUNAKAN RECT() (DIPERBESAR)
  
  fill(70, 120, 170, 180);
  noStroke();
  
  // Percikan raksasa kiri (diperbesar)
  rect(shipX - 195, shipY + 30, 12, 60);
  rect(shipX - 187, shipY + 22, 9, 52);
  rect(shipX - 180, shipY + 37, 15, 67);
  rect(shipX - 172, shipY + 45, 7, 45);
  rect(shipX - 165, shipY + 30, 10, 52);
  
  // Percikan raksasa kanan (diperbesar)
  rect(shipX + 165, shipY + 37, 13, 67);
  rect(shipX + 172, shipY + 30, 10, 60);
  rect(shipX + 180, shipY + 45, 12, 75);
  rect(shipX + 187, shipY + 52, 9, 52);
  rect(shipX + 195, shipY + 37, 7, 45);
  
  // Percikan medium (diperbesar)
  fill(90, 140, 190, 120);
  for (int i = 0; i < 25; i++) {
    float x = shipX + random(-225, 225);
    float y = shipY + random(30, 120);
    rect(x, y, random(4, 12), random(15, 37));
  }
  
  // Percikan kecil (diperbesar)
  fill(110, 160, 210, 100);
  for (int i = 0; i < 40; i++) {
    float x = shipX + random(-270, 270);
    float y = shipY + random(22, 135);
    rect(x, y, random(3, 7), random(7, 22));
  }
  
  // HUJAN BADAI ANIMASI MENGGUNAKAN LINE()
  
  // Hujan sangat lebat - dengan animasi
  stroke(140, 150, 180, 80);
  strokeWeight(2);
  for (int i = 0; i < 400; i++) {
    float x = (i * 23 + rainOffset) % width;
    float y = (i * 17 + rainOffset * 2) % (height * 0.7);
    float len = 20 + sin(i + rainOffset * 0.1) * 10;
    line(x, y, x - 6, y + len);
  }
  
  // Hujan sedang - dengan animasi
  stroke(160, 170, 200, 60);
  strokeWeight(1);
  for (int i = 0; i < 300; i++) {
    float x = (i * 31 + rainOffset * 1.5) % width;
    float y = (i * 19 + rainOffset * 2.5) % (height * 0.8);
    float len = 15 + sin(i + rainOffset * 0.15) * 5;
    line(x, y, x - 4, y + len);
  }
  
  // Hujan ringan - dengan animasi
  stroke(180, 190, 220, 40);
  strokeWeight(0.5);
  for (int i = 0; i < 200; i++) {
    float x = (i * 37 + rainOffset * 2) % width;
    float y = (i * 29 + rainOffset * 3) % (height * 0.9);
    float len = 8 + sin(i + rainOffset * 0.2) * 4;
    line(x, y, x - 2, y + len);
  }
  
  // Efek angin pada hujan - dengan animasi
  stroke(200, 210, 240, 20);
  strokeWeight(0.3);
  for (int i = 0; i < 100; i++) {
    float x = (i * 41 + rainOffset * 2.5) % width;
    float y = (i * 33 + rainOffset * 3.5) % height;
    float len = 5 + sin(i + rainOffset * 0.25) * 3;
    line(x, y, x - 8, y + len);
  }
  
  // Update variabel animasi
  waveOffset += 0.05;
  rainOffset += 8;
  
  // Cek apakah audio masih diputar
  if (audioStarted && !soundFile.isPlaying()) {
    println("Audio selesai diputar");
    audioStarted = false;
  }
}

void mousePressed() {
  // Klik untuk memicu petir manual
  showLightning = true;
  lightningFrame = 0;
  
  // Restart audio jika sudah selesai
  if (!soundFile.isPlaying()) {
    soundFile.play();
    audioStarted = true;
    println("Audio dimulai ulang");
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    save("animated_epic_ship_storm.png");
  }
  
  // Kontrol audio dengan keyboard
  if (key == ' ') { // Spacebar untuk play/pause
    if (soundFile.isPlaying()) {
      soundFile.pause();
      println("Audio di-pause");
    } else {
      soundFile.play();
      audioStarted = true;
      println("Audio di-play");
    }
  }
  
  if (key == 'r' || key == 'R') { // R untuk restart audio
    soundFile.stop();
    soundFile.play();
    audioStarted = true;
    println("Audio di-restart");
  }
}
