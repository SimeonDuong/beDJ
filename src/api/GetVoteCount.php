<?php
/* Name: GetVoteCount
 * Variables: HOST_id, USER_id
 * Input: Host ID and User ID
 * Modification: NONE
 * Output: HOST_id => val, Votes => val
 * Description: Returns the number of votes that a USER_id has at a HOST_id 
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

$link = mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

// Gets the number of votes for the USER_id at a HOST_id
// $getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL")
// 			or die(print(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null)));
// $votes = mysql_num_rows($getvotes);

if($input['USER_id'] != null && $input['HOST_id'] != null){
	// Find the total number of votes at a Host for a User
	$getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL")
		or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
	$votes = mysql_num_rows($getvotes);
	if($votes == null || $votes == 0){
		$votes = 0;
	}

	// Pull the most recent add_time from the User table for the USER_id
	$addtime = mysql_fetch_assoc(mysql_query("SELECT add_time FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' ORDER BY add_time DESC LIMIT 1"));
	// Calculate the time difference from last allocation and next allocation
	$votetime = strtotime($addtime['add_time']);
	$maxcycles = 6;
	$numvotes = 5;
	
	if(strtotime("+180 seconds", $votetime) < time()){
		$newtime = strtotime("+180 seconds", $votetime);
		$cycles = ceil((time() - $newtime)/180);
		if($cycles > $maxcycles){
			$cycles = $maxcycles;
		}
		$numvotes = 5 * $cycles;
		
		for($i = 0; $i < $numvotes; $i++){
			mysql_query("INSERT INTO Vote(HOST_id, USER_id) VALUES('".$input['HOST_id']."', '".$input['USER_id']."')");
		}

		// Check to make sure the ten votes were added and output SUCCESS or UNEXPECTED
		$checkvotes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND vote_time IS NULL");
		if(!(mysql_num_rows($checkvotes) >= 10)){
			die(generateResponse(status::UNEXPECTED, "Did not allocate votes correctly", null));
		}
		$timeleft = ($votetime + 180) - time();
	}else{
		$timeleft = ($votetime + 180) - time();
	}
	$getvotes = mysql_query("SELECT VOTE_id FROM Vote WHERE HOST_id = '".$input['HOST_id']."' AND USER_id = '".$input['USER_id']."' AND SONG_id IS NULL AND remove_time IS NULL")
		or die(generateResponse(status::QUERY_FAILED, "Could not get the number of votes for User", null));
	$votes = mysql_num_rows($getvotes);
}

// Return the number of votes
if($votes != 0){
	$output = array("HOST_id" => intval($input['HOST_id']), "votes" => $votes, "timeleft" => $timeleft);
	echo generateResponse(status::SUCCESS, null, $output);
}else{
	$output = array("HOST_id" => intval($input['HOST_id']), "votes" => 0, "timeleft" => $timeleft);
	echo generateResponse(status::SUCCESS, null, $output);
}

mysql_close($link);
?>