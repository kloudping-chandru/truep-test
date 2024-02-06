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
    <?php $pagename="allorders"; ?>
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
			
          <h1 class="h3 mb-2 text-gray-800">All Orders</h1>
          
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
                      <th>Orderid</th>
                      <th>Status</th>
					  <th>Subscription Start</th>
					  <th>Subscription End</th>
					  <th>Price</th>
                      <th>View</th>
                      <th>Delete</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>Orderid</th>
                      <th>Status</th>
					  <th>Subscription Start</th>
					  <th>Subscription End</th>
					  <th>Total Bill</th>
                      <th>View</th>
                      <th>Delete</th>
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
                   
                  <!--    <td class="text-center"><a href="delete.php?productid=<?php echo $record['id']?>" id="delete"  class="btn btn-danger" >Delete </a></td>-->
                      
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
		
var currentDate = new Date();

// Get year, month, and day
var year = currentDate.getFullYear();
var month = currentDate.getMonth() + 1; // Add 1 since getMonth() returns zero-based month (0-11)
var day = currentDate.getDate();

// Format the date
var currentTime = year + '-' + addLeadingZero(month) + '-' + addLeadingZero(day);
console.log(currentTime);
// Function to add leading zero if necessary
function addLeadingZero(number) {
  return number < 10 ? '0' + number : number;
}
		
		
var currentDayNumber = currentDate.getDay();
var daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var currentDay = daysOfWeek[currentDayNumber].substring(0, 3);


	get(child(databaseRef, 'Orders/')).then((snapshot) =>{
		var content = "";
		$('#tabledata').html(content);
		
		
		snapshot.forEach(function(childsnapshot){
// 		 console.log(childsnapshot.child('startingDate').val());
// 		 console.log(childsnapshot.child('endingDate').val())
// 		 console.log('</br>');
		  
		    if ( currentTime >= childsnapshot.child('startingDate').val() && currentTime <= childsnapshot.child('endingDate').val() ) {
                  
                    childsnapshot.child('Days').forEach(function(daySnapshot) {
                        
                        if(currentDay == daySnapshot.child('day').val()) {
                            
                            console.log(daySnapshot.child('quantity').val())
                        }
                        
                        
                    });
                    
                    
                    //var category = childsnapshot.child("title").val();
			    content += '<tr>';
			
				content += '<td>'+childsnapshot.child("orderId").val()+'</td>';
				content += '<td>'+childsnapshot.child("status").val()+'</td>';
				content += '<td>'+childsnapshot.child("startingDate").val()+'</td>';
				content += '<td>'+childsnapshot.child("endingDate").val()+'</td>';
				
				content += '<td>'+childsnapshot.child("totalPrice").val()+'</td>';
				
				content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			
			
				content += '<td class="text-center"><button type="button" id="delete" class="btn btn-danger" value='+childsnapshot.key+'>Delete </button></td>';
				content += '';
				
			    content += '</tr>'
          
              }
			
			
			
			
		});
				$('#tabledata').append(content);

	
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