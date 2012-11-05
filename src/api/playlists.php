<html>
<head>
<title>beDJ || active playlists</title>
<meta http-equiv="refresh" content="5">
<style type="text/css">
  body {
    font-family: Helvetica, Arial,
          Times, serif;
    color: #13A8B4 ;
    background-color: black }
  h1 {
    font-family: Helvetica, Geneva, Arial,
          SunSans-Regular, sans-serif }
  </style>
</head>
</html>



<?php
/* Name: displayactivehostsplaylists
 * Variables: NONE
 * Input: NONE
 * Modification: NONE
 * Output: Displays the playlist for all Hosts
 */

include 'database.php';
include 'beDJ_config.php';
include 'GenerateResponse.php';

$input = json_decode(file_get_contents("php://input"), true);

mysql_connect(localhost, $mysql_username, $mysql_userpass);
mysql_select_db(questir5_beDJ);

/*
* this guy is a custom comparator function to sort our songvotes array
* @param Object $op1 the first operator
* @param Object $op2 the second operator
*/
function voteComparator($op1, $op2)
{
	return $op2['votes'] - $op1['votes'];
}




// Get all of the active HOST_ids
$active = 1;		// Need to define int code for active
$hostquery = mysql_query("SELECT * FROM Host WHERE active = $active");

while($HOST_id = mysql_fetch_assoc($hostquery)){
	$HOST_ids[] = $HOST_id;
}

$printbreak = 0;

// For each HOST_id pull the PLAYLIST_id and then pull the Playlist informatoin
foreach($HOST_ids as $id){
	$playlistid = mysql_fetch_assoc(mysql_query("SELECT active_playlist_id, name FROM Host WHERE HOST_id = '".$id['HOST_id']."' AND active_playlist_id IS NOT NULL"));
	// Pair the SONG_id to vote count
	$playlistids[$id['HOST_id']] = $playlistid['active_playlist_id'];
	$songs = array();
	$songquery = mysql_query("SELECT SONG_id FROM PlaylistSongMap WHERE PLAYLIST_id = '".$playlistid['active_playlist_id']."'");
	$npid = mysql_fetch_assoc(mysql_query("SELECT SONG_id FROM SongPlayMap WHERE HOST_id = '".$id['HOST_id']."' AND finish_time IS NULL"));
	$nowplaying = mysql_fetch_assoc(mysql_query("SELECT name, artist FROM Song WHERE SONG_id = '".$npid['SONG_id']."'"));
	$i = 0;
	
	// Print Playlist Name
	if($printbreak != 0){
		echo "<br><br>";
	}else{$printbreak++;}
	
	echo "<b>", $playlistid['name'], "</b>";
	echo "<br>";
	echo "Now Playing: ", $nowplaying['name'], " by ", $nowplaying['artist'];
	echo "<br>";
	
	while($SONG_id = mysql_fetch_assoc($songquery)){
		$songs[] = mysql_fetch_assoc(mysql_query("SELECT SONG_id, name, artist, album, genre, duration FROM Song WHERE SONG_id = '".$SONG_id['SONG_id']."'"));
		$votes = mysql_query("SELECT * FROM Vote WHERE HOST_id = '".$id['HOST_id']."' AND PLAYLIST_id = '".$playlistid['active_playlist_id']."' AND SONG_id = '".$SONG_id['SONG_id']."' AND remove_time IS NULL AND play_time IS NULL AND vote_time IS NOT NULL");
		$songs[$i]["votes"] = mysql_num_rows($votes);
		$i++;
	}
	
	usort($songs, voteComparator);	// Sort the array by votes
	
	foreach($songs as $song){
		// Print the vote count and song title
		echo "<br>";
		if(intval($song['votes']) < 10){echo "0";}
		echo $song['votes'], "   ||   ", $song['name'];
	}
}

mysql_close();
?>