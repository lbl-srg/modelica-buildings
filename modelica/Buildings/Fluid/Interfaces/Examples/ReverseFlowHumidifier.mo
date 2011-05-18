within Buildings.Fluid.Interfaces.Examples;
model ReverseFlowHumidifier
  "Model that tests the reverse flow for a humidifier"
  import Buildings;
  extends Modelica.Icons.Example;
package Medium = Buildings.Media.PerfectGases.MoistAir;
  Buildings.Utilities.Diagnostics.AssertEquality assTem(threShold=0.01)
    "Assert to test if the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEnt(threShold=0.5)
    "Assert to test if the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Utilities.Diagnostics.AssertEquality assMas(threShold=1E-5)
    "Assert to test if the outputs of the forward flow and reverse flow model are identical"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Buildings.Fluid.MassExchangers.HumidifierPrescribed humBac(
    redeclare package Medium = Medium,
    dp_nominal=0,
    m_flow(start=1),
    show_T=true,
    m_flow_nominal=1,
    T=283.15,
    mWat_flow_nominal=0.1) "Humidifier with backward flow"
    annotation (Placement(transformation(extent={{-32,-16},{-52,4}})));
  Buildings.Fluid.MassExchangers.HumidifierPrescribed humFor(
    redeclare package Medium = Medium,
    dp_nominal=0,
    m_flow(start=1),
    show_T=true,
    m_flow_nominal=1,
    T=283.15,
    mWat_flow_nominal=0.1) "Humidifier with forward flow"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Constant u2(k=0.01) "Control input"
    annotation (Placement(transformation(extent={{-92,54},{-80,66}})));
  Modelica.Fluid.Sources.MassFlowSource_T source1(
    m_flow=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    use_T_in=false,
    use_X_in=false,
    T(displayUnit="K") = 323.15,
    X={0.01,0.99},
    nPorts=2)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,28})));
  Modelica.Fluid.Sources.FixedBoundary sink1(
                                            redeclare package Medium = Medium,
      nPorts=2)                                         annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,28})));
  Sensors.SpecificEnthalpy senEnt1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Sensors.Temperature senTem1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Sensors.MassFraction senMas1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{50,70},{70,90}})));
  Sensors.Temperature senTem2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Sensors.SpecificEnthalpy senEnt2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Sensors.MassFraction senMas2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    from_dp=true,
    linearized=false,
    dp_nominal=1000) "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{38,-100},{58,-80}})));
equation
  connect(u2.y, humFor.u)                annotation (Line(
      points={{-79.4,60},{-60,60},{-60,36},{-52,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source1.ports[1], humFor.port_a)                annotation (Line(
      points={{-80,30},{-50,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humBac.port_b, source1.ports[2])         annotation (Line(
      points={{-52,-6},{-60,-6},{-60,26},{-80,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(u2.y, humBac.u)         annotation (Line(
      points={{-79.4,60},{-70,60},{-70,12},{-24,12},{-24,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(humFor.port_b, senTem1.port)         annotation (Line(
      points={{-30,30},{-30,70},{-20,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humFor.port_b, senEnt1.port)         annotation (Line(
      points={{-30,30},{-30,48},{20,48},{20,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humFor.port_b, senMas1.port)         annotation (Line(
      points={{-30,30},{-30,48},{60,48},{60,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humBac.port_a, senTem2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-60},{-50,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humBac.port_a, senEnt2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-70},{-10,-70},{-10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humBac.port_a, senMas2.port)         annotation (Line(
      points={{-32,-6},{-32,-30},{-60,-30},{-60,-70},{30,-70},{30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humFor.port_b, res1.port_a)         annotation (Line(
      points={{-30,30},{-10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sink1.ports[1]) annotation (Line(
      points={{10,30},{30,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(humBac.port_a, res2.port_a)         annotation (Line(
      points={{-32,-6},{-26.5,-6},{-26.5,-6},{-21,-6},{-21,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, sink1.ports[2]) annotation (Line(
      points={{10,-6},{16,-6},{16,26},{30,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.T, assTem.u1) annotation (Line(
      points={{-13,80},{0,80},{0,60},{70,60},{70,16},{78,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senEnt1.h_out, assEnt.u1) annotation (Line(
      points={{31,80},{40,80},{40,54},{66,54},{66,-14},{78,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMas1.X, assMas.u1) annotation (Line(
      points={{71,80},{80,80},{80,64},{64,64},{64,-44},{78,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem2.T, assTem.u2) annotation (Line(
      points={{-43,-50},{-20,-50},{-20,-30},{50,-30},{50,4},{78,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senEnt2.h_out, assEnt.u2) annotation (Line(
      points={{1,-50},{8,-50},{8,-32},{54,-32},{54,-26},{78,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMas2.X, assMas.u2) annotation (Line(
      points={{41,-50},{60,-50},{60,-56},{78,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ReverseFlowHumidifier.mos" "Simulate and plot"),
    Diagram(graphics),
    Documentation(info="<html>
This model tests whether the results for a humidifer are
identical for forward flow and reverse flow.
If the results differ, then an assert is triggered.
</html>", revisions="<html>
<ul>
<li>
August 19, 2010, by Michael Wetter:<br>
First implementation based on a model from Giuliano Fontanella.
</li>
</ul>
</html>"));
end ReverseFlowHumidifier;
