within Buildings.Fluid.Examples.Performance;
model Example4 "Example 4 model of simple condensing heat exchanger"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;
  parameter Boolean allowFlowReversal=false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";

  Modelica.Units.SI.MassFlowRate m_condens=min(0, -vol.ports[1].m_flow*(bou.X[1]
       - xSat.X[1])) "Water vapor mass flow rate";
  Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    nPorts=2,
    ports(m_flow(min={0,-Modelica.Constants.inf})),
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal,
    prescribedHeatFlowRate=true) "Mixing volume for extracting moisture"
    annotation (Placement(transformation(extent={{0,16},{20,36}})));
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=1,
    m2_flow_nominal=1,
    dp1_nominal=0,
    dp2_nominal=0,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal) "Heat exchanger"
    annotation (Placement(transformation(extent={{-20,20},{-40,0}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=Medium.p_default + 1000,
    use_p_in=false,
    use_T_in=true,
    X={0.02,0.98},
    nPorts=2) "Sink and source"
              annotation (Placement(transformation(extent={{-70,-4},{-50,16}})));
  Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    T=273.15,
    nPorts=1) "Air source"
    annotation (Placement(transformation(extent={{20,14},{0,-6}})));
  Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium, nPorts=1)
    "Air sink" annotation (Placement(transformation(extent={{78,6},{58,26}})));
  Modelica.Blocks.Sources.RealExpression mCond(y=m_condens)
    annotation (Placement(transformation(extent={{-40,40},{-20,20}})));
  Buildings.Utilities.Psychrometrics.X_pTphi xSat(use_p_in=false)
    "Block for converting relative humidity into absolute humidity"
    annotation (Placement(transformation(extent={{30,52},{50,32}})));
  Modelica.Blocks.Sources.Constant phiSat(k=1) "Humidity of 100%"
    annotation (Placement(transformation(extent={{-28,40},{-12,56}})));
  Modelica.Blocks.Sources.Ramp Tin(
    duration=1,
    height=20,
    offset=293.15) "Inlet temperature ramp"
    annotation (Placement(transformation(extent={{-52,30},{-72,50}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100,
    allowFlowReversal=allowFlowReversal,
    from_dp=true) "Pressure drop component"
    annotation (Placement(transformation(extent={{30,6},{50,26}})));

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0) "Temperature sensor"
           annotation (Placement(transformation(extent={{-16,10},{-4,22}})));
equation
  connect(phiSat.y, xSat.phi) annotation (Line(
      points={{-11.2,48},{28,48}},
      color={0,0,127}));
  connect(mCond.y, vol.mWat_flow) annotation (Line(
      points={{-19,30},{-16,30},{-16,34},{-2,34}},
      color={0,0,127}));
  connect(Tin.y, bou.T_in) annotation (Line(
      points={{-73,40},{-80,40},{-80,10},{-72,10}},
      color={0,0,127}));
  connect(res.port_b, sin.ports[1]) annotation (Line(
      points={{50,16},{58,16}},
      color={0,127,255}));
  connect(senTem.port_b, vol.ports[1]) annotation (Line(
      points={{-4,16},{8,16}},
      color={0,127,255}));
  connect(senTem.T, xSat.T) annotation (Line(
      points={{-10,22.6},{-10,42},{28,42}},
      color={0,0,127}));
  connect(vol.ports[2], res.port_a) annotation (Line(
      points={{12,16},{30,16}},
      color={0,127,255}));
  connect(hex.port_a1, sou.ports[1]) annotation (Line(
      points={{-20,4},{0,4}},
      color={0,127,255}));
  connect(hex.port_a2, bou.ports[1]) annotation (Line(
      points={{-40,16},{-46,16},{-46,8},{-50,8}},
      color={0,127,255}));
  connect(hex.port_b1, bou.ports[2]) annotation (Line(
      points={{-40,4},{-50,4}},
      color={0,127,255}));
  connect(hex.port_b2, senTem.port_a) annotation (Line(
      points={{-20,16},{-16,16}},
      color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-20},
            {80,60}}),         graphics),    Documentation(revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
July 28, 2015, by Michael Wetter:<br/>
Moved assignment of <code>m_condens</code> from equation section to
declaration to avoid graphical and textual equations.
</li>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example generates a non-linear algebraic loop
that consists of <i>12</i> equations before manipulation.
This loop can be decoupled and removed by changing the equation
</p>
<pre>
port_a.m_flow + port_b.m_flow = -mWat_flow;
</pre>
<p>
in
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
to
</p>
<pre>
port_a.m_flow + port_b.m_flow = 0;
</pre>
<p>
See Jorissen et al. (2015) for a discussion.
</p>
<h4>References</h4>
<ul>
<li>
Filip Jorissen, Michael Wetter and Lieve Helsen.<br/>
Simulation speed analysis and improvements of Modelica
models for building energy simulation.<br/>
Submitted: 11th Modelica Conference. Paris, France. Sep. 2015.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=20),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/Example4.mos"
        "Simulate and plot"));
end Example4;
