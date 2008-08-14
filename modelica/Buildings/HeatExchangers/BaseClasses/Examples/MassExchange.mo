model MassExchange "Test model for latent heat exchange" 
   package Medium = Buildings.Media.PerfectGases.MoistAir;
  annotation(Diagram, Commands(file="MassExchange.mos" "run"),
    Coordsys(extent=[-100,-100; 180,100]));
  Buildings.HeatExchangers.BaseClasses.MassExchange masExc(redeclare package 
      Medium = Medium) "Model for mass exchange" 
                                     annotation (extent=[20,0; 40,20]);
  Modelica.Blocks.Sources.Ramp TSur(
    duration=1,
    height=20,
    offset=273.15 + 5) "Surface temperature" 
                   annotation (extent=[-80,60; -60,80]);
    Modelica.Blocks.Sources.Constant XWat(k=0.01) 
    "Humidity mass fraction in medium" 
      annotation (extent=[-80,0; -60,20]);
  annotation (Diagram);
    Modelica.Blocks.Sources.Constant Gc(k=1) 
    "Sensible convective thermal conductance" 
      annotation (extent=[-80,-80; -60,-60]);
equation 
  connect(TSur.y, masExc.TSur)    annotation (points=[-59,70; 8,70; 8,18; 18,18],
                style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(Gc.y, masExc.Gc)    annotation (points=[-59,-70; 8,-70; 8,2; 18,2],
                                 style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(XWat.y, masExc.XInf) annotation (points=[-59,10; -20,10; -20,10; 18,
        10], style(color=74, rgbcolor={0,0,127}));
end MassExchange;
