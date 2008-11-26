model SignalRanker "Example model" 
 annotation (Diagram, Commands(file="SignalRanker.mos" "run"));
  Modelica.Blocks.Sources.Sine sine(freqHz=2) 
    annotation (extent=[-60,60; -40,80]);
  annotation (Diagram);
  Modelica.Blocks.Sources.Pulse pulse(period=0.25) 
    annotation (extent=[-60,-20; -40,0]);
  Buildings.Controls.Continuous.SignalRanker sigRan(
                                                  nin=3) 
    annotation (extent=[-20,20; 0,40]);
  Modelica.Blocks.Sources.ExpSine expSine(freqHz=10) 
    annotation (extent=[-60,20; -40,40]);
equation 
  connect(sine.y, sigRan.u[1])       annotation (points=[-39,70; -32,70; -32,
        28.6667; -22,28.6667],
                 style(color=74, rgbcolor={0,0,127}));
  connect(pulse.y, sigRan.u[2])       annotation (points=[-39,-10; -32,-10; -32,
        30; -22,30], style(color=74, rgbcolor={0,0,127}));
  connect(expSine.y, sigRan.u[3]) annotation (points=[-39,30; -30,30; -30,
        31.3333; -22,31.3333], style(color=74, rgbcolor={0,0,127}));
end SignalRanker;
