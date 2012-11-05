<?php
/* Name: GetUserID
 * Variables: user_name
 * Input: Username
 * Modification: NONE
 * Output: USER_id
 * Description: Returns the USER_id for a sepcific user_name
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);


// Checks that a username was input
if($input['user_name'] == null){
	die(generateResponse(status::MISSING_INFO, "Username was not given", null));
	mysql_close();
}

// Gets the USER_id for the user_name that was input
$output = mysql_fetch_assoc(mysql_query("SELECT USER_id FROM User WHERE user_name = '".$input['user_name']."'"))
	or die(generateResponse(status::QUERY_FAILED, "Could not find the username given", null));

// Pass back the output
if($output != null){
	echo generateResponse(status::SUCCESS, null, $output);
}else{
	echo generateResponse(status::UNEXPECTED, "Something went wrong with the output", $output);
}

mysql_close();
?>