<?php
/* LastPlayed
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: SONG_id 
 */

include 'database.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass) or die("Login Error");
mysql_select_db(questir5_beDJ);

// Get SONG_id
$SONG_id = mysql_fetch_assoc(mysql_query("SELECT SONG_id FROM Play WHERE HOST_id = '".$input['HOST_id']."' AND finish_time = '0000-00-00 00:00:00' "));

// JSON encode a value pair SONG_id to int
$output = array("SONG_id" => $SONG_id);
echo json_encode($output);

mysql_close();
?>