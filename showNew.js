function showNew() {
    let showNew = `
        <form>
            <p><label for="titulo">Título</label></p>
            <input id="titulo" name="titulo" type="text"><br>
            <p><label for="cuerpo">Contenido (Markdown)</label></p>
            <textarea id="cuerpo" name="cuerpo" style="width: 100%;"></textarea><br>
            <button type="button" onclick="doNew()">Enviar</button>
            <button type="button" onclick="doList()">Cancelar</button>
        </form>
    `;
    document.getElementById("main").innerHTML = showNew;
}
