model SmoothBlocks 
  annotation(Diagram, Commands(file="SmoothBlocks.mos" "run"));
  SmoothMax smoMax(deltaX=0.5) annotation (extent=[-20,40; 0,60]);
  Modelica.Blocks.Math.Max max annotation (extent=[-20,0; 0,20]);
  Modelica.Blocks.Sources.Sine sine(freqHz=8) 
    annotation (extent=[-80,60; -60,80]);
  Modelica.Blocks.Sources.Sine sine1 annotation (extent=[-100,0; -80,20]);
  Controls.AssertEquality assEquMax(threShold=0.08) 
    annotation (extent=[40,20; 60,40]);
  SmoothMin smoMin(deltaX=0.5) annotation (extent=[-20,-40; 0,-20]);
  Modelica.Blocks.Math.Min Min annotation (extent=[-20,-80; 0,-60]);
  Controls.AssertEquality assEquMin(threShold=0.08) 
    annotation (extent=[40,-60; 60,-40]);
equation 
  
  connect(sine.y, smoMax.u1) annotation (points=[-59,70; -40,70; -40,56; -22,56],
      style(color=74, rgbcolor={0,0,127}));
  connect(sine.y, max.u1) annotation (points=[-59,70; -40,70; -40,16; -22,16],
      style(color=74, rgbcolor={0,0,127}));
  connect(sine1.y, smoMax.u2) annotation (points=[-79,10; -48,10; -48,44; -22,
        44], style(color=74, rgbcolor={0,0,127}));
  connect(sine1.y, max.u2) annotation (points=[-79,10; -48,10; -48,4; -22,4],
      style(color=74, rgbcolor={0,0,127}));
  connect(smoMax.y, assEquMax.u1) annotation (points=[1,50; 20,50; 20,36; 38,36],
      style(color=74, rgbcolor={0,0,127}));
  connect(max.y, assEquMax.u2) annotation (points=[1,10; 20,10; 20,24; 38,24],
      style(color=74, rgbcolor={0,0,127}));
  connect(sine.y, smoMin.u1) annotation (points=[-59,70; -40,70; -40,-24; -22,
        -24], style(color=74, rgbcolor={0,0,127}));
  connect(sine.y, Min.u1) annotation (points=[-59,70; -40,70; -40,-64; -22,-64],
      style(color=74, rgbcolor={0,0,127}));
  connect(sine1.y, smoMin.u2) annotation (points=[-79,10; -48,10; -48,-36; -22,
        -36], style(color=74, rgbcolor={0,0,127}));
  connect(sine1.y, Min.u2) annotation (points=[-79,10; -48,10; -48,-76; -22,
        -76], style(color=74, rgbcolor={0,0,127}));
  connect(smoMin.y, assEquMin.u1) annotation (points=[1,-30; 20,-30; 20,-44; 38,
        -44],    style(color=74, rgbcolor={0,0,127}));
  connect(Min.y, assEquMin.u2) annotation (points=[1,-70; 20,-70; 20,-56; 38,
        -56], style(color=74, rgbcolor={0,0,127}));
end SmoothBlocks;
