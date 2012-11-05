<?php
/* Name: GetUserVotesForAllHosts
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

$HOST_id = mysql_query("SELECT DISTINCT HOST_id FROM Vote WHERE USER_id = '".$input['USER_id']."' and SONG_id is NULL")
	or die(print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching Vote table" , null)));

// Getting all the HOST_ids
while($HOST = mysql_fetch_assoc($HOST_id)){
	$HOSTS[] = $HOST;
}

// Form the output array of HOST_id => votes
foreach($HOSTS as $id){
	$votes = mysql_query("SELECT * FROM Vote WHERE USER_id = '".$input['USER_id']."' AND SONG_id is NULL AND HOST_id = '".$id['HOST_id']."' AND vote_time IS NULL AND remove_time IS NULL");
	$output[$id['HOST_id']] = mysql_num_rows($votes);
}

if($input['USER_id'] != null){
	echo generateResponse(status::SUCCESS, null, $output);
}

mysql_close();
?>