library web_gl_intro;

import 'dart:html';
import 'dart:web_gl' as WebGL;
import "dart:typed_data";
import "package:vector_math/vector_math.dart";

part 'shader.dart';
part 'quad.dart';

class WebGLScene{
  CanvasElement canvas;
  WebGL.RenderingContext gl;
  Shader quadShader;
  Quad q;
  
  WebGLScene(this.canvas){
  
    gl = canvas.getContext('webgl');
    if (gl == null)
      gl = canvas.getContext("experimental-webgl");
    
    gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.enable(WebGL.BLEND);
    gl.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    
    window.requestAnimationFrame(render);
    quadShader = new Shader(gl);
    q = new Quad(gl, quadShader);
  }
  

  void render(double time){
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(WebGL.COLOR_BUFFER_BIT);
    
    q.render();
  }  
}

void main() {
  new WebGLScene(querySelector("#webglcanvas"));
}

