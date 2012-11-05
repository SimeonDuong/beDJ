<?php
/* AddSongs
 * Variables: input,
 * Inputs: Song[] 
 * Modification: Adds songs in Song[] to SongTable, If already exists, returns ID.
 * Outputs: SongId[]
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$inputArray = json_decode(file_get_contents("php://input"), true);
$returnArray = array();
mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

foreach($inputArray as $song)
{
	$name = $song['name'];
	$artist = $song['artist'];
	$album = $song['album'];
	$genre = $song['genre'];
	$duration = $song['duration'];
	
	/* Checks for null inputs and corrects them if acceptable, or throws an error*/
	if($name == null)
	die(generateResponse(status::MISSING_INFO, "SONG/DURATION name must be set" , null));
	if($artist == null)
	$artist=null;
	if($album == null)
	$album=null;
	if($genre == null)
	$genre=unknown;
	
	$check=mysql_query("SELECT * FROM Songs WHERE name=$name AND artist=$artist AND album=$album AND genre=$genre AND duration=$duration") or die(generateResponse(status::QUERY_FAILED, "query failed" , null));
	
	if(mysql_num_rows($check)!=0) /*song already exists return the id*/
	{
		$row=mysql_fetch_array($check);
		$id=$row['SONG_id'];
		array_push($returnArray, $id); 
		
	}
	else /* Song doesn't exist, add it and find the last id added*/
	{
		mysql_query("INSERT INTO Songs (SONG_id, name, artist, album, genre, duration) VALUES(null,$name,$album,$genre,$duration)") or die("Query error");
		$id=mysql_query("LAST_INSERT_ID()");
		array_push($returnArray, $id);
	}
	
	
}
/*Send output*/
$output = json_encode($returnArray);
print(generateResponse(status::SUCCESS, "Songs added" , $output));

mysql_close();
?>
