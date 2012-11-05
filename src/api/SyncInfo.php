<?php
/* Name: SyncInfo
 * Variables: HOST_id, PLAYLIST_id, USER_id
 * Input: Host ID, Playlist ID, User ID
 * Modification: Vote
 * Output:
 * 	Case 1: PLAYLIST_id, nowplaying, songs[], uservotes, timeleft 
 * 	Case 2: nowplaying, songs[] (minus song metadata), uservotes, timeleft
 * Description: Takes a HOST_id and PLAYLIST_id and returns the PLAYLIST_id, the currently playing song, songs[] with all song meta data
 * 	and vote count and count for a specific USER_id
 * 	Script also allocates votes based on a timestamp calculation
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

$link = mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);



/*
 * PLAYLIST_id CHECK
 */
// Check the input which case is to be taken
if($input['HOST_id'] == null || $input['USER_id'] == null){
	die(generateResponse(status::MISSING_INFO, "The HOST_id or USER_id is missing", null));
	mysql_close();
}

// Use HOST_id to find PLAYLIST_id and check for remove_time
$PLAYLIST_id = mysql_fetch_assoc(mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL"));



/*
 * DATA GATHERING
 */
// Splits to either Case 1 or Case 2 based on matching PLAYLIST_id and gathers required data
$songs = array();
// CHANGE WAS MADE HERE: All I did was make sure that the song hasn't been played with the part that says "AND play_time IS NULL"
$query = mysql_query("SELECT SONG_id FROM PlaylistSongMap WHERE PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND play_time IS NULL ORDER BY play_time AND add_time");
$i = 0;
while($SONG_id = mysql_fetch_assoc($query)){
	
	if($input['PLAYLIST_id'] != $PLAYLIST_id['active_playlist_id']){
		$songs[] = mysql_fetch_assoc(mysql_query("SELECT SONG_id, name, artist, album, genre, duration FROM Song WHERE SONG_id = '".$SONG_id['SONG_id']."'"));
	}else{
		$songs[] = mysql_fetch_assoc(mysql_query("SELECT SONG_id FROM Song WHERE SONG_id = '".$SONG_id['SONG_id']."'"));
	}
	
	$votes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND SONG_id = '".$SONG_id['SONG_id']."' AND remove_time IS NULL AND play_time IS NULL AND vote_time IS NOT NULL");
	$songs[$i]['votes'] = mysql_num_rows($votes);
	if($input['USER_id'] != null){
		$uservotes = mysql_query("SELECT * FROM Vote WHERE SONG_id = '".$SONG_id['SONG_id']."' AND HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND vote_time IS NOT NULL AND remove_time IS NULL AND play_time IS NULL");
		$songs[$i]['uservotes'] = mysql_num_rows($uservotes);
	}
	$i++;
}



/*
 * SORTING
 */
// Custom comparator function to sort our songvotes array
// @param Object $op1 the first operator
// @param Object $op2 the second operator
function voteComparator($op1, $op2){
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



/*
 * NOW PLAYING
 */
// Get the currently playing song for a playlist
$np = mysql_query("SELECT SONG_id FROM SongPlayMap WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL");
$nowplaying = mysql_fetch_assoc($np);



/*
 * VOTE ALLOCATION
 */
// Check the vote count before returning one more time mother fucker
// $getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL AND vote_time IS NULL")
// 	or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
if($input['USER_id'] != null && $input['HOST_id'] != null){
	// Find the total number of votes at a Host for a User
	$getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL")
	or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
	$uservotecount = mysql_num_rows($getvotes);
	if($uservotecount == null || $uservotecount == 0){
		$uservotecount = 0;
	}

	// Pull the most recent add_time from the User table for the USER_id
	$addtime = mysql_fetch_assoc(mysql_query("SELECT add_time FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' ORDER BY add_time DESC LIMIT 1"));
	// Calculate the time difference from last allocation and next allocation
	$votetime = strtotime($addtime['add_time']);
	$maxcycles = 3;
	$numvotes = 10;

	if(strtotime("+180 seconds", $votetime) < time()){
		$newtime = strtotime("+180 seconds", $votetime);
		$cycles = ceil((time() - $newtime)/180);
		if($cycles > $maxcycles){
			$cycles = $maxcycles;
		}
		$numvotes = 10 * $cycles;

		for($i = 0; $i < $numvotes; $i++){
			mysql_query("INSERT INTO Vote(HOST_id, USER_id) VALUES('".$input['HOST_id']."', '".$input['USER_id']."')");
		}

		// Check to make sure the ten votes were added and output SUCCESS or UNEXPECTED
		$checkvotes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND vote_time IS NULL");
		if(!(mysql_num_rows($checkvotes) >= 10)){
			die(generateResponse(status::UNEXPECTED, "Did not allocate votes correctly", null));
		}
		$timeleft = ($votetime + 180) - time();
	}else{
		$timeleft = ($votetime + 180) - time();
	}
	$getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL")
		or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
	$uservotecount = mysql_num_rows($getvotes);
}else{die(generateResponse(status::MISSING_INFO, "You're missing either a USER_id or HOST_id", null));}



/*
 * OUTPUT
 */
// Return output depending on the input match check
if($input['PLAYLIST_id'] != $PLAYLIST_id['active_playlist_id']){
	$output = array("PLAYLIST_id" => intval($PLAYLIST_id["active_playlist_id"]), "nowplaying" => intval($nowplaying["SONG_id"]), "songs" => $songs, "uservotes" => intval($uservotecount), "timeleft" => intval($timeleft));
	echo generateResponse(status::SUCCESS, null, $output);
}else if($input['PLAYLIST_id'] == $PLAYLIST_id['active_playlist_id']){
	$output = array("nowplaying" => intval($nowplaying["SONG_id"]), "songs" => $songs, "uservotes" => intval($uservotecount), "timeleft" => intval($timeleft));
	echo generateResponse(status::SUCCESS, null, $output);
}else{
	echo generateResponse(status::UNEXPECTED, "Something went wrong with getting the playlist", null);
}

mysql_close($link);
?>