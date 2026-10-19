[bolum2.md](https://github.com/user-attachments/files/33662210/bolum2.md)
# Ödev 1 - Bölüm 2: Veritabanı kavramları

## 1. Excel'de veri tutmanın üç sorunu

**Tutarsızlık:** Aynı bilgi birden fazla dosyada tutulur; birinde güncellenir, ötekinde eski kalır. Veritabanında bilgi tek yerde durur, her sorgu aynı güncel kaydı görür.

**Kontrolsüz veri girişi:** Excel'de "batarya" sütununa "yüzde seksen" ya da 150 yazmak serbesttir. Veritabanı her sütuna bir veri tipi ve kısıt (NOT NULL, CHECK, PRIMARY KEY) koyar, geçersiz veriyi daha girişte reddeder.

**Aynı anda çalışma ve yetki:** İki kişi aynı dosyayı açtığında biri ötekinin değişikliğini ezer, dosyayı açan da her şeyi görür. DBMS çok kullanıcılı erişimi yönetir ve kimin hangi tabloyu okuyup yazabileceğini rol bazında sınırlar.

## 2. Birincil anahtar

Birincil anahtar bir tablodaki her satırı tek başına ve kesin olarak ayırt eden sütundur; boş olamaz, tekrar edemez. Öğrenci numarası iyi bir birincil anahtardır çünkü okul her öğrenciye tek bir numara verir ve bu numara değişmez. Ad soyad değildir: aynı isimde iki öğrenci olabilir, isim evlilik ya da yazım düzeltmesiyle değişebilir.

## 3. DBMS ile veritabanı farkı

Veritabanı birbiriyle ilişkili verilerin düzenli toplamıdır, yani tablolar ve içlerindeki kayıtlardır (örneğin `robot_fleet`). DBMS bu veriyi saklayan, sorgulayan, yetkiyi ve eşzamanlı erişimi yöneten yazılımdır. PostgreSQL bir DBMS'tir; `robot_fleet` ise PostgreSQL'in içinde duran bir veritabanıdır.

## 4. Aynı kaydı iki kişi değiştirirse

Önlem alınmazsa ikinci yazan, birincinin değişikliğini fark etmeden ezer ve bir güncelleme kaybolur (lost update); DBMS bunu kilitleme ve işlem (transaction) mekanizmasıyla, kayda aynı anda yalnızca birinin yazmasına izin vererek önler.
