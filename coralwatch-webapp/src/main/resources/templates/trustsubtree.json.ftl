[{id:"${trusteeId}", adjacencies:[
<#list trustors as user>
{nodeTo : "${user.id}", data : {$type: "arrow", $direction: ["${user.id}", "${trusteeId}"]}}${user_has_next?string(',','')}
</#list>]},
<#list trustors as user>
{id: "${user.id!}", name : "${user.displayName!}", adjacencies:[],data: {avatar:"${user.gravatarUrl!}"}}${user_has_next?string(',','')}
</#list>]