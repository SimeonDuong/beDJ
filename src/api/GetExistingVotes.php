<?php

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$votes = mysql_query("SELECT * FROM Vote WHERE USER_id = '".$input['USER_id']."' and SONG_id is NULL" )
or print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching Vote table" , null));

while($a = mysql_fetch_assoc($votes)){
	if(!in_array($a["HOST_id"], $hostarr)){
		$hostarr[]=$a["HOST_id"];
	}
}

foreach($hostarr as &$host){
	$votes = mysql_query("SELECT * FROM Vote WHERE USER_id = '".$input['USER_id']."' and SONG_id is NULL and HOST_id = $host");
	$output[]= array($host => mysql_num_rows($votes));
}
$output=json_encode($output);
print(generateResponse(status::SUCCESS, "if the data field is null the USER_id has no votes with any hosts" , $output));
mysql_close();
?>