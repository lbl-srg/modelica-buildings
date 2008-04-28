model SandBox1 
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
  parameter Modelica.SIunits.MassFlowRate mWat_flow = 0.0001 
    "Water added to air stream";
  parameter Medium.MassFraction X1 = 0.01 "Water mass fraction";
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature" 
    annotation (extent=[-200,92; -180,112]);
    Modelica.Blocks.Sources.Constant POut(k=101325) 
      annotation (extent=[-200,140; -180,160]);
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (extent=[-50,174; -30,194]);
  Buildings.MassExchangers.HumidifierPrescribed hea3(redeclare package Medium 
      = Medium, m0_flow=mWat_flow) "Heater and cooler" 
                                                  annotation (extent=[-54,12; -34,32]);
  
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou_2(
    T=293.15,
    redeclare package Medium = Medium,
    p=101335,
    X={X1,1-X1})          annotation (extent=[-168,12; -148,32]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_2(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=1) 
             annotation (extent=[-100,12; -80,32]);
    Buildings.Fluids.FixedResistances.FixedResistanceDpM res_3(
    from_dp=true,
    redeclare package Medium = Medium,
    dp0=5,
    m0_flow=1) 
             annotation (extent=[-100,54; -80,74],rotation=0);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin_2(          redeclare 
      package Medium = Medium, T=288.15) 
                          annotation (extent=[-168,54; -148,74],
                                                             rotation=0);
  Buildings.MassExchangers.HumidifierPrescribed hea4(
                                                 redeclare package Medium = 
        Medium, m0_flow=0) "Heater and cooler"    annotation (extent=[-12,54; 8,74]);
  Modelica_Fluid.Volumes.MixingVolume mix1(redeclare package Medium = Medium, V=
        0.00000001) 
                 annotation (extent=[-22,12; -2,32]);
  Modelica_Fluid.Sensors.Temperature temperature(redeclare package Medium = 
        Medium) annotation (extent=[-132,10; -112,30]);
  Modelica.Blocks.Sources.Constant u(k=1) 
    annotation (extent=[-110,178; -90,198]);
equation 
  
  connect(POut.y,sin_2. p_in) annotation (points=[-179,150; -179.5,150; -179.5,
        70; -170,70],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(TDb.y,sou_2. T_in) annotation (points=[-179,102; -179.5,102; -179.5,
        22; -170,22],                                             style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sin_2.port, res_3.port_a)  annotation (points=[-148,64; -100,64],
                                                                          style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_2.port_b, hea3.port_a) annotation (points=[-80,22; -54,22],
                style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(hea3.port_b, mix1.port_a) annotation (points=[-34,22; -22.2,22],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(res_3.port_b, hea4.port_a) annotation (points=[-80,64; -12,64],
      style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  connect(gain.y, hea4.u) annotation (points=[-29,184; -22,184; -22,70; -14,70], 
      style(color=74, rgbcolor={0,0,127}));
  connect(sou_2.port, temperature.port_a) annotation (points=[-148,22; -140,22; 
        -140,20; -132,20], style(color=69, rgbcolor={0,127,255}));
  connect(temperature.port_b, res_2.port_a) annotation (points=[-112,20; -106,
        20; -106,22; -100,22], style(color=69, rgbcolor={0,127,255}));
  connect(temperature.T, hea3.T_in) annotation (points=[-122,9; -90,9; -90,16; 
        -56,16], style(color=74, rgbcolor={0,0,127}));
  connect(u.y, gain.u) annotation (points=[-89,188; -72,188; -72,184; -52,184], 
      style(color=74, rgbcolor={0,0,127}));
  connect(u.y, hea3.u) annotation (points=[-89,188; -89,108; -56,108; -56,28], 
      style(color=74, rgbcolor={0,0,127}));
  connect(mix1.port_b, hea4.port_b) annotation (points=[-2,22; 4,22; 4,64; 8,64], 
      style(color=69, rgbcolor={0,127,255}));
end SandBox1;
