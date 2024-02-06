import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-analytics.js";
import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-database.js";
import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-storage.js";

const firebaseConfig = {
	apiKey: "AIzaSyCXmwxk6KSFGdOld3xvHbyltg0k2_owwis",
	authDomain: "foodizm-android-877a3.firebaseapp.com",
	databaseURL: "https://foodizm-android-877a3-default-rtdb.firebaseio.com",
	projectId: "foodizm-android-877a3",
	storageBucket: "foodizm-android-877a3.appspot.com",
	messagingSenderId: "675773478633",
	appId: "1:675773478633:web:754913900c89de3fdf6278",
	measurementId: "G-8WDY1TTR54"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const database = getDatabase(app);
const databaseRef=ref(database);
const storage = getStorage();