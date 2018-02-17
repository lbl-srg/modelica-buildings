within Buildings.Fluid.Movers.Validation;
model SpeedControlled_y_linear
  "Pump with linear characteristic for pressure vs. flow rate"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.5
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 10000
    "Nominal pressure";

  Modelica.Blocks.Sources.Ramp y(
    offset=1,
    duration=0.5,
    startTime=0.25,
    height=-1) "Input signal"
                 annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=300000,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-62,80},{-42,100}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumFixDp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(V_flow=2/1000*{0,m_flow_nominal}, dp={2*dp_nominal,0})),
    use_inputFilter=false) "Pump with fixed pressure raise"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 300000 + 0.01*dp_nominal,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=180,
        origin={128,90})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.01*dp_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal*0.01,
    T=293.15) annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumFixM_flow(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(V_flow=2/1000*{0,m_flow_nominal}, dp={2*dp_nominal,0})),
    use_inputFilter=false) "Pump with fixed mass flow rate"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou3(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 300000 + 0.01*dp_nominal,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=180,
        origin={128,50})));
equation
  connect(pumFixDp.port_b, sou1.ports[1]) annotation (Line(
      points={{60,90},{118,90}},
      color={0,127,255}));
  connect(dp1.port_b, pumFixDp.port_a) annotation (Line(
      points={{5.55112e-16,90},{40,90}},
      color={0,127,255}));
  connect(dp1.port_a, sou.ports[1]) annotation (Line(
      points={{-20,90},{-42,90}},
      color={0,127,255}));
  connect(pumFixM_flow.port_b, sou3.ports[1]) annotation (Line(
      points={{60,50},{118,50}},
      color={0,127,255}));
  connect(sou2.ports[1], pumFixM_flow.port_a) annotation (Line(
      points={{-42,50},{40,50}},
      color={0,127,255}));
  connect(y.y, pumFixDp.y) annotation (Line(
      points={{-59,130},{50,130},{50,102}},
      color={0,0,127}));
  connect(y.y, pumFixM_flow.y) annotation (Line(
      points={{-59,130},{10,130},{10,70},{50,70},{50,62}},
      color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
experiment(Tolerance=1e-06, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/SpeedControlled_y_linear.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates and tests the use of a flow machine whose speed is reduced to zero.
In the top model, the pressure drop across the pump is constant, and in the bottom model,
the mass flow rate across the pump is constant.
In the top model, a small flow resistance has been added since a pump with zero speed cannot
produce a non-zero pressure raise. For this operating region, the pressure drop ensures that
the model is non-singular.
</p>
<p>
The fans have been configured as steady-state models.
This ensures that the actual speed is equal to the input signal.
</p>
</html>", revisions="<html>
<ul>
<li>February 20, 2016, by Ruben Baetens:<br/>
Removal of <code>dynamicBalance</code> as parameter for <code>massDynamics</code> and <code>energyDynamics</code>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled_y_linear;
