<?php
/* Name: RemoveHost
 * Variables: USER_id, HOST_id
 * Input: User ID, Host ID
 * Modification: Host
 * Output: NONE
 * Description: Writes a remove_time to a Host making the Host inactive
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

if($input['USER_id'] == null || $input['HOST_id'] == null){
	die(print(generateResponse(status::MISSING_INFO, "Missing USER_id or HOST_id", null)));
	mysql_close();
}

// Get user_privilege
$user = mysql_fetch_assoc(mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' and HOST_id = '".$input['HOST_id']."' "))
			or die(print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching UserHostMap" , null)));

if($user['user_privilege'] >= 1){
	mysql_query("UPDATE Host SET remove_time = NOW() WHERE HOST_id = '".$input['HOST_id']."' ")
		or die(print(generateResponse(status::QUERY_FAILED, "Not a valid HOST_id" , null)));
	echo generateResponse(status::SUCCESS, "Host removed", null);
}
else{
	echo generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to remove this HOST_id", null);
}
mysql_close();
?>
