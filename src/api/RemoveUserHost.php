<?php
//add remove time to user host map
include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$user = mysql_query("SELECT * FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' and HOST_id = '".$input['HOST_id']."' ")
or print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching UserHostMap table" , null));
$a = mysql_fetch_assoc($user);

if($a[user_priviledge]==1){
	mysql_query("DELETE FROM UserHostMap WHERE USER_id ='".$input['TARGET_id']."' and HOST_id ='".$input['HOST_id']."' ")
	or print(generateResponse(status::QUERY_FAILED, "DELETE failed invalid target_id most likely" , null));;
	print(generateResponse(status::SUCCESS, "user has been removed from host" , null));
}
else{
	print(generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to remove a user from a host" , null));
}


echo json_encode($output);
mysql_close();
?>
