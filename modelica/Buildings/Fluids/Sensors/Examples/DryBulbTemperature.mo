model DryBulbTemperature 
  
    annotation (Diagram, Commands(file=
            "DryBulbTemperature.mos" "run"),
    Documentation(info="<html>
This examples is a unit test for the dynamic dry bulb temperature sensor.
</html>", revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model" 
           annotation (choicesAllMatching = true);
  
    Modelica.Blocks.Sources.Ramp p(
    duration=1,
    offset=101325,
    height=250)  annotation (extent=[40,60; 60,80]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin(redeclare package Medium 
      = Medium, T=293.15)                           annotation (extent=[78,10;
        58,30]);
  Buildings.Fluids.Sensors.DryBulbTemperatureDynamic sen(
                            redeclare package Medium = Medium,
    T_start=Medium.T_default,
    initType=Modelica.Blocks.Types.Init.SteadyState) 
    "Dynamic temperature sensor" 
    annotation (extent=[30,10; 50,30]);
  Buildings.Fluids.Sources.PrescribedMassFlowRate_pTX massFlowRate(redeclare 
      package Medium = Medium, m_flow=1) annotation (extent=[-36,10; -16,30]);
    Modelica.Blocks.Sources.Ramp TDB(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature" 
                 annotation (extent=[-100,40; -80,60]);
    Modelica.Blocks.Sources.Ramp XHum(
    height=(0.0133 - 0.0175),
    offset=0.0175,
    duration=60) "Humidity concentration" 
                 annotation (extent=[-100,-60; -80,-40]);
  Modelica.Blocks.Sources.Constant const annotation (extent=[-100,-20; -80,0]);
  Modelica.Blocks.Math.Feedback feedback annotation (extent=[-70,-20; -50,0]);
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(startTime=0,
      threShold=0.001) 
    annotation (extent=[60,-40; 80,-20]);
  Modelica.Blocks.Continuous.FirstOrder firOrd(T=10, initType=Modelica.Blocks.
        Types.Init.SteadyState) 
    annotation (extent=[10,-46; 30,-26]);
  Modelica_Fluid.Sensors.Temperature temSteSta(redeclare package Medium = 
        Medium) "Steady state temperature sensor" 
    annotation (extent=[0,10; 20,30]);
equation 
  connect(sen.port_b, sin.port) 
    annotation (points=[50,20; 58,20], style(color=69, rgbcolor={0,127,255}));
  connect(TDB.y, massFlowRate.T_in) annotation (points=[-79,50; -60,50; -60,20;
        -38,20], style(color=74, rgbcolor={0,0,127}));
  connect(const.y, feedback.u1) annotation (points=[-79,-10; -68,-10], style(
        color=74, rgbcolor={0,0,127}));
  connect(XHum.y, feedback.u2) annotation (points=[-79,-50; -60,-50; -60,-18],
      style(color=74, rgbcolor={0,0,127}));
  connect(XHum.y, massFlowRate.X_in[1]) annotation (points=[-79,-50; -40,-50;
        -40,13.9; -35.2,13.9], style(color=74, rgbcolor={0,0,127}));
  connect(feedback.y, massFlowRate.X_in[2]) annotation (points=[-51,-10; -44,
        -10; -44,13.9; -35.2,13.9], style(color=74, rgbcolor={0,0,127}));
  connect(p.y, sin.p_in) annotation (points=[61,70; 94,70; 94,26; 80,26], style(
        color=74, rgbcolor={0,0,127}));
  connect(sen.T, assertEquality.u1) annotation (points=[40,9; 40,-24; 58,-24],
      style(color=74, rgbcolor={0,0,127}));
  connect(firOrd.y, assertEquality.u2) 
    annotation (points=[31,-36; 58,-36], style(color=74, rgbcolor={0,0,127}));
  connect(massFlowRate.port, temSteSta.port_a) annotation (points=[-16,20;
        -5.55112e-16,20], style(color=69, rgbcolor={0,127,255}));
  connect(temSteSta.port_b, sen.port_a) 
    annotation (points=[20,20; 30,20], style(color=69, rgbcolor={0,127,255}));
  connect(temSteSta.T, firOrd.u) annotation (points=[10,9; 10,-14; -12,-14; -12,
        -36; 8,-36], style(color=74, rgbcolor={0,0,127}));
end DryBulbTemperature;
