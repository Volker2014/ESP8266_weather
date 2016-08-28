<?php
	$conn = new mysqli($servername, $username, $password, $dbname) or die("Connection failed to " . $conn->connect_error);

	$sql = "SELECT * FROM weather";
	$result = $conn->query($sql);
    if ($result->num_rows > 0) {
		echo "g = new Dygraph(";
		echo "document.getElementById(\"graphdiv\"),\n";
		echo "\"Date,Temp,Humi\\n\"";
		while($row = $result->fetch_assoc()) {
			echo  "+\n\"" . $row['timestamp'] . "," . $row['temperature'] . "," .$row['humidity'] . "\\n\"";
		}
		echo ",\n{labels: [\"Date\", \"Temp\", \"Humi\"]}\n);";
	}
	$conn->close();
?>
