<?php
/* Name: UserHostDisconnect
 * Variables: USER_id, HOST_id
 * Inputs: User ID and Host ID
 * Modification: GuestHostMap
 * Outputs: SUCCESS
 * Description: Takes a valid USER_id and HOST_id and writes a remove time to the GuestHostMap, removing them as a guest from a Host
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

$link = mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

if($input['USER_id'] != null && $input['HOST_id'] != null){
	mysql_query("UPDATE GuestHostMap SET remove_time = NOW() WHERE USER_id = '".$input['USER_id']."' AND HOST_id = '".$input['HOST_id']."' ORDER BY add_time")
		or die(generateResponse(status::QUERY_FAILED, "Could not find User and Host combination", null));
	echo generateResponse(status::SUCCESS, "The User was removed from the Host location", null);
}else{
	echo generateResponse(status::MISSING_INFO, null, null);
}

mysql_close($link);