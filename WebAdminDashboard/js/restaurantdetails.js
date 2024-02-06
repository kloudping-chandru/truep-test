
  import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-analytics.js";
  import { getDatabase, ref, get, set, onValue, child, update } from "https://www.gstatic.com/firebasejs/9.4.1/firebase-database.js";

  
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

const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const database = getDatabase(app);

var databaseRef=ref(database);


get(child(databaseRef, 'RestaurantDetails/')).then((datasnapshot) =>{
	var restName = datasnapshot.child("name").val();
	document.getElementById("restaurantname").innerHTML = restName;
	var restlogo = datasnapshot.child("logo").val();
	var logohtml = '<img class="img-profile rounded-circle" src="'+restlogo+'">'
	document.getElementById("restaurantlogo").innerHTML = logohtml ;
	
	});
