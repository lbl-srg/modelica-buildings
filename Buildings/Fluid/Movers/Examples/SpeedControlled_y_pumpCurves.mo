within Buildings.Fluid.Movers.Examples;
model SpeedControlled_y_pumpCurves
  "Pumps that illustrates the use of the pump curves"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";

  // For OpenModelica, changed m_flow_nominal to a constant. Otherwise
  // the translation fails with "Error: Cyclically dependent parameters found"
  constant Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate";
  // For OpenModelica, changed dp_nominal to a constant. Otherwise
  // the compilation fails.
  constant Modelica.Units.SI.PressureDifference dp_nominal=10000
    "Nominal pressure";

   model pumpModel = Buildings.Fluid.Movers.SpeedControlled_y (
      redeclare package Medium = Medium,
      use_riseTime=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      per(pressure(V_flow=2/1000*m_flow_nominal*{0.2,0.4,0.6,0.8}, dp=
              dp_nominal*{0.9,0.85,0.6,0.2})))
    "Declaration of pump model";

  pumpModel pum(
    inputType=Buildings.Fluid.Types.InputType.Constant,
    per(constantSpeed=1)) "Pump"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  pumpModel pum1(
    inputType=Buildings.Fluid.Types.InputType.Constant,
    per(constantSpeed=0.5)) "Pump"
    annotation (Placement(transformation(extent={{40,38},{60,58}})));
  pumpModel pum2(
    inputType=Buildings.Fluid.Types.InputType.Constant,
    per(constantSpeed=0.05)) "Pump"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  pumpModel pum3(
    inputType=Buildings.Fluid.Types.InputType.Constant,
    per(constantSpeed=0.01)) "Pump"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Modelica.Blocks.Sources.Ramp y(
    offset=1,
    duration=0.5,
    startTime=0.25,
    height=-0.999)
               "Input signal"
                 annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=300000,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{-70,78},{-50,98}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=4,
    p(displayUnit="Pa") = 300000,
    T=293.15) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=180,
        origin={128,88})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.01*dp_nominal,
    use_strokeTime=false) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.01*dp_nominal,
    use_strokeTime=false) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,38},{0,58}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear dp3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.01*dp_nominal,
    use_strokeTime=false) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear dp4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.01*dp_nominal,
    use_strokeTime=false) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(dp1.port_b, pum.port_a)      annotation (Line(
      points={{5.55112e-16,90},{40,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_a, sou.ports[1]) annotation (Line(
      points={{-20,90},{-31,90},{-31,86.5},{-50,86.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, dp1.y) annotation (Line(
      points={{-59,130},{-10,130},{-10,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp2.port_b, pum1.port_a)     annotation (Line(
      points={{5.55112e-16,48},{40,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y,dp2. y) annotation (Line(
      points={{-59,130},{-26,130},{-26,68},{-10,68},{-10,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[2], dp2.port_a) annotation (Line(
      points={{-50,87.5},{-32,87.5},{-32,48},{-20,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp3.port_b, pum2.port_a)     annotation (Line(
      points={{5.55112e-16,6.10623e-16},{10,6.10623e-16},{10,0},{20,0},{20,
          6.10623e-16},{40,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y,dp3. y) annotation (Line(
      points={{-59,130},{-26,130},{-26,20},{-10,20},{-10,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp3.port_a, sou.ports[3]) annotation (Line(
      points={{-20,0},{-28,0},{-36,0},{-36,86},{-50,86},{-50,88.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp4.port_b, pum3.port_a)     annotation (Line(
      points={{5.55112e-16,-50},{40,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y,dp4. y) annotation (Line(
      points={{-59,130},{-26,130},{-26,-30},{-10,-30},{-10,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp4.port_a, sou.ports[4]) annotation (Line(
      points={{-20,-50},{-38,-50},{-38,89.5},{-50,89.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum3.port_b, sou1.ports[1]) annotation (Line(
      points={{60,-50},{110,-50},{110,89.5},{118,89.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum2.port_b, sou1.ports[2]) annotation (Line(
      points={{60,0},{80,0},{80,0},{106,0},{106,88.5},{118,88.5}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(pum1.port_b, sou1.ports[3]) annotation (Line(
      points={{60,48},{104,48},{104,87.5},{118,87.5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, sou1.ports[4]) annotation (Line(
      points={{60,90},{89,90},{89,86.5},{118,86.5}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{160,
            160}})),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/SpeedControlled_y_pumpCurves.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates how the pump curves changes for different (constant) input
signal <code>y</code>.
If <code>y &ge; delta = 0.05</code>, the pump curves are polynomials.
For <code>y &lt; delta = 0.05</code>, the pump curves convert to linear functions to
avoid a singularity at the origin.
</p>
</html>", revisions="<html>
<ul>
<li>
December 2, 2016, by Michael Wetter:<br/>
Changed the valve opening signal to not take on zero as otherwise <code>pum.port_a.p</code>
is negative, violating the <code>min</code> attribute on the pressure variable.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
March 11, 2016, by Michael Wetter:<br/>
Reformulated model for OpenModelica.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
June 14, 2015, by Filip Jorissen:<br/>
Set constant speed for pump using a <code>parameter</code>
instead of a <code>realInput</code>.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled_y_pumpCurves;
