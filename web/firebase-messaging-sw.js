importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: "AIzaSyAoGl7Q96mmksnylNId24uHNhg7ztMNibA",
    authDomain: "pushnotif-3e5be.firebaseapp.com",
    projectId: "pushnotif-3e5be",
    storageBucket: "pushnotif-3e5be.firebasestorage.app",
    messagingSenderId: "171015317576",
    appId: "1:171015317576:web:a734503034489ec796107d",
    measurementId: "G-6LXZ6D7DVF"
});

const messaging = firebase.messaging();
messaging.onBackgroundMessage(function (payload) {
    console.log('[SW] Background message received:', payload);

    const title = payload.data?.title ?? 'Notifikasi';
    const body = payload.data?.body ?? '';

    self.registration.showNotification(title, {
        body: body,
        icon: '/icons/Icon-192.png',
        badge: '/icons/Icon-192.png',
        tag: 'ibpr-notif',
        requireInteraction: true
    });
});