part of web_gl_intro;

class Shader{
  
  String vertexShaderCode, fragmentShaderCode;
  WebGL.Shader vertexShader, fragmentShader;
  WebGL.Program program;
  WebGL.RenderingContext gl;
  
  
  Shader(this.gl){
    vertexShaderCode = """
            precision highp float;

            attribute vec3 aPosition;
            void main() {
                 gl_Position = vec4(aPosition, 1);
            }""";
    fragmentShaderCode = """
          precision highp float;

            uniform vec4 uColor;
            void main() {
              gl_FragColor = uColor;
            }
        """; 
    compile();
  }
  
  void compile(){
    vertexShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderCode);
    gl.compileShader(vertexShader);
    if (!gl.getShaderParameter(vertexShader, WebGL.COMPILE_STATUS)){
      throw gl.getShaderInfoLog(vertexShader);
    }
    
    fragmentShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderCode);
    gl.compileShader(fragmentShader);
    if (!gl.getShaderParameter(fragmentShader, WebGL.COMPILE_STATUS)){
      throw gl.getShaderInfoLog(fragmentShader);
    }
    
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    gl.useProgram(program);
    if (!gl.getProgramParameter(program, WebGL.LINK_STATUS)){
      throw gl.getProgramInfoLog(program);
    }
  }
}