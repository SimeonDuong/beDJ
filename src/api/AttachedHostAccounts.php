<?php
/* Name: AttachedHostAccounts
 * Variables: USER_id
 * Input: User ID
 * Modification: NONE
 * Output: HOST_id => user_privilege
 * Description: Returns all the Hosts and and a user_privilege for any give USER_id
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get the HOST_ids for a given USER_id
$HOST_id = mysql_query("SELECT HOST_id FROM UserHostMap WHERE USER_id = '".$input['USER_id']."'");

// Create an array of HOST_ids
while($HOST = mysql_fetch_assoc($HOST_id)){
	$HOST_ids[] = $HOST;
}

// Pair HOST_id => user_privilege and place it in a output array
foreach($HOST_ids as &$id){
	$user_privilege = mysql_query("SELECT user_privilege FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' AND HOST_id = $id and remove_time IS NULL");
	$output[]= array($id => $user_privilege);
}

echo generateResponse(status::SUCCESS, null, $output);

mysql_close();
?>