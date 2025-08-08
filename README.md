# Uzay Simülasyonu

Bu proje, gezegenlerin ve gök cisimlerinin konumlarını ve hareketlerini simüle eden bir Flutter uygulamasıdır. Uygulama, görsel varlıklar ve Python tabanlı bir sunucu ile birlikte çalışır.

## Özellikler

- Gezegenlerin ve uyduların konumlarını görselleştirme
- Python sunucusu ile veri alışverişi
- Zengin görsel içerik (gezegen, yıldız, uzay görselleri)
- Flutter ile modern arayüz

## Kurulum

1. Gerekli bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```

2. Sunucu tarafı için:
   ```bash
   cd server
   pip install -r requirements.txt
   python main.py
   ```

3. Uygulamayı başlatmak için:
   ```bash
   flutter run
   ```
4. Server başlatmak için:
   ```bash
   cd server
   uvicorn main:app --reload
   ```

## Dosya Yapısı

- `lib/` : Flutter uygulama kaynak dosyaları
- `assets/` : Görsel varlıklar
- `server/` : Python sunucu dosyaları ve veri setleri
- `test/` : Test dosyaları
- `android/`, `ios/` : Platforma özel dosyalar

## Kullanım

- Uygulamayı başlatın ve gezegenlerin konumlarını inceleyin.
- Sunucu ile veri alışverişi için Python sunucusunu çalıştırın.


