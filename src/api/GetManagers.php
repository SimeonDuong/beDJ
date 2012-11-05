<?php
/* Name: GetManagers
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
$users = mysql_query("SELECT DISTINCT USER_id FROM UserHostMap WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
			or die(generateResponse(status::QUERY_FAILED, "Could not get USER_ids", null));

$USER_ids = array();

while($user = mysql_fetch_assoc($users)){
	array_push($USER_ids, $user['USER_id']);
}

$output = array();

// Gather all the Users data from the User table
$i = 0;
foreach($USER_ids as $id){
	$userinfo = mysql_fetch_assoc(mysql_query("SELECT USER_id, user_name FROM User WHERE USER_id = '".$id."'"))
					or die(generateResponse(status::QUERY_FAILED, "Could not get User information", null));
	$userprivilege = mysql_fetch_assoc(mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$id."' AND HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL"))
					or die(generateResponse(status::QUERY_FAILED, "Could not get privilege", null));
	array_push($output, $userinfo);
	$output[$i]['user_privilege'] = intval($userprivilege['user_privilege']);
	$i++;
}

if($output != null){
	echo generateResponse(status::SUCCESS, "All Users information", $output);
}else{echo generateResponse(status::UNEXPECTED, "There were not Users", null);}

mysql_close();
?>