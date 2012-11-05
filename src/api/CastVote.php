<?php
/* Name: CastVote
 * Variables: SONG_id, HOST_id, USER_id, votes
 * Inputs: Song ID, Host ID, User ID
 * Modification: Vote
 * Outputs: VOTE_id
 * Description: Records a passed number of votes for a song (default of one)
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// votes is null then default to 1
if($input['votes'] == null){
	$input['votes'] = 1;
}

// Get PLAYLIST_id
$PLAYLIST_id = mysql_fetch_assoc(mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL"))
	or die(print(generateResponse(status::QUERY_FAILED, "Could not get PLAYLIST_id", null)));

for($i = intval($input['votes']); $i > 0; $i--){	
	// Get VOTE_id
	$VOTE_id = mysql_fetch_assoc(mysql_query("SELECT VOTE_id FROM Vote WHERE USER_id = '".$input['USER_id']."' AND HOST_id = '".$input['HOST_id']."' AND SONG_id IS NULL AND PLAYLIST_id IS NULL AND vote_time IS NULL"))
		or die(print(generateResponse(status::QUERY_FAILED, "Could not find a vote", null)));
	
	// Records vote in the Vote table
	if($VOTE_id != null){
		mysql_query("UPDATE Vote SET vote_time = NOW(), SONG_id = '".$input['SONG_id']."', HOST_id = '".$input['HOST_id']."', PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' WHERE VOTE_id = '".$VOTE_id['VOTE_id']."'")
			or die(print(generateResponse(status::QUERY_FAILED, "Vote was not recorded", null)));
		echo generateResponse(status::SUCCESS, "Vote recorded", intval($VOTE_id));
	}else{die(print(generateResponse(status::UNEXPECTED, "There are not enough votes", null)));}
}

mysql_close();
?>
