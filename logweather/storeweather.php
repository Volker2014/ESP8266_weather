<?php
if(!empty($_GET["temperature"]) && !empty($_GET["humidity"])){
	$temp = $_GET["temperature"];
	$humi = $_GET["humidity"];
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

    $sql = "INSERT INTO weather (timestamp, temperature, humidity) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sdd", $date, $temp, $humi);
    if ($stmt->execute() === FALSE) {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    $stmt->close();
    $conn->close();
}
?>
