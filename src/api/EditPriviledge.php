<?php

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$user = mysql_query("SELECT * FROM UserHostMap WHERE USER_id = '".$input['USER_id']."' and HOST_id = '".$input['HOST_id']."' ")
or print(generateResponse(status::QUERY_FAILED, "invalid USER_id or HOST_id when searching UserHostMap table" , null));;
$a = mysql_fetch_assoc($user);
if($a[user_priviledge]==1){
	mysql_query("UPDATE UserHostMap SET privilege = '".$input['user_privilege']."' WHERE USER_id ='".$input['TARGET_id']."' and HOST_id ='".$input['HOST_id']."' ")
	or print(generateResponse(status::QUERY_FAILED, "most likely invalid TARGET_id" , null));
	print(generateResponse(status::SUCCESS, "user added to host" , null));
}
else{
	print(generateResponse(status::USER_PRIVILEGE_ERROR, "USER_id does not have the privilege to edit user privilege" , null));
}
mysql_close();
?>