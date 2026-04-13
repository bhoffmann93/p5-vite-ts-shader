import p5 from 'p5';
import { Pane } from 'tweakpane';
import Stats from 'stats.js';
import vertexShader from './shaders/default.vert';
import fragmentShader from './shaders/post.frag';

const stats = new Stats();
stats.showPanel(0);
document.body.appendChild(stats.dom);

const params = {
  color: 205,
};

const pane = new Pane({ title: 'Controls' });
pane.addBinding(params, 'color', { min: 0, max: 255, step: 1, label: 'fill' });

new p5((p: p5) => {
  let b: p5.Graphics;
  let postFxShader: p5.Shader;

  p.setup = () => {
    p.createCanvas(p.windowWidth, p.windowHeight, p.WEBGL); //webgl center [0,0]
    b = p.createGraphics(p.windowWidth, p.windowWidth, p.WEBGL); //canvas buffer
    postFxShader = p.createShader(vertexShader, fragmentShader);
  };

  p.draw = () => {
    stats.begin();
    //Render into Buffer
    b.background(50);
    b.fill(params.color);
    b.noStroke();

    b.rectMode(p.CENTER);
    b.rect(0, 0, 100, 100);

    //Post FX Shader Pass
    p.background(0.0);
    p.shader(postFxShader);
    postFxShader.setUniform('uTexture', b);
    postFxShader.setUniform('uResolution', [p.width * p.displayDensity(), p.height * p.displayDensity()]);
    postFxShader.setUniform('uTime', p.millis() / 1000);
    postFxShader.setUniform('uFrame', p.frameCount);
    p.plane(p.width, p.height);
    stats.end();
  };

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
    b.resizeCanvas(p.windowWidth, p.windowHeight);
  };
});

window.addEventListener('keydown', (e) => {
  if (e.key === 'g') {
    pane.hidden = !pane.hidden;
    stats.dom.style.display = stats.dom.style.display === 'none' ? 'block' : 'none';
  }
});
