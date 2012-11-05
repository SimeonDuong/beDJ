<?php
/* Name: GetAllHostNamesForUser
 * Variables: USER_id
 * Input: User ID
 * Modification: NONE
 * Output: HOST_id => VotesCount
 * Description: Takes a USER_id and returns the number of votes they have for each location
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Query for the HOST_id
$HOST_id = mysql_query("SELECT HOST_id FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' AND remove_time IS NULL")
	or die(print(generateResponse(status::QUERY_FAILED, "The was no HOST_ids for that USER_id in the UserHostMap" , null)));
 
while($HOST = mysql_fetch_assoc($HOST_id)){
	$HOSTS[]= $HOST['HOST_id'];
}

$output = array();

foreach($HOSTS as $id){
	$name = mysql_query("SELECT * FROM Host WHERE HOST_id = '".$id."'")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not get the Host name" , null)));
	$name = mysql_fetch_assoc($name);
	if($name[remove_time]== NULL && $name != NULL )
	{
		array_push($output, array("HOST_id" => intval($id), "name" => $name['name'],  "description"=> $name['description'],  "address"=> $name['address'],  "position_x"=> $name['position_x'],  "position_y"=> $name['position_y'],  "host_type"=> $name['host_type']));
	}
}

echo generateResponse(status::SUCCESS, "You now have all of the Hosts" , $output);

mysql_close();
?>