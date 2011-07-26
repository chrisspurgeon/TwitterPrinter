<?php

$page = "";
$messageID = $_GET['since_id'];
$messageAuthor = "";
$messageDate = "";
$messageText = "";
$messageID = "";

$fh = fopen('http://search.twitter.com/search.atom?rpp=' . $_GET['rpp'] . '&q=' . $_GET['q'] . '&since_id=' . $_GET['since_id'] . '& cachebuster=' . mt_rand(1, 100000) , 'r') or die($php_errormsg);
while(!feof($fh)) {
	$page .= fread($fh,1048576);
}
fclose($fh);


// Uncomment for debugging...
echo '<pre>' . $page . '</pre>';

$dom = domxml_open_mem($page);



// print "I got XML!<br />";

$entries = $dom->get_elements_by_tagname('entry');
// echo "The array length is " . count($entries) . "<br />";

if (count($entries) > 0) {

//	echo "I'm here! with " . get_class($dom) . "<br />";
	$oldest_entry = $entries[count($entries) - 1];
//	echo "the single element is " . get_class($oldest_entry) . "<br />";
	
	$theOldestTextArray = $oldest_entry->get_elements_by_tagname('title');
	$theOldestDateArray = $oldest_entry->get_elements_by_tagname('updated');
	$theOldestAuthorArray = $oldest_entry->get_elements_by_tagname('author');
	$theOldestIDArray = $oldest_entry->get_elements_by_tagname('id');

	$theOldestText = $theOldestTextArray[0];
	$theOldestDate = $theOldestDateArray[0];
	$theOldestAuthor = $theOldestAuthorArray[0];
	$theOldestID = $theOldestIDArray[0];

	$textChildren = $theOldestText->child_nodes();
	$dateChildren = $theOldestDate->child_nodes();
	$authorChildren = $theOldestAuthor->child_nodes();
	$IDChildren = $theOldestID->child_nodes();
//	echo "" . $textChildren[0]->get_content() . "<br />";
	$messageText = $textChildren[0]->get_content();
	$messageDate = $dateChildren[0]->get_content();
	$authorChildNodes = $authorChildren[0]->child_nodes();
	
	if (count($authorChildNodes) > 0) {
		$messageAuthor = $authorChildNodes[0]->get_content();
	} else {
		$messageAuthor = "UNKNOWN AUTHOR";
	}
	$messageID = $IDChildren[0]->get_content();
	$messageIDParts = explode(':',$messageID);
	$messageID = $messageIDParts[2];
	

	// date clean up...
	
	$dateParts = explode('T',$messageDate);
	$dateSubParts = explode('-', $dateParts[0]);
	$hourParts = explode(":", $dateParts[1]);

	// Make a date object from the parts
	$theDateStamp = mktime($hourParts[0],$hourParts[1],substr($hourParts[2],0,2),$dateSubParts[1],$dateSubParts[2],$dateSubParts[0]);
	$a = getdate($theDateStamp);


}

echo $messageID . '|||' . $messageAuthor . '|||' . $messageText . '|||';
printf('%s %d, %d %02d:%02d:%02d',$a['month'],$a['mday'],$a['year'],$a['hours'],$a['minutes'],$a['seconds']);


?>