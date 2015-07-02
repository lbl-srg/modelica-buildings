within Buildings.Fluid.Examples;
model ResistanceVolumeFlowReversal
  "System demonstrating impact of allowFlowReversal on number/size of non-linear systems"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real m_flow_nominal=0.1 "Gain value multiplied with input signal";
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary for pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    filteredSpeed=false,
    allowFlowReversal=allowFlowReversal.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump model with unidirectional flow"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    Q_flow_maxHeat=1000,
    Q_flow_maxCool=0,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal.k) "Heater"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=1000) "Pulse input"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) "Gain for m_flow_nominal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    l={0.002,0.002},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dynamicBalance=false) "Three way valve with constant input"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Sources.Constant const(k=0.5) "Constant valve set point"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.BooleanConstant allowFlowReversal(k=false)
    "Block for setting allowFlowReversal in components"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM[nRes.k] res(
    redeclare package Medium = Medium,
    each allowFlowReversal=allowFlowReversal.k,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=1000) "Fluid resistance for splitting flow"
    annotation (Placement(transformation(extent={{56,-30},{76,-10}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=10)
    "Number of parallel branches"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Delays.DelayFirstOrder[nRes.k] vol(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each nPorts=2,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each allowFlowReversal=true) "Mixing volumes for enthalpy circuit"
    annotation (Placement(transformation(extent={{60,-66},{40,-46}})));
equation
  connect(bou.ports[1],hea. port_a) annotation (Line(
      points={{-60,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y,hea. TSet) annotation (Line(
      points={{-59,50},{-50,50},{-50,-14},{-42,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.m_flow_in, gain.y) annotation (Line(
      points={{29.8,-8},{29.8,50},{-19,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u,pulse. y) annotation (Line(
      points={{-42,50},{-59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.port_b,val. port_1) annotation (Line(
      points={{-20,-20},{-10,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val.port_2, pump.port_a) annotation (Line(
      points={{10,-20},{20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y,val. y) annotation (Line(
      points={{-19,10},{0,10},{0,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_3,hea. port_a) annotation (Line(
      points={{0,-30},{0,-70},{-50,-70},{-50,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nRes.k loop
    connect(pump.port_b, res[i].port_a) annotation (Line(
        points={{40,-20},{56,-20}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(res[i].port_b, vol[i].ports[1]) annotation (Line(
      points={{76,-20},{80,-20},{80,-70},{52,-70},{52,-66}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(vol[i].ports[2], val.port_3) annotation (Line(
      points={{48,-66},{48,-70},{0,-70},{0,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  annotation (experiment(
      StopTime=10000),
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/ResistanceVolumeFlowReversal.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model demonstrates the impact of the <code>allowFlowReversal</code> parameter on the sizes
of nonlinear systems of equations. The user can change the parameter value in the <code>allowFlowReversal</code>
block and rerun the simulation. The results are also demonstrated below for <code>nRes.k = 10</code>, 
which is the number of parallel branches containing one pressure drop element and one mixing volume each.
</p>
<p>
This model was created to demonstrate the influence of a new implementation of 
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquationcode\">
Buildings.Fluid.Interfaces.ConservationEquationcode</a>.
The old implementation used the <code>actualStream()</code> function
whereas the new implementation uses the <code>semiLinear()</code>
function. This change allows Dymola to exploit knowledge about the <code>min</code> and <code>max</code> attributes
of <code>m_flow</code>.
When Dymola knows in which way the medium will flow, nonlinear systems can be simplified or completely removed. 
This is illustrated by the results below. 
See <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/216\">issue 216</a> for a discussion.
</p>
<p>
Note that Dymola 2015FD01 can only reliable solve the last case. For the other
two cases the Newton solver of the nonlinear system does not converge.
</p>
<p>
These results were generated using Dymola 2015FD01 64 bit on Ubuntu 14.04
and with <code>Evaluate=false</code>.
</p>
<h3>
ResistanceVolumeFlowReversal = true
</h3>
<p>
Sizes of nonlinear systems of equations: {6, 11, <b>56</b>}<br/>
Sizes after manipulation of the nonlinear systems: {1, 9, <b>12</b>}
</p>
<h3>
ResistanceVolumeFlowReversal = false
</h3>
<p>
<b>Old implementation</b>
</p>
<p>
Sizes of nonlinear systems of equations: {6, 11, <b>44</b>}<br/>
Sizes after manipulation of the nonlinear systems: {1, 9, <b>11</b>}
</p>
<p>
<b>New implementation</b>
</p>
<p>
Sizes of nonlinear systems of equations: {6, 11, <b>4</b>}<br/>
Sizes after manipulation of the nonlinear systems: {1, 9, <b>1</b>}
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end ResistanceVolumeFlowReversal;
