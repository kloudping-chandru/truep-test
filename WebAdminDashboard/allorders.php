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
                      <th>Type</th>
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
                      <th>Type</th>
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
                      
                      
                     <!-- <td class="text-center"><a href="vieworder.php?orderid=<?php //echo $record['id']?>" id=""  class="btn btn-info"> View </a></td> -->
                   
                  <!--    <td class="text-center"><a href="delete.php?productid=<?php //echo $record['id']?>" id="delete"  class="btn btn-danger" >Delete </a></td>-->
                      
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
// Function to add leading zero if necessary
function addLeadingZero(number) {
  return number < 10 ? '0' + number : number;
}
		
		
var currentDayNumber = currentDate.getDay();
var daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var currentDay = daysOfWeek[currentDayNumber].substring(0, 3);
var content = "";
var items = [];
// $('#tabledata').html(content);


	get(child(databaseRef, 'Orders/')).then((snapshot) =>{

		snapshot.forEach(function(childsnapshot){
		  
		    if (currentTime <= childsnapshot.child('endingDate').val() ) {
          items.push([childsnapshot.key, childsnapshot.val()]);
                  
          // childsnapshot.child('Days').forEach(function(daySnapshot) {
          //     if(currentDay == daySnapshot.child('day').val()) {     
          //         console.log(daySnapshot.child('quantity').val())
          //     }
          // });
          //var category = childsnapshot.child("title").val();
        }
		});
        // items.reverse();
        
        // items.forEach(function(item){
        //   content += '<tr>';
        //   content += '<td>'+item[1]["orderId"]+'</td>';
        //   content += '<td>'+item[1]["status"]+'</td>';
        //   content += '<td>'+item[1]["startingDate"]+'</td>';
        //   content += '<td>'+item[1]["endingDate"]+'</td>';
        //   content += '<td>'+item[1]["totalPrice"]+'</td>';
        //   content += '<td class="text-center"><a href="vieworder.php?orderid='+item[0]+'"  class="btn btn-success"> View </a></td>';
        //   content += '<td class="text-center"><button type="button" id="delete" class="btn btn-danger" value='+item[0]+'>Delete </button></td>';
        //   content += '';
        //   content += '</tr>'
        // });
        // $('#tabledata').append(content);
	});

  get(child(databaseRef, 'OnceOrders/')).then((snapshot) =>{

		$('#tabledata').html(content);
		
		snapshot.forEach(function(childsnapshot){
		    if ( currentTime <= childsnapshot.child('endingDate').val() ) {
          items.push([childsnapshot.key, childsnapshot.val()]);
                  
          // childsnapshot.child('Days').forEach(function(daySnapshot) {
          //     if(currentDay == daySnapshot.child('day').val()) {     
          //         console.log(daySnapshot.child('quantity').val())
          //     }
          // });
          //var category = childsnapshot.child("title").val();
        }
		});
    items.sort((a, b) => {
      const dateA = new Date(a[1].startingDate);
      const dateB = new Date(b[1].startingDate);
      return dateB - dateA;
    });
    items.forEach(function(item){
      var type = "Subscription Order"
      content += '<tr>';
      content += '<td>'+item[1]["orderId"]+'</td>';
      content += '<td>'+item[1]["status"]+'</td>';
      if(item[1]["onceOrder"]){
        content += '<td>Once Order</td>';
        type = "Once Order"
      }else{
        content += '<td>Subscription Order</td>';
      };
      content += '<td>'+item[1]["startingDate"]+'</td>';
      content += '<td>'+item[1]["endingDate"]+'</td>';
      content += '<td>'+item[1]["totalPrice"]+'</td>';
      content += '<td class="text-center"><a href="vieworder.php?orderid='+item[0]+'&&type='+type+'"  class="btn btn-success"> View </a></td>';
      content += '<td class="text-center"><button type="button" id="delete" class="btn btn-danger" value='+item[0]+'>Delete </button></td>';
      content += '';
      content += '</tr>'
    });
    $('#tabledata').append(content);
	});

  setTimeout(function() {
    $("#dataTable_filter").append(`<label style="margin:0px 0px 0px 10px;" >Type : <select name="orderType" style="color: #858796;border:1px solid #d1d3e2;" class="form-control-sm" id="orderType">
      <option value="All">All</option><option value="Once Order">Once Order</option><option value="Subscription Order">Subscription Order</option></select></label>`)
    
      $("#orderType").change(function() {
      var typeValue = $(this).val();
      if(typeValue === 'Once Order'){
        $("#tabledata tr").each(function() {
          if ($(this).find("td:eq(2)").text() === "Once Order") {
            $(this).css("display", "");
          }else{
            $(this).css("display", "none");
          }
        });
      }else if(typeValue === 'Subscription Order'){
        $("#tabledata tr").each(function() {
          if ($(this).find("td:eq(2)").text() === "Subscription Order") {
            $(this).css("display", "");
          }else{
            $(this).css("display", "none");
          }
        });
      }else{
        $("#tabledata tr").each(function() {
          $(this).css("display", "");
        });
      }
    });
  }, 100);

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