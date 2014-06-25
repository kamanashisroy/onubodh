<html>
<head>
<script type="text/javascript">
function updateVal(x) {
	var ourvals = x.split(/,/);
	var labels = ["Length","","","","Cracks","Opposite","Adjacent","Sparsity","","","","","","","","","Contrast","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""];
	var output = "";
	var i = 0;
	for(i=0;i<32;i++) {
		output += labels[i] + ":" + ourvals[i] + ",";
	}
	document.getElementById('region').value = output;
};
</script>

</head>
<body>
<div class="regionspacing">
	Length,,,,Cracks,Opposite,Adjacent<br/>
  <label for="region">Features</label>
  <input type="text" id="region" name="region" class="form-control input-md" size=50/>
</div>
<map name="imgfeatures" id="imgfeatures">
<?php readfile("./features_output.pgm.txt"); ?>
</map>
<img src="./output.jpg" usemap="#imgfeatures" />
<!-- img src="./input.jpg" usemap="#imgfeatures" / -->
</body>
</html>
