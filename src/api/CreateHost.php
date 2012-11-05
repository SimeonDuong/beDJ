<?php
/* Name: CreateHost
 * Variables: name, description, address, position_x, position_y, host_type
 * Input: All applicable information for creating a Host
 * Modification: Adds new Host to the Host table
 * Output: SUCCESS and HOST_id or INVALID_HOST_INFO
 * Description: Creates a new Host in the Host table and returns the HOST_id 
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Corrects for apostrophes
$expression = "'";
$insertvalue = "\'";

$input['name'] 			= str_replace($expression, $insertvalue, $input['name']);
$input['description'] 	= str_replace($expression, $insertvalue, $input['description']);
$input['address'] 		= str_replace($experssion, $insertvalue, $input['address']);

// Create new Host
if($input['name'] != null && $input['description'] != null && $input['address'] != null && $input['position_x'] != null && $input['position_y'] != null && $input['host_type'] != null){
	mysql_query("INSERT INTO Host(name, description, address, position_x, position_y, host_type, active) VALUES('".$input['name']."','".$input['description']."','".$input['address']."', '".$input['position_x']."', '".$input['position_y']."', '".$input['host_type']."', 1)")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not create new Host", null)));
	$host_id = mysql_insert_id();
	mysql_query("INSERT INTO UserHostMap(USER_id, HOST_id, user_privilege) VALUES('".$input['USER_id']."', $host_id, 1)")
		or die(print(generateResponse(status::QUERY_FAILED, "just an insert should not fail", null)));
	echo generateResponse(status::SUCCESS, "passing the HOST_id back", array("HOST_id" => intval($host_id)));
}
else{
	echo generateResponse(status::INVALID_HOST_INFO, "There was null Host information", null);
}

mysql_close();
?>