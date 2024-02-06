<?php

session_start();

	$orderid = $_GET['orderid'];
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
			<?php $pagename="orders"; ?>
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
						<h1 class="h3 mb-2 text-gray-800 float-left">Order # <strong><span class="text-uppercase orderid" ></span></strong>  </h1>
						
						<div class="float-right">
							<!--<button class="btn btn-success">Accept order</button>-->
						</div>
						<br><br><br>
						<div class="row float-left">
							
							<div class="col-xl-6 col-lg-6 mb-2">
						 	
							 	<div class="card shadow mb-2">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Order Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  <tbody>
												
											  	<tr>
												  <td>Order ID</td>
												  <td><span class="orderid"></span></td>
												</tr>
												<tr>
												  <td>Total Bill</td>
												  <td><span class="totalbill"></span></td>
												</tr>
												<tr>
												  <td>Current Status</td>
												  <td><span class="currentstatus"></span></td>
												</tr>
												<tr>
												  <td>Order Time</td>
												  <td><span class="ordertime"></span></td>
												</tr>
												
												<tr>
												  <td>Order Date</td>
												  <td><span class="orderdate"></span></td>
												</tr>
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
								
								 
							</div>
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">User Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody>
												
											  	<tr>
												  <td>User ID</td>
												  <td class="userid"></td>
												</tr>
												<tr>
												  <td>Full Name</td>
												  <td class="fullname"></td>
												</tr>
												<tr>
												  <td>Phone</td>
												  <td class="phone"></td>
												</tr>
												<tr>
												  <td>Email</td>
												  <td class="email"></td>
												</tr>
												<tr>
												  <td>Gender</td>
												  <td class="gender"></td>
												</tr>
												<tr>
												  <td>Address</td>
												  <td class="userAddress"></td>
												</tr>
												<tr>
												  <td>Location</td>
												  <td class="userLocation"></td>
												</tr>
												
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
								 
							</div>
							
							<div class="col-xl-12 col-lg-12 mb-2">
							 	<div class="card shadow">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Ordered Items</h6>
									</div>
									<div class="card-body">
										<div class="orderedproducts itemdata row mb-4">
											<img src="images/loading.gif" height="50px" alt="">
										</div>
										
										<div class="orderedproducts dealdata row">
											
										</div>
									</div>
							 	</div>
								 
							</div>
							
							
						</div>



					</div>
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
// import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
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
	
	var ordernodeid = '<?php echo $orderid ?>';
	//alert(ordernodeid);
	
	//var products = databaseRef.child("Orders/"+ordernodeid);
	
	get(child(databaseRef, 'Orders/'+ordernodeid)).then((snapshot)=>{
		var content = "";
		
			var timestamp =  snapshot.child("timeRequested").val();
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
		
		
			var uid = snapshot.child("uid").val();
			$('.userid').html(uid);
		
			var orderid = snapshot.child("orderId").val();
			$('.orderid').html(orderid);
			var totalbill = snapshot.child("totalPrice").val()+" SR";
			$('.totalbill').html(totalbill);
			var currentstatus = snapshot.child("status").val();
			$('.currentstatus').html(currentstatus);
			var ordertime = o_hour+":"+o_min;
			$('.ordertime').html(ordertime);
			var orderdate = o_date+"-"+o_month+"-"+o_year;
			$('.orderdate').html(orderdate);
			
			
		
		
		
			//var usersref = databaseRef.child("Users/"+uid);
			
			get(child(databaseRef, 'Users/'+uid)).then((userSnapshot)=>{
				var u_fullname = userSnapshot.child("fullName").val();
				$('.fullname').html(u_fullname);
				var u_email = userSnapshot.child("email").val();
				$('.email').html(u_email);
				var u_phone = userSnapshot.child("phoneNumber").val();
				$('.phone').html(u_phone);
				var u_gender = userSnapshot.child("gender").val();
				$('.gender').html(u_gender);
				var userAddress = userSnapshot.child("userAddress").val();
				$('.userAddress').html(userAddress);
				var userLocation = userSnapshot.child("userLocation").val();
				$('.userLocation').html(userLocation);
			});
		
		
	});
	
	
	get(child(databaseRef, "Orders/"+ordernodeid+"/items")).then((itemsSnapshot)=>{
		var content = "";
			$('.itemdata').html(content);
			itemsSnapshot.forEach(function(itemchilds){
				
				if(itemchilds.child("type").val()=="item"){
					
					
				    content += '<div class="col-lg-4">';
					content+= '<div class="itempicture">';
					content += '<img src="'+itemchilds.child("image").val()+'" alt="">';
					content+= '</div>';
					content += '<h5> Title: ' +itemchilds.child("title").val()+'</h5>';
				    content += '<h5> Quantity: '+itemchilds.child("quantity").val()+'</h5>';
				    content += '<h5> New Price: '+itemchilds.child("newPrice").val()+'</h5>';
					content += '<h5> Type: '+itemchilds.child("type").val()+'</h5>';
					content += '<h5> Details: '+itemchilds.child("details").val()+'</h5>';
				    content += '</div>';
				
					
				}
				
				
			});
			$('.itemdata').append(content);
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