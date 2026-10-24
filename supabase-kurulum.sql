-- SEKOLATA / SUPABASE TEK SEFERLIK KURULUM
-- ONEMLI: Alttaki EPOSTA_ADRESIN@example.com degerini, Supabase Auth'ta
-- olusturdugunuz yonetici kullanicisinin e-postasi ile degistirin.
-- Bu dosyayi Supabase SQL Editor icinde SADECE BIR KEZ calistirin.

create table public.video_subjects (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(trim(title)) between 1 and 60),
  total integer not null default 0 check (total between 0 and 100000),
  done integer not null default 0 check (done between 0 and total),
  playlist_url text not null default '' check (char_length(playlist_url) <= 2048),
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

-- Web istemcisinin yalnizca gerek duydugu izinleri ver.
alter table public.video_subjects enable row level security;
revoke all on public.video_subjects from anon, authenticated;
grant select on public.video_subjects to anon, authenticated;
grant insert, update, delete on public.video_subjects to authenticated;

-- Tek duzenleyici yetkisi: kimligi JWT ile dogrulanan belirtilmis e-posta.
create function public.is_video_admin()
returns boolean
language sql stable security invoker
set search_path = ''
as $$
  select lower(coalesce(auth.jwt()->>'email', '')) = lower('EPOSTA_ADRESIN@example.com');
$$;
revoke all on function public.is_video_admin() from public, anon;
grant execute on function public.is_video_admin() to authenticated;

-- Herkes dersleri ve izleme ilerlemesini okuyabilir.
create policy "Herkes okuyabilir"
on public.video_subjects for select to anon, authenticated
using (true);

-- Yalnizca yukarida tanimlanan yonetici verileri degistirebilir.
create policy "Yonetici ekleyebilir"
on public.video_subjects for insert to authenticated
with check ((select public.is_video_admin()));

create policy "Yonetici duzenleyebilir"
on public.video_subjects for update to authenticated
using ((select public.is_video_admin()))
with check ((select public.is_video_admin()));

create policy "Yonetici silebilir"
on public.video_subjects for delete to authenticated
using ((select public.is_video_admin()));

-- + ve - islemlerini ayni anda birden cok istek gelse bile
-- atomik olarak guncelle: izlenen sayisi hicbir zaman 0..toplam disina cikmaz.
create function public.change_video_progress(p_id uuid, p_delta integer)
returns setof public.video_subjects
language sql security invoker
set search_path = ''
as $$
  update public.video_subjects
  set done = greatest(0, least(total, done + p_delta))
  where id = p_id and p_delta in (-1, 1)
  returning *;
$$;
revoke all on function public.change_video_progress(uuid,integer) from public, anon;
grant execute on function public.change_video_progress(uuid,integer) to authenticated;

-- Ilk oynatma listeleri. Video sayilari yonetici tarafindan girilecek.
insert into public.video_subjects (title, total, done, playlist_url, sort_order)
values
  ('AGS', 0, 0, '', 0),
  ('Tarih', 0, 0, '', 1),
  ('Coğrafya', 0, 0, '', 2);

-- Acik sayfalardaki ilerleme cubuklari anlik guncellensin.
alter publication supabase_realtime add table public.video_subjects;
