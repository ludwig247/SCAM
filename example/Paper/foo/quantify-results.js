function update_results()
{
        if ( typeof gQuantifyResults == 'undefined' )
        {
          return;
        }

	var files = gQuantifyResults["Files"] ;
	var file_name = getMetaInfo( 'file' );

	if ( file_name == "NONE" )
        {
	  return;
	}

	var file;
	
	for( var f in files )
	{
		if ( files[f]["Name"] == file_name)
		{
			file= files[f];
			break;
		}
	}
	
	var locations = file["Locations"];
	var properties = gQuantifyResults["Properties"];
	for ( var line in locations )
	{
		var ident = "#source_line_" + line;
		var results = locations[ line ][ "Results" ];

		for ( var idx = 0; idx < results.length ; idx++ )
		{
			if( results[idx] == 1  )
			{
				var title_text = "covered by " + properties[idx]["Name"];
				$(ident).attr( "title" , title_text );
				break;
			}
		}
	}
}


function getMetaInfo( tag ) {
	
	var pattern = "TAG:" + tag;
	var children = document.head.childNodes;
	var comment = "";
	
	for (var i=0, len=children.length; i<len; i++) {
		if (children[i].nodeType == Node.COMMENT_NODE) {
			comment = children[i].data ;			
			if( comment.indexOf( pattern ) != -1 )
			{
				var result = comment.replace( pattern , "" );
				return $.trim( result );
			}
	    }
	}
	return "NONE";
}


$(document).ready( function() {
	update_results();
});
