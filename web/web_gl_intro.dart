library web_gl_intro;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:async' as Async;
import 'dart:web_gl' as WebGL;
import "dart:typed_data";
import "package:vector_math/vector_math.dart";

part 'shader.dart';
part 'quad.dart';

class WebGLScene{
  CanvasElement canvas;
  WebGL.RenderingContext gl;
  Shader quadShader;
  List<Quad> quads;
  
  WebGLScene(this.canvas){
  
    gl = canvas.getContext('webgl');
    if (gl == null)
      gl = canvas.getContext("experimental-webgl");
    
    gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.enable(WebGL.BLEND);
    gl.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    
    quadShader = new Shader(gl);
    quads  = new List<Quad>();
    
    var random = new Math.Random();
    for (int i=0; i<10; i++){
      int w = random.nextInt(100);
      int h = random.nextInt(100);
      int x = random.nextInt(canvas.width-w);
      int y = random.nextInt(canvas.height-h);
      double angle = random.nextDouble();
      Vector4 color = new Vector4(random.nextDouble(), random.nextDouble(), random.nextDouble(), 1.0);
      quads.add(new Quad(gl, quadShader,  x, y, w, h, angle, color));
    }
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
    
    quads.forEach((q){
      q.angle =  q.angle  + 0.3;
      q.render();
    });
    new Async.Timer(new Duration(milliseconds: 30), () => window.requestAnimationFrame(render));
  }  
}

void main() {
  new WebGLScene(querySelector("#webglcanvas"));
}

