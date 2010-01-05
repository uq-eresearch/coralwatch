<script type="text/javascript">
    $(document).ready(function() {
        getTree();
        $('#xpower').tagcloud({type:'sphere',sizemin:8,sizemax:26,power:.2, height: 360});
        $("#cloud-container").hide();
        $("#show-trust-cloud").click(function() {
            if ($("#jit-container").css("display") != "none") {
                $("#jit-container").toggle(400)
            }
            $("#cloud-container").toggle(400);
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

    function addEvent(obj, type, fn) {
        if (obj.addEventListener) obj.addEventListener(type, fn, false);
        else obj.attachEvent('on' + type, fn);
    }
    ;

    function getTree() {
        //init data
        var json = {
            "id": "${userimpl.id?c}",
            "name": "${userimpl.displayName!}",
            "children": [],
            "data": {
                "avatar":"${userimpl.gravatarUrl!}"
            }
        };

        var infovis = document.getElementById('infovis');
        var w = infovis.offsetWidth, h = infovis.offsetHeight;

        //init canvas
        //Create a new canvas instance.
        var canvas = new Canvas('mycanvas', {
            //Where to append the canvas widget
            'injectInto': 'infovis',
            'width': w,
            'height': h,

            //Optional: create a background canvas and plot
            //concentric circles in it.
            'backgroundCanvas': {
                'styles': {
                    'strokeStyle': '#555'
                },

                'impl': {
                    'init': function() {
                    },
                    'plot': function(canvas, ctx) {
                        var times = 6, d = 100;
                        var pi2 = Math.PI * 2;
                        for (var i = 1; i <= times; i++) {
                            ctx.beginPath();
                            ctx.arc(0, 0, i * d, 0, pi2, true);
                            ctx.stroke();
                            ctx.closePath();
                        }
                    }
                }
            }
        });
        //end
        //init RGraph
        var rgraph = new RGraph(canvas, {
            //Set Node and Edge colors.
            interpolation: 'polar',
            levelDistance: 100,
            Node: {
                color: '#ccddee'
            },

            Edge: {
                color: '#772277'
            },

            //Add the name of the node in the correponding label
            //and a click handler to move the graph.
            //This method is called once, on label creation.
            onCreateLabel: function(domElement, node) {
                domElement.innerHTML = node.name;
                $(domElement).qtip(
                {
                    content: '<img src="' + node.data.avatar + '"/>',
                    //                        content: node.data,
                    position: {
                        corner: {
                            tooltip: 'bottomMiddle',
                            target: 'topMiddle'
                        }
                    },
                    style: {
                        tip: true, // Give it a speech bubble tip with automatic corner detection
                        name: 'cream'
                    }

                });
                domElement.onclick = function() {
                    rgraph.onClick(node.id);
                };
            },
            //Change some label dom properties.
            //This method is called each time a label is plotted.
            onPlaceLabel: function(domElement, node) {
                var style = domElement.style;
                style.display = '';
                style.cursor = 'pointer';

                if (node._depth <= 1) {
                    style.fontSize = "0.8em";
                    style.color = "#ccc";

                } else if (node._depth == 2) {
                    style.fontSize = "0.7em";
                    style.color = "#494949";

                } else {
                    style.display = 'none';
                }

                var left = parseInt(style.left);
                var w = domElement.offsetWidth;
                style.left = (left - w / 2) + 'px';
            }
        });

        //load JSON data
        rgraph.loadJSON(json);

    <#list trustTable as trust>
        rgraph.graph.addAdjacence({'id': '${trust.trustee.id!}', 'name' : '${trust.trustee.displayName!}', "data": {"avatar":"${trust.trustee.gravatarUrl!}"}}, {'id': '${trust.trustor.id!}', 'name' : '${trust.trustor.displayName!}',"data": {"avatar":"${trust.trustor.gravatarUrl!}"}}, null);
    </#list>
        rgraph.refresh();
    }

</script>