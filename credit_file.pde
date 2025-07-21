// Font variables
PFont titleFont, subtitleFont, textFont;

void setup() {
  size(1435, 780);
  
  // Load different font styles
  titleFont = createFont("Impact", 80);      // Font tebal untuk judul
  subtitleFont = createFont("Georgia", 36);  // Font elegan untuk subtitle  
  textFont = createFont("Arial", 28);        // Font bersih untuk teks
}

// Variabel untuk animasi
float timer = 0;
int phase = 0; // 0: tampil statis, 1: transisi ke nama
float fadeAlpha = 255;
boolean showNama = false;

// Array hikmah dan nama
String[] hikmahList = {
  "• Hormatilah orang tua dan jangan lupakan asal-usul",
  "• Kesombongan akan membawa kehancuran", 
  "• Kekayaan bukanlah segalanya dalam hidup"
};

String[] namaAnggota = {
  "Taqya Maritsa",
  "(23523108)",
  "Nayomi Khaizura",
  "(23523081)"
};

// Tambahan untuk mata kuliah
String[] namaMatkul = {
  "GRAFIKA DAN MULTIMEDIA"
};

void draw() {
  background(0); // Latar hitam
  
  timer += 0.016; // Asumsi 60 FPS
  
  // Judul besar yang statis (selalu tampil)
  fill(255, 215, 0); // Warna emas
  textAlign(CENTER);
  textFont(titleFont);
  textSize(80);
  text("MALIN KUNDANG", width/2, 150);
  
  // Garis dekoratif di bawah judul
  stroke(255, 215, 0);
  strokeWeight(3);
  line(width/2 - 300, 180, width/2 + 300, 180);
  noStroke();
  
  // Phase 0: Tampilkan hikmah statis selama 5 detik
  if (phase == 0) {
    // Subtitle "Hikmah Cerita"
    fill(200, 200, 200, fadeAlpha);
    textFont(subtitleFont);
    textSize(36);
    text("Hikmah Cerita", width/2, 250);
    
    // Tampilkan hikmah langsung tanpa animasi
    fill(255, fadeAlpha);
    textFont(textFont);
    textSize(28);
    textAlign(CENTER);
    
    for (int i = 0; i < hikmahList.length; i++) {
      float yPos = 320 + (i * 60);
      text(hikmahList[i], width/2, yPos);
    }
    
    // Setelah 5 detik, mulai transisi
    if (timer > 5) {
      phase = 1;
      timer = 0; // Reset timer untuk fase transisi
    }
  }
  
  // Phase 1: Transisi fade out hikmah dan fade in nama
  if (phase == 1) {
    // Fade out hikmah
    if (timer < 2) { // Durasi fade 2 detik
      fadeAlpha = 255 - (timer / 2) * 255;
      
      // Masih tampilkan hikmah dengan alpha menurun
      fill(200, 200, 200, fadeAlpha);
      textFont(subtitleFont);
      textSize(36);
      text("Hikmah Cerita", width/2, 250);
      
      fill(255, fadeAlpha);
      textFont(textFont);
      textSize(28);
      for (int i = 0; i < hikmahList.length; i++) {
        float yPos = 320 + (i * 60);
        text(hikmahList[i], width/2, yPos);
      }
    }
    
    // Fade in nama anggota
    if (timer > 1) { // Mulai fade in saat fade out hampir selesai
      showNama = true;
      float namaAlpha = ((timer - 1) / 2) * 255;
      namaAlpha = constrain(namaAlpha, 0, 255);
      
      // Tampilkan "Tim Produksi"
      fill(200, 200, 200, namaAlpha);
      textFont(subtitleFont);
      textSize(36);
      text("Tim Produksi", width/2, 280);
      
      // Tampilkan nama anggota
      fill(255, namaAlpha);
      textFont(textFont);
      textSize(24);
      
      for (int i = 0; i < namaAnggota.length; i++) {
        float yPos = 340 + (i * 40);
        text(namaAnggota[i], width/2, yPos);
      }
      
      // Tambahkan spasi kemudian tampilkan mata kuliah
      fill(200, 200, 200, namaAlpha);
      textFont(subtitleFont);
      textSize(32);
      text("Informasi Akademik", width/2, 340 + (namaAnggota.length * 40) + 60);
      
      // Tampilkan nama mata kuliah
      fill(255, namaAlpha);
      textFont(textFont);
      textSize(24);
      
      for (int i = 0; i < namaMatkul.length; i++) {
        float yPos = 340 + (namaAnggota.length * 40) + 100 + (i * 35);
        text(namaMatkul[i], width/2, yPos);
      }
      
      // Animasi berhenti di sini (tidak ada reset)
    }
  }
  
  // Efek bintang kecil di background
  drawStars();
}

void drawStars() {
  fill(255, 100);
  noStroke();
  for (int i = 0; i < 15; i++) {
    float x = (noise(i * 0.1, timer * 0.1) * width);
    float y = (noise(i * 0.1 + 100, timer * 0.1) * height);
    float size = noise(i * 0.5, timer * 0.1) * 6 + 3;
    
    // Efek kedip
    float alpha = sin(timer * 3 + i) * 30 + 70;
    fill(255, alpha);
    ellipse(x, y, size, size);
  }
}

void keyPressed() {
  // Tekan spasi untuk reset animasi
  if (key == ' ') {
    phase = 0;
    timer = 0;
    fadeAlpha = 255;
    showNama = false;
  }
}
