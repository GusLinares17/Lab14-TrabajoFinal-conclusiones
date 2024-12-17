function doNew() {
    let titulo = encodeURIComponent(document.getElementById("titulo").value).replace(/%20/g, "+");
    let cuerpo = encodeURIComponent(document.getElementById("cuerpo").value).replace(/%20/g, "+");
    let url = `http://localhost:8080/cgi-bin/new.pl?usuario=${userKey}&titulo=${titulo}&cuerpo=${cuerpo}`;
    
    console.log(url);

    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.text(); // Si la respuesta no es XML, ajusta esto
        })
        .then(responseText => {
            responseNew(responseText); // o responseXML si es necesario
        })
        .catch(error => {
            console.error("Error en la solicitud:", error);
        });
}
