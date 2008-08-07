model HumidityRatioPressure "Unit test for humidity ratio model" 
 annotation(Commands(file="HumidityRatioPressure.mos" "run"));
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat(redeclare 
      package Medium = Medium) "Model for humidity ratio" 
                          annotation (extent=[0,20; 20,40]);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1, 
    height=(0.0133 - 0.2), 
    offset=0.2) "Humidity concentration" 
                 annotation (extent=[-60,-20; -40,0]);
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (extent=[-60,20; -40,40]);
  annotation (Diagram);
equation 
  connect(p.y, humRat.p) annotation (points=[-39,30; 1,30], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(XHum.y, humRat.X[1]) annotation (points=[-39,-10; -20,-10; -20,23; 1,
        23], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
end HumidityRatioPressure;
