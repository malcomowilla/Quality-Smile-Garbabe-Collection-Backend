
import { initializeApp } from "firebase/app";
import { getMessaging } from "firebase/messaging/sw";

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
const firebaseApp = initializeApp({
  apiKey: 'AIzaSyCK9SjRH9BvsIbeyaQKpVqPMj7xrmKGL5g',
  authDomain: 'quality-smiles.firebaseapp.com',
  projectId: 'quality-smiles',
  storageBucket: 'quality-smiles.appspot.com',
  messagingSenderId: '273733149863',
  appId: '1:273733149863:web:180d5789bdafec3a86e782',
});




// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = getMessaging(firebaseApp);





