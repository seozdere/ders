/* Seko Kontrol PWA — sadece bu sitenin statik dosyalarını önbelleğe alır. */
'use strict';
const CACHE = 'seko-kontrol-static-v7';
const CORE_FILES = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/icon-maskable-512.png',
  './icons/favicon-32.png',
  './icons/favicon-48.png',
  './icons/apple-touch-icon.png'
];
self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE);
    await cache.addAll(CORE_FILES);
    await self.skipWaiting();
  })());
});
self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const names = await caches.keys();
    await Promise.all(names.filter(name => name.startsWith('seko-kontrol-static-') && name !== CACHE)
      .map(name => caches.delete(name)));
    await self.clients.claim();
  })());
});
self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  // Cross-origin Supabase, kimlik doğrulama, CDN veya diğer istekler asla yakalanmaz.
  if (url.origin !== self.location.origin) return;
  // HTML sayfaları her zaman ağdan denenir: yeni Netlify sürümleri bayat kalmaz.
  if (request.mode === 'navigate') {
    event.respondWith((async () => {
      try {
        const response = await fetch(request);
        if (response.ok) {
          const cache = await caches.open(CACHE);
          await cache.put('./index.html', response.clone());
        }
        return response;
      } catch (_) {
        return (await caches.match(request)) || (await caches.match('./index.html')) || Response.error();
      }
    })());
    return;
  }
  // Yalnızca dağıtımla gelen açıkça belirtilmiş statik dosyalar cache'lenir.
  const allowed = CORE_FILES.some(path => new URL(path, self.registration.scope).pathname === url.pathname);
  if (!allowed) return;
  event.respondWith((async () => {
    const cached = await caches.match(request);
    if (cached) return cached;
    const response = await fetch(request);
    if (response.ok) (await caches.open(CACHE)).put(request, response.clone()).catch(() => {});
    return response;
  })());
});
