YENİ: DÖNEM ÖZETLERİ VE DERS AYRINTILARI (27.10.2026)

1. Supabase SQL Editor > New query bölümünde supabase-ozet-detay.sql dosyasının TAMAMINI çalıştır.
   Bu dosya önceki günlük onarımı da içerir; eski SQL dosyasını tekrar çalıştırma.
2. index.html ve sw.js dahil site dosyalarını birlikte yükle, sayfayı yenile.
3. Sol üstteki Özetler kutusu: Haftalık = son 7 gün, Aylık = son 30 gün,
   Üç aylık = son 90 gün. Bugün dahildir, tarihler İstanbul saatine göredir.
4. Bugünün Özeti veya dönem özetindeki Soru / Video / Deneme kutusuna bas:
   soru için ders ve konu; video için ders; deneme için AGS/ÖABT ve ad görünür.
5. Eski etkinlik toplamları korunur. Ders/konu bilgisi olmayan eski etkinlikler
   “Ayrıntısı bulunmayan eski kayıtlar” olarak görünür; geçmiş ayrıntılar uydurulmaz.
6. Kontrol: bir konuya +1 ekle; hem günlük hem haftalık sorularda ilgili konu +1 olmalı.
   Kalemle 10 artırınca +10, aynı gün 5 azaltınca -5 olmalı. Sayfa yenilenince korunmalı.
   Yeni deneme ekleme ve video +1 işlemlerinde de ilgili adı kontrol et.
7. Canlı Supabase üzerinde SQL bu ortamdan çalıştırılmadı. Kurulum sonrası doğrulama:
   select public.sekolata_summary(1);
   select public.sekolata_summary(7);

--- ÖNCEKİ KURULUM NOTLARI (aşağıdaki eski SQL yerine yukarıdaki yeni dosyayı kullan) ---

SEKO KONTROL — GÜNLÜK ÖZET SAYACI ONARIMI

KURULUM (SIRAYLA)
1. Supabase Dashboard > ilgili proje > SQL Editor > New query.
2. supabase-gunluk-onarim.sql dosyasının tamamını yapıştır ve Run çalıştır.
3. Sonuç tablosunda tracking_ready = true olmalı. Sıfır değerler, onarım sonrası henüz yeni işlem olmadığında normaldir.
4. Netlify'a bu klasörün İÇİNDEKİ tüm dosyaları, sw.js, manifest.webmanifest ve icons klasörü dahil, birlikte yükle.
5. Yüklü Android uygulamasını kapatıp yeniden aç. Gerekirse yenile. Service worker sürümü v4 oldu.
6. Soru Takibi'nde bir konuyu kalemle düzenle: örneğin 20 > 35. Bugünün Özeti açıkken soru sayacı 15 artmalı. Aynı konuyu 35 > 30 yapınca 5 düşmeli.

NOTLAR
- Günlük sayaç her işlemde en az 0 olur. Örneğin günün başında eski sorulardan 10 azaltıp ardından 1 eklemek günlük sayaçta 1 gösterir; gizli eksi bakiye oluşmaz.
- Bu düzeltme SQL tarafındadır: yalnızca index.html yüklemek yeterli değildir. SQL dosyasının tamamını çalıştır; kısmi seçimle çalıştırma.
- Günlük tetikleyiciler eksikse arayüz yanıltıcı 0 yerine bir kurulum uyarısı gösterir.
- Mevcut video/soru/deneme kayıtları SQL ile silinmez veya sıfırlanmaz.
- Önceden ayrı etkinlik kaydı tutulmayan işlemler geriye dönük hesaplanamaz.
- Sıfır, kayıtların bugün olmadığı veya kayıt tetikleyicisinin daha önce kurulmamış olduğu anlamına gelebilir. Onarım sonrası yeni işlemle test et.
- Kullanıcıya görünen sayaç Supabase'de gerçekten kaydedilmiş işlemler üzerinden hesaplanır, tarayıcıda sahte artış üretilmez.
- Gün, Europe/Istanbul saatine göre 00:00-23:59'dur.
- Uygulama Android/Chrome PWA olarak kurulabilir; ortak veri işlemlerinde internet gereklidir.
- Canlı Supabase'e bu ortamdan erişim sağlanamadığı için SQL'in hesabındaki sonucu burada doğrulanamamıştır.
