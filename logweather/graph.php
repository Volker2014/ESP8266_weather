<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7; IE=EmulateIE9">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Mein Wetter</title>
    <script type="text/javascript" src="http://dygraphs.com/dygraph-combined.js"></script>
    <script type="text/javascript" src="synchronizer.js"></script>
  </head>

  <body>
    <div id="graphdiv1" style="width:900px; height:300px;"></div>
    <div id="graphdiv2" style="width:900px; height:300px;"></div>
    <div id="graphdiv3" style="width:900px; height:300px;"></div>
    <script type="text/javascript">
<?php
    require("config.php");
    require("showweather.php");
?>
    </script>
  </body>

</html>