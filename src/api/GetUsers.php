<?php
/* Name: GetUsers
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: USER_ids[]
 * Description: Pulls all the User information at a Host 
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get User IDs from the UserHostMap
$users = mysql_query("SELECT USER_id FROM UserHostMap WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
			or die(print(generateResponse(status::QUERY_FAILED, "Could not get USER_ids", null)));

$USER_ids = array();

while($user = mysql_fetch_assoc($users)){
	if(!in_array($user['USER_id'], $userarr)){
		array_push($USER_ids, $user['USER_id']);
	}
}

$output = array();

// Gather all the Users data from the User table
foreach($USER_ids as $id){
	$userinfo = mysql_fetch_assoc(mysql_query("SELECT * FROM User WHERE USER_id = '".$id['USER_id']."'"))
					or die(print(generateResponse(status::QUERY_FAILED, "Could not get User information", null)));
	array_push($output, $userinfo);
}

if($output != null){
	echo generateResponse(status::SUCCESS, "All Users information", $output);
}else{echo generateResponse(status::UNEXPECTED, "There were not Users", null);}

mysql_close();
?>