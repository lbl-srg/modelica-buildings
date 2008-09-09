model TwoWayValvesMotor 
  
    annotation (Diagram, Commands(file=
            "TwoWayValvesMotor.mos" "run"),
    Documentation(info="<html>
<p>
Test model for two way valves. Note that the 
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
  
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  
  Buildings.Fluids.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    k_SI=2/sqrt(6000)) "Valve model, linear opening characteristics" 
         annotation (extent=[0,10; 20,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sou(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[-68,10;
        -48,30]);
  Modelica_Fluid.Sources.PrescribedBoundary_pTX sin(redeclare package Medium = 
        Medium, T=293.15)                           annotation (extent=[74,10;
        54,30]);
    Modelica.Blocks.Sources.Constant PSin(k=3E5) 
      annotation (extent=[60,60; 80,80]);
    Modelica.Blocks.Sources.Constant PSou(k=306000) 
      annotation (extent=[-100,16; -80,36]);
  Buildings.Fluids.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    k_SI=2/sqrt(6000)) "Valve model, quick opening characteristics" 
         annotation (extent=[0,-20; 20,0]);
  Buildings.Fluids.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    k_SI=2/sqrt(6000),
    R=10,
    delta0=0.1) "Valve model, equal percentage opening characteristics" 
         annotation (extent=[0,-50; 20,-30]);
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25]) 
    "Set point for actuator" annotation (extent=[-100,60; -80,80]);
  Actuators.Motors.IdealMotor mot(                 tOpe=60) "Motor model" 
    annotation (extent=[-60,60; -40,80]);
equation 
  connect(valLin.port_b, sin.port) 
    annotation (points=[20,20; 54,20], style(color=69, rgbcolor={0,127,255}));
  connect(valLin.port_a, sou.port) 
                                annotation (points=[-5.55112e-16,20; -48,20],
                         style(color=69, rgbcolor={0,127,255}));
  connect(PSin.y, sin.p_in) annotation (points=[81,70; 86,70; 86,26; 76,26],
      style(color=74, rgbcolor={0,0,127}));
  connect(PSou.y, sou.p_in) 
    annotation (points=[-79,26; -70,26], style(color=74, rgbcolor={0,0,127}));
  connect(valQui.port_b, sin.port) 
    annotation (points=[20,-10; 32,-10; 32,20; 54,20],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(valQui.port_a, sou.port) 
                                annotation (points=[-5.55112e-16,-10; -29,-10; 
        -29,20; -48,20], style(color=69, rgbcolor={0,127,255}));
  connect(valEqu.port_b, sin.port) 
    annotation (points=[20,-40; 32,-40; 32,20; 54,20],
                                       style(color=69, rgbcolor={0,127,255}));
  connect(valEqu.port_a, sou.port) 
                                annotation (points=[-5.55112e-16,-40; -29,-40; 
        -29,20; -48,20], style(color=69, rgbcolor={0,127,255}));
  connect(ySet.y, mot.u) 
    annotation (points=[-79,70; -62,70], style(color=74, rgbcolor={0,0,127}));
  connect(mot.y, valEqu.y) annotation (points=[-39,70; -12,70; -12,-32; -2,-32],
      style(color=74, rgbcolor={0,0,127}));
  connect(mot.y, valQui.y) annotation (points=[-39,70; -12,70; -12,-2; -2,-2],
      style(color=74, rgbcolor={0,0,127}));
  connect(mot.y, valLin.y) annotation (points=[-39,70; -12,70; -12,28; -2,28],
      style(color=74, rgbcolor={0,0,127}));
end TwoWayValvesMotor;
