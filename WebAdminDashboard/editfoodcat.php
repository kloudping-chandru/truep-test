<?php

session_start();
$catid = $_GET['foodcatid'];

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
			<?php $pagename="foodcategories"; ?>
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
						
						
						<div class="">
							<form method="post" enctype="multipart/form-data">
							<div class="row">
							
								<div class="col-lg-12">
									<div class="form-group">
										
										<input type="text" id="id" class="form-control" value="<?php echo($catid) ?>" name="fieldid" hidden>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label for="name">Category Title</label>
										<input type="text" name="cattitle" class="form-control" value="" id="cattitle">
										<input type="text" name="oldcattitle" class="form-control" value="" id="oldcattitle" hidden>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label for="name">Color Code</label>
										<input type="text" name="colorcode" class="form-control" value="" id="colorcode">
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label for="">Current Image</label>
										<br>
										<img src="images/loading.gif" alt="" id="image" height="100px">
									</div>
									<div class="form-group">
										<label for="">Upload image if you want to change </label>
										<br>
										<input type="file" class="form-control-file" id="newimage" name="image">
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label for="">Current Icon</label>
										<br>
										<img src="images/loading.gif" alt="" id="icon" height="100px">
									</div>
									<div class="form-group">
										<label for="">Upload icon if you want to change </label>
										<br>
										<input type="file" class="form-control-file" id="newicon" name="icon">
									</div>
								</div>
								
								
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" id="update" name="update" >Update Record</button>
										
									</div>
								</div>
							</div>
								
								
							</form>
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
	<script src="js/restaurantdetails.js" type="module"></script>
	
	<script src="firebase.js"></script>
	
	<script type="module">
		
// 			import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";

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
        const storage = getStorage();
        
		//alert(storageRef);
		
		var catid = '<?php echo $catid;?>'
		//alert(catid);
		//return;
		
		//var products = databaseRef.child("Items");
		//var catdetails = databaseRef.child("Categories/"+catid);
		get(child(databaseRef, 'Categories/'+catid)).then((datasnapshot) =>{
		
			var c_title = datasnapshot.child("title").val();
			var c_colorcode = datasnapshot.child("colorCode").val();
			var c_icon = datasnapshot.child("icon").val();
			var c_image = datasnapshot.child("image").val();
			
			//alert(restName);
			document.getElementById("cattitle").value = c_title;
			document.getElementById("colorcode").value = c_colorcode;
			document.getElementById("oldcattitle").value = c_title;
			document.getElementById("image").src = c_image;
			document.getElementById("icon").src = c_icon;
			
	});
	
document.getElementById("update").addEventListener('click', updaterecord);

function updaterecord() {
   	var cn_title = document.getElementById("cattitle").value;
	var cn_colorcode = document.getElementById("colorcode").value;
	var cn_oldcattitle = document.getElementById("oldcattitle").value;
	var cn_oldimage = document.getElementById("image").src;
	var cn_oldicon = document.getElementById("icon").src;
			


  // Check if both newImage and newicon have been updated
  const newImageSelected = document.getElementById("newimage").files.length === 1;
  const newIconSelected = document.getElementById("newicon").files.length === 1;

  if (newImageSelected && newIconSelected) {
    // Both newImage and newicon are updated
    // Update the newImage first
    const catImage = document.querySelector('#newimage').files[0];
    const imageMetadata = { contentType: catImage.type };
    const imageName = (+new Date()) + '-' + catImage.name;
    const catImagesStorageRef = sref(storage, "CategoriesImages/" + imageName);

    const imageUptask = uploadBytesResumable(catImagesStorageRef, catImage, imageMetadata);

    imageUptask.on('state-changed', () => {
      getDownloadURL(imageUptask.snapshot.ref).then((imageDownloadURL) => {
        // Now update newicon
        const catIcon = document.querySelector('#newicon').files[0];
        const iconMetadata = { contentType: catIcon.type };
        const iconName = (+new Date()) + '-' + catIcon.name;
        const catIconsStorageRef = sref(storage, "CategoriesIcons/" + iconName);

        const iconUptask = uploadBytesResumable(catIconsStorageRef, catIcon, iconMetadata);

        iconUptask.on('state-changed', () => {
          getDownloadURL(iconUptask.snapshot.ref).then((iconDownloadURL) => {
            // Update newImage and newicon in the database
            update(ref(database, 'Categories/' + catid), {
              image: imageDownloadURL,
              icon: iconDownloadURL,
              colorCode: cn_colorcode,
              title: cn_title
            });
            window.location = "foodcategories.php";
          });
        });
      });
    });
  } else if (newImageSelected) {
    // Only newImage is updated
  const catImage = document.querySelector('#newimage').files[0];
  const imageMetadata = { contentType: catImage.type };
  const imageName = (+new Date()) + '-' + catImage.name;
  const catImagesStorageRef = sref(storage, "CategoriesImages/" + imageName);

  const imageUptask = uploadBytesResumable(catImagesStorageRef, catImage, imageMetadata);

  imageUptask.on('state-changed', () => {
    getDownloadURL(imageUptask.snapshot.ref).then((imageDownloadURL) => {
      // Update newImage in the database
      update(ref(database, 'Categories/' + catid), {
        image: imageDownloadURL,
        colorCode: cn_colorcode,
        title: cn_title
      });
      window.location = "foodcategories.php";
    });
  });
  } else if (newIconSelected) {
   const catIcon = document.querySelector('#newicon').files[0];
  const iconMetadata = { contentType: catIcon.type };
  const iconName = (+new Date()) + '-' + catIcon.name;
  const catIconsStorageRef = sref(storage, "CategoriesIcons/" + iconName);

  const iconUptask = uploadBytesResumable(catIconsStorageRef, catIcon, iconMetadata);

  iconUptask.on('state-changed', () => {
    getDownloadURL(iconUptask.snapshot.ref).then((iconDownloadURL) => {
      // Update newicon in the database
      update(ref(database, 'Categories/' + catid), {
        icon: iconDownloadURL,
        colorCode: cn_colorcode,
        title: cn_title
      });
      window.location = "foodcategories.php";
    });
  });
  } else {
    // Neither newImage nor newicon is updated
    update(ref(database, 'Categories/' + catid), {
      colorCode: cn_colorcode,
      title: cn_title
    });
    window.location = "foodcategories.php";
  }
}

	
	
// 		document.getElementById("update").addEventListener('click', updaterecord);
		
// 		function updaterecord(){
// 			//alert("in");
// 			var cn_title = document.getElementById("cattitle").value;
// 			var cn_colorcode = document.getElementById("colorcode").value;
// 			var cn_oldcattitle = document.getElementById("oldcattitle").value;
// 			var cn_oldimage = document.getElementById("image").src;
// 			var cn_oldicon = document.getElementById("icon").src;
			
// 			//var storageRefImage = firebase.storage().ref("categories_images");
// 			//var storageRefIcon = firebase.storage().ref("categories_icons");
			
			
			
// 			if( document.getElementById("newimage").files.length == 1 ){
// 				//alert(1);
				
				
// 				var c_image = document.getElementById("image").src;
				
// 				const baseUrl = "https://firebasestorage.googleapis.com/v0/b/foodizm-android-877a3.appspot.com/o/";
				
// 				let imagePath = c_image.replace(baseUrl,"");
    
// 				const indexOfEndPath = imagePath.indexOf("?");

// 				imagePath = imagePath.substring(0,indexOfEndPath);

// 				imagePath = imagePath.replace(/%2F/g,"/");

// 				imagePath = imagePath.replace(/%20/g," ");
				
// 				//alert(imagePath);
				
				
// 				const desertRef = sref(storage, imagePath+"");
				
// 				deleteObject(desertRef).then(() => {
					
// 					// File deleted successfully
// 					//alert("File deleted successfully");
					
// 					const catimage = document.querySelector('#newimage').files[0];
// 					//alert(catimage);
// 					const imageName = (+new Date()) + '-' + catimage.name;
// 					const imageMetadata = {contentType: catimage.type};

// 					const catImagesStorageRef = sref(storage, "CategoriesImages/"+imageName);
					
// 					const imageUptask = uploadBytesResumable(catImagesStorageRef, catimage, imageMetadata);

// 					imageUptask.on('state-changed', ()=>{
// 						getDownloadURL(imageUptask.snapshot.ref).then((downloadURL)=>{
// 							//alert()
// 							update(ref(database, 'Categories/'+catid ), {
// 								image: downloadURL,
// 								colorCode: cn_colorcode,
// 								title: cn_title
// 							});
// 							window.location = "foodcategories.php";
// 						});
// 					});
					
				  
// 				}).catch((error) => {
// 				  alert("Old file not deleted and data is not updated");
// 				});

				
				
// 			}
// 			else if( document.getElementById("newicon").files.length == 1 ){
				
// 				var c_image = document.getElementById("icon").src;
				
// 				const baseUrl = "https://firebasestorage.googleapis.com/v0/b/foodizm-android-877a3.appspot.com/o/";
				
// 				let imagePath = c_image.replace(baseUrl,"");
    
// 				const indexOfEndPath = imagePath.indexOf("?");

// 				imagePath = imagePath.substring(0,indexOfEndPath);

// 				imagePath = imagePath.replace(/%2F/g,"/");

// 				imagePath = imagePath.replace(/%20/g," ");
				
// 				//alert(imagePath);
				
				
// 				const desertRef = sref(storage, imagePath+"");
				
// 				deleteObject(desertRef).then(() => {
					
// 					// File deleted successfully
// 					//alert("File deleted successfully");
					
// 					const catimage = document.querySelector('#newicon').files[0];
// 					//alert(catimage);
// 					const imageName = (+new Date()) + '-' + catimage.name;
// 					const imageMetadata = {contentType: catimage.type};

// 					const catImagesStorageRef = sref(storage, "CategoriesIcons/"+imageName);
					
// 					const imageUptask = uploadBytesResumable(catImagesStorageRef, catimage, imageMetadata);

// 					imageUptask.on('state-changed', ()=>{
// 						getDownloadURL(imageUptask.snapshot.ref).then((downloadURL)=>{
// 							//alert()
// 							update(ref(database, 'Categories/'+catid ), {
// 								icon: downloadURL,
// 								colorCode: cn_colorcode,
// 								title: cn_title
// 							});
// 							window.location = "foodcategories.php";
// 						});
// 					});
					
				  
// 				}).catch((error) => {
// 				  alert("Old file not deleted and data is not updated");
// 				});
// 			}
			
// 			else{
// 				update(ref(database, 'Categories/'+catid ), {
					
// 					colorCode: cn_colorcode,
// 					title: cn_title
// 				});
// 				window.location = "foodcategories.php";
// 			}
			
			
			
// 		}
	</script>
	
	</body>

	</html> 
	<?php

} else {
	header( "location:login.php" );
	exit;
}
?>