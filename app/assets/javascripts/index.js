$(document).ready(function() {
    Home.initialize()
});

var Home = (function () {

  var initialize = function () {
    $(".table-condensed" ).on( "click", ".trendLine", function() {
      addTrend($(this).data('name'), $(this).data('url'))
    });
  }

  var addTrend = function (name, url) {
    jQuery.ajax({url: 'trend',
      type : 'POST',
      data: { name: name, url: url },

      success: function(data) {
        console.log(data)
        $('#favorites_table tr:last').after( '<tr><td>'+ data.name +'</td><td>'
        + data.url + '</td></tr>' );
      },
      error: function(data) {
        console.log(data)
        if (data.status == 422)
          alert(JSON.parse(data.responseText)['errors'])
      }
    });
  }

  return {
    initialize: initialize,
    addTrend: addTrend
  };

})();