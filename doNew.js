function doNew(){
    // encodeURI reemplaza espacios con %20, entonces reemplazamos %20 con + para la url
    let titulo = encodeURIComponent(document.getElementById("titulo").value).replace(/%20/g, "+"); // para reemplazar espacios en el url
    let cuerpo = encodeURIComponent(document.getElementById("cuerpo").value).replace(/%20/g,"+");
    let url = "http://localhost:8080/cgi-bin/new.pl?usuario="+userKey+"&titulo="+titulo+"&cuerpo="+cuerpo;
    console.log(url);
    let xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.send();
    xhr.onload = function () {
        responseNew(xhr.responseXML);
    };
}
