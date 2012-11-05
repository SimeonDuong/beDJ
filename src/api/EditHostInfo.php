<?php
/* Name: EditHostInfo
 * Variables: USER_id, HOST_id, name, description, address, position_x, position_y, host_type
 * Input: User ID, Host ID, Host information
 * Modification: Host
 * Output: SUCCESS or failure
 * Description: Updates the Host table with the new information 
 */

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Get's current User's infromation
$user = mysql_fetch_assoc(mysql_query("SELECT * FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' and HOST_id = '".$input['HOST_id']."' "))
			or die(print(generateResponse(status::QUERY_FAILED, "Could not find the USER_id and HOST_id combination could not be found in the UserHostMap" , null)));

// Update the Host information
if($input['name'] != null && $input['description'] != null && $input['address'] != null && $input['position_x'] != null && $input['position_y'] != null && $input['host_type'] != null ){
	if($user['user_privilege'] < 3){
		mysql_query("UPDATE Host SET name = '".$input['name']."', description = '".$input['description']."', address= '".$input['address']."', position_x = '".$input['position_x']."' , position_y =  '".$input['position_y']."' , host_type = '".$input['host_type']."' WHERE HOST_id = '".$input['HOST_id']."' ")
			or die(print(generateResponse(status::QUERY_FAILED, "Could not update the Host information" , $input)));
		echo generateResponse(status::SUCCESS, "Host info was updated" , $input);
	}else{echo generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to edit host info" , null);}
}else{echo generateResponse(status::INVALID_HOST_INFO, "Part of the Host information was null" , null);}

mysql_close();
?>
