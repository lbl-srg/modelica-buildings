model DewPointTemperature "Unit test for dew point temperature calculation" 
  annotation(Commands(file="DewPointTemperature.mos" "run"), Diagram);
   package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  Buildings.Utilities.Psychrometrics.DewPointTemperature TDewPoi 
    annotation (extent=[-60,40; -40,60]);
  Buildings.Utilities.Psychrometrics.HumidityRatioPressure humRat 
    annotation (extent=[-20,0; 0,20]);
  annotation (Diagram);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.01 - 0.1),
    offset=0.1) "Humidity concentration" 
                 annotation (extent=[-80,-40; -60,-20]);
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (extent=[-80,0; -60,20]);
equation 
  connect(humRat.p_w, TDewPoi.p_w) annotation (points=[-19,17; -32,17; -32,50; 
        -39,50],style(
      color=0,
      rgbcolor={0,0,0},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(p.y, humRat.p) annotation (points=[-59,10; -19,10], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=7,
      rgbfillColor={255,255,255},
      fillPattern=1));
  connect(XHum.y, humRat.XWat) annotation (points=[-59,-30; -40,-30; -40,3; -19,
        3], style(color=74, rgbcolor={0,0,127}));
end DewPointTemperature;
