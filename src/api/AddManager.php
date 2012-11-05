<?php
/* Name: AddManager
 * Variables: USER_id (current), TARGET_id (new User), HOST_id, user_privilege
 * Input: User ID for the current user and the new User ID, Host ID
 * Modification: UserHostMap
 * Output: SUCCESS or failure
 * Description: Takes a USER_id and maps it to a specified HOST_id
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Checks that there is valid input being passed
if($input['USER_id'] == null || $input['HOST_id'] == null || $input['TARGET_id']== null){
	die(generateResponse(status::MISSING_INFO, "USER_id or HOST_id not passed or not TARGET_id to map", $input));
	mysql_close();
}

// Pull the current User's user_privilege from the UserHostMap
$userprivilege = mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' AND HOST_id = '".$input['HOST_id']."' ")
					or die(generateResponse(status::QUERY_FAILED, "USER_id is not mapped to that Host", null));
$userprivilege=mysql_fetch_assoc($userprivilege);
// Check that the User has sufficient user_privilege
if($userprivilege['user_privilege'] <= 10){
	mysql_query("INSERT INTO UserHostMap(USER_id, HOST_id, user_privilege) VALUES('".$input['TARGET_id']."', '".$input['HOST_id']."', '".$input['user_privilege']."')")
		or die(generateResponse(status::QUERY_FAILED, "Could not map new User to Host", null));
	echo generateResponse(status::SUCCESS, "User successfully mapped to Host", $input);
}
else{
	echo generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id can not add new User to Host", null);
}

mysql_close();
?>
