part of web_gl_intro;

class Quad{
  WebGL.RenderingContext gl;
  Shader shader;
  int aPosition;
  WebGL.Buffer vertexBuffer, indexBuffer;
  
  Quad(this.gl, this.shader){
    gl.useProgram(shader.program);

    aPosition       = gl.getAttribLocation(shader.program, 'aPosition');
    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferDataTyped(WebGL.ARRAY_BUFFER, new Float32List.fromList([
                                                                     -0.0, -0.0, 0.0,
                                                                      1.0, -0.0, 0.0,
                                                                      1.0, 1.0, 0.0,
                                                                     -0.0, 1.0, 0.0
                                                                     ]), WebGL.STATIC_DRAW);
    gl.vertexAttribPointer(aPosition, 3, WebGL.RenderingContext.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(aPosition);
    
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, new Int16List.fromList([0,1,2,0,2,3]), WebGL.STATIC_DRAW);
  }
  
  render(){
    //Передаем в униформ красный цвет
    gl.uniform4f(gl.getUniformLocation(shader.program, 'uColor'), 1.0, 0.0, 0.0, 1.0);
    gl.drawElements(WebGL.TRIANGLES, 6, WebGL.UNSIGNED_SHORT, 0);
  }  
}