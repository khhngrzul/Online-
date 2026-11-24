# Campus Hub — Flutter

Оюутны солилцоо, мэдээллийн апп (дарсны өнгө, оюутны кодоор нэвтрэх, зураг оруулах).

## Ажиллуулах

Flutter болон Python суулгасан байна.

1. Backend-ийг асаана:
   ```powershell
   cd backend
   python -m pip install -r requirements.txt
   python manage.py migrate
   python manage.py createsuperuser
   $env:DEBUG = "true"
   python manage.py runserver 0.0.0.0:8000
   ```
   `createsuperuser`-ийн username, email, password-оо өөрөө тохируулна. `$env:DEBUG = "true"`-г сервер асаадаг яг тэр terminal дээр runserver-ээс өмнө ажиллуулна.
2. Өөр terminal дээр Flutter-ийг асаана:
   ```powershell
   flutter pub get
   flutter run -d chrome
   ```
   Android emulator-ийн API хаягийг код автоматаар `10.0.2.2:8000` болгоно.
3. Өөр компьютер/утаснаас холбохдоо Flutter-ийг `--dart-define=API_BASE_URL=http://<backend-ийн-LAN-IP>:8000/api`-тай ажиллуулж, Django-ийн `ALLOWED_HOSTS` орчинд backend-ийн IP-г нэмнэ.
4. iOS: `ios/Runner/Info.plist` дотор `NSPhotoLibraryUsageDescription` байна.

Демо нэвтрэх: код `B240101001`, нууц үг `1234`.

## Өгөгдөл ба API

Зарын жагсаалт, ангилал, зурагтай зар нэмэх/устгах үйлдэл Django API-тай холбогдоно:

- `GET/POST /api/items/`
- `DELETE /api/items/<id>/`
- `GET /api/categories/`

Backend анх ажиллахад migration нь ангилал болон жишээ зар үүсгэнэ. Нэвтрэх эрх, чат, самбарын нийтлэл, таалагдсан зар одоогоор Flutter-ийн local state-д хэвээр; эдгээр нь backend-д синк хийгдээгүй.

## Бүтэц
```
lib/
  main.dart       апп эхлэх цэг + доод цэс
  models.dart     өнгө, модель, state, туслах функц
  api_service.dart Django REST API хүсэлтүүд
  nevtreh.dart    нэвтрэх / бүртгүүлэх (оюутны код)
  nuur.dart       нүүр + самбар
  zar_chat.dart   зар, зарын дэлгэрэнгүй, зар нэмэх, чат
  profile.dart    профайл + профайл засах
```
