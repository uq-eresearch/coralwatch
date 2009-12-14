(function() {
    function b() {
    }

    function c(w, u) {
        for (var v in (u || {})) {
            w[v] = u[v]
        }
        return w
    }

    function m(u) {
        return(typeof u == "function") ? u : function() {
            return u
        }
    }

    var k = Date.now || function() {
        return +new Date
    };

    function j(v) {
        var u = h(v);
        return(u) ? ((u != "array") ? [v] : v) : []
    }

    var h = function(u) {
        return h.s.call(u).match(/^\[object\s(.*)\]$/)[1].toLowerCase()
    };
    h.s = Object.prototype.toString;
    function g(y, x) {
        var w = h(y);
        if (w == "object") {
            for (var v in y) {
                x(y[v], v)
            }
        } else {
            for (var u = 0; u < y.length; u++) {
                x(y[u], u)
            }
        }
    }

    function r() {
        var y = {};
        for (var x = 0,u = arguments.length; x < u; x++) {
            var v = arguments[x];
            if (h(v) != "object") {
                continue
            }
            for (var w in v) {
                var A = v[w],z = y[w];
                y[w] = (z && h(A) == "object" && h(z) == "object") ? r(z, A) : n(A)
            }
        }
        return y
    }

    function n(w) {
        var v;
        switch (h(w)) {case"object":v = {};for (var y in w) {
            v[y] = n(w[y])
        }break;case"array":v = [];for (var x = 0,u = w.length; x < u; x++) {
            v[x] = n(w[x])
        }break;default:return w}
        return v
    }

    function d(y, x) {
        if (y.length < 3) {
            return null
        }
        if (y.length == 4 && y[3] == 0 && !x) {
            return"transparent"
        }
        var v = [];
        for (var u = 0; u < 3; u++) {
            var w = (y[u] - 0).toString(16);
            v.push((w.length == 1) ? "0" + w : w)
        }
        return(x) ? v : "#" + v.join("")
    }

    function i(u) {
        f(u);
        if (u.parentNode) {
            u.parentNode.removeChild(u)
        }
        if (u.clearAttributes) {
            u.clearAttributes()
        }
    }

    function f(w) {
        for (var v = w.childNodes,u = 0; u < v.length; u++) {
            i(v[u])
        }
    }

    function t(w, v, u) {
        if (w.addEventListener) {
            w.addEventListener(v, u, false)
        } else {
            w.attachEvent("on" + v, u)
        }
    }

    function s(v, u) {
        return(" " + v.className + " ").indexOf(" " + u + " ") > -1
    }

    function p(v, u) {
        if (!s(v, u)) {
            v.className = (v.className + " " + u)
        }
    }

    function a(v, u) {
        v.className = v.className.replace(new RegExp("(^|\\s)" + u + "(?:\\s|$)"), "$1")
    }

    function e(u) {
        return document.getElementById(u)
    }

    var o = function(v) {
        v = v || {};
        var u = function() {
            this.constructor = u;
            if (o.prototyping) {
                return this
            }
            var x = (this.initialize) ? this.initialize.apply(this, arguments) : this;
            return x
        };
        for (var w in o.Mutators) {
            if (!v[w]) {
                continue
            }
            v = o.Mutators[w](v, v[w]);
            delete v[w]
        }
        c(u, this);
        u.constructor = o;
        u.prototype = v;
        return u
    };
    o.Mutators = {Extends:function(w, u) {
        o.prototyping = u.prototype;
        var v = new u;
        delete v.parent;
        v = o.inherit(v, w);
        delete o.prototyping;
        return v
    },Implements:function(u, v) {
        g(j(v), function(w) {
            o.prototying = w;
            c(u, (h(w) == "function") ? new w : w);
            delete o.prototyping
        });
        return u
    }};
    c(o, {inherit:function(v, y) {
        var u = arguments.callee.caller;
        for (var x in y) {
            var w = y[x];
            var A = v[x];
            var z = h(w);
            if (A && z == "function") {
                if (w != A) {
                    if (u) {
                        w.__parent = A;
                        v[x] = w
                    } else {
                        o.override(v, x, w)
                    }
                }
            } else {
                if (z == "object") {
                    v[x] = r(A, w)
                } else {
                    v[x] = w
                }
            }
        }
        if (u) {
            v.parent = function() {
                return arguments.callee.caller.__parent.apply(this, arguments)
            }
        }
        return v
    },override:function(v, u, y) {
        var x = o.prototyping;
        if (x && v[u] != x[u]) {
            x = null
        }
        var w = function() {
            var z = this.parent;
            this.parent = x ? x[u] : v[u];
            var A = y.apply(this, arguments);
            this.parent = z;
            return A
        };
        v[u] = w
    }});
    o.prototype.implement = function() {
        var u = this.prototype;
        g(Array.prototype.slice.call(arguments || []), function(v) {
            o.inherit(u, v)
        });
        return this
    };
    this.TreeUtil = {prune:function(v, u) {
        this.each(v, function(x, w) {
            if (w == u && x.children) {
                delete x.children;
                x.children = []
            }
        })
    },getParent:function(u, y) {
        if (u.id == y) {
            return false
        }
        var x = u.children;
        if (x && x.length > 0) {
            for (var w = 0; w < x.length; w++) {
                if (x[w].id == y) {
                    return u
                } else {
                    var v = this.getParent(x[w], y);
                    if (v) {
                        return v
                    }
                }
            }
        }
        return false
    },getSubtree:function(u, y) {
        if (u.id == y) {
            return u
        }
        for (var w = 0,x = u.children; w < x.length; w++) {
            var v = this.getSubtree(x[w], y);
            if (v != null) {
                return v
            }
        }
        return null
    },getLeaves:function(w, u) {
        var x = [],v = u || Number.MAX_VALUE;
        this.each(w, function(z, y) {
            if (y < v && (!z.children || z.children.length == 0)) {
                x.push({node:z,level:v - y})
            }
        });
        return x
    },eachLevel:function(u, z, w, y) {
        if (z <= w) {
            y(u, z);
            for (var v = 0,x = u.children; v < x.length; v++) {
                this.eachLevel(x[v], z + 1, w, y)
            }
        }
    },each:function(u, v) {
        this.eachLevel(u, 0, Number.MAX_VALUE, v)
    },loadSubtrees:function(D, x) {
        var C = x.request && x.levelsToShow;
        var y = this.getLeaves(D, C),A = y.length,z = {};
        if (A == 0) {
            x.onComplete()
        }
        for (var w = 0,u = 0; w < A; w++) {
            var B = y[w],v = B.node.id;
            z[v] = B.node;
            x.request(v, B.level, {onComplete:function(G, E) {
                var F = E.children;
                z[G].children = F;
                if (++u == A) {
                    x.onComplete()
                }
            }})
        }
    }};
    this.Canvas = (function() {
        var v = {injectInto:"id",width:200,height:200,backgroundColor:"#333333",styles:{fillStyle:"#000000",strokeStyle:"#000000"},backgroundCanvas:false};

        function x() {
            x.t = x.t || typeof(HTMLCanvasElement);
            return"function" == x.t || "object" == x.t
        }

        function w(z, C, B) {
            var A = document.createElement(z);
            (function(E, F) {
                if (F) {
                    for (var D in F) {
                        E[D] = F[D]
                    }
                }
                return arguments.callee
            })(A, C)(A.style, B);
            if (z == "canvas" && !x() && G_vmlCanvasManager) {
                A = G_vmlCanvasManager.initElement(document.body.appendChild(A))
            }
            return A
        }

        function u(z) {
            return document.getElementById(z)
        }

        function y(C, B, A, E) {
            var D = A ? (C.width - A) : C.width;
            var z = E ? (C.height - E) : C.height;
            B.translate(D / 2, z / 2)
        }

        return function(B, C) {
            var N,G,z,K,D,J;
            if (arguments.length < 1) {
                throw"Arguments missing"
            }
            var A = B + "-label",I = B + "-canvas",E = B + "-bkcanvas";
            C = r(v, C || {});
            var F = {width:C.width,height:C.height};
            z = w("div", {id:B}, r(F, {position:"relative"}));
            K = w("div", {id:A}, {overflow:"visible",position:"absolute",top:0,left:0,width:F.width + "px",height:0});
            var L = {position:"absolute",top:0,left:0,width:F.width + "px",height:F.height + "px"};
            D = w("canvas", r({id:I}, F), L);
            var H = C.backgroundCanvas;
            if (H) {
                J = w("canvas", r({id:E}, F), L);
                z.appendChild(J)
            }
            z.appendChild(D);
            z.appendChild(K);
            u(C.injectInto).appendChild(z);
            N = D.getContext("2d");
            y(D, N);
            var M = C.styles;
            var O;
            for (O in M) {
                N[O] = M[O]
            }
            if (H) {
                G = J.getContext("2d");
                M = H.styles;
                for (O in M) {
                    G[O] = M[O]
                }
                y(J, G);
                H.impl.init(J, G);
                H.impl.plot(J, G)
            }
            return{id:B,getCtx:function() {
                return N
            },getElement:function() {
                return z
            },resize:function(T, P) {
                var S = D.width,U = D.height;
                D.width = T;
                D.height = P;
                D.style.width = T + "px";
                D.style.height = P + "px";
                if (H) {
                    J.width = T;
                    J.height = P;
                    J.style.width = T + "px";
                    J.style.height = P + "px"
                }
                if (!x()) {
                    y(D, N, S, U)
                } else {
                    y(D, N)
                }
                var Q = C.styles;
                var R;
                for (R in Q) {
                    N[R] = Q[R]
                }
                if (H) {
                    Q = H.styles;
                    for (R in Q) {
                        G[R] = Q[R]
                    }
                    if (!x()) {
                        y(J, G, S, U)
                    } else {
                        y(J, G)
                    }
                    H.impl.init(J, G);
                    H.impl.plot(J, G)
                }
            },getSize:function() {
                return{width:D.width,height:D.height}
            },path:function(P, Q) {
                N.beginPath();
                Q(N);
                N[P]();
                N.closePath()
            },clear:function() {
                var P = this.getSize();
                N.clearRect(-P.width / 2, -P.height / 2, P.width, P.height)
            },clearRectangle:function(T, R, Q, S) {
                if (!x()) {
                    var P = N.fillStyle;
                    N.fillStyle = C.backgroundColor;
                    N.fillRect(S, T, Math.abs(R - S), Math.abs(Q - T));
                    N.fillStyle = P
                } else {
                    N.clearRect(S, T, Math.abs(R - S), Math.abs(Q - T))
                }
            }}
        }
    })();
    this.Polar = function(v, u) {
        this.theta = v;
        this.rho = u
    };
    Polar.prototype = {getc:function(u) {
        return this.toComplex(u)
    },getp:function() {
        return this
    },set:function(u) {
        u = u.getp();
        this.theta = u.theta;
        this.rho = u.rho
    },setc:function(u, v) {
        this.rho = Math.sqrt(u * u + v * v);
        this.theta = Math.atan2(v, u);
        if (this.theta < 0) {
            this.theta += Math.PI * 2
        }
    },setp:function(v, u) {
        this.theta = v;
        this.rho = u
    },clone:function() {
        return new Polar(this.theta, this.rho)
    },toComplex:function(w) {
        var u = Math.cos(this.theta) * this.rho;
        var v = Math.sin(this.theta) * this.rho;
        if (w) {
            return{x:u,y:v}
        }
        return new Complex(u, v)
    },add:function(u) {
        return new Polar(this.theta + u.theta, this.rho + u.rho)
    },scale:function(u) {
        return new Polar(this.theta, this.rho * u)
    },equals:function(u) {
        return this.theta == u.theta && this.rho == u.rho
    },$add:function(u) {
        this.theta = this.theta + u.theta;
        this.rho += u.rho;
        return this
    },$madd:function(u) {
        this.theta = (this.theta + u.theta) % (Math.PI * 2);
        this.rho += u.rho;
        return this
    },$scale:function(u) {
        this.rho *= u;
        return this
    },interpolate:function(w, C) {
        var x = Math.PI,A = x * 2;
        var v = function(D) {
            return(D < 0) ? (D % A) + A : D % A
        };
        var z = this.theta,B = w.theta;
        var y;
        if (Math.abs(z - B) > x) {
            if (z > B) {
                y = v((B + ((z - A) - B) * C))
            } else {
                y = v((B - A + (z - (B - A)) * C))
            }
        } else {
            y = v((B + (z - B) * C))
        }
        var u = (this.rho - w.rho) * C + w.rho;
        return{theta:y,rho:u}
    }};
    var l = function(v, u) {
        return new Polar(v, u)
    };
    Polar.KER = l(0, 0);
    this.Complex = function(u, v) {
        this.x = u;
        this.y = v
    };
    Complex.prototype = {getc:function() {
        return this
    },getp:function(u) {
        return this.toPolar(u)
    },set:function(u) {
        u = u.getc(true);
        this.x = u.x;
        this.y = u.y
    },setc:function(u, v) {
        this.x = u;
        this.y = v
    },setp:function(v, u) {
        this.x = Math.cos(v) * u;
        this.y = Math.sin(v) * u
    },clone:function() {
        return new Complex(this.x, this.y)
    },toPolar:function(w) {
        var u = this.norm();
        var v = Math.atan2(this.y, this.x);
        if (v < 0) {
            v += Math.PI * 2
        }
        if (w) {
            return{theta:v,rho:u}
        }
        return new Polar(v, u)
    },norm:function() {
        return Math.sqrt(this.squaredNorm())
    },squaredNorm:function() {
        return this.x * this.x + this.y * this.y
    },add:function(u) {
        return new Complex(this.x + u.x, this.y + u.y)
    },prod:function(u) {
        return new Complex(this.x * u.x - this.y * u.y, this.y * u.x + this.x * u.y)
    },conjugate:function() {
        return new Complex(this.x, -this.y)
    },scale:function(u) {
        return new Complex(this.x * u, this.y * u)
    },equals:function(u) {
        return this.x == u.x && this.y == u.y
    },$add:function(u) {
        this.x += u.x;
        this.y += u.y;
        return this
    },$prod:function(w) {
        var u = this.x,v = this.y;
        this.x = u * w.x - v * w.y;
        this.y = v * w.x + u * w.y;
        return this
    },$conjugate:function() {
        this.y = -this.y;
        return this
    },$scale:function(u) {
        this.x *= u;
        this.y *= u;
        return this
    },$div:function(z) {
        var u = this.x,w = this.y;
        var v = z.squaredNorm();
        this.x = u * z.x + w * z.y;
        this.y = w * z.x - u * z.y;
        return this.$scale(1 / v)
    }};
    var q = function(v, u) {
        return new Complex(v, u)
    };
    Complex.KER = q(0, 0);
    this.Graph = new o({initialize:function(u) {
        var v = {complex:false,Node:{}};
        this.opt = r(v, u || {});
        this.nodes = {}
    },getNode:function(u) {
        if (this.hasNode(u)) {
            return this.nodes[u]
        }
        return false
    },getAdjacence:function(w, u) {
        var v = [];
        if (this.hasNode(w) && this.hasNode(u) && this.nodes[w].adjacentTo({id:u}) && this.nodes[u].adjacentTo({id:w})) {
            v.push(this.nodes[w].getAdjacency(u));
            v.push(this.nodes[u].getAdjacency(w));
            return v
        }
        return false
    },addNode:function(u) {
        if (!this.nodes[u.id]) {
            this.nodes[u.id] = new Graph.Node(c({id:u.id,name:u.name,data:u.data}, this.opt.Node), this.opt.complex)
        }
        return this.nodes[u.id]
    },addAdjacence:function(x, w, v) {
        var y = [];
        if (!this.hasNode(x.id)) {
            this.addNode(x)
        }
        if (!this.hasNode(w.id)) {
            this.addNode(w)
        }
        x = this.nodes[x.id];
        w = this.nodes[w.id];
        for (var u in this.nodes) {
            if (this.nodes[u].id == x.id) {
                if (!this.nodes[u].adjacentTo(w)) {
                    y.push(this.nodes[u].addAdjacency(w, v))
                }
            }
            if (this.nodes[u].id == w.id) {
                if (!this.nodes[u].adjacentTo(x)) {
                    y.push(this.nodes[u].addAdjacency(x, v))
                }
            }
        }
        return y
    },removeNode:function(w) {
        if (this.hasNode(w)) {
            var v = this.nodes[w];
            for (var u = 0 in v.adjacencies) {
                var adj = v.adjacencies[u];
                this.removeAdjacence(w, adj.nodeTo.id)
            }
            delete this.nodes[w]
        }
    },removeAdjacence:function(y, x) {
        if (this.hasNode(y)) {
            this.nodes[y].removeAdjacency(x)
        }
        if (this.hasNode(x)) {
            this.nodes[x].removeAdjacency(y)
        }
    },hasNode:function(x) {
        return x in this.nodes
    }});
    Graph.Node = new o({initialize:function(x, z) {
        var y = {id:"",name:"",data:{},adjacencies:{},selected:false,drawn:false,exist:false,angleSpan:{begin:0,end:0},alpha:1,startAlpha:1,endAlpha:1,pos:(z && q(0, 0)) || l(0, 0),startPos:(z && q(0, 0)) || l(0, 0),endPos:(z && q(0, 0)) || l(0, 0)};
        c(this, c(y, x))
    },adjacentTo:function(x) {
        return x.id in this.adjacencies
    },getAdjacency:function(x) {
        return this.adjacencies[x]
    },addAdjacency:function(y, z) {
        var x = new Graph.Adjacence(this, y, z);
        return this.adjacencies[y.id] = x
    },removeAdjacency:function(x) {
        delete this.adjacencies[x]
    }});
    Graph.Adjacence = function(x, z, y) {
        this.nodeFrom = x;
        this.nodeTo = z;
        this.data = y || {};
        this.alpha = 1;
        this.startAlpha = 1;
        this.endAlpha = 1
    };
    Graph.Util = {filter:function(y) {
        if (!y || !(h(y) == "string")) {
            return function() {
                return true
            }
        }
        var x = y.split(" ");
        return function(A) {
            for (var z = 0; z < x.length; z++) {
                if (A[x[z]]) {
                    return false
                }
            }
            return true
        }
    },getNode:function(x, y) {
        return x.getNode(y)
    },eachNode:function(B, A, x) {
        var z = this.filter(x);
        for (var y in B.nodes) {
            if (z(B.nodes[y])) {
                A(B.nodes[y])
            }
        }
    },eachAdjacency:function(A, B, x) {
        var y = A.adjacencies,z = this.filter(x);
        for (var C in y) {
            if (z(y[C])) {
                B(y[C], C)
            }
        }
    },computeLevels:function(D, E, A, z) {
        A = A || 0;
        var B = this.filter(z);
        this.eachNode(D, function(F) {
            F._flag = false;
            F._depth = -1
        }, z);
        var y = D.getNode(E);
        y._depth = A;
        var x = [y];
        while (x.length != 0) {
            var C = x.pop();
            C._flag = true;
            this.eachAdjacency(C, function(F) {
                var G = F.nodeTo;
                if (G._flag == false && B(G)) {
                    if (G._depth < 0) {
                        G._depth = C._depth + 1 + A
                    }
                    x.unshift(G)
                }
            }, z)
        }
    },eachBFS:function(C, D, B, y) {
        var z = this.filter(y);
        this.clean(C);
        var x = [C.getNode(D)];
        while (x.length != 0) {
            var A = x.pop();
            A._flag = true;
            B(A, A._depth);
            this.eachAdjacency(A, function(E) {
                var F = E.nodeTo;
                if (F._flag == false && z(F)) {
                    F._flag = true;
                    x.unshift(F)
                }
            }, y)
        }
    },eachLevel:function(B, F, y, C, A) {
        var E = B._depth,x = this.filter(A),D = this;
        y = y === false ? Number.MAX_VALUE - E : y;
        (function z(I, G, H) {
            var J = I._depth;
            if (J >= G && J <= H && x(I)) {
                C(I, J)
            }
            if (J < H) {
                D.eachAdjacency(I, function(K) {
                    var L = K.nodeTo;
                    if (L._depth > J) {
                        z(L, G, H)
                    }
                })
            }
        })(B, F + E, y + E)
    },eachSubgraph:function(y, z, x) {
        this.eachLevel(y, 0, false, z, x)
    },eachSubnode:function(y, z, x) {
        this.eachLevel(y, 1, 1, z, x)
    },anySubnode:function(A, z, y) {
        var x = false;
        z = z || m(true);
        var B = h(z) == "string" ? function(C) {
            return C[z]
        } : z;
        this.eachSubnode(A, function(C) {
            if (B(C)) {
                x = true
            }
        }, y);
        return x
    },getSubnodes:function(C, D, x) {
        var z = [],B = this;
        D = D || 0;
        var A,y;
        if (h(D) == "array") {
            A = D[0];
            y = D[1]
        } else {
            A = D;
            y = Number.MAX_VALUE - C._depth
        }
        this.eachLevel(C, A, y, function(E) {
            z.push(E)
        }, x);
        return z
    },getParents:function(y) {
        var x = [];
        this.eachAdjacency(y, function(z) {
            var A = z.nodeTo;
            if (A._depth < y._depth) {
                x.push(A)
            }
        });
        return x
    },isDescendantOf:function(A, B) {
        if (A.id == B) {
            return true
        }
        var z = this.getParents(A),x = false;
        for (var y = 0; !x && y < z.length; y++) {
            x = x || this.isDescendantOf(z[y], B)
        }
        return x
    },clean:function(x) {
        this.eachNode(x, function(y) {
            y._flag = false
        })
    }};
    Graph.Op = {options:{type:"nothing",duration:2000,hideLabels:true,fps:30},removeNode:function(C, A) {
        var x = this.viz;
        var y = r(this.options, x.controller, A);
        var E = j(C);
        var z,B,D;
        switch (y.type) {case"nothing":for (z = 0; z < E.length; z++) {
            x.graph.removeNode(E[z])
        }break;case"replot":this.removeNode(E, {type:"nothing"});x.fx.clearLabels();x.refresh(true);break;case"fade:seq":case"fade":B = this;for (z = 0; z < E.length; z++) {
            D = x.graph.getNode(E[z]);
            D.endAlpha = 0
        }x.fx.animate(r(y, {modes:["fade:nodes"],onComplete:function() {
            B.removeNode(E, {type:"nothing"});
            x.fx.clearLabels();
            x.reposition();
            x.fx.animate(r(y, {modes:["linear"]}))
        }}));break;case"fade:con":B = this;for (z = 0; z < E.length; z++) {
            D = x.graph.getNode(E[z]);
            D.endAlpha = 0;
            D.ignore = true
        }x.reposition();x.fx.animate(r(y, {modes:["fade:nodes","linear"],onComplete:function() {
            B.removeNode(E, {type:"nothing"})
        }}));break;case"iter":B = this;x.fx.sequence({condition:function() {
            return E.length != 0
        },step:function() {
            B.removeNode(E.shift(), {type:"nothing"});
            x.fx.clearLabels()
        },onComplete:function() {
            y.onComplete()
        },duration:Math.ceil(y.duration / E.length)});break;default:this.doError()}
    },removeEdge:function(D, B) {
        var x = this.viz;
        var z = r(this.options, x.controller, B);
        var y = (h(D[0]) == "string") ? [D] : D;
        var A,C,E;
        switch (z.type) {case"nothing":for (A = 0; A < y.length; A++) {
            x.graph.removeAdjacence(y[A][0], y[A][1])
        }break;case"replot":this.removeEdge(y, {type:"nothing"});x.refresh(true);break;case"fade:seq":case"fade":C = this;for (A = 0; A < y.length; A++) {
            E = x.graph.getAdjacence(y[A][0], y[A][1]);
            if (E) {
                E[0].endAlpha = 0;
                E[1].endAlpha = 0
            }
        }x.fx.animate(r(z, {modes:["fade:vertex"],onComplete:function() {
            C.removeEdge(y, {type:"nothing"});
            x.reposition();
            x.fx.animate(r(z, {modes:["linear"]}))
        }}));break;case"fade:con":C = this;for (A = 0; A < y.length; A++) {
            E = x.graph.getAdjacence(y[A][0], y[A][1]);
            if (E) {
                E[0].endAlpha = 0;
                E[0].ignore = true;
                E[1].endAlpha = 0;
                E[1].ignore = true
            }
        }x.reposition();x.fx.animate(r(z, {modes:["fade:vertex","linear"],onComplete:function() {
            C.removeEdge(y, {type:"nothing"})
        }}));break;case"iter":C = this;x.fx.sequence({condition:function() {
            return y.length != 0
        },step:function() {
            C.removeEdge(y.shift(), {type:"nothing"});
            x.fx.clearLabels()
        },onComplete:function() {
            z.onComplete()
        },duration:Math.ceil(z.duration / y.length)});break;default:this.doError()}
    },sum:function(E, y) {
        var C = this.viz;
        var F = r(this.options, C.controller, y),B = C.root;
        var A,D;
        C.root = y.id || C.root;
        switch (F.type) {case"nothing":D = C.construct(E);A = Graph.Util;A.eachNode(D, function(G) {
            A.eachAdjacency(G, function(H) {
                C.graph.addAdjacence(H.nodeFrom, H.nodeTo, H.data)
            })
        });break;case"replot":C.refresh(true);this.sum(E, {type:"nothing"});C.refresh(true);break;case"fade:seq":case"fade":case"fade:con":A = Graph.Util;that = this;D = C.construct(E);var x = this.preprocessSum(D);var z = !x ? ["fade:nodes"] : ["fade:nodes","fade:vertex"];C.reposition();if (F.type != "fade:con") {
            C.fx.animate(r(F, {modes:["linear"],onComplete:function() {
                C.fx.animate(r(F, {modes:z,onComplete:function() {
                    F.onComplete()
                }}))
            }}))
        } else {
            A.eachNode(C.graph, function(G) {
                if (G.id != B && G.pos.getp().equals(Polar.KER)) {
                    G.pos.set(G.endPos);
                    G.startPos.set(G.endPos)
                }
            });
            C.fx.animate(r(F, {modes:["linear"].concat(z)}))
        }break;default:this.doError()}
    },morph:function(E, y) {
        var C = this.viz;
        var F = r(this.options, C.controller, y),B = C.root;
        var A,D;
        C.root = y.id || C.root;
        switch (F.type) {case"nothing":D = C.construct(E);A = Graph.Util;A.eachNode(D, function(G) {
            A.eachAdjacency(G, function(H) {
                C.graph.addAdjacence(H.nodeFrom, H.nodeTo, H.data)
            })
        });A.eachNode(C.graph, function(G) {
            A.eachAdjacency(G, function(H) {
                if (!D.getAdjacence(H.nodeFrom.id, H.nodeTo.id)) {
                    C.graph.removeAdjacence(H.nodeFrom.id, H.nodeTo.id)
                }
            });
            if (!D.hasNode(G.id)) {
                C.graph.removeNode(G.id)
            }
        });break;case"replot":C.fx.clearLabels(true);this.morph(E, {type:"nothing"});C.refresh(true);C.refresh(true);break;case"fade:seq":case"fade":case"fade:con":A = Graph.Util;that = this;D = C.construct(E);var x = this.preprocessSum(D);A.eachNode(C.graph, function(G) {
            if (!D.hasNode(G.id)) {
                G.alpha = 1;
                G.startAlpha = 1;
                G.endAlpha = 0;
                G.ignore = true
            }
        });A.eachNode(C.graph, function(G) {
            if (G.ignore) {
                return
            }
            A.eachAdjacency(G, function(H) {
                if (H.nodeFrom.ignore || H.nodeTo.ignore) {
                    return
                }
                var I = D.getNode(H.nodeFrom.id);
                var J = D.getNode(H.nodeTo.id);
                if (!I.adjacentTo(J)) {
                    var K = C.graph.getAdjacence(I.id, J.id);
                    x = true;
                    K[0].alpha = 1;
                    K[0].startAlpha = 1;
                    K[0].endAlpha = 0;
                    K[0].ignore = true;
                    K[1].alpha = 1;
                    K[1].startAlpha = 1;
                    K[1].endAlpha = 0;
                    K[1].ignore = true
                }
            })
        });var z = !x ? ["fade:nodes"] : ["fade:nodes","fade:vertex"];C.reposition();A.eachNode(C.graph, function(G) {
            if (G.id != B && G.pos.getp().equals(Polar.KER)) {
                G.pos.set(G.endPos);
                G.startPos.set(G.endPos)
            }
        });C.fx.animate(r(F, {modes:["polar"].concat(z),onComplete:function() {
            A.eachNode(C.graph, function(G) {
                if (G.ignore) {
                    C.graph.removeNode(G.id)
                }
            });
            A.eachNode(C.graph, function(G) {
                A.eachAdjacency(G, function(H) {
                    if (H.ignore) {
                        C.graph.removeAdjacence(H.nodeFrom.id, H.nodeTo.id)
                    }
                })
            });
            F.onComplete()
        }}));break;default:this.doError()}
    },preprocessSum:function(z) {
        var x = this.viz;
        var y = Graph.Util;
        y.eachNode(z, function(B) {
            if (!x.graph.hasNode(B.id)) {
                x.graph.addNode(B);
                var C = x.graph.getNode(B.id);
                C.alpha = 0;
                C.startAlpha = 0;
                C.endAlpha = 1
            }
        });
        var A = false;
        y.eachNode(z, function(B) {
            y.eachAdjacency(B, function(C) {
                var D = x.graph.getNode(C.nodeFrom.id);
                var E = x.graph.getNode(C.nodeTo.id);
                if (!D.adjacentTo(E)) {
                    var F = x.graph.addAdjacence(D, E, C.data);
                    if (D.startAlpha == D.endAlpha && E.startAlpha == E.endAlpha) {
                        A = true;
                        F[0].alpha = 0;
                        F[0].startAlpha = 0;
                        F[0].endAlpha = 1;
                        F[1].alpha = 0;
                        F[1].startAlpha = 0;
                        F[1].endAlpha = 1
                    }
                }
            })
        });
        return A
    }};
    Graph.Plot = {Interpolator:{moebius:function(C, E, A) {
        if (E <= 1 || A.norm() <= 1) {
            var z = A.x,D = A.y;
            var B = C.startPos.getc().moebiusTransformation(A);
            C.pos.setc(B.x, B.y);
            A.x = z;
            A.y = D
        }
    },linear:function(x, A) {
        var z = x.startPos.getc(true);
        var y = x.endPos.getc(true);
        x.pos.setc((y.x - z.x) * A + z.x, (y.y - z.y) * A + z.y)
    },"fade:nodes":function(x, A) {
        if (A <= 1 && (x.endAlpha != x.alpha)) {
            var z = x.startAlpha;
            var y = x.endAlpha;
            x.alpha = z + (y - z) * A
        }
    },"fade:vertex":function(x, A) {
        var z = x.adjacencies;
        for (var y in z) {
            this["fade:nodes"](z[y], A)
        }
    },polar:function(y, B) {
        var A = y.startPos.getp(true);
        var z = y.endPos.getp();
        var x = z.interpolate(A, B);
        y.pos.setp(x.theta, x.rho)
    }},labelsHidden:false,labelContainer:false,labels:{},getLabelContainer:function() {
        return this.labelContainer ? this.labelContainer : this.labelContainer = document.getElementById(this.viz.config.labelContainer)
    },getLabel:function(x) {
        return(x in this.labels && this.labels[x] != null) ? this.labels[x] : this.labels[x] = document.getElementById(x)
    },hideLabels:function(y) {
        var x = this.getLabelContainer();
        if (y) {
            x.style.display = "none"
        } else {
            x.style.display = ""
        }
        this.labelsHidden = y
    },clearLabels:function(x) {
        for (var y in this.labels) {
            if (x || !this.viz.graph.hasNode(y)) {
                this.disposeLabel(y);
                delete this.labels[y]
            }
        }
    },disposeLabel:function(y) {
        var x = this.getLabel(y);
        if (x && x.parentNode) {
            x.parentNode.removeChild(x)
        }
    },hideLabel:function(B, x) {
        B = j(B);
        var y = x ? "" : "none",z,A = this;
        g(B, function(D) {
            var C = A.getLabel(D.id);
            if (C) {
                C.style.display = y
            }
        })
    },sequence:function(y) {
        var z = this;
        y = r({condition:m(false),step:b,onComplete:b,duration:200}, y || {});
        var x = setInterval(function() {
            if (y.condition()) {
                y.step()
            } else {
                clearInterval(x);
                y.onComplete()
            }
            z.viz.refresh(true)
        }, y.duration)
    },animate:function(z, y) {
        var B = this,x = this.viz,C = x.graph,A = Graph.Util;
        z = r(x.controller, z || {});
        if (z.hideLabels) {
            this.hideLabels(true)
        }
        this.animation.setOptions(r(z, {$animating:false,compute:function(E) {
            var D = y ? y.scale(-E) : null;
            A.eachNode(C, function(G) {
                for (var F = 0; F < z.modes.length; F++) {
                    B.Interpolator[z.modes[F]](G, E, D)
                }
            });
            B.plot(z, this.$animating);
            this.$animating = true
        },complete:function() {
            A.eachNode(C, function(D) {
                D.startPos.set(D.pos);
                D.startAlpha = D.alpha
            });
            if (z.hideLabels) {
                B.hideLabels(false)
            }
            B.plot(z);
            z.onComplete();
            z.onAfterCompute()
        }})).start()
    },plot:function(y, G) {
        var E = this.viz,B = E.graph,z = E.canvas,x = E.root,C = this,F = z.getCtx(),D = Graph.Util;
        y = y || this.viz.controller;
        y.clearCanvas && z.clear();
        var A = !!B.getNode(x).visited;
        D.eachNode(B, function(H) {
            D.eachAdjacency(H, function(I) {
                var J = I.nodeTo;
                if (!!J.visited === A && H.drawn && J.drawn) {
                    !G && y.onBeforePlotLine(I);
                    F.save();
                    F.globalAlpha = Math.min(Math.min(H.alpha, J.alpha), I.alpha);
                    C.plotLine(I, z, G);
                    F.restore();
                    !G && y.onAfterPlotLine(I)
                }
            });
            F.save();
            if (H.drawn) {
                F.globalAlpha = H.alpha;
                !G && y.onBeforePlotNode(H);
                C.plotNode(H, z, G);
                !G && y.onAfterPlotNode(H)
            }
            if (!C.labelsHidden && y.withLabels) {
                if (H.drawn && F.globalAlpha >= 0.95) {
                    C.plotLabel(z, H, y)
                } else {
                    C.hideLabel(H, false)
                }
            }
            F.restore();
            H.visited = !A
        })
    },plotLabel:function(A, B, z) {
        var C = B.id,x = this.getLabel(C);
        if (!x && !(x = document.getElementById(C))) {
            x = document.createElement("div");
            var y = this.getLabelContainer();
            y.appendChild(x);
            x.id = C;
            x.className = "node";
            x.style.position = "absolute";
            z.onCreateLabel(x, B);
            this.labels[B.id] = x
        }
        this.placeLabel(x, B, z)
    },plotNode:function(z, y, G) {
        var E = this.node,B = z.data;
        var D = E.overridable && B;
        var x = D && B.$lineWidth || E.lineWidth;
        var A = D && B.$color || E.color;
        var F = y.getCtx();
        F.lineWidth = x;
        F.fillStyle = A;
        F.strokeStyle = A;
        var C = z.data && z.data.$type || E.type;
        this.nodeTypes[C].call(this, z, y, G)
    },plotLine:function(E, z, G) {
        var x = this.edge,B = E.data;
        var D = x.overridable && B;
        var y = D && B.$lineWidth || x.lineWidth;
        var A = D && B.$color || x.color;
        var F = z.getCtx();
        F.lineWidth = y;
        F.fillStyle = A;
        F.strokeStyle = A;
        var C = E.data && E.data.$type || x.type;
        this.edgeTypes[C].call(this, E, z, G)
    },fitsInCanvas:function(z, x) {
        var y = x.getSize();
        if (z.x >= y.width || z.x < 0 || z.y >= y.height || z.y < 0) {
            return false
        }
        return true
    }};
    var Loader = {construct:function(y) {
        var z = (h(y) == "array");
        var x = new Graph(this.graphOptions);
        if (!z) {
            (function(A, C) {
                A.addNode(C);
                for (var B = 0,D = C.children; B < D.length; B++) {
                    A.addAdjacence(C, D[B]);
                    arguments.callee(A, D[B])
                }
            })(x, y)
        } else {
            (function(B, E) {
                var H = function(J) {
                    for (var I = 0; I < E.length; I++) {
                        if (E[I].id == J) {
                            return E[I]
                        }
                    }
                    return undefined
                };
                for (var D = 0; D < E.length; D++) {
                    B.addNode(E[D]);
                    for (var C = 0,A = E[D].adjacencies; C < A.length; C++) {
                        var F = A[C],G;
                        if (typeof A[C] != "string") {
                            G = F.data;
                            F = F.nodeTo
                        }
                        B.addAdjacence(E[D], H(F), G)
                    }
                }
            })(x, y)
        }
        return x
    },loadJSON:function(y, x) {
        this.json = y;
        this.graph = this.construct(y);
        if (h(y) != "array") {
            this.root = y.id
        } else {
            this.root = y[x ? x : 0].id
        }
    }};
    this.Trans = {linear:function(x) {
        return x
    }};
    (function() {
        var x = function(A, z) {
            z = j(z);
            return c(A, {easeIn:function(B) {
                return A(B, z)
            },easeOut:function(B) {
                return 1 - A(1 - B, z)
            },easeInOut:function(B) {
                return(B <= 0.5) ? A(2 * B, z) / 2 : (2 - A(2 * (1 - B), z)) / 2
            }})
        };
        var y = {Pow:function(A, z) {
            return Math.pow(A, z[0] || 6)
        },Expo:function(z) {
            return Math.pow(2, 8 * (z - 1))
        },Circ:function(z) {
            return 1 - Math.sin(Math.acos(z))
        },Sine:function(z) {
            return 1 - Math.sin((1 - z) * Math.PI / 2)
        },Back:function(A, z) {
            z = z[0] || 1.618;
            return Math.pow(A, 2) * ((z + 1) * A - z)
        },Bounce:function(C) {
            var B;
            for (var A = 0,z = 1; 1; A += z,z /= 2) {
                if (C >= (7 - 4 * A) / 11) {
                    B = z * z - Math.pow((11 - 6 * A - 11 * C) / 4, 2);
                    break
                }
            }
            return B
        },Elastic:function(A, z) {
            return Math.pow(2, 10 * --A) * Math.cos(20 * A * Math.PI * (z[0] || 1) / 3)
        }};
        g(y, function(A, z) {
            Trans[z] = x(A)
        });
        g(["Quad","Cubic","Quart","Quint"], function(A, z) {
            Trans[A] = x(function(B) {
                return Math.pow(B, [z + 2])
            })
        })
    })();
    var Animation = new o({initalize:function(x) {
        this.setOptions(x)
    },setOptions:function(x) {
        var y = {duration:2500,fps:40,transition:Trans.Quart.easeInOut,compute:b,complete:b};
        this.opt = r(y, x || {});
        return this
    },getTime:function() {
        return k()
    },step:function() {
        var y = this.getTime(),x = this.opt;
        if (y < this.time + x.duration) {
            var z = x.transition((y - this.time) / x.duration);
            x.compute(z)
        } else {
            this.timer = clearInterval(this.timer);
            x.compute(1);
            x.complete()
        }
    },start:function() {
        this.time = 0;
        this.startTimer();
        return this
    },startTimer:function() {
        var y = this,x = this.opt;
        if (this.timer) {
            return false
        }
        this.time = this.getTime() - this.time;
        this.timer = setInterval((function() {
            y.step()
        }), Math.round(1000 / x.fps));
        return true
    }});
    (function() {
        var G = Array.prototype.slice;

        function E(Q, K, I, O) {
            var M = K.Node,N = Graph.Util;
            var J = K.multitree;
            if (M.overridable) {
                var P = -1,L = -1;
                N.eachNode(Q, function(T) {
                    if (T._depth == I && (!J || ("$orn" in T.data) && T.data.$orn == O)) {
                        var R = T.data.$width || M.width;
                        var S = T.data.$height || M.height;
                        P = (P < R) ? R : P;
                        L = (L < S) ? S : L
                    }
                });
                return{width:P < 0 ? M.width : P,height:L < 0 ? M.height : L}
            } else {
                return M
            }
        }

        function H(J, M, L, I) {
            var K = (I == "left" || I == "right") ? "y" : "x";
            J[M][K] += L
        }

        function C(J, K) {
            var I = [];
            g(J, function(L) {
                L = G.call(L);
                L[0] += K;
                L[1] += K;
                I.push(L)
            });
            return I
        }

        function F(L, I) {
            if (L.length == 0) {
                return I
            }
            if (I.length == 0) {
                return L
            }
            var K = L.shift(),J = I.shift();
            return[
                [K[0],J[1]]
            ].concat(F(L, I))
        }

        function A(I, J) {
            J = J || [];
            if (I.length == 0) {
                return J
            }
            var K = I.pop();
            return A(I, F(K, J))
        }

        function D(L, J, M, I, K) {
            if (L.length <= K || J.length <= K) {
                return 0
            }
            var O = L[K][1],N = J[K][0];
            return Math.max(D(L, J, M, I, ++K) + M, O - N + I)
        }

        function B(L, J, I) {
            function K(O, Q, N) {
                if (Q.length <= N) {
                    return[]
                }
                var P = Q[N],M = D(O, P, J, I, 0);
                return[M].concat(K(F(O, C(P, M)), Q, ++N))
            }

            return K([], L, 0)
        }

        function y(M, L, K) {
            function I(P, R, O) {
                if (R.length <= O) {
                    return[]
                }
                var Q = R[O],N = -D(Q, P, L, K, 0);
                return[N].concat(I(F(C(Q, N), P), R, ++O))
            }

            M = G.call(M);
            var J = I([], M.reverse(), 0);
            return J.reverse()
        }

        function x(O, M, J, P) {
            var K = B(O, M, J),N = y(O, M, J);
            if (P == "left") {
                N = K
            } else {
                if (P == "right") {
                    K = N
                }
            }
            for (var L = 0,I = []; L < K.length; L++) {
                I[L] = (K[L] + N[L]) / 2
            }
            return I
        }

        function z(J, T, K, aa, Y) {
            var M = aa.multitree;
            var S = ["x","y"],P = ["width","height"];
            var L = +(Y == "left" || Y == "right");
            var Q = S[L],Z = S[1 - L];
            var V = aa.Node;
            var O = P[L],X = P[1 - L];
            var N = aa.siblingOffset;
            var W = aa.subtreeOffset;
            var U = aa.align;
            var I = Graph.Util;

            function R(ad, ah, al) {
                var ac = (V.overridable && ad.data["$" + O]) || V[O];
                var ak = ah || ((V.overridable && ad.data["$" + X]) || V[X]);
                var ao = [],am = [],ai = false;
                var ab = ak + aa.levelDistance;
                I.eachSubnode(ad, function(aq) {
                    if (aq.exist && (!M || ("$orn" in aq.data) && aq.data.$orn == Y)) {
                        if (!ai) {
                            ai = E(J, aa, aq._depth, Y)
                        }
                        var ap = R(aq, ai[X], al + ab);
                        ao.push(ap.tree);
                        am.push(ap.extent)
                    }
                });
                var ag = x(am, W, N, U);
                for (var af = 0,ae = [],aj = []; af < ao.length; af++) {
                    H(ao[af], K, ag[af], Y);
                    aj.push(C(am[af], ag[af]))
                }
                var an = [
                    [-ac / 2,ac / 2]
                ].concat(A(aj));
                ad[K][Q] = 0;
                if (Y == "top" || Y == "left") {
                    ad[K][Z] = al
                } else {
                    ad[K][Z] = -al
                }
                return{tree:ad,extent:an}
            }

            R(T, false, 0)
        }

        this.ST = (function() {
            var J = [];

            function K(P) {
                P = P || this.clickedNode;
                var M = this.geom,T = Graph.Util;
                var U = this.graph;
                var N = this.canvas;
                var L = P._depth,Q = [];
                T.eachNode(U, function(V) {
                    if (V.exist && !V.selected) {
                        if (T.isDescendantOf(V, P.id)) {
                            if (V._depth <= L) {
                                Q.push(V)
                            }
                        } else {
                            Q.push(V)
                        }
                    }
                });
                var R = M.getRightLevelToShow(P, N);
                T.eachLevel(P, R, R, function(V) {
                    if (V.exist && !V.selected) {
                        Q.push(V)
                    }
                });
                for (var S = 0; S < J.length; S++) {
                    var O = this.graph.getNode(J[S]);
                    if (!T.isDescendantOf(O, P.id)) {
                        Q.push(O)
                    }
                }
                return Q
            }

            function I(O) {
                var N = [],M = Graph.Util,L = this.config;
                O = O || this.clickedNode;
                M.eachLevel(this.clickedNode, 0, L.levelsToShow, function(P) {
                    if (L.multitree && !("$orn" in P.data) && M.anySubnode(P, function(Q) {
                        return Q.exist && !Q.drawn
                    })) {
                        N.push(P)
                    } else {
                        if (P.drawn && !M.anySubnode(P, "drawn")) {
                            N.push(P)
                        }
                    }
                });
                return N
            }

            return new o({Implements:Loader,initialize:function(O, L) {
                var M = {onBeforeCompute:b,onAfterCompute:b,onCreateLabel:b,onPlaceLabel:b,onComplete:b,onBeforePlotNode:b,onAfterPlotNode:b,onBeforePlotLine:b,onAfterPlotLine:b,request:false};
                var N = {orientation:"left",labelContainer:O.id + "-label",levelsToShow:2,subtreeOffset:8,siblingOffset:5,levelDistance:30,withLabels:true,clearCanvas:true,align:"center",indent:10,multitree:false,constrained:true,Node:{overridable:false,type:"rectangle",color:"#ccb",lineWidth:1,height:20,width:90,dim:15,align:"center"},Edge:{overridable:false,type:"line",color:"#ccc",dim:15,lineWidth:1},duration:700,fps:25,transition:Trans.Quart.easeInOut};
                this.controller = this.config = r(N, M, L);
                this.canvas = O;
                this.graphOptions = {complex:true};
                this.graph = new Graph(this.graphOptions);
                this.fx = new ST.Plot(this);
                this.op = new ST.Op(this);
                this.group = new ST.Group(this);
                this.geom = new ST.Geom(this);
                this.clickedNode = null
            },plot:function() {
                this.fx.plot(this.controller)
            },switchPosition:function(Q, P, O) {
                var L = this.geom,M = this.fx,N = this;
                if (!M.busy) {
                    M.busy = true;
                    this.contract({onComplete:function() {
                        L.switchOrientation(Q);
                        N.compute("endPos", false);
                        M.busy = false;
                        if (P == "animate") {
                            N.onClick(N.clickedNode.id, O)
                        } else {
                            if (P == "replot") {
                                N.select(N.clickedNode.id, O)
                            }
                        }
                    }}, Q)
                }
            },switchAlignment:function(N, M, L) {
                this.config.align = N;
                if (M == "animate") {
                    this.select(this.clickedNode.id, L)
                } else {
                    if (M == "replot") {
                        this.onClick(this.clickedNode.id, L)
                    }
                }
            },addNodeInPath:function(L) {
                J.push(L);
                this.select((this.clickedNode && this.clickedNode.id) || this.root)
            },clearNodesInPath:function(L) {
                J.length = 0;
                this.select((this.clickedNode && this.clickedNode.id) || this.root)
            },refresh:function() {
                this.reposition();
                this.select((this.clickedNode && this.clickedNode.id) || this.root)
            },reposition:function() {
                Graph.Util.computeLevels(this.graph, this.root, 0, "ignore");
                this.geom.setRightLevelToShow(this.clickedNode, this.canvas);
                Graph.Util.eachNode(this.graph, function(L) {
                    if (L.exist) {
                        L.drawn = true
                    }
                });
                this.compute("endPos")
            },compute:function(N, M) {
                var O = N || "startPos";
                var L = this.graph.getNode(this.root);
                c(L, {drawn:true,exist:true,selected:true});
                if (!!M || !("_depth" in L)) {
                    Graph.Util.computeLevels(this.graph, this.root, 0, "ignore")
                }
                this.computePositions(L, O)
            },computePositions:function(P, L) {
                var N = this.config;
                var M = N.multitree;
                var S = N.align;
                var O = S !== "center" && N.indent;
                var T = N.orientation;
                var R = M ? ["top","right","bottom","left"] : [T];
                var Q = this;
                g(R, function(U) {
                    z(Q.graph, P, L, Q.config, U);
                    var V = ["x","y"][+(U == "left" || U == "right")];
                    (function W(X) {
                        Graph.Util.eachSubnode(X, function(Y) {
                            if (Y.exist && (!M || ("$orn" in Y.data) && Y.data.$orn == U)) {
                                Y[L][V] += X[L][V];
                                if (O) {
                                    Y[L][V] += S == "left" ? O : -O
                                }
                                W(Y)
                            }
                        })
                    })(P)
                })
            },requestNodes:function(O, P) {
                var M = r(this.controller, P),L = this.config.levelsToShow,N = Graph.Util;
                if (M.request) {
                    var R = [],Q = O._depth;
                    N.eachLevel(O, 0, L, function(S) {
                        if (S.drawn && !N.anySubnode(S)) {
                            R.push(S);
                            S._level = L - (S._depth - Q)
                        }
                    });
                    this.group.requestNodes(R, M)
                } else {
                    M.onComplete()
                }
            },contract:function(P, Q) {
                var O = this.config.orientation;
                var L = this.geom,N = this.group;
                if (Q) {
                    L.switchOrientation(Q)
                }
                var M = K.call(this);
                if (Q) {
                    L.switchOrientation(O)
                }
                N.contract(M, r(this.controller, P))
            },move:function(M, N) {
                this.compute("endPos", false);
                var L = N.Move,O = {x:L.offsetX,y:L.offsetY};
                if (L.enable) {
                    this.geom.translate(M.endPos.add(O).$scale(-1), "endPos")
                }
                this.fx.animate(r(this.controller, {modes:["linear"]}, N))
            },expand:function(M, N) {
                var L = I.call(this, M);
                this.group.expand(L, r(this.controller, N))
            },selectPath:function(P) {
                var O = Graph.Util,N = this;
                O.eachNode(this.graph, function(R) {
                    R.selected = false
                });
                function Q(S) {
                    if (S == null || S.selected) {
                        return
                    }
                    S.selected = true;
                    g(N.group.getSiblings([S])[S.id], function(T) {
                        T.exist = true;
                        T.drawn = true
                    });
                    var R = O.getParents(S);
                    R = (R.length > 0) ? R[0] : null;
                    Q(R)
                }

                for (var L = 0,M = [P.id].concat(J); L < M.length; L++) {
                    Q(this.graph.getNode(M[L]))
                }
            },setRoot:function(S, R, Q) {
                var P = this,N = this.canvas;
                var L = this.graph.getNode(this.root);
                var M = this.graph.getNode(S);

                function O() {
                    if (this.config.multitree && M.data.$orn) {
                        var U = M.data.$orn;
                        var V = {left:"right",right:"left",top:"bottom",bottom:"top"}[U];
                        L.data.$orn = V;
                        (function T(W) {
                            Graph.Util.eachSubnode(W, function(X) {
                                if (X.id != S) {
                                    X.data.$orn = V;
                                    T(X)
                                }
                            })
                        })(L);
                        delete M.data.$orn
                    }
                    this.root = S;
                    this.clickedNode = M;
                    Graph.Util.computeLevels(this.graph, this.root, 0, "ignore")
                }

                delete L.data.$orns;
                if (R == "animate") {
                    this.onClick(S, {onBeforeMove:function() {
                        O.call(P);
                        P.selectPath(M)
                    }})
                } else {
                    if (R == "replot") {
                        O.call(this);
                        this.select(this.root)
                    }
                }
            },addSubtree:function(L, N, M) {
                if (N == "replot") {
                    this.op.sum(L, c({type:"replot"}, M || {}))
                } else {
                    if (N == "animate") {
                        this.op.sum(L, c({type:"fade:seq"}, M || {}))
                    }
                }
            },removeSubtree:function(Q, M, P, O) {
                var N = this.graph.getNode(Q),L = [];
                Graph.Util.eachLevel(N, +!M, false, function(R) {
                    L.push(R.id)
                });
                if (P == "replot") {
                    this.op.removeNode(L, c({type:"replot"}, O || {}))
                } else {
                    if (P == "animate") {
                        this.op.removeNode(L, c({type:"fade:seq"}, O || {}))
                    }
                }
            },select:function(L, O) {
                var T = this.group,R = this.geom;
                var P = this.graph.getNode(L),N = this.canvas;
                var S = this.graph.getNode(this.root);
                var M = r(this.controller, O);
                var Q = this;
                M.onBeforeCompute(P);
                this.selectPath(P);
                this.clickedNode = P;
                this.requestNodes(P, {onComplete:function() {
                    T.hide(T.prepare(K.call(Q)), M);
                    R.setRightLevelToShow(P, N);
                    Q.compute("pos");
                    Graph.Util.eachNode(Q.graph, function(V) {
                        var U = V.pos.getc(true);
                        V.startPos.setc(U.x, U.y);
                        V.endPos.setc(U.x, U.y);
                        V.visited = false
                    });
                    Q.geom.translate(P.endPos.scale(-1), ["pos","startPos","endPos"]);
                    T.show(I.call(Q));
                    Q.plot();
                    M.onAfterCompute(Q.clickedNode);
                    M.onComplete()
                }})
            },onClick:function(N, U) {
                var O = this.canvas,S = this,R = this.fx,T = Graph.Util,L = this.geom;
                var Q = {Move:{enable:true,offsetX:0,offsetY:0},onBeforeRequest:b,onBeforeContract:b,onBeforeMove:b,onBeforeExpand:b};
                var M = r(this.controller, Q, U);
                if (!this.busy) {
                    this.busy = true;
                    var P = this.graph.getNode(N);
                    this.selectPath(P, this.clickedNode);
                    this.clickedNode = P;
                    M.onBeforeCompute(P);
                    M.onBeforeRequest(P);
                    this.requestNodes(P, {onComplete:function() {
                        M.onBeforeContract(P);
                        S.contract({onComplete:function() {
                            L.setRightLevelToShow(P, O);
                            M.onBeforeMove(P);
                            S.move(P, {Move:M.Move,onComplete:function() {
                                M.onBeforeExpand(P);
                                S.expand(P, {onComplete:function() {
                                    S.busy = false;
                                    M.onAfterCompute(N);
                                    M.onComplete()
                                }})
                            }})
                        }})
                    }})
                }
            }})
        })();
        ST.Op = new o({Implements:Graph.Op,initialize:function(I) {
            this.viz = I
        }});
        ST.Group = new o({initialize:function(I) {
            this.viz = I;
            this.canvas = I.canvas;
            this.config = I.config;
            this.animation = new Animation;
            this.nodes = null
        },requestNodes:function(N, M) {
            var L = 0,J = N.length,P = {};
            var K = function() {
                M.onComplete()
            };
            var I = this.viz;
            if (J == 0) {
                K()
            }
            for (var O = 0; O < J; O++) {
                P[N[O].id] = N[O];
                M.request(N[O].id, N[O]._level, {onComplete:function(R, Q) {
                    if (Q && Q.children) {
                        Q.id = R;
                        I.op.sum(Q, {type:"nothing"})
                    }
                    if (++L == J) {
                        Graph.Util.computeLevels(I.graph, I.root, 0);
                        K()
                    }
                }})
            }
        },contract:function(K, J) {
            var M = Graph.Util;
            var I = this.viz;
            var L = this;
            K = this.prepare(K);
            this.animation.setOptions(r(J, {$animating:false,compute:function(N) {
                if (N == 1) {
                    N = 0.99
                }
                L.plotStep(1 - N, J, this.$animating);
                this.$animating = "contract"
            },complete:function() {
                L.hide(K, J)
            }})).start()
        },hide:function(K, J) {
            var N = Graph.Util,I = this.viz;
            for (var L = 0; L < K.length; L++) {
                if (true || !J || !J.request) {
                    N.eachLevel(K[L], 1, false, function(O) {
                        if (O.exist) {
                            c(O, {drawn:false,exist:false})
                        }
                    })
                } else {
                    var M = [];
                    N.eachLevel(K[L], 1, false, function(O) {
                        M.push(O.id)
                    });
                    I.op.removeNode(M, {type:"nothing"});
                    I.fx.clearLabels()
                }
            }
            J.onComplete()
        },expand:function(J, I) {
            var L = this,K = Graph.Util;
            this.show(J);
            this.animation.setOptions(r(I, {$animating:false,compute:function(M) {
                L.plotStep(M, I, this.$animating);
                this.$animating = "expand"
            },complete:function() {
                L.plotStep(undefined, I, false);
                I.onComplete()
            }})).start()
        },show:function(I) {
            var K = Graph.Util,J = this.config;
            this.prepare(I);
            g(I, function(M) {
                if (J.multitree && !("$orn" in M.data)) {
                    delete M.data.$orns;
                    var L = " ";
                    K.eachSubnode(M, function(N) {
                        if (("$orn" in N.data) && L.indexOf(N.data.$orn) < 0 && N.exist && !N.drawn) {
                            L += N.data.$orn + " "
                        }
                    });
                    M.data.$orns = L
                }
                K.eachLevel(M, 0, J.levelsToShow, function(N) {
                    if (N.exist) {
                        N.drawn = true
                    }
                })
            })
        },prepare:function(I) {
            this.nodes = this.getNodesWithChildren(I);
            return this.nodes
        },getNodesWithChildren:function(K) {
            var J = [],O = Graph.Util,M = this.config,I = this.viz.root;
            K.sort(function(R, Q) {
                return(R._depth <= Q._depth) - (R._depth >= Q._depth)
            });
            for (var N = 0; N < K.length; N++) {
                if (O.anySubnode(K[N], "exist")) {
                    for (var L = N + 1,P = false; !P && L < K.length; L++) {
                        if (!M.multitree || "$orn" in K[L].data) {
                            P = P || O.isDescendantOf(K[N], K[L].id)
                        }
                    }
                    if (!P) {
                        J.push(K[N])
                    }
                }
            }
            return J
        },plotStep:function(T, O, V) {
            var S = this.viz,L = this.config,K = S.canvas,U = K.getCtx(),I = this.nodes,Q = Graph.Util;
            var N,M;
            var J = {};
            for (N = 0; N < I.length; N++) {
                M = I[N];
                J[M.id] = [];
                var R = L.multitree && !("$orn" in M.data);
                var P = R && M.data.$orns;
                Q.eachSubgraph(M, function(W) {
                    if (R && P && P.indexOf(W.data.$orn) > 0 && W.drawn) {
                        W.drawn = false;
                        J[M.id].push(W)
                    } else {
                        if ((!R || !P) && W.drawn) {
                            W.drawn = false;
                            J[M.id].push(W)
                        }
                    }
                });
                M.drawn = true
            }
            if (I.length > 0) {
                S.fx.plot()
            }
            for (N in J) {
                g(J[N], function(W) {
                    W.drawn = true
                })
            }
            for (N = 0; N < I.length; N++) {
                M = I[N];
                U.save();
                S.fx.plotSubtree(M, O, T, V);
                U.restore()
            }
        },getSiblings:function(I) {
            var K = {},J = Graph.Util;
            g(I, function(N) {
                var M = J.getParents(N);
                if (M.length == 0) {
                    K[N.id] = [N]
                } else {
                    var L = [];
                    J.eachSubnode(M[0], function(O) {
                        L.push(O)
                    });
                    K[N.id] = L
                }
            });
            return K
        }});
        ST.Geom = new o({initialize:function(I) {
            this.viz = I;
            this.config = I.config;
            this.node = I.config.Node;
            this.edge = I.config.Edge
        },translate:function(J, I) {
            I = j(I);
            Graph.Util.eachNode(this.viz.graph, function(K) {
                g(I, function(L) {
                    K[L].$add(J)
                })
            })
        },switchOrientation:function(I) {
            this.config.orientation = I
        },dispatch:function() {
            var J = Array.prototype.slice.call(arguments);
            var K = J.shift(),I = J.length;
            var L = function(M) {
                return typeof M == "function" ? M() : M
            };
            if (I == 2) {
                return(K == "top" || K == "bottom") ? L(J[0]) : L(J[1])
            } else {
                if (I == 4) {
                    switch (K) {case"top":return L(J[0]);case"right":return L(J[1]);case"bottom":return L(J[2]);case"left":return L(J[3])}
                }
            }
            return undefined
        },getSize:function(J, I) {
            var L = this.node,M = J.data,K = this.config;
            var O = L.overridable,P = K.siblingOffset;
            var R = (this.config.multitree && ("$orn" in J.data) && J.data.$orn) || this.config.orientation;
            var Q = (O && M.$width || L.width) + P;
            var N = (O && M.$height || L.height) + P;
            if (!I) {
                return this.dispatch(R, N, Q)
            } else {
                return this.dispatch(R, Q, N)
            }
        },getTreeBaseSize:function(M, N, J) {
            var K = this.getSize(M, true),I = 0,L = this;
            if (J(N, M)) {
                return K
            }
            if (N === 0) {
                return 0
            }
            Graph.Util.eachSubnode(M, function(O) {
                I += L.getTreeBaseSize(O, N - 1, J)
            });
            return(K > I ? K : I) + this.config.subtreeOffset
        },getEdge:function(I, N, Q) {
            var M = function(S, R) {
                return function() {
                    return I.pos.add(new Complex(S, R))
                }
            };
            var L = this.node;
            var O = this.node.overridable,J = I.data;
            var P = O && J.$width || L.width;
            var K = O && J.$height || L.height;
            if (N == "begin") {
                if (L.align == "center") {
                    return this.dispatch(Q, M(0, K / 2), M(-P / 2, 0), M(0, -K / 2), M(P / 2, 0))
                } else {
                    if (L.align == "left") {
                        return this.dispatch(Q, M(0, K), M(0, 0), M(0, 0), M(P, 0))
                    } else {
                        if (L.align == "right") {
                            return this.dispatch(Q, M(0, 0), M(-P, 0), M(0, -K), M(0, 0))
                        } else {
                            throw"align: not implemented"
                        }
                    }
                }
            } else {
                if (N == "end") {
                    if (L.align == "center") {
                        return this.dispatch(Q, M(0, -K / 2), M(P / 2, 0), M(0, K / 2), M(-P / 2, 0))
                    } else {
                        if (L.align == "left") {
                            return this.dispatch(Q, M(0, 0), M(P, 0), M(0, K), M(0, 0))
                        } else {
                            if (L.align == "right") {
                                return this.dispatch(Q, M(0, -K), M(0, 0), M(0, 0), M(-P, 0))
                            } else {
                                throw"align: not implemented"
                            }
                        }
                    }
                }
            }
        },getScaledTreePosition:function(I, J) {
            var L = this.node;
            var O = this.node.overridable,K = I.data;
            var P = (O && K.$width || L.width);
            var M = (O && K.$height || L.height);
            var Q = (this.config.multitree && ("$orn" in I.data) && I.data.$orn) || this.config.orientation;
            var N = function(S, R) {
                return function() {
                    return I.pos.add(new Complex(S, R)).$scale(1 - J)
                }
            };
            if (L.align == "left") {
                return this.dispatch(Q, N(0, M), N(0, 0), N(0, 0), N(P, 0))
            } else {
                if (L.align == "center") {
                    return this.dispatch(Q, N(0, M / 2), N(-P / 2, 0), N(0, -M / 2), N(P / 2, 0))
                } else {
                    if (L.align == "right") {
                        return this.dispatch(Q, N(0, 0), N(-P, 0), N(0, -M), N(0, 0))
                    } else {
                        throw"align: not implemented"
                    }
                }
            }
        },treeFitsInCanvas:function(N, I, O) {
            var K = I.getSize(N);
            var L = (this.config.multitree && ("$orn" in N.data) && N.data.$orn) || this.config.orientation;
            var J = this.dispatch(L, K.width, K.height);
            var M = this.getTreeBaseSize(N, O, function(Q, P) {
                return Q === 0 || !Graph.Util.anySubnode(P)
            });
            return(M < J)
        },setRightLevelToShow:function(K, I) {
            var L = this.getRightLevelToShow(K, I),J = this.viz.fx;
            Graph.Util.eachLevel(K, 0, this.config.levelsToShow, function(N) {
                var M = N._depth - K._depth;
                if (M > L) {
                    N.drawn = false;
                    N.exist = false;
                    J.hideLabel(N, false)
                } else {
                    N.exist = true
                }
            });
            K.drawn = true
        },getRightLevelToShow:function(L, J) {
            var I = this.config;
            var M = I.levelsToShow;
            var K = I.constrained;
            if (!K) {
                return M
            }
            while (!this.treeFitsInCanvas(L, J, M) && M > 1) {
                M--
            }
            return M
        }});
        ST.Plot = new o({Implements:Graph.Plot,initialize:function(I) {
            this.viz = I;
            this.config = I.config;
            this.node = this.config.Node;
            this.edge = this.config.Edge;
            this.animation = new Animation;
            this.nodeTypes = new ST.Plot.NodeTypes;
            this.edgeTypes = new ST.Plot.EdgeTypes
        },plotSubtree:function(N, M, P, K) {
            var I = this.viz,L = I.canvas;
            P = Math.min(Math.max(0.001, P), 1);
            if (P >= 0) {
                N.drawn = false;
                var J = L.getCtx();
                var O = I.geom.getScaledTreePosition(N, P);
                J.translate(O.x, O.y);
                J.scale(P, P)
            }
            this.plotTree(N, !P, M, K);
            if (P >= 0) {
                N.drawn = true
            }
        },plotTree:function(L, M, I, S) {
            var O = this,Q = this.viz,J = Q.canvas,K = this.config,R = J.getCtx();
            var P = K.multitree && !("$orn" in L.data);
            var N = P && L.data.$orns;
            Graph.Util.eachSubnode(L, function(U) {
                if ((!P || N.indexOf(U.data.$orn) > 0) && U.exist && U.drawn) {
                    var T = L.getAdjacency(U.id);
                    !S && I.onBeforePlotLine(T);
                    R.globalAlpha = Math.min(L.alpha, U.alpha);
                    O.plotLine(T, J, S);
                    !S && I.onAfterPlotLine(T);
                    O.plotTree(U, M, I, S)
                }
            });
            if (L.drawn) {
                R.globalAlpha = L.alpha;
                !S && I.onBeforePlotNode(L);
                this.plotNode(L, J, S);
                !S && I.onAfterPlotNode(L);
                if (M && R.globalAlpha >= 0.95) {
                    this.plotLabel(J, L, I)
                } else {
                    this.hideLabel(L, false)
                }
            } else {
                this.hideLabel(L, true)
            }
        },placeLabel:function(T, L, O) {
            var R = L.pos.getc(true),M = this.node,J = this.viz.canvas;
            var S = M.overridable && L.data.$width || M.width;
            var N = M.overridable && L.data.$height || M.height;
            var P = J.getSize();
            var K,Q;
            if (M.align == "center") {
                K = {x:Math.round(R.x - S / 2 + P.width / 2),y:Math.round(R.y - N / 2 + P.height / 2)}
            } else {
                if (M.align == "left") {
                    Q = this.config.orientation;
                    if (Q == "bottom" || Q == "top") {
                        K = {x:Math.round(R.x - S / 2 + P.width / 2),y:Math.round(R.y + P.height / 2)}
                    } else {
                        K = {x:Math.round(R.x + P.width / 2),y:Math.round(R.y - N / 2 + P.height / 2)}
                    }
                } else {
                    if (M.align == "right") {
                        Q = this.config.orientation;
                        if (Q == "bottom" || Q == "top") {
                            K = {x:Math.round(R.x - S / 2 + P.width / 2),y:Math.round(R.y - N + P.height / 2)}
                        } else {
                            K = {x:Math.round(R.x - S + P.width / 2),y:Math.round(R.y - N / 2 + P.height / 2)}
                        }
                    } else {
                        throw"align: not implemented"
                    }
                }
            }
            var I = T.style;
            I.left = K.x + "px";
            I.top = K.y + "px";
            I.display = this.fitsInCanvas(K, J) ? "" : "none";
            O.onPlaceLabel(T, L)
        },getAlignedPos:function(N, L, I) {
            var K = this.node;
            var M,J;
            if (K.align == "center") {
                M = {x:N.x - L / 2,y:N.y - I / 2}
            } else {
                if (K.align == "left") {
                    J = this.config.orientation;
                    if (J == "bottom" || J == "top") {
                        M = {x:N.x - L / 2,y:N.y}
                    } else {
                        M = {x:N.x,y:N.y - I / 2}
                    }
                } else {
                    if (K.align == "right") {
                        J = this.config.orientation;
                        if (J == "bottom" || J == "top") {
                            M = {x:N.x - L / 2,y:N.y - I}
                        } else {
                            M = {x:N.x - L,y:N.y - I / 2}
                        }
                    } else {
                        throw"align: not implemented"
                    }
                }
            }
            return M
        },getOrientation:function(I) {
            var K = this.config;
            var J = K.orientation;
            if (K.multitree) {
                var L = I.nodeFrom;
                var M = I.nodeTo;
                J = (("$orn" in L.data) && L.data.$orn) || (("$orn" in M.data) && M.data.$orn)
            }
            return J
        }});
        ST.Plot.NodeTypes = new o({none:function() {
        },circle:function(M, J) {
            var P = M.pos.getc(true),L = this.node,N = M.data;
            var K = L.overridable && N;
            var O = K && N.$dim || L.dim;
            var I = this.getAlignedPos(P, O * 2, O * 2);
            J.path("fill", function(Q) {
                Q.arc(I.x + O, I.y + O, O, 0, Math.PI * 2, true)
            })
        },square:function(M, J) {
            var P = M.pos.getc(true),L = this.node,N = M.data;
            var K = L.overridable && N;
            var O = K && N.$dim || L.dim;
            var I = this.getAlignedPos(P, O, O);
            J.getCtx().fillRect(I.x, I.y, O, O)
        },ellipse:function(K, J) {
            var N = K.pos.getc(true),O = this.node,L = K.data;
            var M = O.overridable && L;
            var I = (M && L.$width || O.width) / 2;
            var Q = (M && L.$height || O.height) / 2;
            var P = this.getAlignedPos(N, I * 2, Q * 2);
            var R = J.getCtx();
            R.save();
            R.scale(I / Q, Q / I);
            J.path("fill", function(S) {
                S.arc((P.x + I) * (Q / I), (P.y + Q) * (I / Q), Q, 0, Math.PI * 2, true)
            });
            R.restore()
        },rectangle:function(K, J) {
            var N = K.pos.getc(true),O = this.node,L = K.data;
            var M = O.overridable && L;
            var I = M && L.$width || O.width;
            var Q = M && L.$height || O.height;
            var P = this.getAlignedPos(N, I, Q);
            J.getCtx().fillRect(P.x, P.y, I, Q)
        }});
        ST.Plot.EdgeTypes = new o({none:function() {
        },line:function(J, L) {
            var K = this.getOrientation(J);
            var N = J.nodeFrom,O = J.nodeTo;
            var M = this.viz.geom.getEdge(N._depth < O._depth ? N : O, "begin", K);
            var I = this.viz.geom.getEdge(N._depth < O._depth ? O : N, "end", K);
            L.path("stroke", function(P) {
                P.moveTo(M.x, M.y);
                P.lineTo(I.x, I.y)
            })
        },"quadratic:begin":function(R, J) {
            var Q = this.getOrientation(R);
            var M = R.data,I = this.edge;
            var O = R.nodeFrom,S = R.nodeTo;
            var K = this.viz.geom.getEdge(O._depth < S._depth ? O : S, "begin", Q);
            var L = this.viz.geom.getEdge(O._depth < S._depth ? S : O, "end", Q);
            var P = I.overridable && M;
            var N = P && M.$dim || I.dim;
            switch (Q) {case"left":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(K.x + N, K.y, L.x, L.y)
            });break;case"right":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(K.x - N, K.y, L.x, L.y)
            });break;case"top":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(K.x, K.y + N, L.x, L.y)
            });break;case"bottom":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(K.x, K.y - N, L.x, L.y)
            });break}
        },"quadratic:end":function(R, J) {
            var Q = this.getOrientation(R);
            var M = R.data,I = this.edge;
            var O = R.nodeFrom,S = R.nodeTo;
            var K = this.viz.geom.getEdge(O._depth < S._depth ? O : S, "begin", Q);
            var L = this.viz.geom.getEdge(O._depth < S._depth ? S : O, "end", Q);
            var P = I.overridable && M;
            var N = P && M.$dim || I.dim;
            switch (Q) {case"left":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(L.x - N, L.y, L.x, L.y)
            });break;case"right":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(L.x + N, L.y, L.x, L.y)
            });break;case"top":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(L.x, L.y - N, L.x, L.y)
            });break;case"bottom":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.quadraticCurveTo(L.x, L.y + N, L.x, L.y)
            });break}
        },bezier:function(R, J) {
            var M = R.data,I = this.edge;
            var Q = this.getOrientation(R);
            var O = R.nodeFrom,S = R.nodeTo;
            var K = this.viz.geom.getEdge(O._depth < S._depth ? O : S, "begin", Q);
            var L = this.viz.geom.getEdge(O._depth < S._depth ? S : O, "end", Q);
            var P = I.overridable && M;
            var N = P && M.$dim || I.dim;
            switch (Q) {case"left":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.bezierCurveTo(K.x + N, K.y, L.x - N, L.y, L.x, L.y)
            });break;case"right":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.bezierCurveTo(K.x - N, K.y, L.x + N, L.y, L.x, L.y)
            });break;case"top":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.bezierCurveTo(K.x, K.y + N, L.x, L.y - N, L.x, L.y)
            });break;case"bottom":J.path("stroke", function(T) {
                T.moveTo(K.x, K.y);
                T.bezierCurveTo(K.x, K.y - N, L.x, L.y + N, L.x, L.y)
            });break}
        },arrow:function(Q, L) {
            var W = this.getOrientation(Q);
            var U = Q.nodeFrom,M = Q.nodeTo;
            var Z = Q.data,P = this.edge;
            var R = P.overridable && Z;
            var O = R && Z.$dim || P.dim;
            if (R && Z.$direction && Z.$direction.length > 1) {
                var K = {};
                K[U.id] = U;
                K[M.id] = M;
                var V = Z.$direction;
                U = K[V[0]];
                M = K[V[1]]
            }
            var N = this.viz.geom.getEdge(U, "begin", W);
            var S = this.viz.geom.getEdge(M, "end", W);
            var T = new Complex(S.x - N.x, S.y - N.y);
            T.$scale(O / T.norm());
            var X = new Complex(S.x - T.x, S.y - T.y);
            var Y = new Complex(-T.y / 2, T.x / 2);
            var J = X.add(Y),I = X.$add(Y.$scale(-1));
            L.path("stroke", function(aa) {
                aa.moveTo(N.x, N.y);
                aa.lineTo(S.x, S.y)
            });
            L.path("fill", function(aa) {
                aa.moveTo(J.x, J.y);
                aa.lineTo(I.x, I.y);
                aa.lineTo(S.x, S.y)
            })
        }})
    })();
    var AngularWidth = {setAngularWidthForNodes:function() {
        var x = this.config.Node;
        var z = x.overridable;
        var y = x.dim;
        Graph.Util.eachBFS(this.graph, this.root, function(C, A) {
            var B = (z && C.data && C.data.$aw) || y;
            C._angularWidth = B / A
        }, "ignore")
    },setSubtreesAngularWidth:function() {
        var x = this;
        Graph.Util.eachNode(this.graph, function(y) {
            x.setSubtreeAngularWidth(y)
        }, "ignore")
    },setSubtreeAngularWidth:function(A) {
        var z = this,y = A._angularWidth,x = 0;
        Graph.Util.eachSubnode(A, function(B) {
            z.setSubtreeAngularWidth(B);
            x += B._treeAngularWidth
        }, "ignore");
        A._treeAngularWidth = Math.max(y, x)
    },computeAngularWidths:function() {
        this.setAngularWidthForNodes();
        this.setSubtreesAngularWidth()
    }};
    this.RGraph = new o({Implements:[Loader,AngularWidth],initialize:function(A, x) {
        var z = {labelContainer:A.id + "-label",interpolation:"linear",levelDistance:100,withLabels:true,Node:{overridable:false,type:"circle",dim:3,color:"#ccb",width:5,height:5,lineWidth:1},Edge:{overridable:false,type:"line",color:"#ccb",lineWidth:1},fps:40,duration:2500,transition:Trans.Quart.easeInOut,clearCanvas:true};
        var y = {onBeforeCompute:b,onAfterCompute:b,onCreateLabel:b,onPlaceLabel:b,onComplete:b,onBeforePlotLine:b,onAfterPlotLine:b,onBeforePlotNode:b,onAfterPlotNode:b};
        this.controller = this.config = r(z, y, x);
        this.graphOptions = {complex:false,Node:{selected:false,exist:true,drawn:true}};
        this.graph = new Graph(this.graphOptions);
        this.fx = new RGraph.Plot(this);
        this.op = new RGraph.Op(this);
        this.json = null;
        this.canvas = A;
        this.root = null;
        this.busy = false;
        this.parent = false
    },refresh:function() {
        this.compute();
        this.plot()
    },reposition:function() {
        this.compute("endPos")
    },plot:function() {
        this.fx.plot()
    },compute:function(y) {
        var z = y || ["pos","startPos","endPos"];
        var x = this.graph.getNode(this.root);
        x._depth = 0;
        Graph.Util.computeLevels(this.graph, this.root, 0, "ignore");
        this.computeAngularWidths();
        this.computePositions(z)
    },computePositions:function(E) {
        var y = j(E);
        var D = this.graph;
        var C = Graph.Util;
        var x = this.graph.getNode(this.root);
        var B = this.parent;
        var z = this.config;
        for (var A = 0; A < y.length; A++) {
            x[y[A]] = l(0, 0)
        }
        x.angleSpan = {begin:0,end:2 * Math.PI};
        x._rel = 1;
        C.eachBFS(this.graph, this.root, function(I) {
            var L = I.angleSpan.end - I.angleSpan.begin;
            var O = (I._depth + 1) * z.levelDistance;
            var M = I.angleSpan.begin;
            var N = 0,F = [];
            C.eachSubnode(I, function(Q) {
                N += Q._treeAngularWidth;
                F.push(Q)
            }, "ignore");
            if (B && B.id == I.id && F.length > 0 && F[0].dist) {
                F.sort(function(R, Q) {
                    return(R.dist >= Q.dist) - (R.dist <= Q.dist)
                })
            }
            for (var J = 0; J < F.length; J++) {
                var H = F[J];
                if (!H._flag) {
                    H._rel = H._treeAngularWidth / N;
                    var P = H._rel * L;
                    var G = M + P / 2;
                    for (var K = 0; K < y.length; K++) {
                        H[y[K]] = l(G, O)
                    }
                    H.angleSpan = {begin:M,end:M + P};
                    M += P
                }
            }
        }, "ignore")
    },getNodeAndParentAngle:function(E) {
        var z = false;
        var D = this.graph.getNode(E);
        var B = Graph.Util.getParents(D);
        var A = (B.length > 0) ? B[0] : false;
        if (A) {
            var x = A.pos.getc(),C = D.pos.getc();
            var y = x.add(C.scale(-1));
            z = Math.atan2(y.y, y.x);
            if (z < 0) {
                z += 2 * Math.PI
            }
        }
        return{parent:A,theta:z}
    },tagChildren:function(B, D) {
        if (B.angleSpan) {
            var C = [];
            Graph.Util.eachAdjacency(B, function(E) {
                C.push(E.nodeTo)
            }, "ignore");
            var x = C.length;
            for (var A = 0; A < x && D != C[A].id; A++) {
            }
            for (var z = (A + 1) % x,y = 0; D != C[z].id; z = (z + 1) % x) {
                C[z].dist = y++
            }
        }
    },onClick:function(B, y) {
        if (this.root != B && !this.busy) {
            this.busy = true;
            this.root = B;
            that = this;
            this.controller.onBeforeCompute(this.graph.getNode(B));
            var z = this.getNodeAndParentAngle(B);
            this.tagChildren(z.parent, B);
            this.parent = z.parent;
            this.compute("endPos");
            var x = z.theta - z.parent.endPos.theta;
            Graph.Util.eachNode(this.graph, function(C) {
                C.endPos.set(C.endPos.getp().add(l(x, 0)))
            });
            var A = this.config.interpolation;
            y = r({onComplete:b}, y || {});
            this.fx.animate(r({hideLabels:true,modes:[A]}, y, {onComplete:function() {
                that.busy = false;
                y.onComplete()
            }}))
        }
    }});
    RGraph.Op = new o({Implements:Graph.Op,initialize:function(x) {
        this.viz = x
    }});
    RGraph.Plot = new o({Implements:Graph.Plot,initialize:function(x) {
        this.viz = x;
        this.config = x.config;
        this.node = x.config.Node;
        this.edge = x.config.Edge;
        this.animation = new Animation;
        this.nodeTypes = new RGraph.Plot.NodeTypes;
        this.edgeTypes = new RGraph.Plot.EdgeTypes
    },placeLabel:function(y, C, z) {
        var E = C.pos.getc(true),A = this.viz.canvas;
        var x = A.getSize();
        var D = {x:Math.round(E.x + x.width / 2),y:Math.round(E.y + x.height / 2)};
        var B = y.style;
        B.left = D.x + "px";
        B.top = D.y + "px";
        B.display = this.fitsInCanvas(D, A) ? "" : "none";
        z.onPlaceLabel(y, C)
    }});
    RGraph.Plot.NodeTypes = new o({none:function() {
    },circle:function(z, x) {
        var C = z.pos.getc(true),y = this.node,B = z.data;
        var A = y.overridable && B && B.$dim || y.dim;
        x.path("fill", function(D) {
            D.arc(C.x, C.y, A, 0, Math.PI * 2, true)
        })
    },square:function(A, x) {
        var D = A.pos.getc(true),z = this.node,C = A.data;
        var B = z.overridable && C && C.$dim || z.dim;
        var y = 2 * B;
        x.getCtx().fillRect(D.x - B, D.y - B, y, y)
    },rectangle:function(B, y) {
        var D = B.pos.getc(true),A = this.node,C = B.data;
        var z = A.overridable && C && C.$width || A.width;
        var x = A.overridable && C && C.$height || A.height;
        y.getCtx().fillRect(D.x - z / 2, D.y - x / 2, z, x)
    },triangle:function(B, y) {
        var F = B.pos.getc(true),G = this.node,C = B.data;
        var x = G.overridable && C && C.$dim || G.dim;
        var A = F.x,z = F.y - x,I = A - x,H = F.y + x,E = A + x,D = H;
        y.path("fill", function(J) {
            J.moveTo(A, z);
            J.lineTo(I, H);
            J.lineTo(E, D)
        })
    },star:function(z, y) {
        var D = z.pos.getc(true),E = this.node,B = z.data;
        var x = E.overridable && B && B.$dim || E.dim;
        var F = y.getCtx(),C = Math.PI / 5;
        F.save();
        F.translate(D.x, D.y);
        F.beginPath();
        F.moveTo(x, 0);
        for (var A = 0; A < 9; A++) {
            F.rotate(C);
            if (A % 2 == 0) {
                F.lineTo((x / 0.525731) * 0.200811, 0)
            } else {
                F.lineTo(x, 0)
            }
        }
        F.closePath();
        F.fill();
        F.restore()
    }});
    RGraph.Plot.EdgeTypes = new o({none:function() {
    },line:function(x, y) {
        var A = x.nodeFrom.pos.getc(true);
        var z = x.nodeTo.pos.getc(true);
        y.path("stroke", function(B) {
            B.moveTo(A.x, A.y);
            B.lineTo(z.x, z.y)
        })
    },arrow:function(J, B) {
        var D = J.nodeFrom,A = J.nodeTo;
        var E = J.data,x = this.edge;
        var I = x.overridable && E;
        var L = I && E.$dim || 14;
        if (I && E.$direction && E.$direction.length > 1) {
            var y = {};
            y[D.id] = D;
            y[A.id] = A;
            var z = E.$direction;
            D = y[z[0]];
            A = y[z[1]]
        }
        var N = D.pos.getc(true),C = A.pos.getc(true);
        var H = new Complex(C.x - N.x, C.y - N.y);
        H.$scale(L / H.norm());
        var F = new Complex(C.x - H.x, C.y - H.y);
        var G = new Complex(-H.y / 2, H.x / 2);
        var M = F.add(G),K = F.$add(G.$scale(-1));
        B.path("stroke", function(O) {
            O.moveTo(N.x, N.y);
            O.lineTo(C.x, C.y)
        });
        B.path("fill", function(O) {
            O.moveTo(M.x, M.y);
            O.lineTo(K.x, K.y);
            O.lineTo(C.x, C.y)
        })
    }});
    Complex.prototype.moebiusTransformation = function(z) {
        var x = this.add(z);
        var y = z.$conjugate().$prod(this);
        y.x++;
        return x.$div(y)
    };
    Graph.Util.getClosestNodeToOrigin = function(y, z, x) {
        return this.getClosestNodeToPos(y, Polar.KER, z, x)
    };
    Graph.Util.getClosestNodeToPos = function(z, C, B, x) {
        var y = null;
        B = B || "pos";
        C = C && C.getc(true) || Complex.KER;
        var A = function(E, D) {
            var G = E.x - D.x,F = E.y - D.y;
            return G * G + F * F
        };
        this.eachNode(z, function(D) {
            y = (y == null || A(D[B].getc(true), C) < A(y[B].getc(true), C)) ? D : y
        }, x);
        return y
    };
    Graph.Util.moebiusTransformation = function(z, B, A, y, x) {
        this.eachNode(z, function(D) {
            for (var C = 0; C < A.length; C++) {
                var F = B[C].scale(-1),E = y ? y : A[C];
                D[A[C]].set(D[E].getc().moebiusTransformation(F))
            }
        }, x)
    };
    this.Hypertree = new o({Implements:[Loader,AngularWidth],initialize:function(A, x) {
        var z = {labelContainer:A.id + "-label",withLabels:true,Node:{overridable:false,type:"circle",dim:7,color:"#ccb",width:5,height:5,lineWidth:1,transform:true},Edge:{overridable:false,type:"hyperline",color:"#ccb",lineWidth:1},clearCanvas:true,fps:40,duration:1500,transition:Trans.Quart.easeInOut};
        var y = {onBeforeCompute:b,onAfterCompute:b,onCreateLabel:b,onPlaceLabel:b,onComplete:b,onBeforePlotLine:b,onAfterPlotLine:b,onBeforePlotNode:b,onAfterPlotNode:b};
        this.controller = this.config = r(z, y, x);
        this.graphOptions = {complex:false,Node:{selected:false,exist:true,drawn:true}};
        this.graph = new Graph(this.graphOptions);
        this.fx = new Hypertree.Plot(this);
        this.op = new Hypertree.Op(this);
        this.json = null;
        this.canvas = A;
        this.root = null;
        this.busy = false
    },refresh:function(x) {
        if (x) {
            this.reposition();
            Graph.Util.eachNode(this.graph, function(y) {
                y.startPos.rho = y.pos.rho = y.endPos.rho;
                y.startPos.theta = y.pos.theta = y.endPos.theta
            })
        } else {
            this.compute()
        }
        this.plot()
    },reposition:function() {
        this.compute("endPos");
        var x = this.graph.getNode(this.root).pos.getc().scale(-1);
        Graph.Util.moebiusTransformation(this.graph, [x], ["endPos"], "endPos", "ignore");
        Graph.Util.eachNode(this.graph, function(y) {
            if (y.ignore) {
                y.endPos.rho = y.pos.rho;
                y.endPos.theta = y.pos.theta
            }
        })
    },plot:function() {
        this.fx.plot()
    },compute:function(y) {
        var z = y || ["pos","startPos"];
        var x = this.graph.getNode(this.root);
        x._depth = 0;
        Graph.Util.computeLevels(this.graph, this.root, 0, "ignore");
        this.computeAngularWidths();
        this.computePositions(z)
    },computePositions:function(F) {
        var G = j(F);
        var B = this.graph,D = Graph.Util;
        var E = this.graph.getNode(this.root),C = this,x = this.config;
        var H = this.canvas.getSize();
        var z = Math.min(H.width, H.height) / 2;
        for (var A = 0; A < G.length; A++) {
            E[G[A]] = l(0, 0)
        }
        E.angleSpan = {begin:0,end:2 * Math.PI};
        E._rel = 1;
        var y = (function() {
            var K = 0;
            D.eachNode(B, function(L) {
                K = (L._depth > K) ? L._depth : K;
                L._scale = z
            }, "ignore");
            for (var J = 0.51; J <= 1; J += 0.01) {
                var I = (function(L, M) {
                    return(1 - Math.pow(L, M)) / (1 - L)
                })(J, K + 1);
                if (I >= 2) {
                    return J - 0.01
                }
            }
            return 0.5
        })();
        D.eachBFS(this.graph, this.root, function(N) {
            var J = N.angleSpan.end - N.angleSpan.begin;
            var O = N.angleSpan.begin;
            var M = (function(Q) {
                var R = 0;
                D.eachSubnode(Q, function(S) {
                    R += S._treeAngularWidth
                }, "ignore");
                return R
            })(N);
            for (var L = 1,I = 0,K = y,P = N._depth; L <= P + 1; L++) {
                I += K;
                K *= y
            }
            D.eachSubnode(N, function(T) {
                if (!T._flag) {
                    T._rel = T._treeAngularWidth / M;
                    var S = T._rel * J;
                    var R = O + S / 2;
                    for (var Q = 0; Q < G.length; Q++) {
                        T[G[Q]] = l(R, I)
                    }
                    T.angleSpan = {begin:O,end:O + S};
                    O += S
                }
            }, "ignore")
        }, "ignore")
    },onClick:function(z, x) {
        var y = this.graph.getNode(z).pos.getc(true);
        this.move(y, x)
    },move:function(C, z) {
        var y = q(C.x, C.y);
        if (this.busy === false && y.norm() < 1) {
            var B = Graph.Util;
            this.busy = true;
            var x = B.getClosestNodeToPos(this.graph, y),A = this;
            B.computeLevels(this.graph, x.id, 0);
            this.controller.onBeforeCompute(x);
            if (y.norm() < 1) {
                z = r({onComplete:b}, z || {});
                this.fx.animate(r({modes:["moebius"],hideLabels:true}, z, {onComplete:function() {
                    A.busy = false;
                    z.onComplete()
                }}), y)
            }
        }
    }});
    Hypertree.Op = new o({Implements:Graph.Op,initialize:function(x) {
        this.viz = x
    }});
    Hypertree.Plot = new o({Implements:Graph.Plot,initialize:function(x) {
        this.viz = x;
        this.config = x.config;
        this.node = this.config.Node;
        this.edge = this.config.Edge;
        this.animation = new Animation;
        this.nodeTypes = new Hypertree.Plot.NodeTypes;
        this.edgeTypes = new Hypertree.Plot.EdgeTypes
    },hyperline:function(I, A) {
        var B = I.nodeFrom,z = I.nodeTo,F = I.data;
        var J = B.pos.getc(),E = z.pos.getc();
        var D = this.computeArcThroughTwoPoints(J, E);
        var K = A.getSize();
        var C = Math.min(K.width, K.height) / 2;
        if (D.a > 1000 || D.b > 1000 || D.ratio > 1000) {
            A.path("stroke", function(L) {
                L.moveTo(J.x * C, J.y * C);
                L.lineTo(E.x * C, E.y * C)
            })
        } else {
            var H = Math.atan2(E.y - D.y, E.x - D.x);
            var G = Math.atan2(J.y - D.y, J.x - D.x);
            var y = this.sense(H, G);
            var x = A.getCtx();
            A.path("stroke", function(L) {
                L.arc(D.x * C, D.y * C, D.ratio * C, H, G, y)
            })
        }
    },computeArcThroughTwoPoints:function(L, K) {
        var D = (L.x * K.y - L.y * K.x),z = D;
        var C = L.squaredNorm(),B = K.squaredNorm();
        if (D == 0) {
            return{x:0,y:0,ratio:1001}
        }
        var J = (L.y * B - K.y * C + L.y - K.y) / D;
        var H = (K.x * C - L.x * B + K.x - L.x) / z;
        var I = -J / 2;
        var G = -H / 2;
        var F = (J * J + H * H) / 4 - 1;
        if (F < 0) {
            return{x:0,y:0,ratio:1001}
        }
        var E = Math.sqrt(F);
        var A = {x:I,y:G,ratio:E,a:J,b:H};
        return A
    },sense:function(x, y) {
        return(x < y) ? ((x + Math.PI > y) ? false : true) : ((y + Math.PI > x) ? true : false)
    },placeLabel:function(F, A, C) {
        var E = A.pos.getc(true),y = this.viz.canvas;
        var D = y.getSize();
        var B = A._scale;
        var z = {x:Math.round(E.x * B + D.width / 2),y:Math.round(E.y * B + D.height / 2)};
        var x = F.style;
        x.left = z.x + "px";
        x.top = z.y + "px";
        x.display = "";
        C.onPlaceLabel(F, A)
    }});
    Hypertree.Plot.NodeTypes = new o({none:function() {
    },circle:function(A, y) {
        var z = this.node,C = A.data;
        var B = z.overridable && C && C.$dim || z.dim;
        var D = A.pos.getc(),E = D.scale(A._scale);
        var x = z.transform ? B * (1 - D.squaredNorm()) : B;
        if (x >= B / 4) {
            y.path("fill", function(F) {
                F.arc(E.x, E.y, x, 0, Math.PI * 2, true)
            })
        }
    },square:function(A, z) {
        var F = this.node,C = A.data;
        var x = F.overridable && C && C.$dim || F.dim;
        var y = A.pos.getc(),E = y.scale(A._scale);
        var D = F.transform ? x * (1 - y.squaredNorm()) : x;
        var B = 2 * D;
        if (D >= x / 4) {
            z.getCtx().fillRect(E.x - D, E.y - D, B, B)
        }
    },rectangle:function(A, z) {
        var E = this.node,B = A.data;
        var y = E.overridable && B && B.$width || E.width;
        var F = E.overridable && B && B.$height || E.height;
        var x = A.pos.getc(),D = x.scale(A._scale);
        var C = 1 - x.squaredNorm();
        y = E.transform ? y * C : y;
        F = E.transform ? F * C : F;
        if (C >= 0.25) {
            z.getCtx().fillRect(D.x - y / 2, D.y - F / 2, y, F)
        }
    },triangle:function(C, z) {
        var I = this.node,D = C.data;
        var x = I.overridable && D && D.$dim || I.dim;
        var y = C.pos.getc(),H = y.scale(C._scale);
        var G = I.transform ? x * (1 - y.squaredNorm()) : x;
        if (G >= x / 4) {
            var B = H.x,A = H.y - G,K = B - G,J = H.y + G,F = B + G,E = J;
            z.path("fill", function(L) {
                L.moveTo(B, A);
                L.lineTo(K, J);
                L.lineTo(F, E)
            })
        }
    },star:function(A, z) {
        var G = this.node,C = A.data;
        var x = G.overridable && C && C.$dim || G.dim;
        var y = A.pos.getc(),F = y.scale(A._scale);
        var E = G.transform ? x * (1 - y.squaredNorm()) : x;
        if (E >= x / 4) {
            var H = z.getCtx(),D = Math.PI / 5;
            H.save();
            H.translate(F.x, F.y);
            H.beginPath();
            H.moveTo(x, 0);
            for (var B = 0; B < 9; B++) {
                H.rotate(D);
                if (B % 2 == 0) {
                    H.lineTo((E / 0.525731) * 0.200811, 0)
                } else {
                    H.lineTo(E, 0)
                }
            }
            H.closePath();
            H.fill();
            H.restore()
        }
    }});
    Hypertree.Plot.EdgeTypes = new o({none:function() {
    },line:function(x, y) {
        var z = x.nodeFrom._scale;
        var B = x.nodeFrom.pos.getc(true);
        var A = x.nodeTo.pos.getc(true);
        y.path("stroke", function(C) {
            C.moveTo(B.x * z, B.y * z);
            C.lineTo(A.x * z, A.y * z)
        })
    },hyperline:function(x, y) {
        this.hyperline(x, y)
    }});
    this.TM = {layout:{orientation:"h",vertical:function() {
        return this.orientation == "v"
    },horizontal:function() {
        return this.orientation == "h"
    },change:function() {
        this.orientation = this.vertical() ? "h" : "v"
    }},innerController:{onBeforeCompute:b,onAfterCompute:b,onComplete:b,onCreateElement:b,onDestroyElement:b,request:false},config:{orientation:"h",titleHeight:13,rootId:"infovis",offset:4,levelsToShow:3,addLeftClickHandler:false,addRightClickHandler:false,selectPathOnHover:false,Color:{allow:false,minValue:-100,maxValue:100,minColorValue:[255,0,50],maxColorValue:[0,255,50]},Tips:{allow:false,offsetX:20,offsetY:20,onShow:b}},initialize:function(x) {
        this.tree = null;
        this.shownTree = null;
        this.controller = this.config = r(this.config, this.innerController, x);
        this.rootId = this.config.rootId;
        this.layout.orientation = this.config.orientation;
        if (this.config.Tips.allow && document.body) {
            var B = document.getElementById("_tooltip") || document.createElement("div");
            B.id = "_tooltip";
            B.className = "tip";
            var z = B.style;
            z.position = "absolute";
            z.display = "none";
            z.zIndex = 13000;
            document.body.appendChild(B);
            this.tip = B
        }
        var A = this;
        var y = function() {
            A.empty();
            if (window.CollectGarbage) {
                window.CollectGarbage()
            }
            delete y
        };
        if (window.addEventListener) {
            window.addEventListener("unload", y, false)
        } else {
            window.attachEvent("onunload", y)
        }
    },each:function(x) {
        (function y(D) {
            if (!D) {
                return
            }
            var C = D.childNodes,z = C.length;
            if (z > 0) {
                x.apply(this, [D,z === 1,C[0],C[1]])
            }
            if (z > 1) {
                for (var A = C[1].childNodes,B = 0; B < A.length; B++) {
                    y(A[B])
                }
            }
        })(e(this.rootId).firstChild)
    },toStyle:function(z) {
        var x = "";
        for (var y in z) {
            x += y + ":" + z[y] + ";"
        }
        return x
    },leaf:function(x) {
        return x.children == 0
    },createBox:function(y, A, x) {
        var z;
        if (!this.leaf(y)) {
            z = this.headBox(y, A) + this.bodyBox(x, A)
        } else {
            z = this.leafBox(y, A)
        }
        return this.contentBox(y, A, z)
    },plot:function(B) {
        var D = B.coord,A = "";
        if (this.leaf(B)) {
            return this.createBox(B, D, null)
        }
        for (var z = 0,C = B.children; z < C.length; z++) {
            var y = C[z],x = y.coord;
            if (x.width * x.height > 1) {
                A += this.plot(y)
            }
        }
        return this.createBox(B, D, A)
    },headBox:function(y, B) {
        var x = this.config,A = x.offset;
        var z = {height:x.titleHeight + "px",width:(B.width - A) + "px",left:A / 2 + "px"};
        return'<div class="head" style="' + this.toStyle(z) + '">' + y.name + "</div>"
    },bodyBox:function(y, C) {
        var x = this.config,z = x.titleHeight,B = x.offset;
        var A = {width:(C.width - B) + "px",height:(C.height - B - z) + "px",top:(z + B / 2) + "px",left:(B / 2) + "px"};
        return'<div class="body" style="' + this.toStyle(A) + '">' + y + "</div>"
    },contentBox:function(z, B, y) {
        var A = {};
        for (var x in B) {
            A[x] = B[x] + "px"
        }
        return'<div class="content" style="' + this.toStyle(A) + '" id="' + z.id + '">' + y + "</div>"
    },leafBox:function(A, E) {
        var z = this.config;
        var y = z.Color.allow && this.setColor(A),D = z.offset,B = E.width - D,x = E.height - D;
        var C = {top:(D / 2) + "px",height:x + "px",width:B + "px",left:(D / 2) + "px"};
        if (y) {
            C["background-color"] = y
        }
        return'<div class="leaf" style="' + this.toStyle(C) + '">' + A.name + "</div>"
    },setColor:function(F) {
        var A = this.config.Color,B = A.maxColorValue,y = A.minColorValue,C = A.maxValue,G = A.minValue,E = C - G,D = (F.data.$color - 0);
        var z = function(I, H) {
            return Math.round((((B[I] - y[I]) / E) * (H - G) + y[I]))
        };
        return d([z(0, D),z(1, D),z(2, D)])
    },enter:function(x) {
        this.view(x.parentNode.id)
    },onLeftClick:function(x) {
        this.enter(x)
    },out:function() {
        var x = TreeUtil.getParent(this.tree, this.shownTree.id);
        if (x) {
            if (this.controller.request) {
                TreeUtil.prune(x, this.config.levelsToShow)
            }
            this.view(x.id)
        }
    },onRightClick:function() {
        this.out()
    },view:function(B) {
        var x = this.config,z = this;
        var y = {onComplete:function() {
            z.loadTree(B);
            e(x.rootId).focus()
        }};
        if (this.controller.request) {
            var A = TreeUtil;
            A.loadSubtrees(A.getSubtree(this.tree, B), r(this.controller, y))
        } else {
            y.onComplete()
        }
    },resetPath:function(x) {
        var y = this.rootId,B = this.resetPath.previous;
        this.resetPath.previous = x || false;
        function z(D) {
            var C = D.parentNode;
            return C && (C.id != y) && C
        }

        function A(F, C) {
            if (F) {
                var D = e(F.id);
                if (D) {
                    var E = z(D);
                    while (E) {
                        F = E.childNodes[0];
                        if (s(F, "in-path")) {
                            if (C == undefined || !!C) {
                                a(F, "in-path")
                            }
                        } else {
                            if (!C) {
                                p(F, "in-path")
                            }
                        }
                        E = z(E)
                    }
                }
            }
        }

        A(B, true);
        A(x, false)
    },initializeElements:function() {
        var x = this.controller,z = this;
        var y = m(false),A = x.Tips.allow;
        this.each(function(F, E, D, C) {
            var B = TreeUtil.getSubtree(z.tree, F.id);
            x.onCreateElement(F, B, E, D, C);
            if (x.addRightClickHandler) {
                D.oncontextmenu = y
            }
            if (x.addLeftClickHandler || x.addRightClickHandler) {
                t(D, "mouseup", function(G) {
                    var H = (G.which == 3 || G.button == 2);
                    if (H) {
                        if (x.addRightClickHandler) {
                            z.onRightClick()
                        }
                    } else {
                        if (x.addLeftClickHandler) {
                            z.onLeftClick(D)
                        }
                    }
                    if (G.preventDefault) {
                        G.preventDefault()
                    } else {
                        G.returnValue = false
                    }
                })
            }
            if (x.selectPathOnHover || A) {
                t(D, "mouseover", function(G) {
                    if (x.selectPathOnHover) {
                        if (E) {
                            p(D, "over-leaf")
                        } else {
                            p(D, "over-head");
                            p(F, "over-content")
                        }
                        if (F.id) {
                            z.resetPath(B)
                        }
                    }
                    if (A) {
                        x.Tips.onShow(z.tip, B, E, D)
                    }
                });
                t(D, "mouseout", function(G) {
                    if (x.selectPathOnHover) {
                        if (E) {
                            a(D, "over-leaf")
                        } else {
                            a(D, "over-head");
                            a(F, "over-content")
                        }
                        z.resetPath()
                    }
                    if (A) {
                        z.tip.style.display = "none"
                    }
                });
                if (A) {
                    t(D, "mousemove", function(J, I) {
                        var O = z.tip;
                        I = I || window;
                        J = J || I.event;
                        var N = I.document;
                        N = N.html || N.body;
                        var K = {x:J.pageX || J.clientX + N.scrollLeft,y:J.pageY || J.clientY + N.scrollTop};
                        O.style.display = "";
                        I = {height:document.body.clientHeight,width:document.body.clientWidth};
                        var H = {width:O.offsetWidth,height:O.offsetHeight};
                        var G = O.style,M = x.Tips.offsetX,L = x.Tips.offsetY;
                        G.top = ((K.y + L + H.height > I.height) ? (K.y - H.height - L) : K.y + L) + "px";
                        G.left = ((K.x + H.width + M > I.width) ? (K.x - H.width - M) : K.x + M) + "px"
                    })
                }
            }
        })
    },destroyElements:function() {
        if (this.controller.onDestroyElement != b) {
            var x = this.controller,y = this;
            this.each(function(C, B, A, z) {
                x.onDestroyElement(C, TreeUtil.getSubtree(y.tree, C.id), B, A, z)
            })
        }
    },empty:function() {
        this.destroyElements();
        f(e(this.rootId))
    },loadTree:function(x) {
        this.empty();
        this.loadJSON(TreeUtil.getSubtree(this.tree, x))
    }};
    TM.SliceAndDice = new o({Implements:TM,loadJSON:function(A) {
        this.controller.onBeforeCompute(A);
        var y = e(this.rootId),z = this.config,B = y.offsetWidth,x = y.offsetHeight;
        var C = {coord:{top:0,left:0,width:B,height:x + z.titleHeight + z.offset}};
        if (this.tree == null) {
            this.tree = A
        }
        this.shownTree = A;
        this.compute(C, A, this.layout.orientation);
        y.innerHTML = this.plot(A);
        this.initializeElements();
        this.controller.onAfterCompute(A)
    },compute:function(D, M, B) {
        var O = this.config,I = D.coord,L = O.offset,H = I.width - L,F = I.height - L - O.titleHeight,y = D.data,x = (y && ("$area" in y)) ? M.data.$area / y.$area : 1;
        var G,E,K,C,A;
        var N = (B == "h");
        if (N) {
            B = "v";
            G = F;
            E = Math.round(H * x);
            K = "height";
            C = "top";
            A = "left"
        } else {
            B = "h";
            G = Math.round(F * x);
            E = H;
            K = "width";
            C = "left";
            A = "top"
        }
        M.coord = {width:E,height:G,top:0,left:0};
        var J = 0,z = this;
        g(M.children, function(P) {
            z.compute(M, P, B);
            P.coord[C] = J;
            P.coord[A] = 0;
            J += Math.floor(P.coord[K])
        })
    }});
    TM.Area = new o({loadJSON:function(z) {
        this.controller.onBeforeCompute(z);
        var y = e(this.rootId),A = y.offsetWidth,x = y.offsetHeight,E = this.config.offset,C = A - E,B = x - E - this.config.titleHeight;
        z.coord = {height:x,width:A,top:0,left:0};
        var D = r(z.coord, {width:C,height:B});
        this.compute(z, D);
        y.innerHTML = this.plot(z);
        if (this.tree == null) {
            this.tree = z
        }
        this.shownTree = z;
        this.initializeElements();
        this.controller.onAfterCompute(z)
    },computeDim:function(A, E, y, D, z) {
        if (A.length + E.length == 1) {
            var x = (A.length == 1) ? A : E;
            this.layoutLast(x, y, D);
            return
        }
        if (A.length >= 2 && E.length == 0) {
            E = [A[0]];
            A = A.slice(1)
        }
        if (A.length == 0) {
            if (E.length > 0) {
                this.layoutRow(E, y, D)
            }
            return
        }
        var C = A[0];
        if (z(E, y) >= z([C].concat(E), y)) {
            this.computeDim(A.slice(1), E.concat([C]), y, D, z)
        } else {
            var B = this.layoutRow(E, y, D);
            this.computeDim(A, [], B.dim, B, z)
        }
    },worstAspectRatio:function(x, E) {
        if (!x || x.length == 0) {
            return Number.MAX_VALUE
        }
        var y = 0,F = 0,B = Number.MAX_VALUE;
        for (var C = 0; C < x.length; C++) {
            var z = x[C]._area;
            y += z;
            B = (B < z) ? B : z;
            F = (F > z) ? F : z
        }
        var D = E * E,A = y * y;
        return Math.max(D * F / A, A / (D * B))
    },avgAspectRatio:function(A, x) {
        if (!A || A.length == 0) {
            return Number.MAX_VALUE
        }
        var C = 0;
        for (var y = 0; y < A.length; y++) {
            var B = A[y]._area;
            var z = B / x;
            C += (x > z) ? x / z : z / x
        }
        return C / A.length
    },layoutLast:function(y, x, z) {
        y[0].coord = z
    }});
    TM.Squarified = new o({Implements:[TM,TM.Area],compute:function(F, C) {
        if (!(C.width >= C.height && this.layout.horizontal())) {
            this.layout.change()
        }
        var x = F.children,z = this.config;
        if (x.length > 0) {
            this.processChildrenLayout(F, x, C);
            for (var B = 0; B < x.length; B++) {
                var A = x[B].coord,D = z.offset,E = A.height - (z.titleHeight + D),y = A.width - D;
                C = {width:y,height:E,top:0,left:0};
                this.compute(x[B], C)
            }
        }
    },processChildrenLayout:function(F, x, B) {
        var y = B.width * B.height;
        var A,C = 0,G = [];
        for (A = 0; A < x.length; A++) {
            G[A] = parseFloat(x[A].data.$area);
            C += G[A]
        }
        for (A = 0; A < G.length; A++) {
            x[A]._area = y * G[A] / C
        }
        var z = (this.layout.horizontal()) ? B.height : B.width;
        x.sort(function(I, H) {
            return(I._area <= H._area) - (I._area >= H._area)
        });
        var E = [x[0]];
        var D = x.slice(1);
        this.squarify(D, E, z, B)
    },squarify:function(y, A, x, z) {
        this.computeDim(y, A, x, z, this.worstAspectRatio)
    },layoutRow:function(y, x, z) {
        if (this.layout.horizontal()) {
            return this.layoutV(y, x, z)
        } else {
            return this.layoutH(y, x, z)
        }
    },layoutV:function(x, F, C) {
        var G = 0,z = Math.round;
        g(x, function(H) {
            G += H._area
        });
        var y = z(G / F),D = 0;
        for (var A = 0; A < x.length; A++) {
            var B = z(x[A]._area / y);
            x[A].coord = {height:B,width:y,top:C.top + D,left:C.left};
            D += B
        }
        var E = {height:C.height,width:C.width - y,top:C.top,left:C.left + y};
        E.dim = Math.min(E.width, E.height);
        if (E.dim != E.height) {
            this.layout.change()
        }
        return E
    },layoutH:function(x, E, B) {
        var G = 0,y = Math.round;
        g(x, function(H) {
            G += H._area
        });
        var F = y(G / E),C = B.top,z = 0;
        for (var A = 0; A < x.length; A++) {
            x[A].coord = {height:F,width:y(x[A]._area / F),top:C,left:B.left + z};
            z += x[A].coord.width
        }
        var D = {height:B.height - F,width:B.width,top:B.top + F,left:B.left};
        D.dim = Math.min(D.width, D.height);
        if (D.dim != D.width) {
            this.layout.change()
        }
        return D
    }});
    TM.Strip = new o({Implements:[TM,TM.Area],compute:function(F, C) {
        var x = F.children,z = this.config;
        if (x.length > 0) {
            this.processChildrenLayout(F, x, C);
            for (var B = 0; B < x.length; B++) {
                var A = x[B].coord,D = z.offset,E = A.height - (z.titleHeight + D),y = A.width - D;
                C = {width:y,height:E,top:0,left:0};
                this.compute(x[B], C)
            }
        }
    },processChildrenLayout:function(A, z, E) {
        var B = E.width * E.height;
        var C = parseFloat(A.data.$area);
        g(z, function(F) {
            F._area = B * parseFloat(F.data.$area) / C
        });
        var y = (this.layout.horizontal()) ? E.width : E.height;
        var D = [z[0]];
        var x = z.slice(1);
        this.stripify(x, D, y, E)
    },stripify:function(y, A, x, z) {
        this.computeDim(y, A, x, z, this.avgAspectRatio)
    },layoutRow:function(y, x, z) {
        if (this.layout.horizontal()) {
            return this.layoutH(y, x, z)
        } else {
            return this.layoutV(y, x, z)
        }
    },layoutV:function(x, F, C) {
        var G = 0,z = function(H) {
            return H
        };
        g(x, function(H) {
            G += H._area
        });
        var y = z(G / F),D = 0;
        for (var A = 0; A < x.length; A++) {
            var B = z(x[A]._area / y);
            x[A].coord = {height:B,width:y,top:C.top + (F - B - D),left:C.left};
            D += B
        }
        var E = {height:C.height,width:C.width - y,top:C.top,left:C.left + y,dim:F};
        return E
    },layoutH:function(x, E, B) {
        var G = 0,y = function(H) {
            return H
        };
        g(x, function(H) {
            G += H._area
        });
        var F = y(G / E),C = B.height - F,z = 0;
        for (var A = 0; A < x.length; A++) {
            x[A].coord = {height:F,width:y(x[A]._area / F),top:C,left:B.left + z};
            z += x[A].coord.width
        }
        var D = {height:B.height - F,width:B.width,top:B.top,left:B.left,dim:E};
        return D
    }})
})();