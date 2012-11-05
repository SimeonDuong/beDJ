<?php
/* Name: GetGuests
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: USER_ids[]
 * Description: Pulls all the User information at a Host about Guests 
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get User IDs from the UserHostMap
$users = mysql_query("SELECT DISTINCT USER_id FROM GuestHostMap WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
			or die(generateResponse(status::QUERY_FAILED, "Could not get USER_ids", null));

$USER_ids = array();

while($user = mysql_fetch_assoc($users)){
	array_push($USER_ids, $user['USER_id']);
// 	if(!in_array($user['USER_id'], $USER_ids)){
// 		array_push($USER_ids, $user['USER_id']);
// 	}
}

$output = array();

// Gather all the Users data from the User table
$i = 0;
foreach($USER_ids as $id){
	$userinfo = mysql_fetch_assoc(mysql_query("SELECT * FROM User WHERE USER_id = '".$id."'"))
					or die(generateResponse(status::QUERY_FAILED, "Could not get User information", null));
	$getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$id."' AND SONG_id IS NULL AND remove_time IS NULL")
					or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
	$votes = mysql_num_rows($getvotes);
	
	array_push($output, $userinfo);
	$output[$i]['uservotes'] = intval($votes);
	$i++;
}

if($output != null){
	echo generateResponse(status::SUCCESS, "All Users information", $output);
}else{echo generateResponse(status::UNEXPECTED, "There were not Users", null);}

mysql_close();
?>