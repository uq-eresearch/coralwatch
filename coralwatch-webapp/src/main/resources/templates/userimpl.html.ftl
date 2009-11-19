<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<#include "userimpl-header.html.ftl"/>
<#include "macros/basic.html.ftl"/>

<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/users">Users</a>&ensp;&raquo;&ensp;${userimpl.displayName!}
</div>
<table style="width:100%">

<tr>
    <td><h3>${userimpl.displayName!}</h3></td>
    <td>
        <#if canUpdate>
        <button dojoType="dijit.form.Button" id="editButton"
                onClick="window.location='${baseUrl}/users/${userimpl.id?c}?edit'">Edit
        </button>
        </#if>
        <#if canDelete>
        <button dojoType="dijit.form.Button" onClick="deleteUser(${userimpl.id?c})">Delete</button>
        </#if>
    </td>
</tr>
<tr>
    <td class="headercell"></td>
    <td style="width:60%"></td>
    <td rowspan="4" style="text-align:right">
        <img src="${userimpl.gravatarUrl!}"/>
        <#if userimpl == currentUser><#-- only the user themselves can change, not admins -->
        <br/>
        <a href="http://www.gravatar.com">Change Image</a>
        </#if>
    </td>
</tr>
<tr>
    <td class="headercell">Display Name:</td>
    <td>${userimpl.displayName!}</td>
</tr>
<tr>
    <td class="headercell">Email:</td>
    <td><a href="mailto:${userimpl.email!}">${userimpl.email!}</a></td>
</tr>
<tr>
    <td class="headercell">Member since (d/m/y):</td>
    <td>${(userimpl.registrationDate)!?string("dd/MM/yyyy")}</td>
</tr>
<tr>
    <td class="headercell">Occupation:</td>
    <td>${userimpl.occupation!}</td>
</tr>
<tr>
    <td class="headercell">Address:</td>
    <td>${userimpl.address!}</td>
</tr>
<tr>
    <td class="headercell">Country:</td>
    <td>${userimpl.country!}</td>
</tr>
<tr>
<td class="headercell">Community Trust:</td>
<#if (communityTrust == -1)>
<td>
    <div class="multiField" id="starify2">
        <input type="radio" name="trust" value="1" type="radio">
        <input type="radio" name="trust" value="2" type="radio">
        <input type="radio" name="trust" value="3" type="radio">
        <input type="radio" name="trust" value="4" type="radio">
        <input type="radio" name="trust" value="5" type="radio">
    </div>
    <span>&ensp;(Not Recorded)</span>
</td>
<#else>
<td>
    <div class="multiField" id="starify">
        <input type="radio" name="trust" value="1" type="radio"
               <#if (communityTrust >= 0) && (communityTrust < 1.5)>checked="checked"</#if>>
        <input type="radio" name="trust" value="2" type="radio"
               <#if (communityTrust >= 1.5) && (communityTrust < 2.5)>checked="checked"</#if>>
        <input type="radio" name="trust" value="3" type="radio"
               <#if (communityTrust >= 2.5) && (communityTrust < 3.5)>checked="checked"</#if>>
        <input type="radio" name="trust" value="4" type="radio"
               <#if (communityTrust >= 3.5) && (communityTrust < 4.5)>checked="checked"</#if>>
        <input type="radio" name="trust" value="5" type="radio"
               <#if (communityTrust >= 4.5) && (communityTrust <= 5)>checked="checked"</#if>>
    </div>
    <span>&ensp;(${communityTrust?c})</span>
    <a onClick="jQuery('#cloudPopup').dialog('open');$('#xpower').tagcloud({type:'sphere',sizemin:8,sizemax:26,power:.3});return false;"
       href=".">
        Trust Cloud
    </a>

    <div id="cloudPopup" title="Trust Cloud" style="display:none">
        <pre class="example"
             style="display:none">$("#xpower").tagcloud({type:"sphere",sizemin:8,sizemax:26,power:.3});</pre>
        <ul id="delicious" class="xmpl">
            <li><a href="http://del.icio.us/tag/design">design</a></li>
            <li><a href="http://del.icio.us/tag/blog">blog</a></li>
            <li><a href="http://del.icio.us/tag/programming">programming</a></li>
            <li><a href="http://del.icio.us/tag/tools">tools</a></li>
            <li><a href="http://del.icio.us/tag/music">music</a></li>

            <li><a href="http://del.icio.us/tag/software">software</a></li>
            <li><a href="http://del.icio.us/tag/webdesign">webdesign</a></li>
            <li><a href="http://del.icio.us/tag/web2.0">web2.0</a></li>
            <li><a href="http://del.icio.us/tag/video">video</a></li>
            <li><a href="http://del.icio.us/tag/art">art</a></li>
            <li><a href="http://del.icio.us/tag/reference">reference</a></li>

            <li><a href="http://del.icio.us/tag/linux">linux</a></li>
            <li><a href="http://del.icio.us/tag/tutorial">tutorial</a></li>
            <li><a href="http://del.icio.us/tag/photography">photography</a></li>
            <li><a href="http://del.icio.us/tag/howto">howto</a></li>
            <li><a href="http://del.icio.us/tag/inspiration">inspiration</a></li>
            <li><a href="http://del.icio.us/tag/web">web</a></li>

            <li><a href="http://del.icio.us/tag/css">css</a></li>
            <li><a href="http://del.icio.us/tag/free">free</a></li>
            <li><a href="http://del.icio.us/tag/development">development</a></li>
            <li><a href="http://del.icio.us/tag/education">education</a></li>
            <li><a href="http://del.icio.us/tag/javascript">javascript</a></li>
            <li><a href="http://del.icio.us/tag/travel">travel</a></li>

            <li><a href="http://del.icio.us/tag/news">news</a></li>
            <li><a href="http://del.icio.us/tag/flash">flash</a></li>
            <li><a href="http://del.icio.us/tag/shopping">shopping</a></li>
            <li><a href="http://del.icio.us/tag/business">business</a></li>
            <li><a href="http://del.icio.us/tag/blogs">blogs</a></li>
            <li><a href="http://del.icio.us/tag/tips">tips</a></li>

            <li><a href="http://del.icio.us/tag/mac">mac</a></li>
            <li><a href="http://del.icio.us/tag/food">food</a></li>
            <li><a href="http://del.icio.us/tag/google">google</a></li>
            <li><a href="http://del.icio.us/tag/science">science</a></li>
            <li><a href="http://del.icio.us/tag/technology">technology</a></li>
            <li><a href="http://del.icio.us/tag/politics">politics</a></li>

            <li><a href="http://del.icio.us/tag/books">books</a></li>
            <li><a href="http://del.icio.us/tag/games">games</a></li>
            <li><a href="http://del.icio.us/tag/java">java</a></li>
            <li><a href="http://del.icio.us/tag/resources">resources</a></li>
            <li><a href="http://del.icio.us/tag/recipes">recipes</a></li>
            <li><a href="http://del.icio.us/tag/health">health</a></li>

            <li><a href="http://del.icio.us/tag/opensource">opensource</a></li>
            <li><a href="http://del.icio.us/tag/research">research</a></li>
            <li><a href="http://del.icio.us/tag/funny">funny</a></li>
            <li><a href="http://del.icio.us/tag/toread">toread</a></li>
            <li><a href="http://del.icio.us/tag/photoshop">photoshop</a></li>
            <li><a href="http://del.icio.us/tag/firefox">firefox</a></li>

            <li><a href="http://del.icio.us/tag/humor">humor</a></li>
            <li><a href="http://del.icio.us/tag/online">online</a></li>
            <li><a href="http://del.icio.us/tag/security">security</a></li>
            <li><a href="http://del.icio.us/tag/internet">internet</a></li>
            <li><a href="http://del.icio.us/tag/windows">windows</a></li>
            <li><a href="http://del.icio.us/tag/wordpress">wordpress</a></li>

            <li><a href="http://del.icio.us/tag/fun">fun</a></li>
            <li><a href="http://del.icio.us/tag/php">php</a></li>
            <li><a href="http://del.icio.us/tag/marketing">marketing</a></li>
            <li><a href="http://del.icio.us/tag/search">search</a></li>
            <li><a href="http://del.icio.us/tag/graphics">graphics</a></li>
            <li><a href="http://del.icio.us/tag/portfolio">portfolio</a></li>

            <li><a href="http://del.icio.us/tag/python">python</a></li>
            <li><a href="http://del.icio.us/tag/tutorials">tutorials</a></li>
            <li><a href="http://del.icio.us/tag/social">social</a></li>
            <li><a href="http://del.icio.us/tag/history">history</a></li>
            <li><a href="http://del.icio.us/tag/cool">cool</a></li>
            <li><a href="http://del.icio.us/tag/mobile">mobile</a></li>

            <li><a href="http://del.icio.us/tag/media">media</a></li>
            <li><a href="http://del.icio.us/tag/community">community</a></li>
            <li><a href="http://del.icio.us/tag/download">download</a></li>
            <li><a href="http://del.icio.us/tag/ajax">ajax</a></li>
            <li><a href="http://del.icio.us/tag/photo">photo</a></li>
            <li><a href="http://del.icio.us/tag/diy">diy</a></li>

            <li><a href="http://del.icio.us/tag/ruby">ruby</a></li>
            <li><a href="http://del.icio.us/tag/culture">culture</a></li>
            <li><a href="http://del.icio.us/tag/illustration">illustration</a></li>
            <li><a href="http://del.icio.us/tag/osx">osx</a></li>
            <li><a href="http://del.icio.us/tag/rails">rails</a></li>
            <li><a href="http://del.icio.us/tag/freeware">freeware</a></li>

            <li><a href="http://del.icio.us/tag/fashion">fashion</a></li>
            <li><a href="http://del.icio.us/tag/library">library</a></li>
            <li><a href="http://del.icio.us/tag/architecture">architecture</a></li>
            <li><a href="http://del.icio.us/tag/article">article</a></li>
            <li><a href="http://del.icio.us/tag/photos">photos</a></li>
            <li><a href="http://del.icio.us/tag/writing">writing</a></li>

            <li><a href="http://del.icio.us/tag/ubuntu">ubuntu</a></li>
            <li><a href="http://del.icio.us/tag/seo">seo</a></li>
            <li><a href="http://del.icio.us/tag/audio">audio</a></li>
            <li><a href="http://del.icio.us/tag/apple">apple</a></li>
            <li><a href="http://del.icio.us/tag/environment">environment</a></li>
            <li><a href="http://del.icio.us/tag/twitter">twitter</a></li>

            <li><a href="http://del.icio.us/tag/iphone">iphone</a></li>
            <li><a href="http://del.icio.us/tag/jobs">jobs</a></li>
            <li><a href="http://del.icio.us/tag/home">home</a></li>
            <li><a href="http://del.icio.us/tag/productivity">productivity</a></li>
            <li><a href="http://del.icio.us/tag/youtube">youtube</a></li>
            <li><a href="http://del.icio.us/tag/webdev">webdev</a></li>

            <li><a href="http://del.icio.us/tag/work">work</a></li>
            <li><a href="http://del.icio.us/tag/tv">tv</a></li>
            <li><a href="http://del.icio.us/tag/advertising">advertising</a></li>
            <li><a href="http://del.icio.us/tag/microsoft">microsoft</a></li>
            <li><a href="http://del.icio.us/tag/typography">typography</a></li>
            <li><a href="http://del.icio.us/tag/fic">fic</a></li>

            <li><a href="http://del.icio.us/tag/finance">finance</a></li>
            <li><a href="http://del.icio.us/tag/mp3">mp3</a></li>
            <li><a href="http://del.icio.us/tag/recipe">recipe</a></li>
            <li><a href="http://del.icio.us/tag/jquery">jquery</a></li>
            <li><a href="http://del.icio.us/tag/hardware">hardware</a></li>
            <li><a href="http://del.icio.us/tag/green">green</a></li>

            <li><a href="http://del.icio.us/tag/blogging">blogging</a></li>
            <li><a href="http://del.icio.us/tag/movies">movies</a></li>
            <li><a href="http://del.icio.us/tag/computer">computer</a></li>
            <li><a href="http://del.icio.us/tag/learning">learning</a></li>
            <li><a href="http://del.icio.us/tag/wiki">wiki</a></li>
            <li><a href="http://del.icio.us/tag/images">images</a></li>

            <li><a href="http://del.icio.us/tag/2008">2008</a></li>
            <li><a href="http://del.icio.us/tag/.net">.net</a></li>
            <li><a href="http://del.icio.us/tag/socialnetworking">socialnetworking</a></li>
            <li><a href="http://del.icio.us/tag/language">language</a></li>
            <li><a href="http://del.icio.us/tag/math">math</a></li>
            <li><a href="http://del.icio.us/tag/collaboration">collaboration</a></li>

            <li><a href="http://del.icio.us/tag/au">au</a></li>
            <li><a href="http://del.icio.us/tag/visualization">visualization</a></li>
            <li><a href="http://del.icio.us/tag/lifehacks">lifehacks</a></li>
            <li><a href="http://del.icio.us/tag/code">code</a></li>
            <li><a href="http://del.icio.us/tag/cooking">cooking</a></li>
            <li><a href="http://del.icio.us/tag/energy">energy</a></li>

            <li><a href="http://del.icio.us/tag/interesting">interesting</a></li>
            <li><a href="http://del.icio.us/tag/psychology">psychology</a></li>
            <li><a href="http://del.icio.us/tag/tech">tech</a></li>
            <li><a href="http://del.icio.us/tag/teaching">teaching</a></li>
            <li><a href="http://del.icio.us/tag/game">game</a></li>
            <li><a href="http://del.icio.us/tag/english">english</a></li>

            <li><a href="http://del.icio.us/tag/plugin">plugin</a></li>
            <li><a href="http://del.icio.us/tag/book">book</a></li>
            <li><a href="http://del.icio.us/tag/database">database</a></li>
            <li><a href="http://del.icio.us/tag/economics">economics</a></li>
            <li><a href="http://del.icio.us/tag/videos">videos</a></li>
            <li><a href="http://del.icio.us/tag/tool">tool</a></li>

            <li><a href="http://del.icio.us/tag/socialmedia">socialmedia</a></li>
            <li><a href="http://del.icio.us/tag/email">email</a></li>
            <li><a href="http://del.icio.us/tag/maps">maps</a></li>
        </ul>
    </div>
</td>
</#if>
</tr>
<#if userimpl != currentUser>
<tr>
    <td class="headercell">Your Trust</td>
    <#if (userTrust >= 0)>
    <td>
        <form id="ratings" method="post" action="${baseUrl}/trust">
            <input type="hidden" name="trusteeId" value="${userimpl.id?c}"/>
            <input type="radio" id="trust_1" name="trust" value="1" type="radio"
                   <#if (userTrust >= 0) && (userTrust < 1.5)>checked="checked"</#if>>
            <input type="radio" id="trust_2" name="trust" value="2" type="radio"
                   <#if (userTrust >= 1.5) && (userTrust < 2.5)>checked="checked"</#if>>
            <input type="radio" id="trust_3" name="trust" value="3" type="radio"
                   <#if (userTrust >= 2.5) && (userTrust < 3.5)>checked="checked"</#if>>
            <input type="radio" id="trust_4" name="trust" value="4" type="radio"
                   <#if (userTrust >= 3.5) && (userTrust < 4.5)>checked="checked"</#if>>
            <input type="radio" id="trust_5" name="trust" value="5" type="radio"
                   <#if (userTrust >= 4.5) && (userTrust <= 5)>checked="checked"</#if>>
            <input type="submit" value="Rate" name="submit"/>
        </form>
        <span>&ensp;(${userTrust?c})</span>
    </td>
    <#else>
    <td>
        <form id="ratings2" method="post" action="${baseUrl}/trust">
            <input type="hidden" name="trusteeId" value="${userimpl.id?c}"/>
            <input type="radio" name="trust" value="1" type="radio">
            <input type="radio" name="trust" value="2" type="radio">
            <input type="radio" name="trust" value="3" type="radio">
            <input type="radio" name="trust" value="4" type="radio">
            <input type="radio" name="trust" value="5" type="radio">
            <input type="submit" value="Rate" name="submit"/>
        </form>
        <span>&ensp;(Not Recorded)</span>
    </td>
    </#if>
</tr>
</#if>
</table>
<br/>
<br/>
<@createList "${conductedSurveys?size!} Surveys" conductedSurveys; item><a href="
            ${baseUrl}/surveys/${item.id?c}"><img
        src="${baseUrl}/icons/fam/survey.png"/></a> Conducted on
        ${(item.date)!?date}</@createList>