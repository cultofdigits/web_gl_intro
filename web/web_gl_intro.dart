library web_gl_intro;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import "dart:typed_data";
import "package:vector_math/vector_math.dart";

part 'shader.dart';
part 'quad.dart';

class WebGLScene{
  CanvasElement canvas;
  WebGL.RenderingContext gl;
  Shader quadShader;
  Quad quad_red, quad_blue;
  
  WebGLScene(this.canvas){
  
    gl = canvas.getContext('webgl');
    if (gl == null)
      gl = canvas.getContext("experimental-webgl");
    
    gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.enable(WebGL.BLEND);
    gl.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    
    quadShader = new Shader(gl);
    quad_red = new Quad(gl, quadShader, 100, 100, 20, 40, new Vector4(1.0, 0.0, 0.0, 1.0));
    quad_blue = new Quad(gl, quadShader, 200, 50, 40, 10, new Vector4(0.0, 0.0, 1.0, 1.0));
    
    window.requestAnimationFrame(render);
  }
  

  void render(double time){
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(WebGL.COLOR_BUFFER_BIT);

    Matrix4 cameraMatrix = new Matrix4.identity();
    cameraMatrix.setIdentity();
    /* умнжаем на матрицу отражения
     * [1, 0, 0, 0] 
     * [0,-1, 0, 0] 
     * [0, 0, 1, 0] 
     * [0, 0, 0, 1]
     * чтобы ось у была направлена вниз 
     */
    cameraMatrix.multiply( new Matrix4.identity().setDiagonal(new Vector4(1.0, -1.0, 1.0, 1.0)));
    //переместим начало координат в левый верхний угол
    cameraMatrix.translate(-1.0, -1.0);
    //Изменим масштаб, после изменения масжтаб будет 0 x canvas.width * 0 x canvas.height
    cameraMatrix.scale(2.0/ canvas.width, 2.0 / canvas.height);
    gl.uniformMatrix4fv(gl.getUniformLocation(quadShader.program, "uCameraMatrix"), false, cameraMatrix.storage);
    
    quad_red.render();
    quad_blue.render();
  }  
}

void main() {
  new WebGLScene(querySelector("#webglcanvas"));
}

