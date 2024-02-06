<?php
session_start();
	
	
if(isset($_POST['login'])) {

    $email = $_POST['email'];
    $pword = $_POST['password'];

      $_SESSION['email'] = $email;
      $_SESSION['password'] = $pword;

      header("location:index.php");
      exit;

  }

  if(!isset($_SESSION['email'], $_SESSION['password'])) {

?>

<!DOCTYPE html>
<html lang="en">

<head>

  <?php include('head.php'); ?>
  
  

</head>

<body class="loginbg">

  <div class="container">

    <!-- Outer Row -->
    <div class="row justify-content-center">

      <div class="col-xl-10 col-lg-12 col-md-9">

        <div class="card o-hidden border-0 shadow-lg my-5">
          <div class="card-body p-0">
            <!-- Nested Row within Card Body -->
            <div class="row">
              <div class="col-lg-6 d-none d-lg-block" id="restaurantlogo" style="background-color: #E91E63;">
              	<div class="d-flex align-items-center justify-content-center h-100">
              	<img src="img/white_logo.png" alt="" style="width: 200px;">    
              	</div>
              	
              </div>
              <div class="col-lg-6">
                <div class="p-5">
                  <div class="text-center">
                    <h1 class="h4 text-gray-900 mb-4">Welcome Back!</h1>
                  </div>
                  <form class="user" method="post"  action="login.php" id="loginform">
                    <div class="form-group">
                      <input type="email" class="form-control form-control-user" id="InputEmail" placeholder="Enter Email Address..." name="email" >
                    </div>
                    <div class="form-group">
                      <input type="password" class="form-control form-control-user" id="InputPassword" placeholder="Password" name="password" >
                    </div>
                   <input type="hidden" name="login" value="login">
                   <button type="button" class="btn btn-primary btn-user btn-block" name="submit" id="submit" >Login</button>
                    
                    <input type="" hidden="" id="submitlogin" name="login" value="login">

                    <hr>
                   
                  </form>
                  
                 
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </div>

  </div>


  <!-- Bootstrap core JavaScript-->
	
	
	
<?php include('footerlinks.php'); ?>
	
	<!--<script src="firebase.js"></script>-->
	

<script type="module">
	
	    import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";
// 		const firebaseConfig = {
//             apiKey: "AIzaSyDB24Jsbnavs0M7d7vwRE50UMZv1y5mROQ",
//             authDomain: "foodizmsubcription.firebaseapp.com",
//             databaseURL: "https://foodizmsubcription-default-rtdb.firebaseio.com",
//             projectId: "foodizmsubcription",
//             storageBucket: "foodizmsubcription.appspot.com",
//             messagingSenderId: "1011873790298",
//             appId: "1:1011873790298:web:e54b316ccba26bef189b63",
//             measurementId: "G-6LHY46N60Y"
//           };

              const firebaseConfig = {
                apiKey: "AIzaSyADShqWjJLLLhk51f1Ut_z_iiOZLi7xfgI",
                authDomain: "trupressed-7fb72.firebaseapp.com",
                databaseURL: "https://trupressed-7fb72-default-rtdb.asia-southeast1.firebasedatabase.app",
                projectId: "trupressed-7fb72",
                storageBucket: "trupressed-7fb72.appspot.com",
                messagingSenderId: "668703648575",
                appId: "1:668703648575:web:43d253f83f62115703418a",
                measurementId: "G-4313X9TH9K"
              };

		// Initialize Firebase
		const app = initializeApp(firebaseConfig);
		const analytics = getAnalytics(app);
		const database = getDatabase(app);
        const databaseRef=ref(database);
	
		
	//var firebaseConfig
	$("#submit").on('click', function(){
		//alert("ok");
	
		var useremail = document.getElementById("InputEmail").value;
		var userpass = document.getElementById("InputPassword").value;
		//alert(useremail);
		var databaseRef = ref(database);
		
		
		get(child(databaseRef, 'Admin/')).then((snapshot) => {
			
			var adminemail = snapshot.child("email").val();
			var adminpass = snapshot.child("password").val();
			if(useremail==adminemail && userpass==adminpass){
				
				$("#submitlogin").attr("type","submit");
				$("#submitlogin").click();
				
				//window.location = "index.php?login=true";
			}
			else{
				alert("Email or Password is incorrect");
			}
			
			
			}).catch((error) => {
			  console.error(error);
		});
		
//		adminTable.on('value', function(datasnapshot){
//			var adminemail = datasnapshot.child("email").val();
//			var adminpass = datasnapshot.child("password").val();
//			alert(adminemail);
//			if(useremail==adminemail && userpass==adminpass){
//				
//				$("#submitlogin").attr("type","submit");
//				$("#submitlogin").click();
//				
//				//window.location = "index.php?login=true";
//			}
//			else{
//				alert("Email or Password is incorrect");
//			}
//			
//			//alert(adminemail);
//			//alert(adminpass);
//			
//		});
		
	});
	
	
</script>
 
<!--<script src="js/restaurantdetails.js"></script>-->
</body>

</html>
<?php 
  }else{
		header("location:index.php?login=access");
	  
    	exit; 
	 }

	  ?>