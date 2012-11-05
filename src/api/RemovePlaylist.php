<?php
/* Name: RemovePlaylist
 * Variables: PLAYLIST_id, HOST_id
 * Input: PLAYLIST_id,  HOST_id
 * Modification: Playlist
 * Output: SUCCESS or failure
 * Description: Rights a remove time to the Playlist
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

if($input['PLAYLIST_id'] == null || $input['HOST_id'] == null){
	die(print(generateResponse(status::MISSING_INFO, "There is a missing PLAYLIST_id or HOST_id", null)));
}

/* Checks for existing playlist*/
$result = mysql_query("SELECT * FROM Playlist WHERE PLAYLIST_id = '".$input['PLAYLIST_id']."' AND HOST_id = '".$input['HOST_id']."' LIMIT 1");

if(mysql_num_rows($result) != 0){
	 mysql_query("UPDATE Playlist SET remove_time = NOW() WHERE PLAYLIST_id = '".$input['PLAYLIST_id']."' AND HOST_id = '".$input['HOST_id']."'");
	 echo generateResponse(status::SUCCESS, "Playlist removed", null);
}else{echo generateResponse(status::UNEXPECTED, "There was no playlist to remove", null);}

mysql_close();
?>
