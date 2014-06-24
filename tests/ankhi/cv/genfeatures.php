<html>
<head>
<script type="text/javascript" src="jquery-1.11.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#region').val("hi");
	$('#imgfeatures').on('click', 'area', function (e) {
		var titleval = e.target.title;
		var ourvals = titleval.split(/,/);
		var labels = ["Length","","","","Cracks","Opposite","Adjacent","Sparsity",""];
		var output = "";
		var i = 0;
		for(i=0;i<8;i++) {
			output += labels[i] + ":" + ourvals[i] + ",";
		}
		$('#region').val(output);
	});
});
</script>
</head>
<body>
<div class="regionspacing">
	Length,,,,Cracks,Opposite,Adjacent<br/>
  <label for="region">Features</label>
  <input type="text" id="region" name="region" class="form-control input-md" size=50/>
</div>
<map name="imgfeatures" id="imgfeatures">
<?php readfile("./features.txt"); ?>
</map>
<img src="./output.jpg" usemap="#imgfeatures" />
<!-- img src="./input.jpg" usemap="#imgfeatures" / -->
</body>
</html>
