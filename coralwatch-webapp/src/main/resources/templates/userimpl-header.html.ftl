<script type="text/javascript">
    $(document).ready(function() {
        //        jQuery("#cloudPopup").dialog({ autoOpen: false, position: 'center', modal: true, width: 660, height:420 });
        getTree();
        $('#xpower').tagcloud({type:'sphere',sizemin:8,sizemax:26,power:.2, height: 360});
        $("#cloud-container").hide();
        $("#show-trust-cloud").click(function() {
            if ($("#jit-container").css("display") != "none") {
                $("#jit-container").toggle(400)
            }
            $("#cloud-container").toggle(400);
            //            $('#xpower').tagcloud({type:'sphere',sizemin:8,sizemax:26,power:.2, height: 360});
            return false;
        });

        $("#jit-container").hide();
        $("#show-trust-network").click(function() {
            if ($("#cloud-container").css("display") != "none") {
                $("#cloud-container").toggle(400)
            }
            $("#jit-container").toggle(400);
            return false;
        });
        // Notice the use of the each method to gain access to each element individually
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
        var aLi = $("#delicious>li");
        var iLi = aLi.length;
        $.each(aLi, function(i, o) {
            //$(o).val(iLi-i);
            //$(o).val(Math.round(iLi*Math.sqrt(1-i/iLi)));
            $(o).val(Math.round(iLi * Math.pow(1 - i / iLi, 2))).attr("title", $(o).text());
        });


        $("pre.example").each(function(i, o) {
            var mPre = $(o);
            var aTg = mPre.text().match(/(\w+)(?=#)/);
            var sTg = aTg === null ? "ul" : aTg[0];
            var sId = mPre.text().match(/(?:#)(\w+)/)[1];
            mPre.after("<" + sTg + " id=\"" + sId + "\" class=\"xmpl\"></" + sTg + ">");
            refill(sId);
        });
    });

    function refill(s) {
        var mList = $("#" + s);
        mList.html($("#delicious>li").clone());
        $.each(["list-style","margin","padding","position","height"], function(i, o) {
            mList.css(o, $("#delicious").css(o));
        });
    }
</script>