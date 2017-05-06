within Buildings.Fluid.Boilers.Examples;
model BoilerPolynomial "Test model"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";
 parameter Modelica.SIunits.Power Q_flow_nominal = 3000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    p(displayUnit="Pa") = 300000,
    T=333.15) "Sink"
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = Medium,
    p=300000 + dp_nominal,
    T=303.15)
    annotation (Placement(transformation(extent={{-80,-68},{-60,-48}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,
        1; 3600,1])
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Fluid.Boilers.BoilerPolynomial boi1(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal = m_flow_nominal,
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    T_start=293.15) "Boiler"
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb1(      T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-30,28},{-10,48}})));
  Buildings.Fluid.Boilers.BoilerPolynomial boi2(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal = m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15) "Boiler"
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb2(      T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-32,-40},{-12,-20}})));
equation
  connect(TAmb1.port, boi1.heatPort)
                                   annotation (Line(
      points={{-10,38},{0,38},{0,15.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb2.port, boi2.heatPort)
                                   annotation (Line(
      points={{-12,-30},{-2,-30},{-2,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], boi1.port_a) annotation (Line(
      points={{-60,-56},{-36,-56},{-36,8},{-10,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], boi2.port_a) annotation (Line(
      points={{-60,-60},{-12,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(
      points={{8,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(
      points={{10,8},{40,8},{40,-56},{70,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, boi1.y) annotation (Line(
      points={{-59,-20},{-50,-20},{-50,16},{-12,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y.y, boi2.y) annotation (Line(
      points={{-59,-20},{-50,-20},{-50,-52},{-14,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerPolynomial.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
This example demonstrates the open loop response of the boiler
model for a control signal that is first a ramp from <i>0</i>
to <i>1</i>, followed by a step that switches the boilers off and
then on again.
The instances of the boiler models are parameterized
so that <code>boi1</code> is a dynamic model and
<code>boi2</code> is a steady-state model.
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
April 27, 2013, by Michael Wetter:<br/>
Removed first order filter from the output of the table.
This is not needed and leads to a dynamic state selection.
</li>
<li>
November 1, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPolynomial;
