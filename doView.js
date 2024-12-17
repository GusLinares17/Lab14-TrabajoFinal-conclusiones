function doView(owner, title) {
    let url = http://localhost:8080/cgi-bin/view.pl?usuario=${encodeURIComponent(owner)}&titulo=${encodeURIComponent(title)};
    let xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send();
    xhr.onload = function () {
        if (!xhr.responseXML) {
            console.error("Error: La respuesta no es XML válido.");
            console.log("Respuesta recibida:", xhr.responseText);
            document.getElementById("main").innerHTML = <h2>Error al cargar la página</h2>;
            return;
        }
        responseView(xhr.responseXML);
    };
}
