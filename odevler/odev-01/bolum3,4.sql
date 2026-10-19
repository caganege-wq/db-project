-- Ödev 1 - Bölüm 4: Gruplama ve NULL (Hafta 5 lab föyü)
-- Veritabanı: robot_fleet (Robotik ve Yapay Zeka, BLP 105)
-- Çalıştırma: psql -d robot_fleet -f bolum4.sql


-- Soru 1: Filoda kaç robot var?
SELECT count(*) AS robot_sayisi
FROM robots;
-- 10. count(*) satır sayar, sütunlardaki boşluklar bu sayıyı etkilemez.


-- Soru 2: Kaç robot görevde?
SELECT count(*) AS gorevdeki
FROM robots
WHERE status = 'active';
-- 6. Filonun yarısından fazlası görevde, ama bunlardan Mars-03'ün
-- bölgesi ve operatörü yok: kâğıt üstünde görevde, kimse sahiplenmemiş.


-- Soru 3: Bütün bataryaların toplamı
SELECT sum(battery_level) AS toplam_batarya
FROM robots;
-- 381. Bu toplam 10 değil 9 robotun toplamı; sum Kartal-04'ün NULL
-- değerini sessizce atladı.


-- Soru 4: Ortalama batarya, bir ondalık
SELECT round(avg(battery_level), 1) AS ort_batarya
FROM robots;
-- 42.3. Bu 381 / 9; avg da NULL'ı atlayıp 9'a bölüyor, 10'a değil.
-- Filonun ortalama şarjı yarının altında.


-- Soru 5: En düşük ve en yüksek batarya
SELECT min(battery_level) AS en_dusuk,
       max(battery_level) AS en_yuksek
FROM robots;
-- 0 ve 91. Sıfır olan Atlas-03 kapalı (offline) robot; en dolu Kartal-03.
-- NULL ne en küçük ne en büyük sayıldı.


-- Soru 6: Her durumda kaç robot var?
SELECT status, count(*) AS adet
FROM robots
GROUP BY status
ORDER BY adet DESC;
-- 4 satır döndü, çünkü status sütununda 4 farklı değer var
-- (active 6, charging 2, maintenance 1, offline 1). Toplam 10 tutuyor.


-- Soru 7: Her model için robot sayısı ve ortalama batarya
SELECT model,
       count(*) AS adet,
       round(avg(battery_level), 1) AS ort_batarya
FROM robots
GROUP BY model
ORDER BY model;
-- 3 satır. DRN-X1'in ortalaması (57.7) 4 değil 3 robottan hesaplandı,
-- Kartal-04 eksik; adet sütunu 4 dese de ortalama 3 robotun ortalaması.


-- Soru 8: Her bölgede, her durumdan kaç robot var?
SELECT zone, status, count(*) AS adet
FROM robots
GROUP BY zone, status
ORDER BY zone, status;
-- 7 satır. Beklenmeyen satır en alttaki bölgesi boş "active 1" satırı:
-- Mars-03'ün bölgesi NULL, GROUP BY NULL'ları ayrı bir grup yapıyor.
-- Depo A'nın iki satırda görünmesi de dikkat çekici: orada bir robot
-- çalışırken öteki (Atlas-03) kapalı.


-- Soru 9: Birden fazla robotu olan modeller
SELECT model, count(*) AS adet
FROM robots
GROUP BY model
HAVING count(*) > 1
ORDER BY model;
-- 3 satır. Üç modelin üçünde de birden fazla robot var, HAVING hiçbir
-- grubu elemedi. "Birden fazla" = count(*) > 1, yani en az 2.


-- Soru 10: Sadece görevdeki robotlar; en az 2 robotu olan modeller ve
-- ortalama bataryaları
SELECT model,
       count(*) AS adet,
       round(avg(battery_level), 1) AS ort_batarya
FROM robots
WHERE status = 'active'
GROUP BY model
HAVING count(*) >= 2
ORDER BY model;
-- 2 satır (AMR-300 3 robot 37.0, DRN-X1 2 robot 54.5).
-- WHERE gruplamadan önce görevde olmayan 4 robotu eledi.
-- HAVING gruplamadan sonra AMR-200'ü eledi: görevde tek robotu var (Atlas-01).


-- Soru 11: NULL avı, her sütunun dolu sayısı
SELECT count(*)             AS satir_sayisi,
       count(id)            AS id_dolu,
       count(name)          AS name_dolu,
       count(model)         AS model_dolu,
       count(status)        AS status_dolu,
       count(battery_level) AS batarya_dolu,
       count(zone)          AS zone_dolu,
       count(operator_name) AS operator_dolu
FROM robots;
-- 10 | 10 | 10 | 10 | 10 | 9 | 9 | 9
-- Üç sütunda birer eksik var: battery_level (Kartal-04, sensör arızası),
-- zone ve operator_name (ikisi de Mars-03, henüz atanmadı).
--
-- | Sütun         | Dolu | Eksik |
-- |---------------|------|-------|
-- | battery_level | 9    | 1     |
-- | zone          | 9    | 1     |
-- | operator_name | 9    | 1     |
-- | diğerleri     | 10   | 0     |


-- Soru 12: Bilgisi eksik olan robotlar
-- Önce = NULL ile:
SELECT name
FROM robots
WHERE battery_level = NULL
   OR zone = NULL
   OR operator_name = NULL;
-- 0 satır. Hata vermedi ama yanlış: NULL hiçbir şeye eşit değil,
-- "= NULL" karşılaştırması hep "bilinmiyor" dönüyor.

-- Sonra IS NULL ile:
SELECT name, battery_level, zone, operator_name
FROM robots
WHERE battery_level IS NULL
   OR zone IS NULL
   OR operator_name IS NULL;
-- 2 satır (Mars-03, Kartal-04). Soru 11'deki 3 eksik hücre 2 robota ait.


-- Soru 13: İki ortalama
SELECT round(avg(battery_level), 1)              AS bos_atlanarak,
       round(avg(coalesce(battery_level, 0)), 1) AS bos_sifir_sayilarak
FROM robots;
-- 42.3 | 38.1, fark 4.2 puan.
-- Bu veri için daha dürüst olan 42.3 (boşu atlayan), yanına "9 robot
-- üzerinden, Kartal-04'ün sensörü arızalı" notuyla. Kartal-04'ün bataryası
-- sıfır değil, bilinmiyor; şarjda olduğu için büyük ihtimalle sıfır da değil.
-- coalesce ile 0 yazmak, ölçmediğimiz bir değeri uydurmak olur ve filoyu
-- olduğundan zayıf gösterir.

-- Ek: kayıp kayıt
SELECT count(*) AS elliden_kucuk
FROM robots
WHERE battery_level < 50;
-- 5

SELECT count(*) AS elli_ve_ustu
FROM robots
WHERE battery_level >= 50;
-- 4. 5 + 4 = 9, oysa 10 robot var. Kayıp robot Kartal-04: bataryası
-- bilinmediği için iki koşulda da "bilinmiyor" sonucu alıp elendi.


-- Soru 14: Operatörleri işe giriş yılına göre say
SELECT extract(year FROM hired_at) AS giris_yili,
       count(*) AS operator_sayisi
FROM operators
GROUP BY giris_yili
ORDER BY giris_yili;
-- 4 satır (2023: 1, 2024: 3, 2025: 4, 2026: 2).
-- 10 operatörün 6'sı son iki yılda (2025-2026) işe girmiş; ekip görece yeni.
-- 2026'daki Kerem 1 Ekim'de başladı, henüz robotu yok.


-- Soru 15: Bataryaya göre kategori ve her kategoride kaç robot
SELECT CASE
         WHEN battery_level IS NULL THEN 'Bilinmiyor'
         WHEN battery_level < 20    THEN 'Kritik'
         WHEN battery_level < 60    THEN 'Düşük'
         ELSE                            'Normal'
       END AS kategori,
       count(*) AS adet
FROM robots
GROUP BY kategori
ORDER BY adet DESC;
-- 4 satır (Kritik 4, Normal 3, Düşük 2, Bilinmiyor 1). Toplam 10.
-- Filonun %40'ı kritik seviyede; bunların ikisi (Mars-02 ve Kartal-01)
-- şu an görevde.

-- Ek soru: IS NULL satırını en sona taşıyınca
SELECT name,
       CASE
         WHEN battery_level < 20    THEN 'Kritik'
         WHEN battery_level < 60    THEN 'Düşük'
         WHEN battery_level IS NULL THEN 'Bilinmiyor'
         ELSE                            'Normal'
       END AS kategori
FROM robots
WHERE name = 'Kartal-04';
-- Kartal-04 yine "Bilinmiyor". NULL < 20 ve NULL < 60 doğru değil
-- (bilinmiyor) olduğu için ilk iki WHEN atlandı, IS NULL satırı ELSE'ten
-- önce durduğu için onu yakaladı.
-- IS NULL satırını ELSE'ten sonraya koymak sözdizimi hatası veriyor.
-- IS NULL satırı hiç olmasaydı Kartal-04 ELSE'e düşüp "Normal" olurdu;
-- asıl tehlike bu.

-- Ödev 1 - Bölüm 3: SELECT ve WHERE (Hafta 4 lab föyü)
-- Veritabanı: robot_fleet (Robotik ve Yapay Zeka, BLP 105)
-- Çalıştırma: psql -d robot_fleet -f bolum3.sql


-- Soru 1: Bütün robotların adı ve modeli
SELECT name, model
FROM robots;
-- 10 satır döndü.


-- Soru 2: Robot adı ve eksik şarj miktarı (100 - batarya)
SELECT name AS robot,
       100 - battery_level AS missing
FROM robots;
-- 10 satır döndü.
-- Kartal-04'ün missing değeri boş: bataryası NULL, NULL ile yapılan
-- her hesap da NULL çıkıyor (100 - NULL = NULL).


-- Soru 3: Bataryası 50'nin üstündeki robotlar
SELECT name, battery_level
FROM robots
WHERE battery_level > 50;
-- 4 satır döndü (Atlas-01, Kartal-02, Kartal-03, Mars-03).


-- Soru 4: Bakımdaki robotlar
SELECT name, status
FROM robots
WHERE status = 'maintenance';
-- 1 satır döndü (Kartal-02).


-- Soru 5: Görevde olmayan robotlar
SELECT name, status
FROM robots
WHERE status <> 'active';
-- 4 satır döndü (2 şarjda, 1 bakımda, 1 kapalı).


-- Soru 6: AMR-300 modelinde olup bataryası 40'ın üstündeki robotlar
SELECT name, model, battery_level
FROM robots
WHERE model = 'AMR-300'
  AND battery_level > 40;
-- 2 satır döndü (Mars-01 47, Mars-03 55). Mars-02 (9) elendi.


-- Soru 7: Şarjda veya bakımda olan, bataryası 50'nin altındaki robotlar
SELECT name, status, battery_level
FROM robots
WHERE (status = 'charging' OR status = 'maintenance')
  AND battery_level < 50;
-- 1 satır döndü (Atlas-02, 15).

-- Soru 7 (parantezsiz deneme)
SELECT name, status, battery_level
FROM robots
WHERE status = 'charging' OR status = 'maintenance'
  AND battery_level < 50;
-- 2 satır döndü: Atlas-02 ve Kartal-04. Fark 1 satır.
-- AND, OR'dan önce bağlanır. Parantezsiz sorgu aslında şunu soruyor:
--   charging OR (maintenance AND battery_level < 50)
-- Böylece şarjdaki her robot batarya koşulu olmadan geliyor;
-- bataryası bilinmeyen Kartal-04 bu yüzden listeye giriyor.


-- Soru 8: Bataryası 15 ile 50 arasındaki robotlar (uçlar dahil)
SELECT name, battery_level
FROM robots
WHERE battery_level BETWEEN 15 AND 50;
-- 3 satır döndü (Atlas-02 15, Kartal-01 18, Mars-01 47).
-- BETWEEN uçları dahil eder: 15 değerli Atlas-02 listede.


-- Soru 9: Depo A veya Depo B'de olmayan robotlar
SELECT name, zone
FROM robots
WHERE zone NOT IN ('Depo A', 'Depo B');
-- 5 satır döndü.
-- 10 robottan 4'ü Depo A/B'de, yani 6 bekliyordum. Eksik olan Mars-03:
-- bölgesi NULL olduğu için "Depo A değil mi?" sorusunun cevabı bilinmiyor
-- ve satır eleniyor.


-- Soru 10: Adı "kartal" ile başlayan robotlar, büyük/küçük harf fark etmeksizin
SELECT name
FROM robots
WHERE name ILIKE 'kartal%';
-- 4 satır döndü (Kartal-01..04). 4 bekliyordum, 4 geldi.
-- Aynı sorguyu LIKE ile yazınca 0 satır geldi: LIKE harf büyüklüğüne
-- duyarlı, tablodaki isimler büyük K ile başlıyor.


-- Soru 11: Önce modele (A-Z), model içinde bataryaya (yüksekten düşüğe) göre
SELECT name, model, battery_level
FROM robots
ORDER BY model ASC,
         battery_level DESC;
-- 10 satır döndü.
-- DRN-X1 grubunda en üstte Kartal-04 (NULL) çıkıyor: PostgreSQL DESC
-- sıralamada NULL'ı en büyük değer gibi en başa koyuyor.


-- Soru 12: En dolu 3 robot
SELECT name, battery_level
FROM robots
WHERE battery_level IS NOT NULL
ORDER BY battery_level DESC
LIMIT 3;
-- 3 satır döndü (Kartal-03 91, Atlas-01 82, Kartal-02 64).
-- WHERE koşulu olmadan ilk sırada bataryası bilinmeyen Kartal-04 geliyordu
-- (Soru 11'deki NULL davranışı). "En dolu" listesinde bilinmeyen bir değer
-- olamayacağı için NULL'ları dışarıda bıraktım.


-- Soru 13: Filoda hangi bölgeler var?
SELECT DISTINCT zone
FROM robots
ORDER BY zone;
-- 6 satır döndü: Atölye, Depo A, Depo B, Dış Alan, Şarj ve bir boş satır.
-- Boş satır Mars-03'ün NULL bölgesi; DISTINCT NULL'ı da ayrı bir değer
-- olarak gösteriyor. Gerçek bölge sayısı 5.


-- Soru 14: Operatör adları, Türkçe alfabe sırasıyla
-- Önce COLLATE olmadan:
SELECT operator_name
FROM operators
ORDER BY operator_name;
-- 10 satır döndü. Çağla, İsmail ve Şule listenin sonunda, Zeynep'ten sonra
-- (sunucunun varsayılan sıralaması bayt koduna göre; Türkçe harflerin
-- kodu Z'den büyük).

-- Sonra Türkçe kurallarıyla:
SELECT operator_name
FROM operators
ORDER BY operator_name COLLATE "tr-TR-x-icu";
-- 10 satır döndü.
-- Yer değiştirenler: Çağla Can'ın arkasına, İsmail Emre'nin arkasına,
-- Şule Kerem'in arkasına geçti; Zeynep en sona indi.


-- Soru 15: Dış Alan veya Depo B'deki, görevdeki robotların adı, bölgesi ve
-- bataryası, en düşük bataryadan başlayarak
-- Tablo: robots | Sütunlar: name, zone, battery_level
-- Koşul: bölge Dış Alan/Depo B ve durum active | Sıra: batarya artan
SELECT name, zone, battery_level
FROM robots
WHERE zone IN ('Dış Alan', 'Depo B')
  AND status = 'active'
ORDER BY battery_level ASC;
-- 4 satır döndü (Mars-02 9, Kartal-01 18, Mars-01 47, Kartal-03 91).
-- İlk iki robot görevde ama bataryası 20'nin altında.
