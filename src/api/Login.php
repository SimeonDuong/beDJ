<?php
/* Name: Login
 * Variables: user_name, password
 * Inputs: Username & Password
 * Modificatoin: NONE
 * Outputs: Return success or failure statement
 * Description: Takes a user input username, password and email and creates account and returns a USER_id
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$user = mysql_fetch_assoc(mysql_query("SELECT * FROM User WHERE user_name = '".$input['user_name']."'"))
	or die(print(generateResponse(status::QUERY_FAILED, null, null)));
$pass = strval($user['password']);

if($pass == $input['password'] && $pass != null && $input['password'] != null){
	$USER_id = mysql_fetch_assoc(mysql_query("SELECT USER_id, email FROM User WHERE user_name = '".$input['user_name']."'"))
		or die(print(generateResponse(status::QUERY_FAILED, null, null)));
	echo generateResponse(status::SUCCESS, null, $USER_id);
}
else{
	echo generateResponse(status::INVALID_LOGIN, null, null);
}

mysql_close();
?>