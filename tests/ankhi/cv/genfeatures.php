<html>
<body>
<img src="./input.jpg" usemap="#imgfeatures" />
<img src="./output.jpg" usemap="#imgfeatures" />
<map name="imgfeatures">
<?php readfile("./features.txt"); ?>
</map>
</body>
</html>
