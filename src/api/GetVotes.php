<?php
/* GetVotes
 * Variables: HOST_id
 * Input: Host ID
 * Modification: NONE
 * Output: SONG_id paired with number of votes 
 */

include 'database.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass) or die("Login Error");
mysql_select_db(questir5_beDJ);

// Get number of votes
$votes = mysql_num_rows(mysql_query("SELECT VOTE_id, SONG_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND remove_time = '0000-00-00 00:00:00'"));

// Get list of SONG_ids
$ouput = mysql_fetch_array(mysql_query("SELECT VOTE_id, SONG_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND remove_time = '0000-00-00 00:00:00'"));

echo json_encode($output);

mysql_close();
?>