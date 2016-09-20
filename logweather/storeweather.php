<?php
if(!empty($_GET["date"])){
	$temp = $_GET["temperature"];
	$humi = $_GET["humidity"];
    $pooltemp = $_GET["pooltemp"];
    $boxtemp = $_GET["boxtemp"];
    $pressure = $_GET["pressure"];
    $vdd = $_GET["vdd"];
	$date = date("Y-m-d H:i:s");
   $csvData = array($date,$temp,$humi);
   $fp = fopen("weather.csv","a"); 
   if($fp)    {  
       fputcsv($fp,$csvData,',',' '); // Write information to the file
       fclose($fp); // Close the file
	   echo "success";
   }

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname) or die("Connection failed: " . $conn->connect_error);

    $sql = "INSERT INTO weather (timestamp, temperature, humidity, pooltemp, boxtemp, pressure, vdd) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sdddddd", $date, $temp, $humi, $pooltemp, $boxtemp, $pressure, $vdd);
    if ($stmt->execute() === FALSE) {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    $stmt->close();
    $conn->close();
}
?>
