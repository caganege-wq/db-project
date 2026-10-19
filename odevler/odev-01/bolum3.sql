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
