<?php

session_start();

	$orderid = $_GET['productid'];
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
			<?php $pagename="products"; ?>
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
						<h1 class="h3 mb-2 text-gray-800">Product ID <strong><span class="text-uppercase orderid" ></span></strong>  </h1>
						
						<div class="row">
							
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Product Image</h6>
									</div>
									<div class="card-body">
										<img src="images/loading.gif" height="300px" alt="" id="image" width="100%">
									</div>
							 	</div>
							 	
							 	
							 		<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Flavors</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody id="flavors">
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Variations</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  <thead class="thead-dark">
											  	<th>Name</th>
											  	<th>Price</th>
											  </thead>
											  
											  <tbody id="variations">
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
								 
							</div>
							<div class="col-xl-6 col-lg-6 mb-2">
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Product Details</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody>
												
											  	<tr>
												  <td>Product ID</td>
												  <td class="orderid"></td>
												</tr>
												<tr>
												  <td>Title</td>
												  <td class="title"></td>
												</tr>
												<tr>
												  <td>Category</td>
												  <td class="categoryname"></td>
												</tr>
												<tr>
												  <td>Details</td>
												  <td class="details"></td>
												</tr>
												<tr>
												  <td>Price</td>
												  <td class="price"></td>
												</tr>
											    <tr>
												  <td>Stock</td>
												  <td class="stock"></td>
												</tr>
												<tr>
												  <td>Serve</td>
												  <td class="serves"></td>
												</tr>
												<tr>
												  <td>Views</td>
												  <td class="views"></td>
												</tr>
												<tr>
												  <td>Created Time</td>
												  <td class="time"></td>
												</tr>
												
												
											  </tbody>
											</table>
										 </div>
									</div>
							 	</div>
							 	
							 	
							 	<div class="card shadow mb-4">
							 		<div class="card-header py-3">
								  		<h6 class="m-0 font-weight-bold text-primary">Ingredients</h6>
									</div>
									<div class="card-body">
										<div class="table-responsive">
											<table class="table table-bordered"  width="100%" cellspacing="0">
											  
											  
											  <tbody id="ingredients">
												
											  </tbody>
											</table>
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
	var ordernodeid = '<?php echo $orderid ?>';
	//alert(ordernodeid);
	
	get(child(databaseRef, 'Items/'+ordernodeid)).then((snapshot) =>{

		
			var timestamp =  snapshot.child("timeCreated").val();
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
		
		
			var uid = snapshot.key;
			
			$('.orderid').html(uid);
			var title = snapshot.child("title").val()+" SR";
			$('.title').html(title);
			var categoryname = snapshot.child("categoryId").val();
			$('.categoryname').html(categoryname);
		
			var details = snapshot.child("details").val();
			$('.details').html(details);
			var price = snapshot.child("price").val();
			$('.price').html(price);
			
			var stock = snapshot.child("productQuantity").val();
			$('.stock').html(stock);
		
			var no_of_serving = snapshot.child("no_of_serving").val();
			$('.serves').html(no_of_serving);
		
			var views = snapshot.child("viewsCount").val();
			$('.views').html(views);
		
			var image = snapshot.child("image").val();
			document.getElementById("image").src = image;
			//$('.image').src(image);
		
			var ordertime = o_hour+":"+o_min;
			$('.time').html(ts);
			
			
			get(child(databaseRef, "Items/"+ordernodeid+"/customizationForFlavours")).then((flavorSnapshot) =>{
				//alert();
				var content = "";
				$('#flavors').html(content);
				flavorSnapshot.forEach(function(flavors){
					content += '<tr>'
						content += '<td>'+flavors.val()+'</td>'
					content += '</tr>'
				});
				$('#flavors').append(content);
			});
		
		
			
			get(child(databaseRef, "Items/"+ordernodeid+"/customizationForVariations")).then((variationSnapshot) =>{
				//alert();
				var variation = "";
				$('#variations').html(variation);
				variationSnapshot.forEach(function(variationsnap){
					variation += '<tr>'
						variation += '<td>'+variationsnap.child("name").val()+'</td>'
						variation += '<td>'+variationsnap.child("price").val()+'</td>'
					variation += '</tr>'
				});
				$('#variations').append(variation);
			});
		
		
		get(child(databaseRef, "Items/"+ordernodeid+"/ingredients")).then((ingredientSnapshot) =>{
			
				//alert();
				var ingr = "";
				$('#ingredients').html(ingr);
				ingredientSnapshot.forEach(function(ingredient){
					ingr += '<tr>'
						ingr += '<td>'+ingredient.val()+'</td>'
					ingr += '</tr>'
				});
				$('#ingredients').append(ingr);
			});
	
			
			//var category = childsnapshot.child("title").val();
		
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