# Ödev 1 - Bölüm 1: Algoritma ve izleme
# BLP 105 Veri Tabanı Yönetim Sistemleri


# ---------------------------------------------------------------------
# Soru 1.1: İz sürme
# ---------------------------------------------------------------------
# Kâğıt üstünde izleme tablosu (kodu çalıştırmadan önce):
#
# | i | numbers[i] | çift mi? | total | result         |
# |---|------------|----------|-------|----------------|
# | - | -          | -        | 0     | []             |  (başlangıç)
# | 0 | 4          | evet     | 4     | []             |
# | 1 | 7          | hayır    | 4     | [7]            |
# | 2 | 2          | evet     | 6     | [7]            |
# | 3 | 9          | hayır    | 6     | [7, 9]         |
# | 4 | 5          | hayır    | 6     | [7, 9, 5]      |
# | 5 | 1          | hayır    | 6     | [7, 9, 5, 1]   |
# | 6 | 8          | evet     | 14    | [7, 9, 5, 1]   |
#
# Tahmin: total = 14, result = [7, 9, 5, 1]
# Çalıştırınca: tahmin tuttu.
# (Not: i bir indeks, sayının kendisi değil. numbers[i] ile i'yi
#  karıştırmamak bu sorunun asıl dikkat noktası.)

print("Soru 1.1")
numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []

for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])

print(total)
print(result)


# ---------------------------------------------------------------------
# Soru 1.2: En uzun seri
# ---------------------------------------------------------------------
# Sözde kod:
#   seri <- 0          (şu an devam eden serinin uzunluğu)
#   en_uzun <- 0       (şimdiye kadar görülen en uzun seri)
#   her okuma için:
#       eğer okuma > eşik ise:
#           seri <- seri + 1
#           eğer seri > en_uzun ise:
#               en_uzun <- seri
#       değilse:
#           seri <- 0  (seri koptu, sıfırdan başla)
#   en_uzun'u yazdır

print("\nSoru 1.2")


def longest_streak(readings, threshold):
    streak = 0
    longest = 0
    for value in readings:
        if value > threshold:
            streak = streak + 1
            if streak > longest:
                longest = streak
        else:
            streak = 0
    return longest


# Örnekteki listeyle kontrol: cevap 3 olmalı
print(longest_streak([18, 25, 26, 27, 19], 22))

readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22
print(longest_streak(readings, threshold))
# Sonuç 5: 23, 25, 24, 26, 27 serisi (19 gelince kopuyor).
# İkinci seri 23, 24, 25, 26 dört okuma; 22 "üzerinde" değil, seriye girmiyor.


# ---------------------------------------------------------------------
# Soru 1.3: Elle gruplama
# ---------------------------------------------------------------------
print("\nSoru 1.3")

records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]

counts = {}
for record in records:
    course = record["course"]
    if course in counts:
        counts[course] = counts[course] + 1
    else:
        counts[course] = 1

print(counts)
# Beklenen: {'VTYS': 3, 'Yapay Zeka': 2, 'Robotik': 1}
#
# SQL karşılığı:
#   SELECT course, count(*) FROM records GROUP BY course;
# Sözlüğün anahtarı GROUP BY sütunu, sayaç ise count(*).
