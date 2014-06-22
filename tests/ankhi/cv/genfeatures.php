<html>
<body>
<img src="./img.bmp" usemap="#imgfeatures" />
<img src="./output.bmp" usemap="#imgfeatures" />
<map name="imgfeatures">
<?php readfile("./features.txt"); ?>
</map>
</body>
</html>
