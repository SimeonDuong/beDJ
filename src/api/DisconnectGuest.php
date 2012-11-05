<?php
/* DisconnectGuest
 * Variables: HOST_id, USER_id
 * Input: Host ID, User ID
 * Modification: Updates the remove_time for a Host and User combination
 * Output: Success or failure output
 */

include 'database.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass) or die("Login Error");
mysql_select_db(questir5_beDJ);

mysql_query("UPDATE GuestHostMap SET remove_time = NOW() WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."'")
	or die("Remove Error");

print("Success");

mysql_close();
?>