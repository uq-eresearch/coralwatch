dojo.locale = "en";
dojo.require("dojox.grid.DataGrid");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojo.data.ItemFileWriteStore");

var brLayout = [[{
  field: 'country',
  name: 'Country',
  width: 10
},{
  field: 'reef',
  name: 'Reef',
  width: 10
},{
  field: 'surveyor',
  name: 'Surveyor',
  width: 10
},{
  field: 'date',
  name: 'Date',
  width: 10
},{
  field: 'records',
  name: 'Records',
  width: 5
},{
  field: 'view',
  name: 'View',
  width: 10,
  formatter: function(id) {
    return '<a href="/web/guest/survey?p_p_id=surveyportlet_WAR_coralwatch&'+
      '_surveyportlet_WAR_coralwatch_cmd=view&_surveyportlet_WAR_coralwatch_surveyId='+
      id+'">More Info</a>';
  }
},]];

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
  brStore.comparatorMap.country = cmpIgnoreCase;
  brStore.comparatorMap.reef = cmpIgnoreCase;
  brStore.comparatorMap.surveyor = cmpIgnoreCase;
  brStore.comparatorMap.date = cmpDate;
  dojo.xhrGet({
    url: '/coralwatch/api/bleaching-risk',
    handleAs: 'json',
    load: function(data) {
      data.forEach(function(survey) {
        brStore.newItem({
          id: survey[0],
          country: survey[1],
          reef: survey[2],
          surveyor: survey[3],
          date: survey[4],
          records: survey[5],
          view: survey[0]
        });
      });
    },
    error: function(e) {
      console.error('loading bleaching risk data failed %o', e);
    }
  });
});
