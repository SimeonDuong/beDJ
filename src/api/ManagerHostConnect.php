<?php
/* Name: ManagerHostConnect
 * Variables: USER_id, HOST_id
 * Inputs: User ID and Host ID
 * Modificatoin: UserHostMap
 * Outputs: SUCCESS
 * Description: Takes a valid USER_id and HOST_id and connects a User to a Host making them a Manager
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$user = mysql_fetch_assoc(mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' and HOST_id = '".$input['HOST_id']."'"))
			or die(generateResponse(status::QUERY_FAILED, "Could not match USER_id and HOST_id in UserHostMap table", null));

if($user['user_privilege'] <= 10){
	mysql_query("UPDATE GuestHostMap SET remove_time = NOW() WHERE USER_id ='".$input['USER_id']."' AND HOST_id ='".$input['HOST_id']."'")
		or die(generateResponse(status::QUERY_FAILED, "Could not remove User from Host" , null));
	echo generateResponse(status::SUCCESS, "User added to Host", null);
}else{
	echo generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to remove a user from a host", null);
}

mysql_close();
?>