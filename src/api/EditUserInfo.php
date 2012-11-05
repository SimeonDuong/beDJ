<?php
/* Name: EditUserInfo
 * Variables: USER_id, password, email
 * Input: User ID, new password and email
 * Modification: User
 * Output: SUCCESS or failure
 * Description: Updates a specific User's information in the User table
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get User information
$user = mysql_fetch_assoc(mysql_query("SELECT * FROM User WHERE USER_id = '".$input['USER_id']."'"))
			or die(print(generateResponse(status::QUERY_FAILED, "This is not a User", null)));

// Update the User information
if($input['password'] != null && $input['email'] != null ){
	if($user['password'] == $input['password']){
		mysql_query("UPDATE User SET password = '".$input['newpassword']."', email = '".$input['email']."' WHERE USER_id = '".$input['USER_id']."'")
			or die(print(generateResponse(status::QUERY_FAILED, "Could not set new password and email to USER_id" , null)));
		echo generateResponse(status::SUCCESS, "Update User information" , $input);
	}else{echo generateResponse(status::INVALID_USER_INFO, "Password did not match" , null);}
}else{echo generateResponse(status::MISSING_INFO, "User information was left null" , null);}

mysql_close();
?>