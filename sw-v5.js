self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', (event) => {
  // Pass-through network fetch required by Chrome Android WebAPK installer
  event.respondWith(fetch(event.request).catch(() => caches.match(event.request)));
});
