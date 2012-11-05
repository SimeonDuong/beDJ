<?php
/* Name: CreatePlaylist
 * Variables: HOST_id, name, description, songs[]
 * Input: HOST_id, playlist name and description, and and array of song information
 * Modification: Creates new playlist row in the Playlist table and uploads song meta data
 * Output: PLAYLIST_id, SONG_ids[]
 * Description: Creates a playlist by having a valid name description and HOST_id and sends back a PLAYLIST_id and uploads the
 * song data from a passed in song[] and sends back SONG_ids[]
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);
mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$expression = "'";
$insertvalue = "\'";

$input['name'] 			= str_replace($expression, $insertvalue, $input['name']);
$input['description'] 	= str_replace($expression, $insertvalue, $input['description']);

// Make sure no input is null passed from the script
if($input['name'] == null || $input['description'] == null || $input['HOST_id'] == null || $input['songs'] == null){
	die(print(generateResponse(status::MISSING_INFO, null, null)));
	mysql_close();
}

// Adds Playlist after checking for HOST_id and name collisions
// $playlist = mysql_query("SELECT * FROM Playlist WHERE HOST_id = '".$input['HOST_id']."' AND name = '".$input['name']."' AND remove_time IS NULL")
// 				or die(print(generateResponse(status::QUERY_FAILED, "Falied on checking for PLAYLIST_id", null)));

// if(mysql_num_rows($playlist) == 0){
	mysql_query("INSERT INTO Playlist(name, description, HOST_id) VALUES('".$input['name']."', '".$input['description']."', '".$input['HOST_id']."')")
		or die(print(generateResponse(status::QUERY_FAILED, "Playlist insert failed", null)));
// }

// Get PLAYLIST_id
$PLAYLIST_id = mysql_fetch_assoc(mysql_query("SELECT PLAYLIST_id FROM Playlist WHERE HOST_id = '".$input['HOST_id']."' AND name = '".$input['name']."' AND remove_time IS NULL ORDER BY add_time DESC"));

// Takes the songs[] and adds it to the Song table in the database
$songs = $input['songs'];
$SONG_ids = array();

foreach($songs as $song){
	// Get information about each song from the songs[]
	$name 		= str_replace($expression, $insertvalue, $song['name']);
	$artist		= str_replace($expression, $insertvalue, $song['artist']);
	$album 		= str_replace($expression, $insertvalue, $song['album']);
	$genre 		= str_replace($expression, $insertvalue, $song['genre']);
	$duration 	= str_replace($expression, $insertvalue, $song['duration']);

	// Checks for null inputs and corrects them if acceptable, or throws an error
	if($name == null)	{
		$name = "Unknown";
// 		die(generateResponse(status::MISSING_INFO, "song duration and name must be set" , null));
	}
	if($artist == null)	{
		$artist = "Unknown";
	}
	if($album == null)	{
		$album = "Unknown";
	}
	if($genre == null)	{
		$genre = "Unknown";
	}

	$check = mysql_query("SELECT SONG_id FROM Song WHERE name = '".$name."' AND artist = '".$artist."' AND album = '".$album."' AND genre = '".$genre."' AND duration = '".$duration."'")
		or die(generateResponse(status::QUERY_FAILED, "Check for song messed up" , null));
	
	$getsong = mysql_fetch_assoc($check);
	$mapsong = "INSERT INTO PlaylistSongMap(PLAYLIST_ID, SONG_id) VALUES('".$PLAYLIST_id['PLAYLIST_id']."', '".$getsong['SONG_id']."')";
	
	// Song already exists return the SONG_id
	if(mysql_num_rows($check) != 0){
		array_push($SONG_ids, intval($getsong['SONG_id']));
		mysql_query($mapsong)
			or die(print(generateResponse(status::QUERY_FAILED, "Could not map song.", null)));
	}else{
		// Song doesn't exist, add it and pull it's SONG_id
		mysql_query("INSERT INTO Song(name, artist, album, genre, duration) VALUES('".$name."', '".$artist."', '".$album."', '".$genre."', '".$duration."')")
			or die(print(generateResponse(status::QUERY_FAILED, "Insert of song failed", null)));
		$SONG_id = mysql_query("SELECT SONG_id FROM Song WHERE name = '".$name."' AND artist = '".$artist."' AND album = '".$album."' AND genre = '".$genre."' AND duration = '".$duration."'");
		$getsong = mysql_fetch_assoc($SONG_id);
		array_push($SONG_ids, intval($getsong['SONG_id']));
		$mapsong = "INSERT INTO PlaylistSongMap(PLAYLIST_ID, SONG_id) VALUES('".$PLAYLIST_id['PLAYLIST_id']."', '".$getsong['SONG_id']."')";
		mysql_query($mapsong)
			or die(print(generateResponse(status::QUERY_FAILED, "Could not map song.", null)));
	}
}

// Establish active_playlist_id in the Host table
mysql_query("UPDATE Host SET active_playlist_id = '".$PLAYLIST_id['PLAYLIST_id']."' WHERE HOST_id = '".$input['HOST_id']."'");


// Output
// Establish final output
$output = array("PLAYLIST_id" => intval($PLAYLIST_id['PLAYLIST_id']), "SONG_ids"=> $SONG_ids);
echo generateResponse(status::SUCCESS, null, $output);

mysql_close();
?>