<?php
/* Name: ChoosePlaylist
 * Variables: PLAYLIST_id, HOST_id
 * Input: PLAYLIST_id,  HOST_id
 * Modification: Host
 * Output: SUCCESS or failure
 * Description: Takes a PLAYLIST_id and sets the active_playlist_id to that PLAYLIST_id
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Check that input is valid
if($input['PLAYLIST_id'] == null || $input['HOST_id'] == null){
	die(print(generateResponse(status::MISSING_INFO, "Either the PLAYLIST_id or HOST_id is null", $input)));
}

// Checks for that the Playlist in the Playlist table
$result = mysql_query("SELECT * FROM Playlist WHERE PLAYLIST_id = '".$input['PLAYLIST_id']."' AND HOST_id = '".$input['HOST_id']."'");

if(mysql_num_rows($result) != 0){
	 mysql_query("UPDATE Host SET active_playlist_id = '".$input['PLAYLIST_id']."' WHERE HOST_id = '".$input['HOST_id']."'");
}else{
	die(print(generateResponse(status::UNEXPECTED, "There was not a playlist that matched", null)));
}

echo generateResponse(status::SUCCESS, "Changed active_playlist_id to the passed in PLAYLIST_id", null);

mysql_close();
?>
