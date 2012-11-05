<?php
/* Name: DisconnectHost
 * Variables: HOST_id
 * Input:  Host ID
 * Modification: Host
 * Output: NONE
 * Description: Writes NULL to Host active field and active_playlist_id and writes and finish_time to the currently playing song
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Checks for HOST_id
if($input['HOST_id'] == null){
	die(generateResponse(status::MISSING_INFO, "HOST_id was not passed", null));
	mysql_close();
}

// Update Host to make inactive
mysql_query("UPDATE Host SET active = NULL, active_playlist_id = NULL WHERE HOST_id = '".$input['HOST_id']."'")
	or die(generateResponse(status::QUERY_FAILED, "Could not make inactive", null));

// Update SongPlayMap to end current song
mysql_query("UPDATE SongPlayMap SET finish_time = NOW() WHERE HOST_id = '".$input['HOST_id']."' AND finish_time IS NULL")
	or die(generateResponse(status::QUERY_FAILED, "Could not end the current song.", null));

$activechk = mysql_fetch_assoc(mysql_query("SELECT active FROM Host WHERE HOST_id = '".$input['HOST_id']."'"));
if($activechk['active'] == null){
	echo generateResponse(status::SUCCESS, null, null);
}else{
	echo generateResponse(status::UNEXPECTED, "Something went wrong when trying to make the host active", null);
}


mysql_close();
?>
