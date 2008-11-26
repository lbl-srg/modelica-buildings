model NumberOfRequests "Example model" 
 annotation (Diagram, Commands(file="NumberOfRequests.mos" "run"));
  Buildings.Controls.Continuous.NumberOfRequests numReq(
    nin=2,
    threShold=0,
    kind=0) annotation (extent=[0,20; 20,40]);
  Modelica.Blocks.Sources.Sine sine(freqHz=2) 
    annotation (extent=[-60,40; -40,60]);
  annotation (Diagram);
  Modelica.Blocks.Sources.Pulse pulse(period=0.25) 
    annotation (extent=[-60,0; -40,20]);
equation 
  connect(sine.y, numReq.u[1]) annotation (points=[-39,50; -21.5,50; -21.5,29;
        -2,29], style(color=74, rgbcolor={0,0,127}));
  connect(pulse.y, numReq.u[2]) annotation (points=[-39,10; -20,10; -20,31; -2,
        31], style(color=74, rgbcolor={0,0,127}));
end NumberOfRequests;
