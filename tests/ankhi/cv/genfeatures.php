<html>
<head>
<script type="text/javascript" src="jquery-1.11.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#region').val("hi");
	$('#imgfeatures').on('click', 'area', function (e) {
	    $('#region').val(e.target.title);
	});
});
</script>
</head>
<body>
<div class="regionspacing">
  <label for="region">Features</label>
  <input type="text" id="region" name="region" class="form-control input-md"/>
</div>
<map name="imgfeatures" id="imgfeatures">
<?php readfile("./features.txt"); ?>
</map>
<img src="./output.jpg" usemap="#imgfeatures" />
<!-- img src="./input.jpg" usemap="#imgfeatures" / -->
</body>
</html>
