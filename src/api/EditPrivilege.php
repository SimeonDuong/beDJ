<?php
/* Name: EditPrivilege
 * Input: USER_id, HOST_id, TARGET_id, user_privilege
 * Variables; User ID, Host ID, user privilege and User ID that needs updating
 * Modification: UserHostMap
 * Output: SUCCESS or failure
 * Description: Edits another User's privilege if the current user has the right level of privilege
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Gets the user_privilege for the USER_id passed in
$user = mysql_fetch_assoc(mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' AND HOST_id = '".$input['HOST_id']."' "))
			or die(print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching UserHostMap table", null)));

// Updates user_privilege for TARGET_id
if($user['user_privilege'] <= 10){
	mysql_query("UPDATE UserHostMap SET user_privilege = '".$input['user_privilege']."' WHERE USER_id ='".$input['TARGET_id']."' AND HOST_id ='".$input['HOST_id']."' ")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not correctly UPDATE the UserHostMap", null)));
	echo generateResponse(status::SUCCESS, "The User's privilege was updated", null);
}else{
	echo generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to edit user privilege", null);
}

mysql_close();
?>