function responseNew(response){
    //Muestra el nuevo articulo creado
    let article = response.children[0];
    if (article.children.length == 0) { //si esta vacio
        document.getElementById("main").innerHTML = <h2>Error al crear nueva pagina</h2>;
    } 
    else {
        document.getElementById("main").innerHTML = "<h2>"+article.children[0].textContent+"</h2><p>"+article.children[1].textContent+"</p>";
    }
}
