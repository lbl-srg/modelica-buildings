model WetBulbTemperature 
  
    annotation (Diagram, Commands(file=
            "WetBulbTemperature.mos" "run"),
    Documentation(info="<html>
This examples is a unit test for the wet bulb computation.
The problem setup is such that the moisture concentration and
the dry bulb temperature are varied simultaneously so 
that the wet bulb temperature remains constant.
This wet bulb temperature is checked against a constant value with
an assert statement.
If this assert is triggered, then the model for the wet bulb computation
is broken (assuming that the inputs remained unchanged).
</html>", revisions="<html>
<ul>
<li>
May 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  
    Modelica.Blocks.Sources.Ramp TDB(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature" 
                 annotation (extent=[-100,60; -80,80]);
  Modelica.Blocks.Sources.Constant const annotation (extent=[-100,-20; -80,0]);
  Modelica.Blocks.Math.Feedback feedback annotation (extent=[-68,-20; -48,0]);
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(startTime=0,
      threShold=0.05) 
    annotation (extent=[60,20; 80,40]);
  Modelica.Blocks.Sources.Constant TWBExp(k=273.15 + 25) 
    "Expected wet bulb temperature" annotation (extent=[20,-20; 40,0]);
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBul(redeclare 
      package Medium = Medium) "Model for wet bulb temperature" 
    annotation (extent=[0,20; 20,40]);
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure" 
                                    annotation (extent=[-100,20; -80,40]);
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration" 
                 annotation (extent=[-100,-60; -80,-40]);
equation 
  connect(const.y, feedback.u1) annotation (points=[-79,-10; -66,-10], style(
        color=74, rgbcolor={0,0,127}));
  connect(TWBExp.y, assertEquality.u2) 
    annotation (points=[41,-10; 48,-10; 48,24; 58,24],
                                         style(color=74, rgbcolor={0,0,127}));
  connect(TDB.y, wetBul.TDryBul) annotation (points=[-79,70; -39.5,70; -39.5,38; 
        1,38], style(color=74, rgbcolor={0,0,127}));
  connect(feedback.y, wetBul.X[2]) annotation (points=[-49,-10; -6,-10; -6,22; 
        1,22], style(color=74, rgbcolor={0,0,127}));
  connect(p.y, wetBul.p) annotation (points=[-79,30; 1,30],
      style(color=74, rgbcolor={0,0,127}));
  connect(wetBul.TWetBul, assertEquality.u1) 
    annotation (points=[19,30; 40,30; 40,36; 58,36],
                                       style(color=3, rgbcolor={0,0,255}));
  connect(XHum.y, feedback.u2) annotation (points=[-79,-50; -58,-50; -58,-18],
      style(color=74, rgbcolor={0,0,127}));
  connect(XHum.y, wetBul.X[1]) annotation (points=[-79,-50; 1,-50; 1,22], style(
        color=74, rgbcolor={0,0,127}));
end WetBulbTemperature;
