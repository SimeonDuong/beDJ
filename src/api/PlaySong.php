<?php
/* Name: PlaySong
 * Variables: HOST_id, SONG_id, PLAYLIST_id
 * Input: Host ID, Song ID, Playlist ID
 * Modificatoin: play_time = NOW()
 * Output: Returns success or failure
 * Description: Takes a updates the play_time for a specific SONG_id in the Vote table
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass) or die("Login Error");
mysql_select_db(questir5_beDJ);

mysql_query("UPDATE Vote SET play_time=NOW() WHERE HOST_id = '".$input['HOST_id']."' AND SONG_id = '".$input['SONG_id']."' AND PLAYLIST_id = '".$input['PLAYLIST_id']."'")
	or die(print(generateResponse(status::QUERY_FAILED, null, null)));

echo generateResponse(status::SUCCESS, null, null);

mysql_close();
?>