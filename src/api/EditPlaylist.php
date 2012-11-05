<?php
/* EditPlaylist
 * Variables: input,
 * Inputs: SongID[], HostID, OldPlaylistID,
 * Modification: Adds SongIDs to new playlist, sets owner to HostID, updates removeTime on old playlist
 * Outputs: PlaylistID (new)
 */

include 'database.php';
include 'beDJ_config.php';



mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

$inputArray = json_decode(file_get_contents("php://input"), true);
$returnArray = array();

$OldPlaylistID=$inputArray['OLDPLAYLIST_id'];
$HOST_id=$inputArray['HOST_id'];
$IDarray= $inputArray['SongIds'];

$OldPlaylist=mysql_fetch_assoc(mysql_query("SELECT * FROM Playlist WHERE PLAYLIST_id=$OldPlaylistID")) or die("error");
$name=$OldPlaylist['name'];
$description=$OldPlaylist['description'];

mysql_query("UPDATE Playlist SET remove_time=NOW() WHERE PLAYLIST_id=$OldPlaylistID");
mysql_query("INSERT INTO Playlist(PLAYLIST_id,name,description,HOST_id,add_time,remove_time) VALUES(null,$name,$description,$HOST_id,NOW(),'0000-00-00 00:00:00')");
$NEW_id=mysql_query("LAST_INSERT_ID()");

foreach($IDarray as $SONG_id)
{
	mysql_query("INSERT INTO PlaylistSongMap(PLAYLIST_id,SONG_id,add_time,remove_time) VALUES($NEW_id,$SONG_id,NOW(),'0000-00-00 00:00:00')");	
}

echo json_encode($NEW_id);
mysql_close();
?>
