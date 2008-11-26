model ThreeWayValves 
  
    annotation (Diagram, Commands(file=
            "ThreeWayValves.mos" "run"),
    Documentation(info="<html>
<p>
Test model for three way valves. Note that the 
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
 package Medium = Buildings.Media.ConstantPropertyLiquidWater 
    "Medium in the component";
  
  Buildings.Fluids.Actuators.Valves.ThreeWayLinear valLin(
    redeclare package Medium = Medium,
    k_SI=2/sqrt(6000),
    l={0.05,0.05}) "Valve model, linear opening characteristics" 
         annotation (extent=[0,-26; 20,-6]);
    Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal" 
                 annotation (extent=[-60,60; -40,80]);
    Modelica.Blocks.Sources.Ramp P(
    duration=0.5,
    startTime=0.5,
    height=6E3,
    offset=3E5)  annotation (extent=[-100,60; -80,80]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,-26;
        -48,-6]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[74,-26;
        54,-6]);
    Modelica.Blocks.Sources.Constant PSin(k=3E5) 
      annotation (extent=[60,60; 80,80]);
    Modelica.Blocks.Sources.Constant PSou(k=306000) 
      annotation (extent=[-100,-20; -80,0]);
  Buildings.Fluids.Sources.PrescribedBoundary_pTX sou1(
                                                    redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-70,-60;
        -50,-40]);
  Actuators.Valves.ThreeWayEqualPercentageLinear valEquPerLin(
    k_SI=2/sqrt(6000),
    l={0.05,0.05},
    redeclare package Medium = Medium,
    R=10) 
    annotation (extent=[0,-60; 20,-40]);
equation 
  connect(y.y, valLin.y) annotation (points=[-39,70; -12,70; -12,-8; -2,-8],
      style(
      color=74,
      rgbcolor={0,0,127},
      pattern=0,
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(PSin.y, sin.p_in) annotation (points=[81,70; 86,70; 86,-10; 76,-10],
      style(color=74, rgbcolor={0,0,127}));
  connect(PSou.y, sou.p_in) 
    annotation (points=[-79,-10; -70,-10],
                                         style(color=74, rgbcolor={0,0,127}));
  connect(PSou.y, sou1.p_in) annotation (points=[-79,-10; -74,-10; -74,-44; -72,
        -44],style(color=74, rgbcolor={0,0,127}));
  connect(sou1.port, valLin.port_3) annotation (points=[-50,-50; -40,-50; -40,
        -32; 10,-32; 10,-26],
      style(color=69, rgbcolor={0,127,255}));
  connect(sou.port, valLin.port_1) annotation (points=[-48,-16; -1,-16], style(
        color=69, rgbcolor={0,127,255}));
  connect(sin.port, valLin.port_2) annotation (points=[54,-16; 21,-16], style(
        color=69, rgbcolor={0,127,255}));
  connect(sou.port, valEquPerLin.port_1) annotation (points=[-48,-16; -26,-16; 
        -26,-50; -1,-50], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(sou1.port, valEquPerLin.port_3) annotation (points=[-50,-50; -40,-50;
        -40,-70; 10,-70; 10,-60], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(valEquPerLin.port_2, sin.port) annotation (points=[21,-50; 40,-50; 40,
        -16; 54,-16], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
  connect(y.y, valEquPerLin.y) annotation (points=[-39,70; -12,70; -12,-42; -2,
        -42], style(
      color=74,
      rgbcolor={0,0,127},
      fillColor=0,
      rgbfillColor={0,0,0},
      fillPattern=1));
end ThreeWayValves;
