<?php

session_start();

$driverid = $_GET['driverid'];


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
					<!-- Page Heading -->
						
                        <div class="">
							 <form action="" autocomplete="off"> 
							<div class="row">
							<div class="col-lg-4">
									<div class="form-group">
										<label for="name">Full Name</label>
										<input type="text" class="form-control" id="fullName" name="fullName" placeholder="e-g burgers" required>
									</div>
								</div>
                                <div class="col-lg-4">
									<div class="form-group">
										<label for="catimage">Email</label>
										<input type="email" class="form-control" id="email" name="email" autocomplete="new-email" required>
									</div>
								</div>

                                <div class="col-lg-4">
    									<div class="form-group">
    										<label for="name">Password</label>
    										<input type="password" class="form-control" id="password" name="password" autocomplete="new-password" placeholder="e-g burgers" required>
    									</div>
    								</div>
    								<div class="col-lg-4">
    									<div class="form-group">
    										<label for="catimage">Phone Number</label>
    										<input type="number" class="form-control" id="phoneNumber" name="phoneNumber" required>
    									</div>
    								</div>
                                    <div class="col-lg-4">
    									<div class="form-group">
    										<label for="name">Age</label>
    										<input type="number" class="form-control" id="age" name="age" placeholder="e-g burgers" required>
    									</div>
    								</div>
    								<div class="col-lg-4">
    									<div class="form-group">
    										<label for="catimage">User Name</label>
    										<input type="text" class="form-control" id="userName" name="userName" required>
    									</div>
    								</div>
            <!--                         <div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="catimage">License No</label>-->
    								<!--		<input type="text" class="form-control" id="licenseNo" name="licenseNo" required>-->
    								<!--	</div>-->
    								<!--</div> -->
									<div class="col-lg-4">
    									<div class="form-group">
    										<label for="name">Vehicle</label>
    										<input type="text" class="form-control" id="vehicle" name="vehicle" placeholder="e-g burgers" required>
    									</div>
    								</div>
    							    <div class="col-lg-4">
    									<div class="form-group">
    										<label for="catimage">Vin</label>
    										<input type="text" class="form-control" id="vin" name="vin" required>
    									</div>
    								</div>
    								<!--<div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="name">Profile Image</label>-->
    								<!--		<input type="file" class="form-control-file" id="profileImage" name="profileImage" placeholder="e-g burgers" >-->
    								<!--	</div>-->
    								<!--</div>-->
            <!--                        <div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="catimage">Id Card Front</label>-->
    								<!--		<input type="file" class="form-control-file" id="idCardFront" name="idCardFront" >-->
    								<!--	</div>-->
    								<!--</div>-->
    								<!--<div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="name">Id Card Back</label>-->
    								<!--		<input type="file" class="form-control-file" id="idCardBack" name="idCardBack" placeholder="e-g burgers" >-->
    								<!--	</div>-->
    								<!--</div><br><br>-->
            <!--                         <div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="catimage">License Front</label>-->
    								<!--		<input type="file" class="form-control-file" id="licenseFront" name="licenseFront" >-->
    								<!--	</div>-->
    								<!--</div> -->

    								<!--<div class="col-lg-4">-->
    								<!--	<div class="form-group">-->
    								<!--		<label for="name">License Back</label>-->
    								<!--		<input type="file" class="form-control-file" id="licenseBack" name="licenseBack" placeholder="e-g burgers" >-->
    								<!--	</div>-->
    								<!--</div> -->
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" name="submit" id="updateBtn">Update</button>
										
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
	
	<!--<script src="firebase.js"></script>-->
	
	<!-- Getting Categories-->
	<script type="module">
		
// 			import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
		
		 import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
		import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";        import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";
	
// 		import { getDatabase, ref, get, set, onValue, child, orderByChild, equalTo, query  } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";

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
		
		var driverId = '<?php echo $driverid;?>';
	
		get(child(databaseRef, 'Drivers/'+driverId)).then((datasnapshot) =>{
		
		    document.getElementById("fullName").value = datasnapshot.child('fullName').val();
			document.getElementById("email").value = datasnapshot.child('email').val();
			document.getElementById("password").value = datasnapshot.child('password').val();
			document.getElementById("phoneNumber").value = datasnapshot.child('phoneNumber').val();
			document.getElementById("age").value = datasnapshot.child('age').val();
			document.getElementById("userName").value = datasnapshot.child('userName').val();
			document.getElementById("vehicle").value = datasnapshot.child('vehicle').val();
			document.getElementById("vin").value = datasnapshot.child('vin').val();
			
	});
	
	
	
	
	
    document.getElementById("updateBtn").addEventListener('click', updateDriver);

function updateDriver() {
    
    
  // Get input field values
  var fullName = document.getElementById("fullName").value;
  var email = document.getElementById("email").value;
  var password = document.getElementById("password").value;
  var phoneNumber = document.getElementById("phoneNumber").value;
  var age = document.getElementById("age").value;
  var userName = document.getElementById("userName").value;
  var vehicle = document.getElementById("vehicle").value;
  var vin = document.getElementById("vin").value;

  // Check if any field is empty
  if (fullName === '' || email === '' || password === '' || phoneNumber === '' || age === '' || userName === '' || vehicle === '' || vin === '') {
    alert('Fields cannot be null');
    return;
  }

  // Check if email already exists
  checkEmailExistence(email)
    .then(() => {
      // Email doesn't exist, perform the remaining actions
      // ...

      // Example code that adds the driver to the database
      
      var updateRecord = update(ref(database, 'Drivers/'+driverId ), {
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        age: age,
        userName: userName,
        vehicle: vehicle,
        vin: vin,
      });
     
        setTimeout(function(){
            
            if(updateRecord) {
                
                alert('Record Update Successfully!');
                window.location.href = 'drivers.php';
             }else{
                 alert('Some Error Occurred!');
             }
            
        },2000)
      
    })
    .catch((error) => {
      alert(error.message);
    });
}

function checkEmailExistence(email) {
  return new Promise((resolve, reject) => {
    let existEmail = false;
    get(child(databaseRef, 'Drivers/'))
      .then((snapshot) => {
        snapshot.forEach((element) => {
          let previousEmails = element.child('email').val();
          if (previousEmails === email && element.key != driverId) {
            existEmail = true;
            return;
          }
        });

        if (existEmail) {
          reject(new Error('Email Already Exists!'));
        } else {
          resolve();
        }
      })
      .catch((error) => {
        reject(error);
      });
  });
}

</script>
	
</body>

</html> 
	<?php

} else {
	header( "location:login.php" );
	exit;
}
?>