<?php

echo "The since_id is " . $_GET['since_id'] . "<br />";
echo "The q is " . $_GET['q'] . "<br />";
echo "The rpp is " . $_GET['rpp'] . "<br />";

$page = "";

$fh = fopen('http://search.twitter.com/search.atom?rpp=' . $_GET['rpp'] . '&q=' . $_GET['q'] . '&since_id=' . $_GET['since_id'], 'r') or die($php_errormsg);
while(!feof($fh)) {
	$page .= fread($fh,1048576);
}
fclose($fh);

// echo $page;

$dom = domxml_open_mem($page);

print "I got XML!<br />";

$entries = $dom->get_elements_by_tagname('entry');
echo "The array length is " . count($entries) . "<br />";



?>