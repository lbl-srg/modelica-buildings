within Buildings.Templates.Components.Validation;
model Sensors "Validation model for sensor components"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  Fluid.Sources.Boundary_pT bouAirEnt(
    redeclare final package Medium = MediumAir,
    p=bouAirLvg.p + res.dp_nominal,
    nPorts=6) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Fluid.Sources.Boundary_pT bouAirLvg(redeclare final package Medium =
        MediumAir, nPorts=6)                             "Boundary conditions for leaving air"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Buildings.Templates.Components.Sensors.HumidityRatio hum(redeclare final
      package Medium = MediumAir, m_flow_nominal=1) "Humidity ratio"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=1,
    final dp_nominal=100) "Flow resistance"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=1,
    final dp_nominal=100)                "Flow resistance"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy ent(redeclare final
      package Medium = MediumAir, m_flow_nominal=1) "Specific enthalpy"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dp(redeclare
      final package Medium = MediumAir) "Differential pressure"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=1,
    final dp_nominal=100)                "Flow resistance"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Templates.Components.Sensors.Temperature tem(redeclare final
      package Medium = MediumAir, m_flow_nominal=1) "Temperature"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate vol(redeclare final
      package Medium = MediumAir, m_flow_nominal=1,
      typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS) "Volume flow rate"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Fluid.FixedResistances.PressureDrop res3(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=1,
    final dp_nominal=100)                "Flow resistance"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure noDp(redeclare
      final package Medium = MediumAir, have_sen=false)
    "No differential pressure sensor"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
equation
  connect(bouAirEnt.ports[1], res.port_a)
    annotation (Line(points={{-60,38.3333},{-50,38.3333},{-50,40},{-30,40}},
                                               color={0,127,255}));
  connect(res.port_b, hum.port_a)
    annotation (Line(points={{-10,40},{0,40}}, color={0,127,255}));
  connect(hum.port_b, bouAirLvg.ports[1]) annotation (Line(points={{20,40},{50,
          40},{50,38.3333},{60,38.3333}},
                                color={0,127,255}));
  connect(res1.port_b, ent.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(ent.port_b, bouAirLvg.ports[2]) annotation (Line(points={{20,0},{40,0},
          {40,39},{60,39}},     color={0,127,255}));
  connect(bouAirEnt.ports[2], res1.port_a) annotation (Line(points={{-60,39},{-40,
          39},{-40,0},{-30,0}},       color={0,127,255}));
  connect(bouAirEnt.ports[3], dp.port_a) annotation (Line(points={{-60,39.6667},
          {-40,39.6667},{-40,70},{0,70}},
                                color={0,127,255}));
  connect(dp.port_b, bouAirLvg.ports[3]) annotation (Line(points={{20,70},{40,
          70},{40,39.6667},{60,39.6667}},
                            color={0,127,255}));
  connect(res2.port_b, tem.port_a)
    annotation (Line(points={{-10,-40},{0,-40}}, color={0,127,255}));
  connect(res3.port_b, vol.port_a)
    annotation (Line(points={{-10,-80},{0,-80}}, color={0,127,255}));
  connect(tem.port_b, bouAirLvg.ports[4]) annotation (Line(points={{20,-40},{40,
          -40},{40,40.3333},{60,40.3333}}, color={0,127,255}));
  connect(vol.port_b, bouAirLvg.ports[5]) annotation (Line(points={{20,-80},{40,
          -80},{40,41},{60,41}},     color={0,127,255}));
  connect(bouAirEnt.ports[4], res2.port_a) annotation (Line(points={{-60,
          40.3333},{-60,38},{-40,38},{-40,-40},{-30,-40}},
                                                 color={0,127,255}));
  connect(bouAirEnt.ports[5], res3.port_a) annotation (Line(points={{-60,41},{-40,
          41},{-40,-80},{-30,-80}},       color={0,127,255}));

  connect(bouAirEnt.ports[6], noDp.port_a) annotation (Line(points={{-60,
          41.6667},{-40,41.6667},{-40,100},{0,100}},
                                            color={0,127,255}));
  connect(noDp.port_b, bouAirLvg.ports[6]) annotation (Line(points={{20,100},{
          40,100},{40,41.6667},{60,41.6667}},
                                           color={0,127,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Sensors.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Documentation(info="<html>
<p> 
This model validates the models within 
<a href=\"modelica://Buildings.Templates.Components.Sensors\">
Buildings.Templates.Components.Sensors</a>.
</p>
</html>"));
end Sensors;
