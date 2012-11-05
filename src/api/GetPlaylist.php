<?php
/* Name: GetPlaylist
 * Variables: HOST_id, PLAYLIST_id
 * Input: Host ID and Playlist ID
 * Modification: NONE
 * Output: PLAYLIST_id, nowplaying, songs[]
 * Description: Takes a HOST_id and PLAYLIST_id and returns the PLAYLIST_id, the currently playing song, songs[] with all song meta data
 * and vote count and (OPTIONAL) count for a specific user
 * 	Case 1: All ouputs
 * 	Case 2: !songs[]
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Check the input which case is to be taken
if($input['HOST_id'] == null){
	die(print(generateResponse(status::MISSING_INFO, "The HOST_id is null", null)));
	mysql_close();
}

// Use HOST_id to find PLAYLIST_id and check for remove_time
$PLAYLIST_id = mysql_fetch_assoc(mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL"));


if($input['PLAYLIST_id'] != $PLAYLIST_id['active_playlist_id']){
	// Gather Songs data based on PLAYLIST_id and PlaylistUserMap
	$songs = array();
	$query = mysql_query("SELECT SONG_id FROM PlaylistSongMap WHERE PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND play_time IS NULL ORDER BY play_time and add_time");
	$i = 0;
	while($SONG_id = mysql_fetch_assoc($query)){
		$songs[] = mysql_fetch_assoc(mysql_query("SELECT SONG_id, name, artist, album, genre, duration FROM Song WHERE SONG_id = '".$SONG_id['SONG_id']."'"));
		$votes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND SONG_id = '".$SONG_id['SONG_id']."' AND remove_time IS NULL AND play_time IS NULL AND vote_time IS NOT NULL");
		$songs[$i]['votes'] = mysql_num_rows($votes);
		if($input['USER_id'] != null){
			$uservotes = mysql_query("SELECT * FROM Vote WHERE SONG_id = '".$SONG_id['SONG_id']."' AND HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND vote_time IS NOT NULL AND remove_time IS NULL AND play_time IS NULL");
			$songs[$i]['uservotes'] = mysql_num_rows($uservotes);
		}
		$i++;
	}
}else{
	$songs = array();
	$query = mysql_query("SELECT SONG_id FROM PlaylistSongMap WHERE PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND play_time IS NULL ORDER BY play_time and add_time");
	$i = 0;
	while($SONG_id = mysql_fetch_assoc($query)){
		$songs[] = mysql_fetch_assoc(mysql_query("SELECT SONG_id FROM Song WHERE SONG_id = '".$SONG_id['SONG_id']."'"));
		$votes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND SONG_id = '".$SONG_id['SONG_id']."' AND remove_time IS NULL AND play_time IS NULL AND vote_time IS NOT NULL");
		$songs[$i]['votes'] = mysql_num_rows($votes);
		if($input['USER_id'] != null){
			$uservotes = mysql_query("SELECT * FROM Vote WHERE SONG_id = '".$SONG_id['SONG_id']."' AND HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND vote_time IS NOT NULL AND remove_time IS NULL AND play_time IS NULL");
			$songs[$i]['uservotes'] = mysql_num_rows($uservotes);
		}
		$i++;
	}
}

/**
 * this guy is a custom comparator function to sort our songvotes array
 * @param Object $op1 the first operator
 * @param Object $op2 the second operator
 */
function voteComparator($op1, $op2)
{
	return $op2['votes'] - $op1['votes'];
}

// Sort the array by votes
usort($songs, voteComparator);

// Check if all votes are zero
// $allzero = false;
// foreach($songs as $song){
// 	if($song['votes'] == 0){
// 		$allzero = true;
// 	}else{
// 		$allzero = false;
// 		break;
// 	}
// }

// Shuffle the order if all votes are at zero
// if($allzero == true){
// 	shuffle($songs);
// }


// Get the currently playing song for a playlist
$np = mysql_query("SELECT SONG_id FROM SongPlayMap WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL");
$nowplaying = mysql_fetch_assoc($np);


// Return output depending on the input match check
if($input['PLAYLIST_id'] != $PLAYLIST_id['active_playlist_id']){
	$output = array("PLAYLIST_id" => intval($PLAYLIST_id["active_playlist_id"]), "nowplaying" => intval($nowplaying["SONG_id"]), "songs" => $songs);
	echo generateResponse(status::SUCCESS, null, $output);
}else if($input['PLAYLIST_id'] == $PLAYLIST_id['active_playlist_id']){
	$output = array("nowplaying" => intval($nowplaying["SONG_id"]), "songs" => $songs);
	echo generateResponse(status::SUCCESS, null, $output);
}else{
	echo generateResponse(status::UNEXPECTED, "Something went wrong with getting the playlist", null);
}

mysql_close();
?>
