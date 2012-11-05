<?php
/* RemoveSongPlaylist
 * Variables: PLAYLIST_id, SongID[]
 * Input: PLAYLIST_id, SongID[]
 * Modification: Removes song(s) from the target playlist
 * 
 */

include 'database.php';
include 'beDJ_config.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass) or die("Login Error");
mysql_select_db(questir5_beDJ);


if($input['PLAYLIST_id']==null || $input['name']==null || $input['description']==null || $input['HOST_id']==null)
{
die("Null args found");
}

/* Adds Playlist after checking for Host_id,name collisions*/
$result = mysql_query(" SELECT * FROM Playlist where HOST_id = '".$input['HOST_id']."' AND name = '".$input['name']."'");

if(mysql_num_rows($result)==0){
	 mysql_query(" INSERT INTO Playlist (PLAYLIST_id,name,description,HOST_id) VALUES ('".$input['PLAYLIST_id']."','".$input['name']."','".$input['description']."','".$input['PLAYLIST_id']."')");
}
else{
	die("This song does not exist in this playlist");
}

print("0");


mysql_close();
?>
