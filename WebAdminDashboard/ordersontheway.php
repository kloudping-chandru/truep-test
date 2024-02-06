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
    <?php $pagename="ontheway"; ?>
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
			
          <h1 class="h3 mb-2 text-gray-800">On The Way Orders</h1>
          
          
          
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Orders Record</h6>
            </div>
            <div class="card-body">
             
            
             
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>OrderID</th>
                      <th>Status</th>
					  <th>Date</th>
					  <th>Driver Name</th></th>
					  <th>Driver Email</th>
                      <th>Driver Phone No</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>OrderID</th>
                      <th>Status</th>
					  <th>Date</th>
					  <th>Driver Name</th></th>
					  <th>Driver Email</th>
                      <th>Driver Phone No</th>
                    </tr>
                  </tfoot>
                  
                  
                  
                  <tbody id="tabledata">
                    
                  <!--<tr class="text-center">-->
                      
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                      
                      
                  <!--    <td class="text-center"><a href="vieworder.php?orderid=<?php echo $record['id']?>" id=""  class="btn btn-info"> View </a></td>-->
                   
                  <!--    <td class="text-center"><a href="delete.php?productid=<?php echo $record['id']?>" id=""  class="btn btn-danger" onClick="return confirm('Are you sure you want to delete record?')">Delete </a></td>-->
                      
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
        
        
        const today = new Date();
        const currentYear = today.getFullYear();
        const currentMonth = String(today.getMonth() + 1).padStart(2, '0'); // Months are zero-based
        const currentDay = String(today.getDate()).padStart(2, '0');
        const currentDate = `${currentYear}-${currentMonth}-${currentDay}`;
 
        
        
        
        
    get(child(databaseRef, 'OrderAssignToDrivers/')).then((snapshot) => {
    var content = "";

    // Clear the table before appending new data
    $('#tabledata').html(content);

    var promises = []; // Array to store promises

    snapshot.forEach(function (childsnapshot) {
        
        
        if (currentDate == childsnapshot.child('date').val()) {
            
            if(childsnapshot.child('status').val() == 'on the way') {
                
                
                // Push each promise into the array
                promises.push(get(child(databaseRef, 'Drivers/' + childsnapshot.child('driverId').val()))
                    .then((driverSnapshot) => {
                        content += '<tr>';
                        content += '<td>' + childsnapshot.child('orderId').val() + '</td>';
                        content += '<td> <span class="badge badge-success">' + childsnapshot.child('status').val() + '</span></td>';
                        content += '<td>' + childsnapshot.child('date').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('fullName').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('email').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('phoneNumber').val() + '</td>';
                        content += '</tr>';
                    })
                );
            
                
            }
            
        }
    });

    // Execute all promises and wait for them to complete
    Promise.all(promises).then(() => {
        $('#tabledata').append(content);
    });
});

        
        
        
        
	
// 		get(query(ref(database, 'Orders/'), orderByChild('status'), equalTo('onTheWay'))).then((snapshot) =>{
// 			var content = "";
// 		$('#tabledata').html(content);
// 		snapshot.forEach(function(childsnapshot){
// 			//alert(childsnapshot.child('status').val());
			
// 			var timestamp =  childsnapshot.child("timeRequested").val();
// 			//let timestamp =  1594032390;
			
			
// 			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
// 			var ts = new Date(timestamp*1);
// 			var o_date = ts.getDate();
// 			var o_year = ts.getFullYear();
//   			var o_month = months[ts.getMonth()];
//   			var o_hour = ts.getHours();
//   			var o_min =ts.getMinutes();
// 			//var category = childsnapshot.child("title").val();
// 			content += '<tr>';
			
// 				content += '<td>'+childsnapshot.child("orderId").val()+'</td>';
// 				content += '<td>'+childsnapshot.child("status").val()+'</td>';
// 				content += '<td>'+o_hour+":"+o_min+'</td>';
// 				content += '<td>'+o_date+"-"+o_month+"-"+o_year+'</td>';
// 				content += '<td>'+childsnapshot.child("totalPrice").val()+'</td>';
				
// 				content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			
			
// 				content += '<td class="text-center"><button type="button" id="delete" class="btn btn-danger" value='+childsnapshot.key+'>Delete </button></td>';
// 				content += '';
				
// 			content += '</tr>'
			
// 			});
// 		
		
		/*get(q).then(snapshot => {
		  alert(q);
		});*/
		
		
	/*get(ref(database, 'Orders/')).then((snapshot) =>{
			var content = "";
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
			//alert(childsnapshot.child('status').val());
			if(childsnapshot.child('status').val()=='onTheWay'){
			
			
			var timestamp =  childsnapshot.child("timeRequested").val();
			//let timestamp =  1594032390;
			
			
			
			var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
			var ts = new Date(timestamp*1);
			var o_date = ts.getDate();
			var o_year = ts.getFullYear();
  			var o_month = months[ts.getMonth()];
  			var o_hour = ts.getHours();
  			var o_min =ts.getMinutes();
			//var category = childsnapshot.child("title").val();
			content += '<tr>';
			
				content += '<td>'+childsnapshot.child("orderId").val()+'</td>';
				content += '<td>'+childsnapshot.child("status").val()+'</td>';
				content += '<td>'+o_hour+":"+o_min+'</td>';
				content += '<td>'+o_date+"-"+o_month+"-"+o_year+'</td>';
				content += '<td>'+childsnapshot.child("totalPrice").val()+'</td>';
				
				content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			
			
				content += '<td class="text-center"><button type="button" id='+childsnapshot.key+' class="btn btn-danger" onClick="deleteProduct(this.id)">Delete </button></td>';
				content += '';
				
			content += '</tr>'
			}
		});

		
	});*/
		
	
	function deleteProduct(id)
    {
		
        if (confirm('Are you sure you want to Delete this Product?')) {
            
            var rCategory = databaseRef.child("Orders/"+id);
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