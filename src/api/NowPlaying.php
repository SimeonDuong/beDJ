<?php
/* Name: NowPlaying
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: SONG_id
 * Description: Given a HOST_id and return the SONG_id of the currently playing song
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$query = mysql_query("SELECT SONG_id FROM SongPlayMap WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL");
$output = mysql_fetch_assoc($query);

if ($output == false) {
	$output = null;
	echo generateResponse(status::UNEXPECTED, "No song is playing", $output);
	mysql_close();
}

echo generateResponse(status::SUCCESS, null, $output);

mysql_close();
?>