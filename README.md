# Video çalışma panom · Sekolata

GitHub Pages'te çalışan pastel, mobil uyumlu video ilerleme sitesi. Ders ekleme, düzenleme, silme, YouTube oynatma listesi ekleme, **yeşil +** ve **kırmızı −** düğmeleri içerir.

## Önemli: Veriler herkeste nasıl aynı olur?

GitHub Pages sadece statik dosya sunar. Ortak veri kaydetmesi için **Supabase** veritabanı gerekir. Proje bağlantısı kurulmadan `index.html` açılır ve *önizleme modunda* çalışır; bu modun verileri yalnızca o tarayıcıda saklanır. **Gerçek cihazlar arası paylaşım için aşağıdaki SQL ve yönetici kurulumunu tamamlayın.**

### 1. Mevcut Supabase projesinde yönetici oluştur

Supabase projen zaten tanımlı: `https://cilvblpqydnrtryvghit.supabase.co`. [Supabase Dashboard](https://supabase.com/dashboard) üzerinden bu projeyi aç.

**Authentication → Providers / Sign In** ayarlarında herkese açık yeni kullanıcı kaydını (sign-up) kapalı tutmak, yalnızca size ait bir yönetici hesabı kullanmak uygundur.

**Authentication → Users → Add user** bölümünden yönetici e-postanız ve parolanızla bir kullanıcı oluşturun (gerekiyorsa e-postayı onaylayın).

### 2. SQL kodunu çalıştır

Supabase **SQL Editor**'ü aç. Bu klasördeki `supabase-kurulum.sql` dosyasını aç, içindeki `EPOSTA_ADRESIN@example.com` kısmını oluşturduğun yönetici hesabının e-postasıyla değiştir, ardından SQL'i **bir defa** çalıştır.

Bu işlem AGS, Tarih ve Coğrafya listelerini oluşturur; **herkese okuma, sadece yöneticiye değiştirme** izni verir ve canlı güncellemeyi açar. Aynı SQL'i ikinci kez çalıştırma; aksi durumda mevcut tablo zaten bulunduğundan hata alırsın.

### 3. Supabase bağlantısı hazır

Proje URL’si ve gönderdiğin **publishable key** `index.html` içine yerleştirildi. Tekrar girmen gerekmez. **Ancak bunun veri tabanındaki tabloların oluşturulduğu anlamına gelmediğini unutma.**

**Asla `service_role` veya `secret` anahtarını HTML'ye koyma.** Publishable/anon key gizli değildir; verileri SQL dosyasındaki RLS kuralları korur.

### 4. GitHub Pages'e yükle

GitHub'da yeni bir repository oluştur. Düzenlediğin `index.html` dosyasını deponun ana klasörüne yükle. **Settings → Pages → Build and deployment → Deploy from a branch** → `main` / `/(root)` seç.

GitHub Pages adresini aç. Ziyaretçiler **aynı ilerlemeyi okur**. Üstteki **Yönetici girişi** ile giriş yaptığında ders ekleyebilir, değiştirebilir ve +/− kullanabilirsin. Başka cihazlardaki açık sayfalar canlı değişikliklerle güncellenir. Canlı bağlantı koptuğunda, sayfa odağa gelince ve belirli aralıklarla tekrar veritabanından okur.

### Kullanım notları

- Video sayısı YouTube'dan otomatik alınmıyor; kalem simgesiyle giriliyor.
- Oynatma listesi bağlantısı yalnızca YouTube adresi olabilir.
- Sonraki cihazdaki düzenleme için yöneticinin giriş yapması gerekir.
- Supabase bağlantısı çalışmazsa site eski/kayıt dışı sayılarla değişiklik yapmaz: hata durumu gösterir.
- Verilerin kalıcılığı Supabase projesini ve içerdiği veritabanını korumanıza bağlıdır. Düzenli yedek/export almak iyi fikirdir.
- Test amaçlı eski tarayıcı verileri otomatik olarak Supabase'e **aktarılmaz**. Eski değerleri bağlı sitede bir kez manuel gir.

## Dosyalar

- `index.html` — site (tek dosya; Supabase JS kütüphanesini CDN üzerinden yükler)
- `supabase-kurulum.sql` — ortak veri, güvenlik ve canlı güncellemeler
- `README.md` — bu kurulum rehberi

**Not:** Bu paket Supabase hesabına doğrudan bağlanarak SQL çalıştırmaz. URL ve publishable key herkese açık istemci bilgileri olduğundan tek başına SQL Editor yetkisi vermez. SQL dosyasındaki yönetici e-posta alanını doldurup dosyayı Supabase hesabında bir kez çalıştırmalısın. Bu işlem tamamlanmazsa veri kartları yüklenmeyebilir.
