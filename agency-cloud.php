<?php

//social media registry
$account_query = 'http://registry.usa.gov/accounts.json?service_id=github&agency_id=&tag=';
	
//URL to query GitHub API to retreive repos
$repo_query = 'https://api.github.com/users/%s/repos';

//max size
$max_size = 3;
$min_size = .1;

//get accounts
$data = file_get_contents( $account_query );
$agencies = json_decode( $data )->accounts;

//loop through accounts and build wordle seed info
$counts = array();
foreach ( $agencies as &$agency ) {
    
    $repos = json_decode( file_get_contents( sprintf( $repo_query, $agency->account ) ) );
    $counts[ $agency->organization ] = sizeof( $repos );
    
}

$counts = array_filter( $counts );
$min = min( $counts );
$max = max( $counts );

?>
<style>
    .tag { list-style: none; display: inline; }
    .count { font-size: 12px; color: #aaa; }
</style>
<ul clas="tags">
<?php foreach ( $counts as $agency => $count ) { 
$weight = ( log( (int) $count ) - log( (int) $min ) ) / ( log( (int) $max ) - log( (int) $min ) );
$size = round( $min_size + ( $max_size - $min_size ) * $weight, 2);

?>
<li class="tag" style="font-size: <?php echo $size; ?>em"><?php echo $agency; ?><span class="count">(<?php echo $count; ?>)</span></li>
<?php } ?>
</ul>