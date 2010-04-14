<script type="text/javascript">
    if (document.createStyleSheet) {
        document.createStyleSheet('http://jquery-ui.googlecode.com/svn/tags/1.7.2/themes/base/ui.all.css');
    } else {
        //        var styles = "@import url('http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dijit/themes/tundra/tundra.css');";
        var newSS = document.createElement('link');
        newSS.rel = 'stylesheet';
        newSS.href = 'http://jquery-ui.googlecode.com/svn/tags/1.7.2/themes/base/ui.all.css';
        document.getElementsByTagName("head")[0].appendChild(newSS);
    }
</script>


<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://jquery-ui.googlecode.com/svn/tags/1.7.2/ui/ui.tabs.js"></script>