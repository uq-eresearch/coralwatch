<%
    String baseURL = HttpUtils.getRequestURL(request).toString();
    int slashIndex = baseURL.lastIndexOf('/');
    baseURL = baseURL.substring(0, slashIndex + 1);

%>
<script type="text/javascript">
    // Create the tooltips only on document load

    jQuery(document).ready(function()
    {
        // Use the each() method to gain access to each elements attributes
        jQuery('#dark-color-field').each(function()
        {
            jQuery(this).qtip(
            {
                content: {
                    // Set the text to an image HTML string with the correct src URL to the loading image you want to use
                    text: 'Loading...',
                    url: '<%=baseURL + "slate-dark.jsp"%>', // Use the rel attribute of each element for the url to load
                    title:false
                },
                position: {
                    corner: {
                        target: 'bottomRight', // Position the tooltip above the link
                        tooltip: 'topLeft'
                    },
                    adjust: {
                        screen: true // Keep the tooltip on-screen at all times
                    }
                },
                show: {
                    when: 'focus',
                    solo: true // Only show one tooltip at a time
                },
                hide: 'unfocus',
                style: {
                    tip: true, // Apply a speech bubble tip to the tooltip at the designated tooltip corner
                    border: {
                        width: 0,
                        radius: 5
                    },
                    name: 'light', // Use the default light style
                    width: 230, // Set the tooltip width
                    height: 230
                }
            })
        });
    });
</script>
<input class="colorField" id="dark-color-field" name="dark-color-field" type="text" style="width:30px;"/>