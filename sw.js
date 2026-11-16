// ===== NHE TAM PRO V5 - SERVICE WORKER AUTO UPDATE =====
const SW_VERSION = 'v5-build-1794700000'; // Doi so nay moi lan cap nhat
const CACHE_NAME = 'nhetam-' + SW_VERSION;

// Cai dat SW moi - bo qua cho
self.addEventListener('install', (event) => {
  self.skipWaiting(); // Kich hoat ngay, khong doi tab cu dong
});

// Kich hoat SW moi - xoa cache cu, nhan quyen dieu khien tat ca tab
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name.startsWith('nhetam-') && name !== CACHE_NAME)
          .map((name) => {
            console.log('[SW] Xoa cache cu:', name);
            return caches.delete(name);
          })
      );
    }).then(() => {
      return self.clients.claim(); // Nhan quyen dieu khien tat ca tab ngay
    }).then(() => {
      // Bao cho tat ca tab reload de lay ban moi (khong mat localStorage)
      return self.clients.matchAll({ type: 'window' }).then((clients) => {
        clients.forEach((client) => {
          client.postMessage({ type: 'SW_UPDATED', version: SW_VERSION });
        });
      });
    })
  );
});

// Fetch - luon lay tu mang truoc, cache du phong
self.addEventListener('fetch', (event) => {
  // Chi xu ly request GET
  if (event.request.method !== 'GET') return;

  event.respondWith(
    fetch(event.request, { cache: 'no-cache' })
      .then((response) => {
        // Luu vao cache moi
        if (response && response.status === 200) {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseClone);
          });
        }
        return response;
      })
      .catch(() => {
        // Neu mat mang, lay tu cache du phong
        return caches.match(event.request);
      })
  );
});
