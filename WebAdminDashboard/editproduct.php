<?php
//include( 'database-connection.php' );
session_start();


$prductid = $_GET['productid'];
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

					
								
						<!-- Page Heading -->
						
						
						<div class="">
							<form action="" method="post" enctype="multipart/form-data">
							<div class="row">
							
								<div class="text-center col-lg-12">
									<img src="images/loading.gif" alt="" id="oldimage" height="200px">
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="categoryname">Select Category</label>
										<select name="categoryname" id="categoryname" class="form-control" required>
											<option value="" selected>Choose Category</option>
											
										</select>
										<input type="text" id="oldcat" value="" hidden="">
									</div>
								</div>
								<div class="col-lg-4">
									<div class="form-group">
										<label for="name">Product Name</label>
										<input type="text" id="name" class="form-control" name="name" required>
									</div>
								</div>
								
								<div class="col-lg-4">
									<div class="form-group">
										<label for="desc">Description</label>
										<textarea name="long" id="desc" class="form-control"></textarea>
									</div>
								</div>
								<div class="col-lg-3">
									<div class="form-group">
										<label for="price">Price</label>
										<input type="number" class="form-control" id="price" name="price" required>
									</div>
								</div>
								<div class="col-lg-3">
									<div class="form-group">
										<label for="desc">Stock</label>
										<input type="number" class="form-control" id="stock" name="stock" required>
									</div>
								</div>
								<div class="col-lg-3">
									<div class="form-group">
										<label for="noofserves">No of Serves</label>
										<input type="number" class="form-control" id="noofserves" name="noofserves" placeholder="e-g 2, 3 or 5" required>
									</div>
								</div>
								
								<div class="col-lg-3">
									<div class="form-group">
										<label for="image">Image</label>
										<input type="file" class="form-control-file" id="image" name="image" required>
									</div>
								</div>
								
							<!--	<div class="form-group col-lg-12">-->
							<!--		<h4>Product Flavors</h4>-->
							<!--	</div>-->
      					
      							<!--<div id="flavors-dive" class="col-md-12">-->
      					    		<!--<div class="row" >
							<!--			<div class="form-group col-lg-6">-->
							<!--				<label for="">Flavor</label>-->
							<!--				<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Fajita" required value="default">-->
							<!--			</div>-->
										
										
						 <!--   		</div>-->
							<!--	</div>-->
							<!--	<div class="form-group col-lg-12">-->
										
							<!--		<button id="add-more-flavors" class="btn btn-info">+</button>-->
							<!--	</div>-->
								
								
							<!--	<div class="form-group col-lg-12">-->
							<!--		<h4>Product Variations</h4>-->
							<!--	</div>-->
							<!--	<div id="variations-div" class="col-md-12">-->
      					    		<!--<div class="row" >
							<!--			<div class="form-group col-lg-5">-->
							<!--				<label for="">Variation Name</label>-->
							<!--				<input type="text" class="form-control" name="variation-name[]" id="" placeholder="e-g Large or small" required value="default">-->
							<!--			</div>-->
							<!--			<div class="form-group col-lg-5">-->
							<!--				<label for="">Variation Price</label>-->
							<!--				<input type="text" class="form-control" name="variation-price[]" id="" placeholder="e-g 100" required value="default">-->
							<!--			</div>-->
							<!--		</div>-->
							<!--	</div>-->
       <!--						<div class="form-group col-lg-12">-->
							<!--	<button id="add-more-variations" class="btn btn-info">+</button>-->
							<!--</div>-->
							
							
							<!--<div class="form-group col-lg-12">-->
							<!--		<h4>Ingredients E-g Coke, Sprite</h4>-->
							<!--	</div>-->
      					
      	<!--						<div id="ingredients-div" class="col-md-12">-->
      					    		<!--<div class="row" >
							<!--			<div class="form-group col-lg-6">-->
							<!--				<label for="">Ingredients</label>-->
							<!--				<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Regular Coke" required value="default">-->
							<!--			</div>-->
										
										
						 <!--   		</div>-->
							<!--	</div>-->
							<!--	<div class="form-group col-lg-12">
							<!--		<button id="add-more-ingredients" class="btn btn-info">+</button>-->
							<!--	</div>-->
								
								<div class="col-lg-12 mt-5">
									<div class="form-group">
									<button type="button" class="btn btn-block btn-success" name="submit" id="updateBtn" >Update Product</button>
										
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
	
	
	<script type="module">
		
// 		import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-app.js";
// 		import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-analytics.js";
		
    // 	import { getDatabase, ref, get, set, onValue, child, remove, push, query, orderByChild, equalTo, update } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-database.js";
    //     import { ref as sref, getStorage, uploadBytes, uploadBytesResumable, getDownloadURL, deleteObject } from "https://www.gstatic.com/firebasejs/9.6.11/firebase-storage.js";

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
	
	
	
	
	
	
// 	<!-- Getting Previous details-->
	
		
		var productid = '<?php echo $prductid; ?>';
		
		
// 		var flavorref =  databaseRef.child("Items/"+productid+"/customizationForFlavours");
// 		var variationref = databaseRef.child("Items/"+productid+"/customizationForVariations");
// 		var ingredientref = databaseRef.child("Items/"+productid+"/ingredients");
		//alert(products);
// 		var storageRefImage = firebase.storage().ref("item_images");
		

		
		 get(child(databaseRef, 'Items/'+productid)).then((datasnapshot) =>{

            var oldcategoryname = datasnapshot.child("categoryName").val();
			document.getElementById("oldcat").value = oldcategoryname;
			var details = datasnapshot.child("details").val();
			document.getElementById("desc").value = details;
			var image = datasnapshot.child("image").val();
			document.getElementById("oldimage").src = image;
			var title = datasnapshot.child("title").val();
			document.getElementById("name").value = title;
			var price = datasnapshot.child("price").val();
			document.getElementById("price").value = price;
			var stock = datasnapshot.child("productQuantity").val();
			document.getElementById("stock").value = stock;
			var serves = datasnapshot.child("no_of_serving").val();
			document.getElementById("noofserves").value = serves;


        });
    

		
		
// 		flavorref.once('value', function(flavorSnap){
// 			flavorSnap.forEach(function(flvsnap){
// 				//alert(flvsnap.val());
				
// 				var r ='<div class="row" ><div class="form-group col-md-6">';
// 			    var r = r+ '<label for="">Add New Flavor</label>';
// 			    var r = r+ '<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Tikka" required value="'+flvsnap.val()+'">';
// 			    var r = r+ '</div>';

// 	       	    var r = r+ '<div class="form-group col-md-1">';
// 			    var r = r+ '<label >Remove</label>';
// 			    var r = r+ '<button class="btn-danger btn remove-spec">-</button>';
// 			    var r = r+ '</div></div>';
		    
// 				$("#flavors-dive").append(r);
// 				$(".remove-spec").click(function(e){
// 				    e.preventDefault();
// 				    $(this).closest(".row").remove();
// 				});
				
				
				
// 			});
// 		});
		
// 		variationref.once('value', function(variationSnap){
// 			variationSnap.forEach(function(varsnap){
// 				//alert(varsnap.child("name").val());
				
// 				var r ='<div class="row" ><div class="form-group col-md-5">';
// 			    var r = r+ '<label for="">Variation Name</label>';
// 			    var r = r+ '<input type="text" class="form-control" name="variation-name[]" id="variation-name[]" placeholder="e-g Small" required value="'+varsnap.child("name").val()+'">';
// 			    var r = r+ '</div>';
// 	       	    var r = r+ '<div class="form-group col-md-5">';
// 			    var r = r+ '<label for="">Variation Price</label>';
// 			    var r = r+ '<input type="text" class="form-control" name="variation-price[]" id="variation-price[]" placeholder="e-g 200" required value="'+varsnap.child("price").val()+'">';
// 			    var r = r+ '</div>';
// 	       	    var r = r+ '<div class="form-group col-lg-2">';
// 			    var r = r+ '<label >Remove</label> <br>';
// 			    var r = r+ '<button class="btn-danger btn remove-variation">-</button>';
// 			    var r = r+ '</div></div>';
		    
// 				$("#variations-div").append(r);
// 				$(".remove-variation").click(function(e){
// 				    e.preventDefault();
// 				    $(this).closest(".row").remove();
// 				});
				
				
				
// 			});
// 		});
		
// 		ingredientref.once('value', function(ingredientSnap){
// 			ingredientSnap.forEach(function(ingsnap){
// 				//alert(ingsnap.val());
				
				
				
// 				var r ='<div class="row" ><div class="form-group col-md-6">';
// 			    var r = r+ '<label for="">Add New Ingredient</label>';
// 			    var r = r+ '<input type="text" class="form-control" name="ingredients[]" id="ingredients[]"  required value="'+ingsnap.val()+'">';
// 			    var r = r+ '</div>';

// 	       	    var r = r+ '<div class="form-group col-md-1">';
// 			    var r = r+ '<label >Remove</label>';
// 			    var r = r+ '<button class="btn-danger btn remove-ingredient">-</button>';
// 			    var r = r+ '</div></div>';
		    
// 				$("#ingredients-div").append(r);
// 				$(".remove-ingredient").click(function(e){
// 				    e.preventDefault();
// 				    $(this).closest(".row").remove();
// 				});
				
// 			});
// 		});
		
		//alert();
		

	
	
// 	<!-- Getting Categories-->

	
		
	get(child(databaseRef, 'Categories/')).then((snapshot) => {

       	var catcontent = "";
		var oldcat = document.getElementById("oldcat").value;
		$('#categoryname').html(catcontent);

        
       snapshot.forEach(function(childsnapshot){
			//var category = childsnapshot.child("title").val();
			var catname = childsnapshot.child("title").val();
			
			if(oldcat==catname){
				catcontent +='<option value="'+childsnapshot.child("title").val()+'" selected> '+childsnapshot.child("title").val()+'</option>';
			}
			else{
				catcontent +='<option value="'+childsnapshot.child("title").val()+'" > '+childsnapshot.child("title").val()+'</option>';
			}
        });
			$('#categoryname').append(catcontent);
     
   });
	
	
	
// 	<!-- Add product to database -->
	
		
		
		document.getElementById('updateBtn').addEventListener('click',(event)=>{
			var catname = document.getElementById("categoryname").value;
			var productname = document.getElementById("name").value;
			var description= document.getElementById("desc").value;
			var price= document.getElementById("price").value;
			var stock= document.getElementById("stock").value;
			var noofserves= document.getElementById("noofserves").value;
			//var viewcount = 0;
			//var flavorArray = $("#flavors[]").val();
			//alert(flavorArray.length);
			
			
// 			var flavors = [];
// 			var variations = [];
// 			var ingredient = [];
			
// 			$("input[name='flavors[]']").each(function() {
// 				flavors.push($(this).val());
// 			});
// 			$("input[name='ingredients[]']").each(function() {
// 				ingredient.push($(this).val());
// 			});
			
// 			var variationName = [];
// 			var variationPrice = [];
			
// 			$("input[name='variation-name[]']").each(function() {
// 				variationName.push($(this).val());
				
// 			});
// 			$("input[name='variation-price[]']").each(function() {
// 				variationPrice.push($(this).val());
				
// 			});
// 			for(var i=0;i<variationName.length;i++){
// 				variations.push({"name":variationName[i], "price":variationPrice[i]});
				
// 			}
			//console.log(variations);
			
			//alert(flavors.length);
			
			//return;
			var date = new Date();
			var timestamp = ""+date.getTime();
			
			
			if( document.getElementById("image").files.length == 1 ){
				
				const catimage = document.querySelector('#image').files[0];
				const imageName = (+new Date()) + '-' + catimage.name;
				const imageMetadata = {contentType: catimage.type};
			
    			const catImagesStorageRef = sref(storage, "ProductsImages/"+ imageName);
    			const imageUptask = uploadBytesResumable( catImagesStorageRef, catimage, imageMetadata);
			
    			  imageUptask.on('state-changed', ()=>{
    				getDownloadURL(imageUptask.snapshot.ref).then((imagedownloadURL)=>{
    				   let updateData = update(ref(database, 'Items/'+productid), {
                                	categoryName: catname,
                					details: description,
                					no_of_serving: noofserves,
                					price: price,
                					productQuantity:stock.toString(),
                					title: productname,
                					image: imagedownloadURL
                            });
                            
                            setTimeout(()=>{
                                 
                                    if(updateData) {
                                        alert("Data Updated Successfully");
                                        location.href = 'products.php';
                                     }else{
                                        alert('some Error Occurred')
                                     }
                                 
                                },500)
                            
    				});
    			});
			
			
			}else{
			    
			    let updateData = update(ref(database, 'Items/'+productid), {
                            	categoryName: catname,
            					details: description,
            					no_of_serving: noofserves,
            					price: price,
            					productQuantity:stock.toString(),
            					title: productname
                        });
                        
                         setTimeout(()=>{
                             
                                if(updateData) {
                                    alert("Data Updated Successfully");
                                    location.href = 'products.php';
                                 }else{
                                    alert('some Error Occurred')
                                 }
                             
                            },500);
                            
			}
			
			
				
				 
				
			
// 			var updateflavors = products.update({
// 				customizationForFlavours: flavors,
// 				customizationForVariations: variations,
// 				ingredients: ingredient
// 			}).updateflavors;
			
			
			
			
			
		});

// <!-- Add Flavors -->		
// <!--    $("#add-more-flavors").on("click",function(e){-->
// <!--        e.preventDefault();-->
        
// <!--        var r ='<div class="row" ><div class="form-group col-md-6">';-->
// <!--		    var r = r+ '<label for="">Add New Flavor</label>';-->
// <!--		    var r = r+ '<input type="text" class="form-control" name="flavors[]" id="flavors[]" placeholder="e-g Tikka" required>';-->
// <!--		    var r = r+ '</div>';-->

// <!--       	    var r = r+ '<div class="form-group col-md-1">';-->
// <!--		    var r = r+ '<label >Remove</label>';-->
// <!--		    var r = r+ '<button class="btn-danger btn remove-spec">-</button>';-->
// <!--		    var r = r+ '</div></div>';-->
		    
// <!--		$("#flavors-dive").append(r);-->
// <!--		$(".remove-spec").click(function(e){-->
// <!--		    e.preventDefault();-->
// <!--		    $(this).closest(".row").remove();-->
// <!--		});-->
// <!--    });-->

// <!-- Add Variations -->	
// <!--    $("#add-more-variations").on("click",function(e){-->
// <!--        e.preventDefault();-->
        
// <!--        var r ='<div class="row" ><div class="form-group col-md-5">';-->
// <!--		    var r = r+ '<label for="">Variation Name</label>';-->
// <!--		    var r = r+ '<input type="text" class="form-control" name="variation-name[]" id="variation-name[]" placeholder="e-g Small" required>';-->
// <!--		    var r = r+ '</div>';-->
// <!--       	    var r = r+ '<div class="form-group col-md-5">';-->
// <!--		    var r = r+ '<label for="">Variation Price</label>';-->
// <!--		    var r = r+ '<input type="text" class="form-control" name="variation-price[]" id="variation-price[]" placeholder="e-g 200" required>';-->
// <!--		    var r = r+ '</div>';-->
// <!--       	    var r = r+ '<div class="form-group col-lg-2">';-->
// <!--		    var r = r+ '<label >Remove</label> <br>';-->
// <!--		    var r = r+ '<button class="btn-danger btn remove-variation">-</button>';-->
// <!--		    var r = r+ '</div></div>';-->
		    
// <!--		$("#variations-div").append(r);-->
// <!--		$(".remove-variation").click(function(e){-->
// <!--		    e.preventDefault();-->
// <!--		    $(this).closest(".row").remove();-->
// <!--		});-->
// <!--    });-->

// <!-- Add Ingredients -->	

// <!--    $("#add-more-ingredients").on("click",function(e){-->
// <!--        e.preventDefault();-->
        
// <!--        var r ='<div class="row" ><div class="form-group col-md-6">';-->
// <!--		    var r = r+ '<label for="">Add New Ingredient</label>';-->
// <!--		    var r = r+ '<input type="text" class="form-control" name="ingredients[]" id="ingredients[]" placeholder="e-g Coke Sprite" required>';-->
// <!--		    var r = r+ '</div>';-->

// <!--       	    var r = r+ '<div class="form-group col-md-1">';-->
// <!--		    var r = r+ '<label >Remove</label>';-->
// <!--		    var r = r+ '<button class="btn-danger btn remove-ingredient">-</button>';-->
// <!--		    var r = r+ '</div></div>';-->
		    
// <!--		$("#ingredients-div").append(r);-->
// <!--		$(".remove-ingredient").click(function(e){-->
// <!--		    e.preventDefault();-->
// <!--		    $(this).closest(".row").remove();-->
// <!--		});-->
// <!--    });-->
</script>

	<!--<script src="js/restaurantdetails.js"></script>-->

</body>

</html> 
	<?php

} else {
	header( "location:login.php" );
	exit;
}
?>