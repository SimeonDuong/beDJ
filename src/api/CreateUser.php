<?php
/* Name: CreateUser
 * Variables: user_name, password, email (optional)
 * Inputs: Username & Password, Email (optional)
 * Modificatoin: User
 * Outputs: SUCCESS & USER_id
 * Description: Creates a new user account in the User table
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Check to see if the username is already taken
$user_name = mysql_query("SELECT * FROM User WHERE user_name = '".$input['user_name']."'")
	or die(generateResponse(status::QUERY_FAILED, null, null));

// Add user to User if the name is not already taken
if(mysql_num_rows($user_name) > 0){
	die(generateResponse(status::USERNAME_TAKEN, "That username is already taken", null));
}else if($input['user_name'] != null && $input['password'] != null && $input['email'] != null){
	mysql_query("INSERT INTO User(user_name, password, email) VALUES('".$input['user_name']."','".$input['password']."','".$input['email']."')")
		or die(generateResponse(status::QUERY_FAILED, null, null));
	$USER_id = mysql_fetch_assoc(mysql_query("SELECT USER_id FROM User WHERE user_name = '".$input['user_name']."'"));
	echo generateResponse(status::SUCCESS, null, $USER_id);
}else if($input['user_name'] != null && $input['password'] != null){
	mysql_query("INSERT INTO User(user_name, password, email) VALUES('".$input['user_name']."','".$input['password']."', NULL)")
		or die(generateResponse(status::QUERY_FAILED, null, null));
	$USER_id = mysql_fetch_assoc(mysql_query("SELECT USER_id FROM User WHERE user_name = '".$input['user_name']."'"));
	echo generateResponse(status::SUCCESS, null, $USER_id);
}else{
	die(generateResponse(status::UNEXPECTED, "Something went wrong while trying to create the new user", null));
}

mysql_close();
?>