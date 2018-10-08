(function($) {
  $.QueryString = (function(a) {
    if (a === "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i) {
      var p=a[i].split('=');
      if (p.length != 2) continue;
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
  })(window.location.search.substr(1).split('&'));
})(jQuery);

dojo.locale = "en";
dojo.require("dojox.grid.DataGrid");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojo.data.ItemFileWriteStore");

var dateFormatter = function(data) {
    return dojo.date.locale.format(new Date(Number(data)), {
        datePattern: "dd MMM yyyy",
        selector: "date",
        locale: "en"
    });
};

var datamodule = getCookie('datamodule');

var brLayout = [
        {
            field: "country",
            name: "Country",
            width: 10
        },
        {
            field: "reef",
            name: "Reef",
            width: 10
        },
        {
            field: "groupname",
            name: "Group",
            width: 10
        },
        {
            field: "surveyor",
            name: "Surveyor",
            width: 10
        },
        {
            field: "comments",
            name: "Comment",
            width: 10
        },
        {
            field: "date",
            name: "Date",
            width: 10,
            formatter: dateFormatter
        },
        {
            field: "records",
            name: "Records",
            width: 5
        },
        {
          field: 'view',
          name: 'View',
          width: 10,
          formatter: function(id) {
            var url = window.location.origin + "/web/guest/survey?p_p_id=surveyportlet_WAR_coralwatch&" + "_surveyportlet_WAR_coralwatch_cmd=view&_surveyportlet_WAR_coralwatch_surveyId=" + id;
            if (datamodule) return '<a target="popup" href="' + url + '" onclick="window.open(\'' + url + '\',\'popup\',\'width=682,height=644\'); return false;">More Info</a>';
            else return '<a target="_blank" href="' + url + '">More Info</a>';
            //return '<a target="popup" href="/web/guest/survey?p_p_id=surveyportlet_WAR_coralwatch&' + '_surveyportlet_WAR_coralwatch_cmd=view&_surveyportlet_WAR_coralwatch_surveyId=' + id + '">More Info</a>';
          }
        }
    ]
];

var brData = {
  identifier: 'id',
  label: 'name',
  items: []
}

function cmpIgnoreCase(a,b) {
  if((a === null) && (b === null)) {
    return 0;
  } else if(a === null) {
    return -1;
  } else if(b === null) {
    return 1;
  } else {
    return a.toLowerCase().localeCompare(b.toLowerCase());
  }
}

function cmpDate(a,b) {
  if((a === null) && (b === null)) {
    return 0;
  } else if(a === null) {
    return -1;
  } else if(b === null) {
    return 1;
  } else {
    var aa = Date.parse(a);
    var bb = Date.parse(b);
    if(aa === bb) {
      return 0;
    } else if(aa < bb) {
      return -1;
    } else {
      return 1;
    }
  }
}

dojo.addOnLoad(function() {
  brStore.comparatorMap = {};

  brStore.comparatorMap["country"] = cmpIgnoreCase;
  brStore.comparatorMap["reef"] = cmpIgnoreCase;
  brStore.comparatorMap["surveyor"] = cmpIgnoreCase;
  brStore.comparatorMap["groupname"] = cmpIgnoreCase;
  brStore.comparatorMap["comments"] = cmpIgnoreCase;
  brStore.comparatorMap["date"] = cmpDate;
  brStore.comparatorMap["records"] = function(a, b) {
      var ret = 0;
      if (Number(a) > Number(b)) ret = 1;
      if (Number(a) < Number(b)) ret = -1;
      return ret;
  };

  var url = '/coralwatch/api/bleaching-risk';

  var param;
  if (jQuery.QueryString.all === 'all') {
    param = 'all=all';
    jQuery("#rdAll").attr('checked', 'checked');

  } else if (jQuery.QueryString.past === '48m') {
    param = 'past=48m';
    jQuery("#rdPast48m").attr('checked', 'checked');

  } else if (jQuery.QueryString.past === '12m') {
    param = 'past=12m';
    jQuery("#rdPast12m").attr('checked', 'checked');

  } else if (jQuery.QueryString.past === '3m') {
    param = 'past=3m';
    jQuery("#rdPast3m").attr('checked', 'checked');

  } else {
    param = 'past=3m';
    jQuery("#rdPast3m").attr('checked', 'checked');
  }

  dojo.xhrGet({
    url: url + '?' + param,
    handleAs: 'json',
    preventCache: true,
    load: function(data_json) {
        //console.log("row data = ", data_json);
        if (data_json) {
            data_json.forEach(function(br, index) {

                brStore.newItem({
                    id: br[0],
                    country: br[1],
                    reef: br[2],
                    groupname: br[11],
                    surveyor: br[3],
                    comments: br[12],
                    date: br[4],
                    records: br[5],
                    view: br[0]
                });
            });
        }
    },
    error: function(e) {
        console.error('loading bleaching risk data failed %o', e);
    }
  });

  jQuery("input[name='rd1']" ).change(function() {
    var val = jQuery(this).val();

    var url = window.location.href;
    if (window.location.href.indexOf('?') >= 0) url = window.location.href.substring(0, window.location.href.indexOf('?'));

    if (val === 'all') url += '?all=all';
    else if (val === '48m') url += '?past=48m';
    else if (val === '12m') url += '?past=12m';
    else if (val === '3m') url += '?past=3m';
    else url += '?past=3m';

    window.location.href = url;
  });

  function apply_search () {
      brGrid.queryOptions = {ignoreCase: true};
      brGrid.filter({
          surveyor: "*" + dijit.byId("surveyorFilterField").getValue() + "*",
          reef: "*" + dijit.byId("reefFilterField").getValue() + "*",
          country: "*" + dijit.byId("countryFilterField").getValue() + "*",
          groupname: "*" + dijit.byId("groupFilterField").getValue() + "*",
          comments: "*" + dijit.byId("commentFilterField").getValue() + "*"
      });
  }

});
