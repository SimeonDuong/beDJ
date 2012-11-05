<?php
/* Name: UserHostConnect
 * Variables: USER_id, HOST_id
 * Inputs: User ID and Host ID
 * Modification: GuestHostMap
 * Outputs: SUCCESS and HOST_id
 * Description: Takes a valid USER_id and HOST_id and adds them to the UserHostMap, making them a guest a Host location
 */ 

include 'database.php';
include 'GenerateResponse.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

$link = mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

if($input['USER_id'] != null && $input['HOST_id'] != null){
	mysql_query("INSERT INTO GuestHostMap(USER_id, guest_level, HOST_id) VALUES('".$input['USER_id']."', 1 ,'".$input['HOST_id']."')")
		or die(print(generateResponse(status::QUERY_FAILED, "Could not map User to Host", null)));
	
	// Pull the most recent add_time from the User table for the USER_id
	$addtime = mysql_fetch_assoc(mysql_query("SELECT add_time FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' ORDER BY add_time DESC LIMIT 1"));
	// Calculate the time difference from last allocation and next allocation
	$votetime = strtotime($addtime['add_time']);
	$maxcycles = 3;
	$numvotes = 10;
	
	if($addtime == null || $addtime == false){
		for($i = 0; $i < 10; $i++){
			mysql_query("INSERT INTO Vote(HOST_id, USER_id) VALUES('".$input['HOST_id']."', '".$input['USER_id']."')");
		}
		
		// Check to make sure the ten votes were added and output SUCCESS or UNEXPECTED
		$checkvotes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND vote_time IS NULL");
		if(!(mysql_num_rows($checkvotes) >= 10)){
			die(generateResponse(status::UNEXPECTED, "Did not allocate votes correctly", null));
		}
	}else{
	
		if(strtotime("+1 day", $votetime) < time()){
			$newtime = strtotime("+1 day", $votetime);
			$cycles = ceil((time() - $newtime)/180);
			if($cycles > $maxcycles){
				$cycles = $maxcycles;
			}
			$numvotes = 10 * $cycles;
		
			for($i = 0; $i < $numvotes; $i++){
				mysql_query("INSERT INTO Vote(HOST_id, USER_id) VALUES('".$input['HOST_id']."', '".$input['USER_id']."')");
			}
		
			// Check to make sure the ten votes were added and output SUCCESS or UNEXPECTED
			$checkvotes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND vote_time IS NULL");
			if(!(mysql_num_rows($checkvotes) >= 10)){
				die(generateResponse(status::UNEXPECTED, "Did not allocate votes correctly", null));
			}
			$timeleft = ($votetime + 86400) - time();
		}else{
			$timeleft = ($votetime + 86400) - time();
		}
	
	}	
	
	$output = array("HOST_id" => $input['HOST_id']);
	echo generateResponse(status::SUCCESS, null, $output);
}else{echo generateResponse(status::MISSING_INFO, null, null);}

mysql_close($link);
?>
