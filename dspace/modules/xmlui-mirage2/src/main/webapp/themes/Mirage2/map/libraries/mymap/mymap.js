
// Define map and base layers
var mymap = L.map('mapid').setView([51.4,16.8], 5);

var Mapbox=L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
		maxZoom: 18,
		attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
				'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
				'Imagery © <a href="http://mapbox.com">Mapbox</a>',
		id: 'mapbox.streets'
}).addTo(mymap);

var OSM_BlackWhite = L.tileLayer('http://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png', {
	maxZoom: 18,
	attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
});



var popup = L.popup();



// Define Layer styles
var fidgeo_Style = {
    "color": "#073291",
    "weight": 3,
    "opacity": 0.65,
    "fillOpacity": 0.7,
    "fillColor": 'darkblue'

};

var external_Style = {
  "color": "#0048D8",
  "weight": 3,
  "opacity": 0.65,
  "fillOpacity": 0.5,
  "fillColor": '#2b8cbe'

};

var order_Style = {
  "color": "#B1D0FF",
  "weight": 3,
  "opacity": 0.55,
  "fillOpacity": 0.3,
  "fillColor": '#6baed6'
};

// Interaction style

var highlightStyle = {
    "color": '#b30000',
    "weight": 4,
    "opacity": 1,
    "fillOpacity": 0.3,
    "fillColor": '#b30000'
};

var selectStyle = {
    "color": '#800026',
    "weight": 4,
    "opacity": 1,
    "fillOpacity": 0.3,
    "fillColor": '#800026'
};

// Generate Popup content and bind functionality

function onEachFeature(feature, layer) {
		

	 if (feature.properties.Link1 != ""&& feature.properties.Link2 == ""){
        layer.bindPopup("<b>Title: </b>"+feature.properties.Title+"<br><b>Subtitle: </b>"+feature.properties.Subtitle+"<br><b>"+feature.properties.Text+"</b><br><a href='"+feature.properties.Link1+"' target='_blank' title='"+feature.properties.ML1+"'>"+feature.properties.LText1+"</a>");
     }
     if (feature.properties.Link2 != "" && feature.properties.Link3 == ""){
        layer.bindPopup("<b>Title: </b>"+feature.properties.Title+"<br><b>Subtitle: </b>"+feature.properties.Subtitle+"<br><b>"+feature.properties.Text+"</b><br><a href='"+feature.properties.Link1+"' target='_blank' title='"+feature.properties.ML1+"'>"+feature.properties.LText1+"</a><br><a href='"+feature.properties.Link2+"' target='_blank' title='"+feature.properties.ML2+"'>"+feature.properties.LText2+"</a>");
     }
     if (feature.properties.Link3 != ""){
        layer.bindPopup("<b>Title: </b>"+feature.properties.Title+"<br><b>Subtitle: </b>"+feature.properties.Subtitle+"<br><b>"+feature.properties.Text+"</b><br><a href='"+feature.properties.Link1+"' target='_blank' title='"+feature.properties.ML1+"'>"+feature.properties.LText1+"</a><br><a href='"+feature.properties.Link2+"' target='_blank' title='"+feature.properties.ML2+"'>"+feature.properties.LText2+"</a>"+"<br><a href='"+feature.properties.Link3+"' target='_blank' title='"+feature.properties.ML3+"'>"+feature.properties.LText3+"</a>");
     }

	var currentLayer;
	var currentStyle = layer.options.style
	
	// Create search Index:
	var p = layer.feature.properties;	
	p.Index = p.Title.replace("[","").replace("]",",");
	 
	
	

	layer.on("mouseover", function (e) {
		info.update(layer.feature.properties);
		if (currentLayer === undefined){
			layer.setStyle(highlightStyle);
		info.update(layer.feature.properties);
		//breaks with IE
		//layer.bringToFront();
		}

	});

	mymap.on("mousemove", function (e) {
		if (currentLayer != undefined && currentLayer._popup.isOpen()===false){
			currentLayer = undefined;
			layer.setStyle(currentStyle);
		}
	});


	layer.on("mouseout", function (e) {
		info.update();
		if (currentLayer === undefined){
			layer.setStyle(currentStyle);
			// Breaks with IE
			//layer.bringToBack();
			info.update();
		}
	});

	layer.on("click", function (e) {
		currentLayer = layer;
		layer.setStyle(selectStyle);
		mymap.setView(e.latlng, 8);	
	});

}


// Load data from GeoJson into Layer according Layer type
var order_layer = L.geoJson(geojson, {
  filter: function(feature, layer) {
    return (feature.properties.Layer === "GK25 / bestellbar (FID GEO)");
  },style:order_Style,onEachFeature:onEachFeature
}).addTo(mymap);

var external_layer = L.geoJson(geojson, {
  filter: function(feature, layer) {
    return (feature.properties.Layer === "GK25 / extern");
  },style:external_Style,onEachFeature:onEachFeature
}).addTo(mymap);

var fidgeo_maps_layer = L.geoJson(geojson, {
  filter: function(feature, layer) {
    return (feature.properties.Layer === "GK25 / GEO-LEOe-docs");
  },style:fidgeo_Style,onEachFeature:onEachFeature
}).addTo(mymap);

	

// L.control
var baseMaps={"Mapbox":Mapbox,"OSM_BlackWhite":OSM_BlackWhite};
var overlayMaps={
	  "<font color='#073291'><b>GK25/GEO-LEOe-docs</b></font>": fidgeo_maps_layer,
	  "<font color='#0048D8'><b>GK25/extern</b></font>": external_layer,
	  "<font color='#B1D0FF'><b>GK25/bestellbar(FID GEO)</b></font>": order_layer  
	}

L.control.layers(baseMaps,overlayMaps,{collapsed:false,position:'bottomright'}).addTo(mymap);


//leaflet-search
var poiLayers = L.layerGroup([
		fidgeo_maps_layer,
		external_layer,
		order_layer
]);

var searchControl = new L.control.search({
	layer: poiLayers,
	initial: false,
	propertyName: 'Index',
	hideMarkerOnCollapse: true,
	position: 'topleft'
}).addTo(mymap);



// create a fullscreen button and add it to the map
L.control.fullscreen({
	  position: 'topleft', // change the position of the button can be topleft, topright, bottomright or bottomleft, defaut topleft
	  title: 'Enter fullscreen mode', // change the title of the button, default Full Screen
	  titleCancel: 'Exit fullscreen mode', // change the title of the button when fullscreen is on, default Exit Full Screen
	  content: null, // change the content of the button, can be HTML, default null
	  forceSeparateButton: true, // force seperate button to detach from zoom buttons, default false
	  forcePseudoFullscreen: true, // force use of pseudo full screen even if full screen API is available, default false
	  fullscreenElement: false // Dom element to render in full screen, false by default, fallback to map._container
}).addTo(mymap);


// Dynamic Hover Info Control
var info = L.control();

info.onAdd = function (map) {
    this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
    this.update();
    return this._div;
};

// method that we will use to update the control based on feature properties passed
info.update = function (props) {
      this._div.innerHTML = '<h4>Selected map:</h4>' +  (props ?
          '<b>' + props.Title + '</b><br />' + props.Subtitle + '<br />'+ props.Layer
          : 'Please select a map');
};

info.addTo(mymap);
  
  
// Zoom to a certain map by id provided by url parameter  
function visualizeByID (id) {
  fidgeo_maps_layer.eachLayer(function(layer) {
   
	  var matches= layer.feature.properties.Title.match(/\[(.*?)\]/);
	  if (matches) {
		var map_id = matches[1];
		map_id= map_id.replace ("Neue Nr. ", '');
	  }
	  
	  if (map_id == id){
		layer.openPopup();
		var arr=layer.feature.geometry.coordinates[0];
		var coords=arr[0];
		mymap.setView([coords[1],coords[0]], 8);
	  }
  })
}
  
// Zoom to a certain feature
 var params = {};
window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m, key, value) {
	params[key] = value;
});
	
if (params["id"] != null){
	var id = params["id"];
	visualizeByID(id);
}
  
  
 
