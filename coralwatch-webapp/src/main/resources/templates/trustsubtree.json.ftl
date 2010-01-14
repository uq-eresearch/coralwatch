[{id:"${trusteeId}", adjacencies:[
<#list trustors as user>
"${user.id}"${user_has_next?string(',','')}
</#list>], data :{$type: "arrow"}},
<#list trustors as user>
{id: "${user.id!}", name : "${user.displayName!}", adjacencies:[],data: {avatar:"${user.gravatarUrl!}"}}${user_has_next?string(',','')}
</#list>]