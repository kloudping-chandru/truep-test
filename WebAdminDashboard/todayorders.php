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
    <?php $pagename="todayorders"; ?>
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
			
          <h1 class="h3 mb-2 text-gray-800">Today Orders</h1>
         
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
                      <th width="10%">Title</th>
                      <th width="20%">Details</th>
                      <th width="10%">Type</th>
					  <th width="15%">Image</th>
                      <th width="10%">New Price</th>
                      <th width="10%">Quantity</th>
                      <th width="10%">View</th>
                      <th width="20%">Assign To Driver</th>
                    </tr>
                  </thead>
                  <tfoot>
                      <tr>
                          <th width="10%">Title</th>
                          <th width="20%">Details</th>
                          <th width="10%">Type</th>
    					  <th width="15%">Image</th>
                          <th width="10%">New Price</th>
                          <th width="10%">Quantity</th>
                          <th width="10%">View</th>
                          <th width="20%">Assign To Driver</th>
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
<!-- Modal -->
<div class="modal fade" id="DriversShowModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Select Driver</h5>
        
      </div>
      <div class="modal-body">
        <form id="driversDisplayForm">
            <select class="form-control" id="driversDropdown">
                <option value=""> Select Driver </option>s
             </select>
             <input type="hidden" id="orderKeyToAssignInput">
             <input type="hidden" id="AssignDay">
             <input type="hidden" id="AssignQty">
             <input type="hidden" id="AssignProductId">
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="asignBtn">Assign</button>
      </div>
    </div>
  </div>
</div>

  <!-- Page level plugins -->
  <script src="vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="js/demo/datatables-demo.js"></script>
	
	<!--<script src="firebase.js"></script>-->


	<script type="module">
	
// 	import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
// 		import { getDatabase, ref, get, set, onValue, child, orderByChild, equalTo, query, push , update } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

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

get(child(databaseRef, 'Drivers/')).then((dSnapshot) =>{
		dSnapshot.forEach(function(driverSnapshot){
		  $('#driversDropdown').append(`<option value="${driverSnapshot.key}"> ${driverSnapshot.child('fullName').val()} </option>`); 
		});	
	});
  var content = "";
  var items = [];
	get(child(databaseRef, 'Orders/')).then((snapshot) =>{
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
          if ( currentTime <= childsnapshot.child('startingDate').val() ) {  
                if(childsnapshot.child('status').val() == 'requested')  {
                    childsnapshot.child('Days').forEach(function(daySnapshot) {
                        if(currentDay == daySnapshot.child('day').val()) { 
                            if(daySnapshot.child('quantity').val() > 0) {
                                childsnapshot.child('items').forEach(function(productSnapshot) {
                                  var item = [
                                    "Subscription Order",
                                    productSnapshot.child("title").val(),
                                    productSnapshot.child("details").val(),
                                    productSnapshot.child("image").val(),
                                    productSnapshot.child("newPrice").val(),
                                    daySnapshot.child("quantity").val(),
                                    childsnapshot.key
                                  ];
                                  if (!childsnapshot.child('driverUid').val()) {
                                    item.push("0");
                                    item.push(productSnapshot.child("itemId").val());
                                    item.push(daySnapshot.child('day').val());
                                    item.push(daySnapshot.child("quantity").val());
                                  }
                                  items.push(item);
                            //         content += '<tr>';
                            //         content += '<td>'+productSnapshot.child("title").val()+'</td>';
                            //         content += '<td>'+productSnapshot.child("details").val()+'</td>';
                            //         content += '<td> <img src="'+productSnapshot.child("image").val()+'" style="width:100px; height="100px"></td>';
                            //         content += '<td>'+productSnapshot.child("newPrice").val()+'</td>';
                            //         content += '<td>'+daySnapshot.child("quantity").val()+'</td>';
			                      //   content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			                      //  if(!childsnapshot.child('driverUid').val()) {
			                      //       content += '<td class="text-center"><a href="javascript:void(0)" productId='+productSnapshot.child("itemId").val()+' dayValue='+daySnapshot.child('day').val()+'  qtyValue='+daySnapshot.child("quantity").val()+' id='+childsnapshot.key+' data-toggle="modal" data-target="#DriversShowModal" class="btn btn-dark AssignToDriverBtn"> Assign To Driver </a></td>';  
			                      //  }else{
			                      //      content += '<td> <p> Order Already Assign To Driver  </p> </td>';
			                      //  }
                    			  //   content += '</tr>';
                               });
                           }       
                        }  
                    });
		        }    
              }
		});
	
	});

  get(child(databaseRef, 'OnceOrders/')).then((snapshot) =>{
		$('#tabledata').html(content);
		snapshot.forEach(function(childsnapshot){
          if ( currentTime <= childsnapshot.child('onceOrder').val() ) {
                if(childsnapshot.child('status').val() == 'requested')  {
                    childsnapshot.child('Days').forEach(function(daySnapshot) {
                        if(currentDay == daySnapshot.child('day').val()) { 
                            if(daySnapshot.child('quantity').val() > 0) {
                                childsnapshot.child('items').forEach(function(productSnapshot) {

                                  var item = [
                                    "Once Order",
                                    productSnapshot.child("title").val(),
                                    productSnapshot.child("details").val(),
                                    productSnapshot.child("image").val(),
                                    productSnapshot.child("newPrice").val(),
                                    daySnapshot.child("quantity").val(),
                                    childsnapshot.key
                                  ];
                                  if (!childsnapshot.child('driverUid').val()) {
                                    item.push("0");
                                    item.push(productSnapshot.child("itemId").val());
                                    item.push(daySnapshot.child('day').val());
                                    item.push(daySnapshot.child("quantity").val());
                                  }
                                  items.push(item);
                            //         content += '<tr>';
                            //         content += '<td>'+productSnapshot.child("title").val()+'</td>';
                            //         content += '<td>'+productSnapshot.child("details").val()+'</td>';
                            //         content += '<td> <img src="'+productSnapshot.child("image").val()+'" style="width:100px; height="100px"></td>';
                            //         content += '<td>'+productSnapshot.child("newPrice").val()+'</td>';
                            //         content += '<td>'+daySnapshot.child("quantity").val()+'</td>';
			                      //   content += '<td class="text-center"><a href="vieworder.php?orderid='+childsnapshot.key+'"  class="btn btn-success"> View </a></td>';
			                      //  if(!childsnapshot.child('driverUid').val()) {
			                      //       content += '<td class="text-center"><a href="javascript:void(0)" productId='+productSnapshot.child("itemId").val()+' dayValue='+daySnapshot.child('day').val()+'  qtyValue='+daySnapshot.child("quantity").val()+' id='+childsnapshot.key+' data-toggle="modal" data-target="#DriversShowModal" class="btn btn-dark AssignToDriverBtn"> Assign To Driver </a></td>';  
			                      //  }else{
			                      //      content += '<td> <p> Order Already Assign To Driver  </p> </td>';
			                      //  }
                    			  //   content += '</tr>';
                               });
                           }       
                        }  
                    });
		        }    
              }
		});
    items.forEach(function(item){
      content += '<tr>';
      content += '<td>'+item[1]+'</td>';
      content += '<td>'+item[2]+'</td>';
      content += '<td>'+item[0]+'</td>';
      content += '<td> <img src="'+item[3]+'" style="width:100px; height="100px"></td>';
      content += '<td>'+item[4]+'</td>';
      content += '<td>'+item[5]+'</td>';
      content += '<td class="text-center"><a href="vieworder.php?orderid='+item[6]+'&&type='+item[0]+'"  class="btn btn-success"> View </a></td>';
      if(item[7] == "0") {
          content += '<td class="text-center"><a href="javascript:void(0)" productId='+item[8]+' dayValue='+item[9]+'  qtyValue='+item[10]+' id='+item[6]+' data-toggle="modal" data-target="#DriversShowModal" class="btn btn-dark AssignToDriverBtn"> Assign To Driver </a></td>';  
      }else{
          content += '<td> <p> Order Already Assign To Driver  </p> </td>';
      }
      content += '</tr>';
    });
	
	    $('#tabledata').append(content);

		
        $('.AssignToDriverBtn').on('click',function(){
            
             let key = $(this).attr('id');
             let day = $(this).attr('dayValue');
             let qty = $(this).attr('qtyValue');
             let productId = $(this).attr('productId');
            
            document.getElementById('orderKeyToAssignInput').value = key;
            document.getElementById('AssignDay').value = day;
            document.getElementById('AssignQty').value = qty;
            document.getElementById('AssignProductId').value = productId;
            
        });
	
	});

document.getElementById('asignBtn').addEventListener('click',(event) =>{
  
  let driversId = document.getElementById('driversDropdown').value;
  let orderId = document.getElementById('orderKeyToAssignInput').value;
  let day = document.getElementById('AssignDay').value;
  let qty = document.getElementById('AssignQty').value;
  let productID = document.getElementById('AssignProductId').value;
  
  const today = new Date();
  const currentYear = today.getFullYear();
  const currentMonth = String(today.getMonth() + 1).padStart(2, '0'); // Months are zero-based
  const currentDay = String(today.getDate()).padStart(2, '0');
  const currentDate = `${currentYear}-${currentMonth}-${currentDay}`;
  
  

  if(!driversId) {
      
      alert('Please Select Driver!');
      return;
  }
  
  
  if(!driversId || !orderId || !day || !qty || !productID) {
      
      alert('Some Error Occurred!');
      return;
  }
  
  
  let obj = {
      driverId: driversId,
      orderId: orderId,
      itemId: productID,
      day: day,
      qty: qty,
      status: 'on the way',
      date: currentDate
  };
  
  document.getElementById('asignBtn').setAttribute('disabled',true);
  
  var getCurrentId =   push( ref(database, 'OrderAssignToDrivers/'), obj);
  
   update( ref(database, 'Orders/'+orderId), {driverUid: driversId});
   
  // Update product quantity in "Items" node
  
  const itemRef = ref(database, 'Items/' + productID);

  get(itemRef).then((snapshot) => {
    if (snapshot.exists()) {
      let currentItem = snapshot.val();
      let currentQuantity = currentItem.productQuantity;

      // Calculate the updated quantity
      let updatedQuantity = currentQuantity - parseInt(qty); // Subtract the assigned quantity

      // Update the quantity in the database
      update(itemRef, { productQuantity: updatedQuantity })
        .then(() => {
          // Quantity updated successfully
          console.log('Quantity updated successfully');
        })
        .catch((error) => {
          console.error('Error updating quantity:', error);
        });

    } else {
      // Item with the given productID not found
      console.error('Item not found');
    }
  }).catch((error) => {
    console.error('Error fetching item:', error);
  });
    
  setTimeout(function(){
      
      if(getCurrentId) {
          location.reload();
      }else{
          alert('some error occurred!');
           document.getElementById('asignBtn').removeAttribute('disabled');

      }
      
  },2000);
    
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