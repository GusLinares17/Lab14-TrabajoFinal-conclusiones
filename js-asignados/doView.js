function doView (owner, titulo) { 

    let xml = new XMLHttpRequest();
    xml.open(GET, url, true);

    xml.send();
    if (!xhr.responseXML) {
        console.error("Error: La respuesta no es XML válido.");
        console.log("Respuesta recibida:", xhr.responseText);
        console.log(xml.statusText + "-->" + xml.status + "state");
        
        // Si no es un XML válido, muestra un mensaje de error en un elemento HTML con id `main`.
        document.getElementById("main").innerHTML = "<h2>Error al cargar la página</h2>";
        return;
    }

    // Si la respuesta es un XML válido, se pasa a la función `responseView` para procesarla.
    responseView(xhr.responseXML);
};