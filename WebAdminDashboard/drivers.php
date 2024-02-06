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
         
         <?php  if(isset($error)){
			?> <div class="alert alert-danger" role="alert">
			  <?php echo $error ?>
			</div>
			<?php }?>
         
          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">All Drivers</h1>
         
         <a href="newdriver.php" class="btn btn-primary btn-block mb-2" >Add Driver</a>
        
          
          <!-- DataTales -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Drivers Record</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>Phone Number</th>
                      <th>Email</th>
                      <th>Full Name</th>
                      <th>View Details</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                       <th>Phone Number</th>
                      <th>Email</th>
                      <th>Full Name</th>
                      <th>View Details</th>
                      <th>Edit</th>
                      <th>Delete</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                    
                  <tr class="text-center">
                     
                      <td colspan="7"><img src="images/loading.gif" alt="" height="50px"></td>
                      
                    </tr>
                  
                   
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


 
<?php include('footerlinks.php'); ?>
  <!-- Page level plugins -->
  <script src="vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="js/demo/datatables-demo.js"></script>
	
	<!--<script src="firebase.js"></script>-->


<!-- Getting Categories -->
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
		
	get(child(databaseRef, 'Drivers/')).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td>'+childsnapshot.child('phoneNumber').val()+'</td>';
				content += '<td>'+childsnapshot.child("email").val()+'</td>';
				content += '<td>'+childsnapshot.child("fullName").val()+'</td>';
				content += '<td class="text-center"><a href="viewdrivers.php?driverid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
                content += '<td class="text-center"><a href="editdriver.php?driverid='+childsnapshot.key+'"  class="btn btn-info " > Edit </a></td>';
				content += '<td class="text-center "> <input type="text" hidden value="'+childsnapshot.key+'"  class="catname">  <button type="button" value="'+childsnapshot.child("timeCreated").val()+'"  class="btn btn-danger btn-delete" disabled >Delete </button></td>';
				content += '';
			    content += '</tr>'
		});
		$('#tabledata').append(content);
		//dele_script();
		
		$(".btn-delete").on("click",function(){
			var dataid = $(this).attr("value");
			dataid = dataid+"";
			var name = $(this).parent().find(".catname").val();
			
			//alert(name);
			
        	if (confirm('Are you sure you want to Delete this Category and All Products related to this category? This action is non reversible.. ')) {
            	get(query(ref(database, 'Drivers/'), orderByChild('categoryId'), equalTo(dataid))).then((snapshot) =>{
					//alert(snapshot.child("categoryId").val());
					snapshot.forEach(function(childsnap)
						{ 
						//alert(child.key);
						remove(child(databaseRef, 'Drivers/'+childsnap.key));
							//databaseRef.child("Items/"+child.key).remove();
						}); 
				});
			
           		remove(child(databaseRef, 'drivers/'+name)).then((snapshot)=>{
					location.reload();
				});
           
			} else {

			}
		
    	});
	});



	
	
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