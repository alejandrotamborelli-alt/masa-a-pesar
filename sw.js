/* Service worker de "Masa a pesar".
 *
 * IMPORTANTE: subí VERSION en cada cambio que se publique (v1 -> v2 -> v3 ...).
 * Ese número es lo único que le avisa al navegador que hay una versión nueva
 * para descargar. Si no cambia, el iPad sigue mostrando la copia vieja.
 */
const VERSION = 'v8';
const CACHE = 'masa-a-pesar-' + VERSION;

const CORE = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icons/icon-192.png',
  './icons/icon-512.png',
  './icons/icon-maskable-512.png',
  './apple-touch-icon.png',
  './assets/fondo.jpg',
  './assets/frasco.png',
  './assets/matraz.png',
  './assets/balanza.png',
  './assets/pizarron.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE)
      .then((cache) => cache.addAll(CORE))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  if (req.method !== 'GET') return;

  const url = new URL(req.url);

  // Tipografías de Google: se guardan la primera vez que hay conexión.
  if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
    event.respondWith(
      caches.open(CACHE).then((cache) =>
        cache.match(req).then((hit) =>
          hit || fetch(req).then((res) => {
            cache.put(req, res.clone());
            return res;
          }).catch(() => hit)
        )
      )
    );
    return;
  }

  // Mismo origen: primero la copia local, si no hay se busca en la red.
  if (url.origin === self.location.origin) {
    event.respondWith(
      caches.match(req).then((hit) =>
        hit || fetch(req).then((res) => {
          const copy = res.clone();
          caches.open(CACHE).then((cache) => cache.put(req, copy));
          return res;
        }).catch(() =>
          req.mode === 'navigate' ? caches.match('./index.html') : undefined
        )
      )
    );
  }
});
