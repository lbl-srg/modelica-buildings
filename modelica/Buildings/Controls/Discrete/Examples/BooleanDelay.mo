model BooleanDelay "Example model" 
 annotation (Diagram, Commands(file="BooleanDelay.mos" "run"));
  Buildings.Controls.Discrete.BooleanDelay del annotation (extent=[0,-20; 20,0]);
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.25) 
    annotation (extent=[-60,-20; -40,0]);
equation 
  connect(booleanPulse.y, del.u) annotation (points=[-39,-10; -2,-10], style(
        color=5, rgbcolor={255,0,255}));
end BooleanDelay;
