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
    <?php $pagename="bannerimages"; ?>
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
          <h1 class="h3 mb-2 text-gray-800">All Banner Images</h1>
         
          <button type="button" class="btn btn-primary btn-block mb-2" data-toggle="modal" data-target="#myModal" >+Add New</button>
        

         <div class="modal" id="myModal">
			<div class="modal-dialog modal-md">
			  <div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
				  <h4 class="modal-title">Fill The Form</h4>
				  <button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
				 <div class="">
					<form>
							<div class="row">
								<div class="col-lg-12">
									<div class="form-group">
										<label for="name">Image</label>
										<input type="file" class="form-control" id="image" required>
									</div>
								</div>
							
							
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" name="submit" id="saveBtn" >Save</button>
										
									</div>
								</div>
							</div>
								
								
							</form>
						</div>
				   </div>
                </div>
			</div>
		  </div>
          
          <!-- DataTales -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">Images</h6>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>image</th>
                    </tr>
                  </thead>
               
                  
                  
                  
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


<!-- Getting Categories -->



<script type="module">
//       	import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
// 	import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";

	import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";
        import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";
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
        const storage = getStorage();


	get(child(databaseRef, 'BannerImages/')).then((snapshot) =>{
		var content = "";
        var dataArr = [];
		$('#tabledata').html(content);

        snapshot.forEach((element)=>{
            dataArr.push(element);
        });



		dataArr.reverse().forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			  content += '<tr>';
			
				content += '<td> <img src="'+childsnapshot.child('image').val()+'" width="200px" height="150px"> </td>';
        
				content += '<td class="text-center "> <a href="javascript:void(0)"  key="'+childsnapshot.key+'" class="btn btn-danger deleteBtn" > Delete </a> </td>';
				content += '</tr>'
		});
		$('#tabledata').append(content);
		//dele_script();
		



		$(".deleteBtn").on("click",function(){
		
			var key = $(this).attr('key');
		
        	if (confirm('Are you sure you want to delete this Image!')) {
            	
                var deleteTable = remove(child(databaseRef, 'BannerImages/'+key));

                if(deleteTable) {
                    location.reload();
                }else{
                    alert('Some error occurred!');
                    return;
                }
                
            } else {

			}
		
    	});
	});


  


//Add New Table Code
document.getElementById('saveBtn').addEventListener('click', () => {


    let image = document.getElementById('image').value;

  if (!image) {
    alert('Please select The image!');
    return;
  }

  document.getElementById('saveBtn').disabled = true;

            var date = new Date();
			var timestamp = ""+date.getTime();
			
			const bannerImage = document.querySelector('#image').files[0];
			const imageName = (+new Date()) + '-' + bannerImage.name;
			const imageMetadata = {contentType: bannerImage.type};
			
			const bannerImageStorageRef = sref(storage, "BannerImages/"+ imageName);
			const imageUptask = uploadBytesResumable( bannerImageStorageRef, bannerImage, imageMetadata );
			
			imageUptask.on('state-changed', ()=>{
				getDownloadURL(imageUptask.snapshot.ref).then((imagedownloadURL)=>{
				    
					push(ref(database, 'BannerImages/'), {
					
						image: imagedownloadURL,
					});
					    window.location = "bannerimages.php";
				});
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