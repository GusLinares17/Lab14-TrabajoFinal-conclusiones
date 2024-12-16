function showNew(){
    let showNew = `<p>Titulo</p>
    <input id='titulo' name ='titulo' type='text'><br>
    <p>Contenido-markdown</p>
    <textarea style = "width: 100%;" type="text" id ="cuerpo" name="cuerpo"></textarea><br>
    <button onclick='doNew()'>Enviar</button>
    <button onclick='doList()'>Cancelar</button>`;
    document.getElementById("main").innerHTML = showNew;
}
