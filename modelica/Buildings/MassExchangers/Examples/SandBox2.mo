model SandBox2 
  import Buildings;
  
  annotation(Diagram, Commands(file="HumidifierPrescribed.mos" "run"),
Documentation(info="<html>
<p>
Model that tests the basic class that is used for the humidifier model.
It adds and removes water for forward and reverse flow.
The top and bottom models should give similar results, although 
the sign of the humidity difference over the components differ
because of the reverse flow.
The model uses assert statements that will be triggered if
results that are expected to be close to each other differ by more
than a prescribed threshold.</p>
</html>",
revisions="<html>
<ul>
<li>
April 18, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Coordsys(extent=[-200,-200; 200,200]));
 package Medium = Modelica.Media.Air.MoistAir;
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,92; -180,112]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_1(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335)             annotation (extent=[-168,92; -148,112]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_12(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[-100,134; -80,154],
                                                  rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_1(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,134; -148,154],
                                                             rotation=0);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-200,140; -180,160]);
    Modelica.Blocks.Sources.Ramp u(
    height=2,
    duration=1,
    offset=-1,
    startTime=0) "Control signal" 
                 annotation (extent=[-148,174; -128,194]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_1(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=0.5) 
             annotation (extent=[20,134; 40,154], rotation=0);
  Buildings.MassExchangers.HumidifierPrescribed hea2(
                                                 redeclare package Medium = 
        Medium, Q0_flow=5000) "Heater and cooler" annotation (extent=[-40,134;
        -20,154]);
equation 
  connect(POut.y,sin_1. p_in) annotation (points=[-179,150; -170,150],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y,sou_1. T_in) annotation (points=[-179,102; -170,102],
                                                                  style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_1.port, res_12.port_a) annotation (points=[-148,144; -100,144],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(sou_1.port, res_1.port_b) annotation (points=[-148,102; 108,102; 108,
        144; 40,144], style(color=69, rgbcolor={0,127,255}));
  connect(hea2.port_b, res_1.port_a) annotation (points=[-20,144; 0,144; 0,144;
        20,144], style(color=69, rgbcolor={0,127,255}));
  connect(res_12.port_b, hea2.port_a) annotation (points=[-80,144; -58,144; -58,
        144; -40,144], style(color=69, rgbcolor={0,127,255}));
  connect(u.y, hea2.u) annotation (points=[-127,184; -81.5,184; -81.5,150; -42,
        150], style(color=74, rgbcolor={0,0,127}));
end SandBox2;
