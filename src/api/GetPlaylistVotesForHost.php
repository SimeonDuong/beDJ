<?php
/* Name: GetPlaylistVotesForHost
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: SONG_id => Vote Count
 * Description: Takes a HOST_id and generates and array that pairs [SONG_id => VoteCount]
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get PLAYLIST_id
$activeplaylist = mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
	or die(print(generateResponse(status::QUERY_FAILED, "activeplaylist query failed", $activeplaylist)));
$PLAYLIST_id = mysql_fetch_assoc($activeplaylist);

// Get SONG_ids
$SONG_id = mysql_query("SELECT DISTINCT SONG_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND play_time IS NULL")
	or die(print(generateResponse(status::QUERY_FAILED, "SONG_id query failed", $SONG_id)));
while($SONG = mysql_fetch_assoc($SONG_id)){
	$SONG_ids[] = $SONG;
}

// Get vote count for each SONG_id
foreach($SONG_ids as $id){
	$votes = mysql_query("SELECT DISTINCT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND SONG_id = '".$id['SONG_id']."' AND remove_time IS NULL AND play_time IS NULL AND vote_time IS NOT NULL");
	// Pair the SONG_id to vote count
	$output[]= array($id['SONG_id'] => mysql_num_rows($votes));
}

if($input['HOST_id'] != null){
// 	if($output == null){
// 		echo generateResponse(status::SUCCESS, null, array(votecount => 0));
// 	}else{
		echo generateResponse(status::SUCCESS, null, $output);
// 	}
}

mysql_close();
?>