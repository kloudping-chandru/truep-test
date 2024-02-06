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
    <?php $pagename="delivered"; ?>
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
          <h1 class="h3 mb-2 text-gray-800">Delivered Orders</h1>
          
          <div id="modal"></div>
          
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Orders Record</h6>
            </div>
            <div id="refundMessage"></div>
            <div class="card-body">
          
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th width="10%">Order ID</th>
                      <th width="10%">User ID</th>
                      <th width="10%">Status</th>
                      <th width="10%">Total Price</th>
                      <th width="10%">Refund Value</th>
                      <th width="10%">Payment Type</th>
                      <th width="10%">Driver Name</th></th>
                      <th width="10%">Driver Email</th>
                      <th width="10%">Driver No</th>
                      <th width="10%">Refund</th>
                      
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th width="10%">Order ID</th>
                      <th width="10%">User ID</th>
                      <th width="10%">Status</th>
                      <th width="10%">Total Price</th>
                      <th width="10%">Refund Value</th>
                      <th width="10%">Payment Type</th>
                      <th width="10%">Driver Name</th></th>
                      <th width="10%">Driver Email</th>
                      <th width="10%">Driver No</th>
                      <th width="10%">Refund</th>
                      
                    </tr>
                  </tfoot>
                  <tbody id="tabledata">
                  
                    
                  <!--<tr class="text-center">-->
                      
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                  <!--    <td class="" ><img src="images/loading.gif" height="50px" alt=""></td>-->
                      
                      
                  <!--    <td class="text-center"><a href="vieworder.php?orderid=<?php // echo $record['id']?>" id=""  class="btn btn-info"> View </a></td>-->
                   
                  <!--    <td class="text-center"><a href="delete.php?productid=<?php // echo $record['id']?>" id=""  class="btn btn-danger" onClick="return confirm('Are you sure you want to delete record?')">Delete </a></td>-->
                      
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
    
    const today = new Date();
    const currentYear = today.getFullYear();
    const currentMonth = String(today.getMonth() + 1).padStart(2, '0'); // Months are zero-based
    const currentDay = String(today.getDate()).padStart(2, '0');
    const currentDate = `${currentYear}-${currentMonth}-${currentDay}`;
function tableData(){
    get(child(databaseRef, 'Delivered_Orders/')).then((snapshot) => {
    var content = "";

    // Clear the table before appending new data
    $('#tabledata').html(content);

    var promises = []; // Array to store promises

    snapshot.forEach(function (childsnapshot) {
        
            
              // Push each promise into the array
                promises.push(get(child(databaseRef, 'Drivers/' + childsnapshot.child('driverId').val()))
                    .then((driverSnapshot) => {
                        content += '<tr>';
                        content += '<td>' + childsnapshot.child('orderId').val() + '</td>';
                        content += '<td>' + childsnapshot.child('uid').val() + '</td>';
                        if(childsnapshot.child('status').val() == "completed"){
                          content += '<td> <span class="badge badge-primary">' + childsnapshot.child('status').val() + '</span></td>';
                        }else{
                          content += '<td> <span class="badge badge-warning">' + childsnapshot.child('status').val() + '</span></td>';
                        }
                        content += '<td>' + childsnapshot.child('totalPrice').val() + '</td>';
                        content += '<td>' + (childsnapshot.child('refundAmount').val() || "") + '</td>';
                        content += '<td>' + childsnapshot.child('paymentType').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('fullName').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('email').val() + '</td>';
                        content += '<td>' + driverSnapshot.child('phoneNumber').val() + '</td>';
                        if(childsnapshot.child('status').val() == "refunded"){
                          content += '<td class="text-center"><button disabled class="refund btn badge-secondary" data-bal="'+childsnapshot.child('totalPrice').val()+'" data-uid="'+childsnapshot.child('uid').val()+'" data-task="0" data-toggle="modal" data-target="#refundModal" data-orderid="' + childsnapshot.child('orderId').val() + '" data-value="' + childsnapshot.key + '"> Refund </button></td>';
                        }else{
                          content += '<td class="text-center"><button class="refund btn btn-warning" data-bal="'+childsnapshot.child('totalPrice').val()+'" data-uid="'+childsnapshot.child('uid').val()+'" data-task="1" data-toggle="modal" data-target="#refundModal" data-orderid="' + childsnapshot.child('orderId').val() + '" data-value="' + childsnapshot.key + '"> Refund </button></td>';
                        }
                        content += '</tr>';
                    })
                );
    });

    // Execute all promises and wait for them to complete
    Promise.all(promises).then(() => {
        $('#tabledata').append(content);
    });
});
};
// Table Data Update Function
tableData();
// Modal Close Function
function modalClose(){
  var modalBackdrop = document.querySelector('.modal-backdrop');
  if (modalBackdrop) {
    modalBackdrop.remove();
  }
  (document.querySelector('#page-top')).classList.remove('modal-open');
  refundModal.classList.remove('show');
  refundModal.style.display = 'none';
  refundModal.style.paddingRight = '0px';
};
// Refund Function
setTimeout(function() {
  var refundButtons = document.querySelectorAll('.refund');
  refundButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      var orderKey = button.getAttribute('data-value');
      var orderId = button.getAttribute('data-orderid');
      var userId = button.getAttribute('data-uid');
      var task = button.getAttribute('data-task')
      var orderValue = button.getAttribute('data-bal')
      const specificOrderRef = child(databaseRef, 'Delivered_Orders/' + orderKey);
      const specificUsersRef = child(databaseRef, 'Users/' + userId);
      const specificWalletRef = child(databaseRef, 'WalletHistory/');
      const specificNotificationRef = child(databaseRef, 'NotificationData/');

      var modal = ""
      $('#modal').html(modal);
      modal += '<div class="modal fade" id="refundModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><h5 class="modal-title" id="exampleModalLabel">Initiate Refund</h5></div><div class="modal-body"><form id="refundForm">';
      modal += '<label for="refundIdInput">ORDER ID</label>'
      modal += '<input class="form-control" type="text" id="refundIdInput" value="'+orderId+'" disabled></br>';
      modal += '<label for="refundValueInput">REFUND AMOUNT <b id = "message"></b></label>'
      modal += '<input class="form-control" type="text" id="refundValueInput">';
      modal += '</form></div><div class="modal-footer"><button type="button" class="btn btn-primary" id="refundBtn">Refund</button><button type="button" class="btn btn-primary" id="cancelBtn">Cancel</button></div></div></div></div>';
      $('#modal').html(modal);

      var refundButton = document.querySelector('#refundBtn');
      var message = document.querySelector('#message');
      var updateValue = false;
      var refundValueInput = document.querySelector('#refundValueInput');
      var refundModal = document.querySelector('#refundModal');
      refundButton.addEventListener('click', function() {
        if (isNaN(parseInt(refundValueInput.value))) {
          $('#message').html('(Please enter a numeric value.)');
          document.querySelector('#message').style.display = 'inline-block';
        }else if((parseInt(orderValue)) < (parseInt(refundValueInput.value)) || (parseInt(refundValueInput.value)) <= 0){
          $('#message').html('(Please enter correct refund amount.)');
          document.querySelector('#message').style.display = 'inline-block';
        }else{
          $('#message').html('');
          updateValue = true;
        };
        if(task == 1 && updateValue == true){
          var orderStatus = "refunded";
          update(specificOrderRef, {
            status: orderStatus,
            totalPrice: (parseInt(orderValue) - parseInt(refundValueInput.value)),
            refundAmount: refundValueInput.value,
          })
          get(specificUsersRef).then((snapshot) => {
            var userWalletBalance = (parseInt(snapshot.child('userWallet').val()) + parseInt(refundValueInput.value)).toString() + ".0";
            update(specificUsersRef, {
              userWallet: userWalletBalance,
            });
          });
          push(specificWalletRef, {
            amountAdded: refundValueInput.value,
            message: "Refund",
            orderId: orderKey,
            timeAdded: Date.now(),
            uid: userId,
          });
          push(specificNotificationRef, {
            body: "Your refund amound " +refundValueInput.value+ " has been processed.",
            key: "wallet",
            deviceId: "",
            title: "Refund Processed",
            timeStamp: Date.now(),
            uid: userId,
          })
          .then(() => {
            tableData();
            modalClose();
            $('#refundMessage').html('<div class="alert alert-warning"><strong>Success!</strong> Indicates a successful or positive action.</div>');
            setTimeout(function() {
              $('#refundMessage').html('');
            }, 3000);
          })
        }
        // else{
        //   var orderStatus = "completed";
        //   update(specificOrderRef, {
        //     status: orderStatus,
        //     refundAmount: "0",
        //   }).then(() => {
        //     location.reload();
        //   })
        // }
      });

      var cancelButton = document.querySelector('#cancelBtn');
      cancelButton.addEventListener('click', function() {
        modalClose();
      });
      get(child(databaseRef, '/')).then((snapshot) => {
        console.log(snapshot.val());
      });
    });
  });
}, 1000);


	
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