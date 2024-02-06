<?php
session_start();


if(isset($_SESSION['email'], $_SESSION['password'])) {
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
			<a href="newproduct.php" class="btn btn-block btn-info">Add New Product</a>
          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">All Product</h1>
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Products Record</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>Image</th>
                      <th>Product Name</th>
                      <th>Category</th>
					  <th>No of Serving</th>
					  <th>Price</th>
					  <th>Stock</th>
                      <th>View Details</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>Image</th>
                      <th>Product Name</th>
                      <th>Category</th>
					  <th>No of Serving</th>
					  <th>Price</th>
					  <th>Stock</th>
                      <th>View Details</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                    
                  <!--<tr class="text-center">-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                  <!--    <td ><img src="images/loading.gif" alt="" height="50px"></td>-->
                      
                  <!--  </tr>-->
                 
                   
                  </tbody>
                </table>
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


  <!-- Bootstrap core JavaScript-->
  <?php include('footerlinks.php'); ?>

  <!-- Page level plugins -->
  <script src="vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="js/demo/datatables-demo.js"></script>
	
	<!--<script src="firebase.js"></script>-->


	<!-- Getting Products -->
<script type="module">

// import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
// 		import { getDatabase, ref, get, set, onValue, child, orderByChild, equalTo, query  } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

	 import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";        import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";	    
		

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
  
	get(child(databaseRef, 'Items/')).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			var category = childsnapshot.child("categoryId").val();
			//var category1;
			//alert(category);
			
			
			
			get(query(ref(database, 'Categories/'), orderByChild('timeCreated'), equalTo(category))).then((catsnapshot) =>{
				//var category1;
				//alert(catsnapshot.child("title").val());
				content += "";
				catsnapshot.forEach(function(catsnapshot1){
					var category1 = catsnapshot1.child("title").val();
					
				});
				
				
				//alert(category1);
			
			});
			
			
			content += '<tr>';
			

						content += '<td><img src="'+childsnapshot.child("image").val()+'" alt="" height="50px"></td>';

						content += '<td>'+childsnapshot.child("title").val()+'</td>';
						content += '<td>'+childsnapshot.child("categoryId").val()+'</td>';
						content += '<td>'+childsnapshot.child("no_of_serving").val()+'</td>';
						content += '<td>'+childsnapshot.child("price").val()+'</td>';
						content += '<td>'+childsnapshot.child("productQuantity").val()+'</td>';

						content += '<td class="text-center"><a href="viewproduct.php?productid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';

						content += '<td class="text-center"><a href="editproduct.php?productid='+childsnapshot.key+'"  class="btn btn-info" > Edit </a></td>';

						content += '<td class="text-center"><button type="button" id='+childsnapshot.key+' class="btn btn-danger" onClick="deleteProduct(this.id)" disabled>Delete </button></td>';
						content += '';

					content += '</tr>'
			
			
		});
		$('#tabledata').append(content);
	});
	function deleteProduct(id)
    {
		
        if (confirm('Are you sure you want to Delete this Product?')) {
            
            var rCategory = databaseRef.child("Items/"+id);
            rCategory.remove();
            location.reload();
        } else {
            
        }
    }
    
</script>




<script src="js/restaurantdetails.js" type="module"></script>
</body>

</html>
<?php 
} else {
    header("location:login.php");
    exit;
  }
?>