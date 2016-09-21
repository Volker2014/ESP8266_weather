<?php
	$conn = new mysqli($servername, $username, $password, $dbname) or die("Connection failed to " . $conn->connect_error);

	$sql = "SELECT * FROM weather";
	$result = $conn->query($sql);
    if ($result->num_rows > 0) {
		echo "g1 = new Dygraph(";
		echo "document.getElementById(\"graphdiv1\"),\n";
		echo "\"Date,Temp,Humi\\n\"";
		while($row = $result->fetch_assoc()) {
			echo  "+\n\"" . $row['timestamp'] . "," . $row['temperature'] . "," .$row['humidity'] . "\\n\"";
		}
		echo ",\n{labels: [\"Date\", \"Temp\", \"Humi\"],\n";
        echo "series : {\n";
        echo "'Humi': { axis: 'y2' },\n";
        echo "},\n";
        echo "axes: {\n";
        echo "y2: {\n";
        echo "}\n";
        echo "},\n";
        echo "ylabel: 'Temperature (C)',\n";
        echo "y2label: 'Humidity (%)'}\n);";
		echo "g2 = new Dygraph(";
		echo "document.getElementById(\"graphdiv2\"),\n";
		echo "\"Date,Pressure\\n\"";
        $result->data_seek(0);
		while($row = $result->fetch_assoc()) {
			echo  "+\n\"" . $row['timestamp'] . "," . $row['pressure'] . "\\n\"";
		}
		echo ",\n{labels: [\"Date\", \"Pressure\"],ylabel: 'Pressure (mBar)'}\n);";
		echo "g3 = new Dygraph(";
		echo "document.getElementById(\"graphdiv3\"),\n";
		echo "\"Date,Pooltemp\\n\"";
        $result->data_seek(0);
		while($row = $result->fetch_assoc()) {
			echo  "+\n\"" . $row['timestamp'] . "," . $row['pooltemp'] . "\\n\"";
		}
		echo ",\n{labels: [\"Date\", \"Pooltemp\"],ylabel: 'Temperature (C)'}\n);";
	}
	$conn->close();

    echo "gs = [];\n";
    echo "gs.push(g1);\n";
    echo "gs.push(g2);\n";    
    echo "gs.push(g3);\n";
    //echo "sync = Dygraph.synchronize(gs);\n";
?>
