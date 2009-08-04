/*******************HTML Elements****************************/
* {
    margin: 0;
    padding: 0;
}

body {
    background: #FFFFFF url(${baseUrl}/icons/footer_bg.gif) bottom repeat-x;
    text-align: justfy;
    color: #2F4F4F;
}

p {
    text-align: justify;
    margin-bottom: 15px;
    line-height: 17px;
}

p.small {
    font-size: 10px;
}

a {
    color: #3d6f92;
}

a:hover {
    text-decoration: none;
}

a img {
    border: 0;
}

h3 {
    margin-bottom: 10px;
    color: #006986;
}

ul {
    margin-left: 30px;
    list-style-type: square;
}

ol {
    margin-left: 30px;
}

li {
    margin-bottom: 5px;
}

img {
    vertical-align: top;
}

html, input, textarea {
    font-family: arial, sans-serif;
    font-size: 12px;
    line-height: 17px;
    color: #868686;
}

input, select {
    vertical-align: middle;
    font-weight: normal;
}

strong {
    font-size: 12px;
    color: #444444;
}

textarea {
    width: 516px;
    height: 68px;
    border: 1px solid #a4a4a4;
    background: none;
    padding: 0 0 0 5px;
    overflow: auto;
    font-family: tahoma;
    line-height: 13px;
}

form .div {
    text-align: right;
    padding: 6px 0 0 0;
}

ul.menu_items {
    margin-left: 0px;
    list-style-type: none;
}

li.link {
    margin-bottom: 0px;
}

.input {
    width: 171px;
    height: 18px;
    border: 1px solid #a4a4a4;
    background: none;
    padding: 0 0 0 5px;
    font-family: tahoma;
    line-height: 13px;
    color: #a4a4a4;
}

/*Customized layout */

.headercell {
    text-align: left;
    font-weight: bold;
}

.list_table {
    
    border: solid 1px #ededed;
}
.list_table td {
    border: solid 1px #ededed;
}
.list_table th {
    border: solid 1px #ededed;
    background-color: #e8e8e8;
}

#main {
    width: 800px;
}

#header {
    height: 180px;
}

#footer {
    height: 61px;
}

#index .ver_line {
    background: url(${baseUrl}/icons/ver_line.gif) repeat-y 493px 0;
    width: 100%;
}

.h_logo {
    height: 110px;
    width: 100%;
}

.clear {
    clear: both;
}

#header_tall {
    background: url(${baseUrl}/icons/header_tall.gif) top repeat-x;
}

#main {
    margin: 0 auto;
}

#header .left {
    padding: 26px 0 0 0;
}

#menu {
    background: url(${baseUrl}/icons/menu_tall.gif) top repeat-x;
    height: 60px;
}

#menu .rightbg {
    background: url(${baseUrl}/icons/menu_right.gif) top right no-repeat;
}

#menu .leftbg {
    background: url(${baseUrl}/icons/menu_left.gif) top left no-repeat;
    width: 100%;
    height: 60px;
}

#menu .padding {
    padding: 9px 0;
}

#menu li {
    float: left;
    width: 113px;
    background: url(${baseUrl}/icons/menu_libg.gif) top right repeat-y;
    font-size: 12px;
    text-align: center;
    display: block;
}

#menu li a {
    color: #919191;
    text-decoration: none;
    font-weight: normal;
    font-size: 12px;
    display: block;
    padding: 8px 0 5px 0;
}

#menu li span {
    display: block;
    padding: 8px 0 5px 0;
}

#menu li a:hover {
    color: #000000;
    text-decoration: underline;
}

#menu li span {
    color: #000000;
    text-decoration: underline;
}

#menu .last {
    background: none;
}

#footer .indent {
    padding: 23px 0 0 17px;
    color: #868686;
    font-size: 12px;
}

#footer a {
    color: #444444;
    font-weight: bold;
}

.border {
    background: url(${baseUrl}/icons/border_tall.gif) top repeat-x;
}

.border .btall {
    background: url(${baseUrl}/icons/border_tall.gif) bottom repeat-x;
}

.border .ltall {
    background: url(${baseUrl}/icons/border_tall.gif) left repeat-y;
}

.border .rtall {
    background: url(${baseUrl}/icons/border_tall.gif) right repeat-y;
}

.border .tleft {
    background: url(${baseUrl}/icons/border_tl.gif) top left no-repeat;
}

.border .tright {
    background: url(${baseUrl}/icons/border_tr.gif) top right no-repeat;
}

.border .bleft {
    background: url(${baseUrl}/icons/border_bl.gif) bottom left no-repeat;
}

.border .bright {
    background: url(${baseUrl}/icons/border_br.gif) bottom right no-repeat;
    width: 100%;
}

.border .ind {
    padding: 4px 4px 15px 2px;
}

.border a img {
    float: right;
}

#footer_banner {
    text-align: center;
    margin: 30px;
    clear: both;
}

div.main_content {
    margin: 0 20 0 20px;
    padding: 4ex 2em 4ex 2em;
}

.footer_banner_list li {
    list-style-type: none;
    display: inline;
    margin: auto 10px;
    height: 80px;
    vertical-align: middle;
}

.frontTable {
    margin: 0 auto;
}

.frontTable td {
    padding: 0 9px;
}

.highlight {
    padding: 15px;
    font-size: 10px;
    text-align: justify;
}

.highlight2 {
    background-color: #E0ECFF;
    border: dotted 1px #C3D9FF;
    padding: 10px;
    _height: 30px;
    min-height: 25px;
}

.left {
    float: left;
    margin-right: 15px;
    margin-bottom: 20px;
}

.right {
    float: right;
    margin-left: 15px;
    margin-bottom: 20px;
}

.rightImage {
    float: right;
    margin-left: 15px;
    margin-bottom: 20px;
    display: inline;
    width: 260px;
    font-size: 10px;
    text-align: justify;
}
