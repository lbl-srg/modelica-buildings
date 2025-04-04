within Buildings.Fluid.Movers.Validation;
model Pump_y_stratos "Model validation using a Wilo Stratos 80/1-12 pump"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.Pumps.Wilo.Stratos80slash1to12 per "Pump performance data"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=5) "Boundary condition with fixed pressure"
    annotation (Placement(transformation(extent={{-120,-32},{-100,-12}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium =Medium,
    nPorts=5) "Boundary condition with fixed pressure"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));

  Modelica.Blocks.Sources.Ramp m_flow(
    startTime=100,
    duration=800,
    height=60/3.6,
    offset=0) "Ramp signal for forced mass flow rate"
    annotation (Placement(transformation(extent={{-36,88},{-24,100}})));

  Buildings.Fluid.Movers.SpeedControlled_y pump1(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Movers.SpeedControlled_y pump2(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Movers.SpeedControlled_y pump3(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Buildings.Fluid.Movers.SpeedControlled_y pump4(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Movers.SpeedControlled_y pump5(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump1(
    redeclare package Medium = Medium,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,60},{58,80}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump2(
    redeclare package Medium = Medium,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,10},{58,30}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump3(
    redeclare package Medium = Medium,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,-36},{58,-16}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump4(
    redeclare package Medium = Medium,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,-80},{58,-60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump5(
    redeclare package Medium = Medium,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,-130},{58,-110}})));

  Modelica.Blocks.Sources.Constant y1(k=2960/2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,84},{-78,96}})));
  Modelica.Blocks.Sources.Constant y2(k=2610/2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,34},{-78,46}})));
  Modelica.Blocks.Sources.Constant y3(k=1930/2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-6},{-78,6}})));
  Modelica.Blocks.Sources.Constant y4(k=3300/2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-56},{-78,-44}})));
  Modelica.Blocks.Sources.Constant y5(k=900/2610) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,-108},{-78,-96}})));

  Modelica.Blocks.Math.Min min1
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,91})));
  Modelica.Blocks.Math.Min min2
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,45})));
  Modelica.Blocks.Math.Min min3
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,-5})));
  Modelica.Blocks.Math.Min min4
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,-49})));
  Modelica.Blocks.Math.Min min5
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,-97})));

  Modelica.Blocks.Sources.Constant mMax_flow1(k=40/3.6)
    "Maximum flow rate of the pump at given speed"
    annotation (Placement(transformation(extent={{2,76},{14,88}})));
  Modelica.Blocks.Sources.Constant mMax_flow2(k=55/3.6)
    "Maximum flow rate of the pump at given speed"
    annotation (Placement(transformation(extent={{0,30},{12,42}})));
  Modelica.Blocks.Sources.Constant mMax_flow3(k=40/3.6)
    "Maximum flow rate of the pump at given speed"
    annotation (Placement(transformation(extent={{0,-20},{12,-8}})));
  Modelica.Blocks.Sources.Constant mMax_flow4(k=22/3.6)
    "Maximum flow rate of the pump at given speed"
    annotation (Placement(transformation(extent={{0,-64},{12,-52}})));
  Modelica.Blocks.Sources.Constant mMax_flow5(k=16/3.6)
    "Maximum flow rate of the pump at given speed"
    annotation (Placement(transformation(extent={{0,-112},{12,-100}})));

equation
  connect(sou.ports[1], pump1.port_a) annotation (Line(
      points={{-100,-23.6},{-70,-23.6},{-70,70},{-60,70}},
      color={0,127,255}));
  connect(forcedPump1.port_a, pump1.port_b) annotation (Line(
      points={{38,70},{-40,70}},
      color={0,127,255}));
  connect(pump1.y, y1.y)
    annotation (Line(points={{-50,82},{-50,90},{-77.4,90}}, color={0,0,127}));
  connect(pump2.port_a, sou.ports[2]) annotation (Line(
      points={{-60,20},{-70,20},{-70,-22.8},{-100,-22.8}},
      color={0,127,255}));
  connect(pump3.port_a, sou.ports[3]) annotation (Line(
      points={{-60,-26},{-70,-26},{-70,-22},{-100,-22}},
      color={0,127,255}));
  connect(pump4.port_a, sou.ports[4]) annotation (Line(
      points={{-60,-70},{-70,-70},{-70,-24},{-96,-24},{-96,-21.2},{-100,-21.2}},
      color={0,127,255}));

  connect(pump5.port_a, sou.ports[5]) annotation (Line(
      points={{-60,-120},{-70,-120},{-70,-20.4},{-100,-20.4}},
      color={0,127,255}));
  connect(pump2.port_b, forcedPump2.port_a) annotation (Line(
      points={{-40,20},{38,20}},
      color={0,127,255}));
  connect(pump3.port_b, forcedPump3.port_a) annotation (Line(
      points={{-40,-26},{38,-26}},
      color={0,127,255}));
  connect(pump4.port_b, forcedPump4.port_a) annotation (Line(
      points={{-40,-70},{38,-70}},
      color={0,127,255}));
  connect(pump5.port_b, forcedPump5.port_a) annotation (Line(
      points={{-40,-120},{38,-120}},
      color={0,127,255}));
  connect(y2.y, pump2.y)
    annotation (Line(points={{-77.4,40},{-50,40},{-50,32}}, color={0,0,127}));
  connect(y3.y, pump3.y)
    annotation (Line(points={{-77.4,0},{-50,0},{-50,-14}}, color={0,0,127}));
  connect(y4.y, pump4.y) annotation (Line(points={{-77.4,-50},{-50,-50},{-50,-58}},
        color={0,0,127}));
  connect(y5.y, pump5.y) annotation (Line(points={{-77.4,-102},{-50,-102},{-50,-108}},
        color={0,0,127}));
  connect(forcedPump1.m_flow_in, min1.y) annotation (Line(
      points={{48,82},{48,82},{48,91},{40.5,91}},
      color={0,0,127}));
  connect(min1.u1, m_flow.y) annotation (Line(
      points={{29,94},{-23.4,94}},
      color={0,0,127}));
  connect(min2.y, forcedPump2.m_flow_in) annotation (Line(
      points={{40.5,45},{48,45},{48,32},{48,32}},
      color={0,0,127}));
  connect(min2.u1, m_flow.y) annotation (Line(
      points={{29,48},{-14,48},{-14,94},{-23.4,94}},
      color={0,0,127}));
  connect(min3.y, forcedPump3.m_flow_in) annotation (Line(
      points={{40.5,-5},{44.25,-5},{44.25,-14},{48,-14}},
      color={0,0,127}));
  connect(min5.y, forcedPump5.m_flow_in) annotation (Line(
      points={{40.5,-97},{44.25,-97},{44.25,-108},{48,-108}},
      color={0,0,127}));
  connect(min4.y, forcedPump4.m_flow_in) annotation (Line(
      points={{40.5,-49},{44.25,-49},{44.25,-58},{48,-58}},
      color={0,0,127}));
  connect(min3.u1, m_flow.y) annotation (Line(
      points={{29,-2},{-14,-2},{-14,94},{-23.4,94}},
      color={0,0,127}));
  connect(min4.u1, m_flow.y) annotation (Line(
      points={{29,-46},{-14,-46},{-14,94},{-23.4,94}},
      color={0,0,127}));
  connect(min5.u1, m_flow.y) annotation (Line(
      points={{29,-94},{-14,-94},{-14,94},{-23.4,94}},
      color={0,0,127}));
  connect(mMax_flow1.y, min1.u2) annotation (Line(
      points={{14.6,82},{18,82},{18,88},{29,88}},
      color={0,0,127}));
  connect(mMax_flow2.y, min2.u2) annotation (Line(
      points={{12.6,36},{20,36},{20,42},{29,42}},
      color={0,0,127}));
  connect(min3.u2, mMax_flow3.y) annotation (Line(
      points={{29,-8},{20,-8},{20,-14},{12.6,-14}},
      color={0,0,127}));
  connect(mMax_flow4.y, min4.u2) annotation (Line(
      points={{12.6,-58},{26,-58},{26,-52},{29,-52}},
      color={0,0,127}));
  connect(mMax_flow5.y, min5.u2) annotation (Line(
      points={{12.6,-106},{20,-106},{20,-100},{29,-100}},
      color={0,0,127}));
  connect(forcedPump1.port_b, sin.ports[1]) annotation (Line(
      points={{58,70},{100,70},{100,-1.6},{110,-1.6}},
      color={0,127,255}));
  connect(forcedPump2.port_b, sin.ports[2]) annotation (Line(
      points={{58,20},{100,20},{100,-0.8},{110,-0.8}},
      color={0,127,255}));
  connect(forcedPump3.port_b, sin.ports[3]) annotation (Line(
      points={{58,-26},{100,-26},{100,0},{110,0}},
      color={0,127,255}));
  connect(forcedPump4.port_b, sin.ports[4]) annotation (Line(
      points={{58,-70},{100,-70},{100,-2.66667},{110,-2.66667},{110,0.8}},
      color={0,127,255}));
  connect(forcedPump5.port_b, sin.ports[5]) annotation (Line(
      points={{58,-120},{100,-120},{100,-1},{110,-1},{110,1.6}},
      color={0,127,255}));

  annotation (experiment(Tolerance=1e-08, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/Pump_y_stratos.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example provides a validation for the speed-controlled model.
A Wilo Stratos 80/1-12 pump is simulated for five different speeds for load
that changes with time.
The resulting curves for the pump head and mass flow rate are plotted
using colored lines over the pump data sheet.
The resulting figures are shown below.
</p>
<p>Pump heads:</p>
<p><img src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Validation/PumpValidationHead.png\"
alt=\"Pump head.\"/>
</p>
<p>Pump electrical power:</p>
<p><img src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Validation/PumpValidationPower.png\"
alt=\"Pump power.\"/></p>
<p>The figures are adapted from the
<a href=\"http://productfinder.wilo.com/en/COM/product/0000001700017d670001003a/fc_product_datasheet\">
Wilo Stratos 80/1-12 data sheet</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 8, 2024, by Hongxiang Fu:<br/>
Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
in the mover component to suppress a warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
<li>
March 21, 2023, by Hongxiang Fu:<br/>
Replaced the pumps with <code>Nrpm</code> signal with ones with <code>y</code>
signal.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed dublicate <code>experiment</code> annotation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
November 26, 2014, by Filip Jorissen:<br/>
Cleaned up implementation
</li>
<li>
February 27, 2014, by Filip Jorissen:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-140},{140,120}},
          preserveAspectRatio=false)));
end Pump_y_stratos;
