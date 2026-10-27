# Мандах зар, мэдээллийн backend

Энэ backend нь таны Flutter формын нийтлэлийн төрөл, гарчиг, ангилал, хэнд зориулсан, дэлгэрэнгүй мэдээлэл болон зургийн URL-г PostgreSQL-д хадгална.

## 1. Шаардлага
- Node.js суусан байх
- PostgreSQL ажиллаж байх
- Flutter төсөлд `http` болон зураг сонгох бол `image_picker` package нэмэх

## 2. Өгөгдлийн сан үүсгэх
PostgreSQL дээр `mandakh_posts` нэртэй database үүсгээд `backend/schema.sql` файлыг ажиллуулна.

## 3. Backend ажиллуулах
`backend` хавтас руу орж:

```bash
npm install
```

`.env.example` файлыг `.env` нэрээр хуулж, `DATABASE_URL` дээр өөрийн PostgreSQL нууц үг, порт, database нэрийг тохируулна.

```bash
npm run dev
```

Ажиллаж байгаа эсэхийг `http://localhost:4000/api/health` дээр шалгана.

## 4. Flutter холбох
`flutter_lib/post_api.dart` файлыг өөрийн Flutter төслийн `lib/post_api.dart` болгон хуулна. `pubspec.yaml` дотор `http` package нэмээд `flutter pub get` ажиллуулна.

`apiBaseUrl`-ийг ажиллуулж буй төхөөрөмждөө тохируул:
- Chrome / Windows desktop: `http://localhost:4000`
- Android emulator: `http://10.0.2.2:4000`
- Бодит утас: компьютерийн LAN IP хаяг, жишээ нь `http://192.168.1.20:4000`

## 5. Нийтлэх товчийг холбоход
Таны `CreatePostScreen`-ийн `_Нийтлэх` товчны `onPressed` дотор `PostApi.createPost(...)` дуудна. Жишээ:

```dart
final result = await PostApi.createPost(
  postType: _selectedType,
  title: _titleController.text,
  category: _selectedCategory!,
  audience: _selectedAudience,
  content: _contentController.text,
);
```

Үүнийг `try/catch`, талбар шалгалт болон `mounted` шалгалттай async callback дотор ашиглаарай. Зураг сонгох, upload хийхэд `image_picker`-ээр сонгосон файлыг `PostApi.uploadImage(File(path))` руу өгч, буцаасан `imageUrl`-г `createPost` руу дамжуулна.

Анхаар: Энэ жишээ нь шинэ `posts` хүснэгт ашиглана. Таны одоо байгаа хүснэгтийн схем өөр бол `schema.sql` болон SQL query-г тааруулах шаардлагатай. Одоогоор хэрэглэгчийн нэвтрэлт/эрхийн шалгалт хийгдээгүй; бодит системд нэмэх хэрэгтэй.
