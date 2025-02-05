# 🏎️ Mobil Araba Yarışı Oyunu v1.2.5

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart Version](https://img.shields.io/badge/Dart-3.x-blue)
![Version](https://img.shields.io/badge/Version-1.2.5-green)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Proje Hakkında

Bu proje, modern ve eğlenceli bir mobil araba yarışı oyunudur. Flutter kullanılarak geliştirilmiş olup, kullanıcılara heyecan verici bir oyun deneyimi sunmaktadır.

### 🎮 Özellikler

- 🎥 Özel splash video ekranı
- 🚗 Modern ve şık araba tasarımları
- 🎵 Arka plan müziği kontrolü
- 🏆 Yüksek skor sistemi
- 🌈 Etkileyici görsel efektler
- 🎨 Modern ve kullanıcı dostu arayüz
- 📊 Skor takip sistemi
- ⚡ Performans optimizasyonu
- 🔧 Kolay kontroller

## 🛠️ Teknik Detaylar

### Kullanılan Teknolojiler

- ⚡ Flutter 3.x
- 💾 SharedPreferences (Yerel depolama)
- 🎨 Custom Paint (Özel çizimler)
- 🎵 Audio Service (Ses yönetimi)
- 📦 GetIt (Bağımlılık enjeksiyonu)
- 🎥 Video Player (Splash video)

### Son Güncellemeler (v1.0.9)

#### 🎥 Splash Video Ekranı
- Özel açılış videosu eklendi
- Video Player entegrasyonu
- Tam ekran video desteği
- Otomatik menü geçişi

#### 🎵 Ses Sistemi İyileştirmeleri
- Arka plan müziği optimizasyonu
- Ses durumu hafıza sistemi
- Uygulama yaşam döngüsü entegrasyonu

#### 🎨 UI/UX Geliştirmeleri
- Responsive tasarım iyileştirmeleri
- Dinamik font boyutları
- Ekran oranlarına uyum
- SafeArea optimizasyonları

### Mimari

Proje, temiz mimari prensipleri gözetilerek geliştirilmiştir:

```
lib/
  ├── core/
  │   ├── constants/
  │   ├── services/
  │   ├── styles/
  │   └── widgets/
  ├── features/
  │   ├── game/
  │   │   ├── models/
  │   │   ├── pages/
  │   │   └── widgets/
  │   ├── splash/
  │   │   └── pages/
  │   └── settings/
  │       ├── pages/
  │       └── widgets/
  └── main.dart
```

## 🎯 Oyun Mekanikleri

- 🏁 Artan zorluk seviyesi
- 🚦 Rastgele engeller
- 💨 Hız kontrolü
- 💥 Çarpışma sistemi
- 🎯 Skor sistemi

## 🎨 Görsel Özellikler

- 🌈 Gradyan arka planlar
- 💫 Animasyonlar
- 🚥 LED efektleri
- 🌟 Parıltı efektleri
- 🎨 Modern UI tasarımı

## 🚀 Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/kerimayvaz77/RaceNS.git
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS

## �� Nasıl Oynanır?

1. 🎥 Açılış videosunu izleyin
2. 🎯 Parmağınızı ekranda sağa veya sola kaydırarak arabayı kontrol edin
3. 🚗 Diğer arabalardan kaçının
4. ⭐ Mümkün olduğunca uzun süre hayatta kalın
5. 🏆 Yüksek skor yapmaya çalışın

## 🔄 Güncellemeler

### Versiyon 1.2.5
- 🎥 Splash video sistemi iyileştirildi:
  - Video tam ekran desteği
  - Otomatik geçiş sistemi optimize edildi
  - Video performansı artırıldı
  - Hata yakalama mekanizması geliştirildi

- 🎮 Oyun deneyimi iyileştirmeleri:
  - Araba kontrolleri hassaslaştırıldı
  - Çarpışma sistemi geliştirildi
  - Skor sistemi optimize edildi

- 🔧 Teknik iyileştirmeler:
  - Bellek kullanımı optimize edildi
  - Performans iyileştirmeleri yapıldı
  - Hata ayıklama sistemi geliştirildi

### Versiyon 1.0.9
- 🎥 Splash video ekranı eklendi:
  - Özel açılış videosu
  - Tam ekran video desteği
  - Otomatik menü geçişi
  
- 🎵 Ses sistemi güncellemeleri:
  - Ekran kapandığında müzik otomatik durma özelliği
  - Uygulama arka plandayken müzik kontrolü
  - Müzik durumu hafıza sistemi iyileştirmesi
  - Ses seviyesi optimizasyonu

- 🎨 Responsive tasarım iyileştirmeleri:
  - Tüm ekran boyutlarına uyumlu hale getirildi
  - Dinamik font boyutları eklendi
  - Ekran oranlarına göre otomatik ölçeklendirme
  - SafeArea ve MediaQuery optimizasyonları
  - iPhone ve Android cihazlar için özel düzenlemeler

- 🛠️ Teknik iyileştirmeler:
  - ScreenUtil implementasyonu güncellendi
  - Widget ağacı optimizasyonu
  - Bellek yönetimi iyileştirmeleri
  - AppLifecycleState entegrasyonu
  - Tema ve renk sistemi güncellemesi

## 👨‍💻 Geliştirici

Kerim AYVAZ

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakınız.

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📞 İletişim

- 📧 E-posta: kerimayvaz7@gmail.com
- 💬 GitHub Issues: [issues](https://github.com/kerimayvaz77/RaceNS/issues)

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
