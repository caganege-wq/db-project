# Ödev Raporu

**Ödev no:** Ödev 1     **Hafta:** 1-5     **Tarih:** 23 / 10 / 2026

**Ad Soyad:** Çağan Ege Akışık  **Öğrenci No:** 202507130050

**Program:** ☒ Robotik ve Yapay Zeka     **Kullandığım veritabanı:** ☒ `robot_fleet`

**PR bağlantısı:** `https://github.com/caganege-wq/db-project/pull/1`     **Commit sayısı:** 7

---

## 1. Ne yaptım

Bölüm 1'de üç Python sorusunu önce kâğıtta izleyip sonra kodladım; elle sözlükle yaptığım sayım (Soru 1.3), SQL'deki `GROUP BY course` ile aynı iş: sözlüğün anahtarı gruplama sütunu, değeri `count(*)`. Bölüm 2'de veritabanı kavramlarını kendi cümlelerimle yazdım. Bölüm 3 ve 4'te `robot_fleet` üzerinde 30 sorgu çalıştırdım ve her birinin satır sayısını kontrol ettim. En çok öğrendiğim şey, sorgunun hatasız çalışmasının sonucun doğru olduğu anlamına gelmediği: NULL içeren tek bir robot, birçok sorgunun sonucunu sessizce değiştirdi.

## 2. Sonuçlar

Çözdüğüm soru sayısı: 37 / 37 (3 + 4 + 15 + 15)     Bonus: ☐ denedim ☒ denemedim

En zorlandığım soru: **H5 Soru 15 (ek soru)**

**Neden zorlandım:** Ders notunu okuyunca `IS NULL` satırını sona taşıyınca Kartal-04'ün "Normal" olmasını bekliyordum, ama sonuç değişmedi ve önce nedenini anlayamadım.

**Nasıl çözdüm:** `CASE`'in koşulları yukarıdan aşağı denediğini hatırladım. `NULL < 20` ve `NULL < 60` doğru değil (bilinmiyor) olduğu için atlanıyor, `IS NULL` satırı `ELSE`'ten önce durduğu sürece onu yakalıyor. `IS NULL` satırını tamamen silince Kartal-04 "Normal" çıktı; asıl tehlikenin satırın yerinde değil, yokluğunda olduğunu böyle gördüm.

## 3. Ödevde sorulan dört konu

**Parantez tuzağı (H4 S7):** Parantezli 1, parantezsiz 2 satır; fark 1. `AND` önce bağlandığı için parantezsiz sorgu "şarjda olan herkes veya bataryası 50'nin altında bakımda olanlar" diye okunuyor. Bataryası bilinmeyen Kartal-04 şarjda olduğu için koşulsuz listeye girdi.

**Türkçe sıralama (H4 S14):** `COLLATE` olmadan Çağla, İsmail ve Şule Zeynep'ten sonra en sona düştü. `COLLATE "tr-TR-x-icu"` ile Çağla Can'ın, İsmail Emre'nin, Şule Kerem'in arkasına geçti; Zeynep en sona indi.

**Kayıp kayıtlar (H5):** `battery_level < 50` 5, `>= 50` 4 satır; toplam 9, oysa 10 robot var. Kayıp olan Kartal-04: bataryası NULL, iki karşılaştırmanın sonucu da "bilinmiyor" olduğu için ikisinde de elendi.

**İki ortalama (H5 S13):** `avg` 42.3, `avg(coalesce(..., 0))` 38.1; fark 4.2 puan. Daha dürüst olan 42.3, "9 robot üzerinden, 1 robotun sensörü arızalı" notuyla. Kartal-04'ün bataryası sıfır değil bilinmiyor; şarjda olduğu için sıfır olması da pek olası değil. Sıfır yazmak ölçmediğim bir değeri uydurmak ve filoyu olduğundan zayıf göstermek olur.

## 4. Beklemediğim bir sonuç

**Soru:** H4 S12 (en dolu 3 robot)  **Beklediğim:** Kartal-03 en üstte  **Gelen:** en üstte bataryası boş Kartal-04

**Sebebi:** PostgreSQL azalan sıralamada NULL'ı en büyük değer gibi en başa koyuyor. `WHERE battery_level IS NOT NULL` ekleyince doğru liste geldi. Benzer şekilde H4 S9'da 6 satır beklerken 5 geldi: bölgesi NULL olan Mars-03 `NOT IN` koşulunda elendi.

## 5. Aldığım bir hata ve çözümü

**Hata mesajı:** `ERROR: syntax error at or near "WHEN"`

**Sebebi ve çözümü:** H5 Soru 15'te `WHEN battery_level IS NULL` satırını "en sona" taşırken `ELSE 'Normal'` satırının da altına koydum. `ELSE` her zaman `CASE`'in son dalıdır, ondan sonra yeni bir `WHEN` gelemez; PostgreSQL hatanın tam yerini `^` işaretiyle gösterdi. Satırı `ELSE`'in hemen üstüne alınca sorgu çalıştı.

## 6. Yapay zeka kullanım beyanı

☒ Kullandım:

| Soru no | Araç | Ne sordum (özet) | Cevabı nasıl doğruladım |
|---|---|---|---|
| Tüm bölümler | Claude (Anthropic) | Ödev yönergesini verip dört bölümün çözümünü, sorgu yorumlarını ve rapor taslağını istedim | `bolum3.sql` ve `bolum4.sql` dosyalarını kendi `robot_fleet` veritabanımda `psql -f` ile çalıştırdım, her sorgunun satır sayısını dosyadaki yorumla karşılaştırdım. H4 S7, S12 ve H5 S13 sonuçlarını `SELECT * FROM robots;` çıktısına bakarak elle kontrol ettim (ör. 381 / 9 = 42.3). `bolum1.py`'yi çalıştırıp Soru 1.1'in izleme tablosunu Python Tutor'da adım adım takip ettim. |

## 7. Öz değerlendirme

| Ölçüt | 4 | 3 | 2 | 1 |
|---|---|---|---|---|
| A, Doğruluk | ☒ | ☐ | ☐ | ☐ |
| B, SQL kalitesi | ☒ | ☐ | ☐ | ☐ |
| C, Yorum ve analiz | ☐ | ☒ | ☐ | ☐ |
| D, Git ve PR | ☐ | ☒ | ☐ | ☐ |
| E, Dürüstlük ve beyan | ☒ | ☐ | ☐ | ☐ |

**Bir dahaki ödevde daha iyi yapacağım şey:** Yapay zekâyı çözümü baştan istemek yerine, önce kendim yazıp takıldığım sorguyu kontrol ettirmek için kullanacağım.

## 8. Bana sorun

Ders notunda NULL kontrolü `CASE`'in sonuna konursa sensörü bozuk robotun "Normal" olacağı yazıyor. Denediğimde `IS NULL` satırını `ELSE`'ten hemen önceye taşıyınca Kartal-04 yine "Bilinmiyor" çıktı; `ELSE`'ten sonraya koyunca sözdizimi hatası aldım. "Normal" sonucu yalnızca `IS NULL` satırı hiç yokken çıkıyor. Notta kastedilen bu durum muydu?

---

**İmza:** ________________________

*Doğruluk beyanı: Kullandığım tüm yardımcı kaynakları ve yapay zeka araçlarını yukarıda beyan ettim.*
