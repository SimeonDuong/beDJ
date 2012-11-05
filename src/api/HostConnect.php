<?php
/* Name: HostConnect
 * Variables: HOST_id
 * Input:  Host ID
 * Modification: Host
 * Output: NONE
 * Description: Writes 1 to Host active field
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

// Updates the Host to make it inactive
mysql_query("UPDATE Host SET active = 1 WHERE HOST_id = '".$input['HOST_id']."'")
	or die(generateResponse(status::QUERY_FAILED, "Could not make inactive", null));

echo generateResponse(status::SUCCESS, null, null);

mysql_close();
?>