part of web_gl_intro;

class Quad{
  WebGL.RenderingContext gl;
  Shader shader;
  int aPosition;
  WebGL.Buffer vertexBuffer, indexBuffer;
  int x, y, w, h;
  Vector4 color;
  double angle;
  
  Quad(this.gl, this.shader, this.x, this.y, this.w, this.h, this.angle, this.color){
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
    Matrix4 objectMat = new Matrix4.identity();
    //создаем матрицу вида
    objectMat.setIdentity();
    //передвиним объект на нужное расстояние
    objectMat.translate(1.0*x, 1.0*y );
    //повернем прямоугольник на нужный угол
    objectMat.rotateZ(angle);
    //изменим масштаб, чтобы прямоугольник был нужного размера
    objectMat.scale(1.0*w, 1.0*h);
    //передаем матрицу в шейдер
    gl.uniformMatrix4fv(gl.getUniformLocation(shader.program, "uObjectMatrix"), false, objectMat.storage);

    //Передаем в униформ красный цвет
    gl.uniform4fv(gl.getUniformLocation(shader.program, 'uColor'), color.storage);
    gl.drawElements(WebGL.TRIANGLES, 6, WebGL.UNSIGNED_SHORT, 0);
  }  
}