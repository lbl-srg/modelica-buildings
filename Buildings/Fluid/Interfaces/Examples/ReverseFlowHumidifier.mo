within Buildings.Fluid.Interfaces.Examples;
model ReverseFlowHumidifier
  "Model that tests the reverse flow for a humidifier"
  extends Modelica.Icons.Example;
package Medium = Buildings.Media.Air;
  Modelica.Blocks.Math.Add cheTem(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Math.Add cheEnt(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Modelica.Blocks.Math.Add cheMas(k2=-1)
    "Check whether the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Fluid.Humidifiers.Humidifier_u humBac(
    redeclare package Medium = Medium,
    dp_nominal=0,
    m_flow(start=1),
    m_flow_nominal=1,
    mWat_flow_nominal=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Humidifier with backward flow"
    annotation (Placement(transformation(extent={{-32,-16},{-52,4}})));
  Buildings.Fluid.Humidifiers.Humidifier_u humFor(
    redeclare package Medium = Medium,
    dp_nominal=0,
    m_flow(start=1),
    m_flow_nominal=1,
    mWat_flow_nominal=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Humidifier with forward flow"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Constant u2(k=0.01) "Control input"
    annotation (Placement(transformation(extent={{-92,54},{-80,66}})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    T(displayUnit="K") = 323.15,
    X={0.01,0.99},
    nPorts=1,
    m_flow=0.5) "Fluid source"
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,30})));
  Buildings.Fluid.Sources.FixedBoundary sink1(
    redeclare package Medium = Medium,
    nPorts=2) "Fluid sink"
                 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={40,28})));
  Sensors.SpecificEnthalpy senEnt1(redeclare package Medium = Medium)
    "Specific enthalpy sensor"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Sensors.Temperature senTem1(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Sensors.MassFraction senMas1(redeclare package Medium = Medium)
    "Mass fraction sensor"
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Sensors.Temperature senTem2(redeclare package Medium = Medium)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Sensors.SpecificEnthalpy senEnt2(redeclare package Medium = Medium)
    "Specific enthalpy sensor"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Sensors.MassFraction senMas2(redeclare package Medium = Medium)
    "Mass fraction sensor"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  FixedResistances.PressureDrop res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));

  Modelica.Fluid.Sources.MassFlowSource_T source2(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    T(displayUnit="K") = 323.15,
    X={0.01,0.99},
    nPorts=1,
    m_flow=0.5) "Fluid source"
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-6})));
equation
  connect(u2.y, humFor.u)                annotation (Line(
      points={{-79.4,60},{-60,60},{-60,36},{-52,36}},
      color={0,0,127}));
  connect(u2.y, humBac.u)         annotation (Line(
      points={{-79.4,60},{-70,60},{-70,12},{-24,12},{-24,0},{-30,0}},
      color={0,0,127}));
  connect(humFor.port_b, senTem1.port)         annotation (Line(
      points={{-30,30},{-30,70},{-20,70}},
      color={0,127,255}));
  connect(humFor.port_b, senEnt1.port)         annotation (Line(
      points={{-30,30},{-30,48},{20,48},{20,70}},
      color={0,127,255}));
  connect(humFor.port_b, senMas1.port)         annotation (Line(
      points={{-30,30},{-30,48},{60,48},{60,70}},
      color={0,127,255}));
  connect(humBac.port_a, senTem2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-60},{-50,-60}},
      color={0,127,255}));
  connect(humBac.port_a, senEnt2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-70},{-10,-70},{-10,-60}},
      color={0,127,255}));
  connect(humBac.port_a, senMas2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-70},{30,-70},{30,-60}},
      color={0,127,255}));
  connect(humFor.port_b, res1.port_a)         annotation (Line(
      points={{-30,30},{-10,30}},
      color={0,127,255}));
  connect(res1.port_b, sink1.ports[1]) annotation (Line(
      points={{10,30},{30,30}},
      color={0,127,255}));
  connect(humBac.port_a, res2.port_a)         annotation (Line(
      points={{-32,-6},{-10,-6}},
      color={0,127,255}));
  connect(res2.port_b, sink1.ports[2]) annotation (Line(
      points={{10,-6},{16,-6},{16,26},{30,26}},
      color={0,127,255}));
  connect(senTem1.T,cheTem. u1) annotation (Line(
      points={{-13,80},{0,80},{0,60},{70,60},{70,16},{78,16}},
      color={0,0,127}));
  connect(senEnt1.h_out,cheEnt. u1) annotation (Line(
      points={{31,80},{40,80},{40,54},{66,54},{66,-14},{78,-14}},
      color={0,0,127}));
  connect(senMas1.X,cheMas. u1) annotation (Line(
      points={{71,80},{80,80},{80,64},{64,64},{64,-44},{78,-44}},
      color={0,0,127}));
  connect(senTem2.T,cheTem. u2) annotation (Line(
      points={{-43,-50},{-20,-50},{-20,-30},{50,-30},{50,4},{78,4}},
      color={0,0,127}));
  connect(senEnt2.h_out,cheEnt. u2) annotation (Line(
      points={{1,-50},{8,-50},{8,-32},{54,-32},{54,-26},{78,-26}},
      color={0,0,127}));
  connect(senMas2.X,cheMas. u2) annotation (Line(
      points={{41,-50},{60,-50},{60,-56},{78,-56}},
      color={0,0,127}));
  connect(humFor.port_a, source1.ports[1]) annotation (Line(
      points={{-50,30},{-80,30}},
      color={0,127,255}));
  connect(source2.ports[1], humBac.port_b) annotation (Line(
      points={{-80,-6},{-52,-6}},
      color={0,127,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ReverseFlowHumidifier.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This model tests whether the results for a humidifer are
identical for forward flow and reverse flow.
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
November 2, 2016, by Michael Wetter:<br/>
Changed assertions to blocks that compute the difference,
and added the difference to the regression results.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/564\">issue 564</a>.
</li>
<li>
October 9, 2013, by Michael Wetter:<br/>
Replaced
<code>Modelica.Fluid.Sources.FixedBoundary</code>
with
<code>Buildings.Fluid.Sources.FixedBoundary</code>
as otherwise, the pedantic model check fails in
Dymola 2014 FD01 beta3.
</li>
<li>
July 5, 2013, by Michael Wetter:<br/>
Changed one instance of <code>Modelica.Fluid.Sources.MassFlowSource_T</code>,
that was connected to the two fluid streams,
to two instances, each having half the mass flow rate.
This is required for the model to work with Modelica 3.2.1 due to the
change introduced in
ticket <a href=\"https://trac.modelica.org/Modelica/ticket/739\">#739</a>.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
First implementation based on a model from Giuliano Fontanella.
</li>
</ul>
</html>"));
end ReverseFlowHumidifier;
