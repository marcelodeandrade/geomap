function createMap(topoJSON, cod_capital){
	var _view = new ol.View({
		center: ol.proj.transform([0,0], 'EPSG:4326', 'EPSG:3857'),
		zoom: 5
	});

	var _style = [new ol.style.Style({
		fill: new ol.style.Fill({
			color: 'rgba(255, 102, 0, 0.3)'
		}),
		stroke: new ol.style.Stroke({
			color: 'rgb(255, 255, 153)',
			width: 1
		})
	})];

	var _capitalStyle = [new ol.style.Style({
		fill: new ol.style.Fill({
			color: 'rgba(125, 202, 38, 0.3)'
		}),
		stroke: new ol.style.Stroke({
			color: 'rgb(255, 255, 153)',
			width: 1
		})
	})];

	var funcStyle = function(feature, resolution){
		if(feature['n']['cod'] == cod_capital){
			return _capitalStyle;
		}
		return _style;
	}

	var _layer = new ol.layer.Vector({
		source: new ol.source.TopoJSON({
			projection: 'EPSG:3857',
			object: topoJSON
		}),
		style: funcStyle
	});

	var _map = new ol.Map({
		target: 'map',
		layers: [
		new ol.layer.Tile({
			source: new ol.source.OSM()
		}),
		_layer
		],
		view: _view
	});

	var _extent = _layer.getSource().getExtent();
	_map.getView().fitExtent(_extent, _map.getSize());
	_map.on("click", function(e) {
		_map.forEachFeatureAtPixel(e.pixel, function (feature, layer) {
			var clickCod = feature['n']['cod'];
			alert(clickCod);
		});
	});
	_map.on("pointermove", function(e) {
		_map.forEachFeatureAtPixel(e.pixel, function (feature, layer) {
			var clickCod = feature['n']['cod'];
			var clickName = municipios[clickCod.toString().substr(0,2)][clickCod.toString()];
			document.getElementById('tooltip').innerHTML = clickName;
			if(document.getElementById('tooltip').style.display != 'block'){
				document.getElementById('tooltip').style.display = 'block';
			}
			var t = setTimeout('unshowTooltip("'+clickName+'")',2000);
		});
	});
}

function unshowTooltip(n){
	if(n == document.getElementById('tooltip').innerHTML){
		document.getElementById('tooltip').style.display = 'none';
	}
}