library(leaflet)
library(leaflet.extras)
library(htmlwidgets)

# Crear el mapa
  leaflet() %>%
    setView(lng = -58.45, lat = -34.6, zoom = 12) %>%
    
    # Capas base
    addProviderTiles("OpenStreetMap", group = "Mapa base") %>%
    addProviderTiles("Esri.WorldImagery", group = "Satélite") %>%
    addProviderTiles("CartoDB.Positron", group = "Positron (Claro)") %>% 
    
    # Controles de capas
    addLayersControl(
        baseGroups = c("Mapa base", "Satélite", "Positron (Claro)"),
        position = "topleft"
    ) %>% 
    
    # Buscador de direcciones
    addSearchOSM(
        options = searchOptions(
            position = 'topleft',
            textPlaceholder = 'Buscar dirección en CABA...'
        )
    ) %>%
    
    # Botón de geolocalización
    addEasyButton(
        easyButton(
            icon = "fa-crosshairs", 
            title = "Centrar en mi ubicación",
            onClick = JS("function(btn, map){ map.locate({setView: true}); }")
        )
    ) %>%
    
    # Escala y controles adicionales
    addScaleBar(position = "bottomleft") %>%
    addFullscreenControl(position = "topleft") %>%
    
    # Usar onRender para agregar los event listeners de geolocalización
    htmlwidgets::onRender("
        function(el, x) {
            var map = this;
            
            // Evento cuando se encuentra la ubicación
            map.on('locationfound', function(e) {
                var radius = e.accuracy / 2;
                
                // Limpiar marcadores previos
                if (map.locationMarker) {
                    map.removeLayer(map.locationMarker);
                }
                if (map.locationCircle) {
                    map.removeLayer(map.locationCircle);
                }
                
                // Crear nuevo marcador
                map.locationMarker = L.marker(e.latlng).addTo(map);
                map.locationMarker.bindPopup('Tu ubicación actual<br>Precisión: ' + radius.toFixed(2) + ' metros').openPopup();
                
                // Crear círculo de precisión
                map.locationCircle = L.circle(e.latlng, radius).addTo(map);
            });
            
            // Evento de error de ubicación
            map.on('locationerror', function(e) {
                alert('Error de geolocalización: ' + e.message);
            });
        }
    ")

 




