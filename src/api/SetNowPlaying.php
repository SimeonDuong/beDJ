<?php
/* Name: SetNowPlaying
 * Variables: HOST_id, SONG_id
 * Input: Host ID, Song ID
 * Modification: Writes values to SongPlayMap
 * Output: Success or Failure
 * Description: Takes a HOST_id and SONG_id and writes the currently playing song tot he SongPlayMap
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

if($input['HOST_id'] != null && $input['SONG_id'] != null){
	// Get PLAYLIST_id
	$activeplaylist = mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
		or die(generateResponse(status::QUERY_FAILED, "activeplaylist query failed", $activeplaylist));
	$PLAYLIST_id = mysql_fetch_assoc($activeplaylist);
	
	// Write the finish_time to the last song that was playing
	$stopsong = mysql_fetch_assoc(mysql_query("SELECT * FROM SongPlayMap WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL ORDER BY start_time DESC"));
	if($stopsong != null){
		mysql_query("UPDATE SongPlayMap SET finish_time = NOW() WHERE SONG_id = '".$stopsong['SONG_id']."' AND HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$stopsong['PLAYLIST_id']."' AND finish_time IS NULL LIMIT 1");
	}
	
	
	if($PLAYLIST_id != null){
		// Update that SongPlayMap
		mysql_query("INSERT INTO SongPlayMap(SONG_id, HOST_id, PLAYLIST_id) VALUES('".$input['SONG_id']."', '".$input['HOST_id']."', '".$PLAYLIST_id['active_playlist_id']."')")
			or die(generateResponse(status::QUERY_FAILED, "Song is not playing", null));
		mysql_query("UPDATE Vote SET play_time = NOW() WHERE HOST_id = '".$input['HOST_id']."' AND SONG_id = '".$input['SONG_id']."' AND play_time IS NULL AND remove_time IS NULL")
			or die(generateResponse(status::QUERY_FAILED, "Could not update the play_time in the Vote table", null));
		
		// Update the PlaylistSongMap
		mysql_query("UPDATE PlaylistSongMap Set play_time = NOW() WHERE PLAYLIST_id = '".$PLAYLIST_id['active_playlist_id']."' AND SONG_id = '".$input['SONG_id']."'")
			or die(generateResponse(status::QUERY_FAILED, "Could not update the PlaylistSongMap", null));
		
		echo generateResponse(status::SUCCESS, "Song is now playing", null);
	}else{echo generateResponse(status::MISSING_INFO, "There was no active playlist id in the host table", null);}
	
}else if($input['HOST_id'] != null && $input['SONG_id'] == null){
	// Get PLAYLIST_id
	$activeplaylist = mysql_query("SELECT active_playlist_id FROM Host WHERE HOST_id = '".$input['HOST_id']."' AND remove_time IS NULL")
		or die(generateResponse(status::QUERY_FAILED, "activeplaylist query failed", $activeplaylist));
	$PLAYLIST_id = mysql_fetch_assoc($activeplaylist);
	
	// Write the finish_time to the last song that was playing
	$stopsong = mysql_fetch_assoc(mysql_query("SELECT * FROM SongPlayMap WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL ORDER BY start_time DESC"));
	if($stopsong != null){
		mysql_query("UPDATE SongPlayMap SET finish_time = NOW() WHERE SONG_id = '".$stopsong['SONG_id']."' AND HOST_id = '".$input['HOST_id']."' AND PLAYLIST_id = '".$stopsong['PLAYLIST_id']."' AND finish_time IS NULL LIMIT 1");
	}
	
	echo generateResponse(status::SUCCESS, "Song has been stopped", null);
}else{echo generateResponse(status::MISSING_INFO, "HOST_id or SONG_id do not match an input case", null);}

mysql_close();
?>