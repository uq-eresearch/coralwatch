<script type="text/javascript">

    $(document).ready(function() {
        jQuery("#cloudPopup").dialog({ autoOpen: false, position: 'center', modal: true, width: 400, height:300 });
    });

    function deleteUser(id) {
        if (confirm("Are you sure you want to delete this user?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/users/" + id,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/users';
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Deletion failed: " + response);
                    return response;
                }
            });
        }
    }

    $(function() {
        $("#ratings").children().not(":radio").hide();
        $("#ratings").stars({
            cancelShow: false,
            callback: function(ui, type, value)
            {
                $.post("${baseUrl}/trust", {trust: value, trusteeId: ${userimpl.id?c}}, function(data)
                {
                    window.location = '${baseUrl}/users/${userimpl.id?c}';
                });
            }
        });

        $("#ratings2").children().not(":radio").hide();

        $("#ratings2").stars({
            cancelShow: false,
            callback: function(ui, type, value)
            {
                $.post("${baseUrl}/trust", {trust: value, trusteeId: ${userimpl.id?c}}, function(data)
                {
                    window.location = '${baseUrl}/users/${userimpl.id?c}';
                });
            }
        });
    });
    $(function() {
        $("#starify").children().not(":input").hide();
        // Create stars from :radio boxes
        $("#starify").stars({
            cancelShow: false,
            disabled: true
        });
        $("#starify2").stars({
            cancelShow: false,
            disabled: true
        });
    });

</script>