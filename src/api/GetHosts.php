<?php
/* Name: GetHosts
 * Variables: NONE
 * Input: NONE
 * Modification: NONE
 * Output: Returns active or !party populated Host list
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

$link = mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get Host table
$party	= 1;		// Need to define int code for host_type
$active = 1;		// Need to define int code for active
$query = mysql_query("SELECT * FROM Host WHERE remove_time IS NULL AND active = $active");

$HOSTS = array();

while($row = mysql_fetch_assoc($query)){
	$HOSTS[] = $row;
};

// JSON encode Host table
if($HOSTS != null){
	echo generateResponse(status::SUCCESS, "Here is all the Hosts", $HOSTS);
}else if($HOSTS == null){
	echo generateResponse(status::SUCCESS, "There were no active Hosts", $HOSTS);
}else{generateResponse(status::UNEXPECTED, "Something went wrong when gathering the Host information", null);}

mysql_close($link);
?>