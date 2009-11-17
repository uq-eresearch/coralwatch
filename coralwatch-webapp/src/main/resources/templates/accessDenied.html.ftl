<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;Access Denied
</div>
<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<h3>Access Denied</h3>
<#if currentUser??>
<p>
    Access to the resource you requested has been denied since you do not have sufficient
    permissions. If you feel this happened in error feel free to contact us. You should
    also not get to this page by following links on the site, so if that happens please
    tell us about it.
</p>
<#else>
<p>
    The page you requested is accessible only to registered users. Please
    <a href="${baseUrl}/login?redirectUrl=${baseUrl}/dashboard">log in</a> if you have an account.
</p>
        </#if>