var MapService = {
  GEOCODE_API_URL : null,

  initialize : function(){
    MapService.GEOCODE_API_URL = "http://maps.googleapis.com/maps/api/geocode/json?sensor=true&";
  },

  loadScript : function(){
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=MapService.initialize";
    document.body.appendChild(script);
  },

  geocode : function(query) {
    $.ajax({
      type: "get",
      url: MapService.GEOCODE_API_URL,
      data: "address="+query,
      success: function(result){
        if(result.status === "OK") {
          var location = result.results[0].geometry.location;
          var lat = location.lat;
          var lng = location.lng;

          Property.searchPropertiesByLatlng(lat, lng);
        }
      }
    });
    return this;
  }
};
window.onload = MapService.loadScript;


var Property = {
  init : function() {
    Property.selectCurrentHour();
    Property.showMoreProperties();
    Property.searchPropertiesByHour();
    Property.reverseGeoCode();
  },

  reverseGeoCode : function() {
    // do a reverse geocoding when user do a search
    $('.dispatcher').find('.search-btn').bind('click', function(evt) {
      evt.preventDefault();
      evt.stopPropagation();

      var query = $('input.search-query').val();
      // check if the query is lat,lng or address
      var tokens = query.split(',');
      if(tokens.length > 0) {
        // Create a reverse geocode request
        if(isNaN(parseFloat(tokens[0]))) {          
          MapService.geocode(query);
        }
        else if(tokens.length == 2){
          var lat = parseFloat(tokens[0]);
          var lng = parseFloat(tokens[1]);

          if(!isNaN(lat) && !isNaN(lng)) {
            Property.searchPropertiesByLatlng(lat, lng);
          }
        }
      }
    });
    return this;
  },

  searchPropertiesByLatlng : function(lat, lng){
    $.ajax({
      type: "post",
      url: "/find",
      data: "latlng[]="+lat+"&latlng[]="+lng,
      success: function(result){
        // replace the content with rendered HTML
        $('#property_list').html(result);
      }
    });
  },

  // initiate a search by hour when user click on a time
  searchPropertiesByHour : function() {
    $('.dispatcher').find('button.btn-time').each(function() {
      var that = $(this);

      that.bind('click', function(evt) {
        // clean up the button
        Property.removeHourSelected();
        that.addClass('btn-info');

        // find the hour we want to search
        var hour = that.attr('data-hour');
        $.ajax({
          type: "get",
          url: "/find",
          data: "hour="+hour,
          success: function(result){
            // replace the content with rendered HTML
            $('#property_list').html(result);
          }
        });
      });
    })
    return this;
  },

  // Select the current hour when page is loaded
  selectCurrentHour : function() {
    var time = new Date();
    hour = time.getHours();

    $('#current_hour').find('button#hour_'+hour).addClass('btn-info');
    return this;
  },

  // bind click handler to show more properties
  showMoreProperties : function() {
    var container = $('#property_list');
    // when user clicks 'more' link
    // show them the other properties of same name 
    // that are also active at this hour
    container.bind('click', function(evt) {
      var that = $(evt.target)
      evt.preventDefault();
      evt.stopPropagation();

      var name = that.attr('data-name');
      var more = container.find('ul.more_'+name);
      more.toggle();
    })
    return this;
  },

  // remove the hour that's selected
  removeHourSelected : function(){
    $('#current_hour').find('button').removeClass('btn-info');
    return this;
  },
}
$(document).ready(function() {
  Property.init();
})