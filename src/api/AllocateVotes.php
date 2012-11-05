<?php
/* Name: AllocateVotes
 * Variables: HOST_id, USER_id
 * Input: Host ID and User ID
 * Modification: Adds 10 votes to the Vote table
 * Output: Returns SUCCESS or FAILURE
 * Description: Adds 10 votes to the Vote table when a HOST_id and USER_id is passesd
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Check input for the caller
if($input['HOST_id'] == null || $input['USER_id'] == null){
	die(print(generateResponse(status::MISSING_INFO, null, null)));
	mysql_close();
}

// if($input['USER_id'] == 1 || $input['USER_id'] == 2 || $input['USER_id'] == 3 || $input['USER_id'] == 4 || $input['USER_id'] == 5){
	// Allocate 10 votes
	for($i = 0; $i < 5; $i++){
		mysql_query("INSERT INTO Vote(HOST_id, USER_id) VALUES('".$input['HOST_id']."', '".$input['USER_id']."')");
	}
	
	// Check to make sure the five votes were added and output SUCCESS or UNEXPECTED
	$checkvotes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND vote_time IS NULL");
	if(mysql_num_rows($checkvotes) >= 5){
		echo generateResponse(status::SUCCESS, "5 or more unused votes allocated", null);
	}else{
		die(print(generateResponse(status::UNEXPECTED, "There are not 5 or more unused votes", null)));
	}
// }else{die(print(generateResponse(status::USER_PRIVILEGE_ERROR, "This user does not have privilege to allocate votes", null)));}

mysql_close();
?>