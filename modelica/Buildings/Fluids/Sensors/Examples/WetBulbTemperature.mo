model WetBulbTemperature 
  import Buildings;
  
    annotation (Diagram, Commands(file=
            "WetBulbTemperature.mos" "run"), 
    Documentation(info="<html>
This examples is a unit test for the wet bulb sensor.
The problem setup is such that the moisture concentration and
the dry bulb temperature are varied simultaneously in such a way
that the wet bulb temperature is constant.
This wet bulb temperature is checked against a constant value with
an assert statement.
In case this assert is triggered, then either the wet bulb sensor or
the medium model got broken (assuming that the inputs remained unchanged).
</html>", revisions="<html>
<ul>
<li>
May 6, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
 package Medium = Buildings.Fluids.Media.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  
    Modelica.Blocks.Sources.Ramp yRam(
    duration=1, 
    offset=101325, 
    height=500)  annotation (extent=[40,60; 60,80]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[74,10;
        54,30]);
  Buildings.Fluids.Sensors.WetBulbTemperature senWetBul(redeclare package 
      Medium = Medium) "Wet bulb temperature sensor" 
    annotation (extent=[16,10; 36,30]);
  Modelica_Fluid.Sources.PrescribedMassFlowRate_TX massFlowRate(redeclare 
      package Medium = Medium, m_flow=1) annotation (extent=[-30,10; -10,30]);
    Modelica.Blocks.Sources.Ramp TDB(
    height=10, 
    duration=1, 
    offset=273.15 + 30) "Dry bulb temperature" 
                 annotation (extent=[-100,40; -80,60]);
    Modelica.Blocks.Sources.Ramp TDB1(
    duration=1, 
    offset=0.0176, 
    height=(0.0132 - 0.0176)) "Dry bulb temperature" 
                 annotation (extent=[-100,-60; -80,-40]);
  Modelica.Blocks.Sources.Constant const annotation (extent=[-100,-20; -80,0]);
  Modelica.Blocks.Math.Feedback feedback annotation (extent=[-68,-20; -48,0]);
  Buildings.Utilities.Controls.AssertEquality assertEquality(threShold=0.05)
    annotation (extent=[40,-40; 60,-20]);
  Modelica.Blocks.Sources.Constant TWBExp(k=273.15 + 25) 
    "Expected wet bulb temperature" annotation (extent=[-6,-46; 14,-26]);
equation 
  connect(senWetBul.port_b, sin.port) 
    annotation (points=[36,20; 54,20], style(color=69, rgbcolor={0,127,255}));
  connect(yRam.y, sin.p_in) annotation (points=[61,70; 92,70; 92,26; 76,26], style(
        color=74, rgbcolor={0,0,127}));
  connect(massFlowRate.port, senWetBul.port_a)
    annotation (points=[-10,20; 16,20], style(color=69, rgbcolor={0,127,255}));
  connect(TDB.y, massFlowRate.T_in) annotation (points=[-79,50; -60,50; -60,20; 
        -32,20], style(color=74, rgbcolor={0,0,127}));
  connect(const.y, feedback.u1) annotation (points=[-79,-10; -66,-10], style(
        color=74, rgbcolor={0,0,127}));
  connect(TDB1.y, feedback.u2) annotation (points=[-79,-50; -58,-50; -58,-18], 
      style(color=74, rgbcolor={0,0,127}));
  connect(TDB1.y, massFlowRate.X_in[1]) annotation (points=[-79,-50; -40,-50; 
        -40,13.9; -29.2,13.9], style(color=74, rgbcolor={0,0,127}));
  connect(feedback.y, massFlowRate.X_in[2]) annotation (points=[-49,-10; -40,
        -10; -40,13.9; -29.2,13.9], style(color=74, rgbcolor={0,0,127}));
  connect(senWetBul.TWB, assertEquality.u1) annotation (points=[26,9; 26,-24; 
        38,-24], style(color=74, rgbcolor={0,0,127}));
  connect(TWBExp.y, assertEquality.u2)
    annotation (points=[15,-36; 38,-36], style(color=74, rgbcolor={0,0,127}));
end WetBulbTemperature;
