<?php
/* Name: RemoveVote
 * Variables: HOST_id, SONG_id, USER_id, votes
 * Input: Host ID, Song ID, User ID
 * Modification: Updates value of remove_time
 * Output: Success or failure output
 * Description: Takes a HOST_id and SONG_id and then creates a new vote with some of the same add_time as the old vote
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

// Get active_playlist_id for the Host
$PLAYLIST_id = mysql_fetch_assoc(mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."'"));

for($i = intval($input['votes']); $i > 0; $i--){
	// Fill in remove_time and write NULL to SONG_id
	mysql_query("UPDATE Vote SET remove_time = NOW() WHERE HOST_id = '".$input['HOST_id']."' AND SONG_id = '".$input['SONG_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND USER_id = '".$input['USER_id']."' AND remove_time IS NULL LIMIT 1")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not remove vote", null)));
	
	// Get the old votes add_time
	$oldvote = mysql_fetch_assoc(mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND SONG_id = '".$input['SONG_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND USER_id = '".$input['USER_id']."' AND remove_time IS NOT NULL LIMIT 1"))
					or die(print(generateResponse(status::QUERY_FAILED, "Could not fetch the old vote", null)));
	
	// Create a new vote with old add_time
	mysql_query("INSERT INTO Vote(HOST_id, USER_id, add_time) VALUES('".$input['HOST_id']."', '".$input['USER_id']."', '".$oldvote['add_time']."')")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not reinsert the Vote", null)));
	
	echo generateResponse(status::SUCCESS, null, null);
}

mysql_close();
?>