<?php

session_start();

	$driverid = $_GET['driverid'];
if ( isset( $_SESSION[ 'email' ], $_SESSION[ 'password' ] ) ) {
	?>

	<!DOCTYPE html>
	<html lang="en">

	<head>

		<?php include('head.php'); ?>
		<!-- Custom styles for this page -->
		<link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

	</head>

	<body id="page-top">

		<!-- Page Wrapper -->
		<div id="wrapper">

			<!-- Sidebar -->
			<?php $pagename="drivers"; ?>
			<?php include('sidebar.php'); ?>
			<!-- End of Sidebar -->

			<!-- Content Wrapper -->
			<div id="content-wrapper" class="d-flex flex-column">

				<!-- Main Content -->
				<div id="content">

					<!-- Topbar -->
					<?php include('topnavbar.php'); ?>
					<!-- End of Topbar -->

					<!-- Begin Page Content -->
					<div class="container-fluid">

						
						<!-- Page Heading -->
						<h1 class="h3 mb-2 text-gray-800">Driver ID <strong><span class="text-uppercase driverId" ></span></strong>  </h1>
						
						<div class="row">
							
							<!--<div class="col-xl-6 col-lg-6 mb-2">-->
							<!-- 	<div class="card shadow mb-4">-->
							<!-- 		<div class="card-header py-3">-->
							<!--	  		<h6 class="m-0 font-weight-bold text-primary">Driver Image</h6>-->
							<!--		</div>-->
							<!--		<div class="card-body">-->
							<!--			<img src="images/loading.gif" height="300px" alt="" id="image" width="100%">-->
							<!--		</div>-->
							<!-- 	</div>-->
							 	
							<!--</div>-->
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Driver Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody>
												<tr>
												  <td>Age</td>
												  <td id="age"></td>
												</tr>
												<tr>
												  <td>Full Name</td>
												  <td id="fullName"></td>
												</tr>
												<tr>
												  <td>Email</td>
												  <td id="email"></td>
												</tr>
												<!--<tr>-->
												<!--  <td>License No</td>-->
												<!--  <td id="license_no"></td>-->
												<!--</tr>-->
												<tr>
												  <td>Phone Number</td>
												  <td id="phoneNumber"></td>
												</tr>
												<tr>
												  <td>Token</td>
												  <td id="token"></td>
												</tr>
												<tr>
												  <td>User Name</td>
												  <td id="userName"></td>
												</tr>
												<tr>
												  <td>Vehicle</td>
												  <td id="vehicle"></td>
												</tr>
												<tr>
												  <td>Approval Status</td>
												  <td id="approvalStatus"></td>
												</tr>
												<tr>    
												  <td>Online Status</td>
												  <td id="onlineStatus"></td>
												</tr>
											    <tr>
												  <td>Vin</td>
												  <td id="vin"></td>
												</tr>
                                            </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
							</div>
							
							
							
							
						</div>

     <!--                   <div class="row">-->
     <!--                       <div class="col-xl-6 col-lg-6 mb-2">-->
					<!--		 	<div class="card shadow mb-4">-->
					<!--		 		<div class="card-header py-3">-->
					<!--			  		<h6 class="m-0 font-weight-bold text-primary">Id Card Front</h6>-->
					<!--				</div>-->
					<!--				<div class="card-body">-->
					<!--					<img src="images/loading.gif" height="300px" alt="" id="idCardFront" width="100%">-->
					<!--				</div>-->
					<!--		 	</div>-->

     <!--                   </div>-->
     <!--                           <div class="col-xl-6 col-lg-6 mb-2">-->
					<!--		 	<div class="card shadow mb-4">-->
					<!--		 		<div class="card-header py-3">-->
					<!--			  		<h6 class="m-0 font-weight-bold text-primary">Id Card Back</h6>-->
					<!--				</div>-->
					<!--				<div class="card-body">-->
					<!--					<img src="images/loading.gif" height="300px" alt="" id="idCardBack" width="100%">-->
					<!--				</div>-->
					<!--		 	</div>-->

					<!--</div>-->
					
					<!-- /.container-fluid -->

				<!--</div>-->
				<!-- <div class="row">-->
    <!--                        <div class="col-xl-6 col-lg-6 mb-2">-->
				<!--			 	<div class="card shadow mb-4">-->
				<!--			 		<div class="card-header py-3">-->
				<!--				  		<h6 class="m-0 font-weight-bold text-primary">License Front</h6>-->
				<!--					</div>-->
				<!--					<div class="card-body">-->
				<!--						<img src="images/loading.gif" height="300px" alt="" id="licenseFront" width="100%">-->
				<!--					</div>-->
				<!--			 	</div>-->

    <!--                    </div>-->
    <!--                            <div class="col-xl-6 col-lg-6 mb-2">-->
				<!--			 	<div class="card shadow mb-4">-->
				<!--			 		<div class="card-header py-3">-->
				<!--				  		<h6 class="m-0 font-weight-bold text-primary">License Back</h6>-->
				<!--					</div>-->
				<!--					<div class="card-body">-->
				<!--						<img src="images/loading.gif" height="300px" alt="" id="licenseBack" width="100%">-->
				<!--					</div>-->
				<!--			 	</div>-->

				<!--	</div>-->
					
					<!-- /.container-fluid -->

				</div>
				<!-- End of Main Content -->

				<!-- Footer -->
				<?php include('footer.php') ?>
				<!-- End of Footer -->

			</div>
			<!-- End of Content Wrapper -->

		</div>
		<!-- End of Page Wrapper -->

		<!-- Scroll to Top Button-->
		<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>
	



<?php include('footerlinks.php') ?>
		<!-- Page level plugins -->
		<script src="vendor/datatables/jquery.dataTables.min.js"></script>
		<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

		<!-- Page level custom scripts -->
		<script src="js/demo/datatables-demo.js"></script>
	
	<!--<script src="firebase.js"></script>-->


<script type="module">
// 	import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
// 		import { getDatabase, ref, get, set, onValue, child, orderByChild, equalTo, query  } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

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
	
	var driverId = '<?php echo $driverid ?>';
	//alert(ordernodeid);
	
	get(child(databaseRef, 'Drivers/'+driverId)).then((snapshot) =>{

		
			var timestamp =  snapshot.child("timeCreated").val();
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
		
		
			var uid = snapshot.key;
			$('.driverId').html(uid);
			
			var age = snapshot.child("age").val();
			$('#age').html(age);
			var fullName = snapshot.child("fullName").val();
			$('#fullName').html(fullName);
		
			var email = snapshot.child("email").val();
			$('#email').html(email);
			var license_no = snapshot.child("licenseNo").val();
			$('#license_no').html(license_no);
		
			var phoneNumber = snapshot.child("phoneNumber").val();
			$('#phoneNumber').html(phoneNumber);
		
			var token = snapshot.child("token").val();
			$('#token').html(token)
			
			var userName = snapshot.child("userName").val();
			$('#userName').html(userName);
			
			var vehicle = snapshot.child("vehicle").val();
			$('#vehicle').html(vehicle);
			
			var approvalStatus = snapshot.child("approvalStatus").val();
			$('#approvalStatus').html(approvalStatus);
			
			var onlineStatus = snapshot.child("onlineStatus").val();
			$('#onlineStatus').html(onlineStatus);
			
			var vin = snapshot.child("vin").val();
			$('#vin').html(vin);
		
			var image = snapshot.child("profileImage").val();
			document.getElementById("image").src = image;
			
			var idCardFront = snapshot.child("idCardFront").val();
			document.getElementById("idCardFront").src = idCardFront;
			
			var idCardBack = snapshot.child("idCardBack").val();
			document.getElementById("idCardBack").src = idCardBack;
			
			var licenseFront = snapshot.child("licenseFront").val();
			document.getElementById("licenseFront").src = licenseFront;
			
			var licenseBack = snapshot.child("licenseBack").val();
			document.getElementById("licenseBack").src = licenseBack;
			
			//$('.image').src(image);
		
			var ordertime = o_hour+":"+o_min;
			$('.time').html(ts);
		
		
	});
</script>

<script src="js/restaurantdetails.js" type="module"></script>
	</body>

	</html> 
	<?php
} else {
	header( "location:login.php" );
	exit;
}
?>