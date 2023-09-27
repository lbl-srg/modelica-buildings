within Buildings.Templates.Components.Validation;
model Dampers "Validation model for damper components"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  Fluid.Sources.Boundary_pT bouAirEnt(
    redeclare final package Medium = MediumAir,
    p=bouAirLvg.p + mod.dat.dp_nominal,
    nPorts=4) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Fluid.Sources.Boundary_pT bouAirLvg(
    redeclare final package Medium =MediumAir, nPorts=4)
    "Boundary conditions for leaving air"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Buildings.Templates.Components.Actuators.Damper mod(
    final typ=Buildings.Templates.Components.Types.Damper.Modulating,
    y_start=0,
    redeclare final package Medium = MediumAir,
    dat(m_flow_nominal=1,
        dp_nominal=50))
    "Modulating damper"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Interfaces.Bus bus
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,60},{20,100}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Reals.Sources.Ramp y(height=1,
    duration=10) "Damper control signal"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  Buildings.Templates.Components.Actuators.Damper pre(
    final typ=Buildings.Templates.Components.Types.Damper.PressureIndependent,
    y_start=0,
    redeclare final package  Medium = MediumAir,
    dat(m_flow_nominal=1, dp_nominal=50))
    "Pressure independent damper"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Interfaces.Bus bus1
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,0},{20,40}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Templates.Components.Actuators.Damper two(
    final typ=Buildings.Templates.Components.Types.Damper.TwoPosition,
    y_start=0,
    redeclare final package Medium = MediumAir,
    dat(m_flow_nominal=1, dp_nominal=50)) "Two-position damper"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Interfaces.Bus bus2
    "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-60},{20,-20}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 1,1],
    timeScale=10,
    period=200) "Damper control signal"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Buildings.Templates.Components.Actuators.Damper non(
    final typ=Buildings.Templates.Components.Types.Damper.None,
    redeclare final package Medium = MediumAir)
    "No damper"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mod.dat.m_flow_nominal,
    final dp_nominal=mod.dat.dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
equation
  connect(bouAirEnt.ports[1], mod.port_a)
    annotation (Line(points={{-70,58.5},{-70,60},{10,60}},
                                                  color={0,127,255}));
  connect(mod.port_b, bouAirLvg.ports[1])
    annotation (Line(points={{30,60},{60,60},{60,58.5},{90,58.5}},
                                                 color={0,127,255}));
  connect(y.y, bus.y) annotation (Line(points={{-68,100},{0,100},{0,80}},
        color={0,0,127}));
  connect(bus, mod.bus) annotation (Line(
      points={{0,80},{20,80},{20,70}},
      color={255,204,51},
      thickness=0.5));
  connect(bouAirEnt.ports[2], pre.port_a) annotation (Line(points={{-70,59.5},{-38,
          59.5},{-38,0},{10,0}},   color={0,127,255}));
  connect(pre.port_b, bouAirLvg.ports[2]) annotation (Line(points={{30,0},{60,0},
          {60,59.5},{90,59.5}},  color={0,127,255}));
  connect(bus1, pre.bus) annotation (Line(
      points={{0,20},{20,20},{20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus1.y)
    annotation (Line(points={{-68,100},{0,100},{0,20}},
                                                     color={0,0,127}));
  connect(bouAirEnt.ports[3], two.port_a) annotation (Line(points={{-70,60.5},{-38,
          60.5},{-38,-60},{10,-60}},         color={0,127,255}));
  connect(two.port_b, bouAirLvg.ports[3]) annotation (Line(points={{30,-60},{60,
          -60},{60,60.5},{90,60.5}},       color={0,127,255}));
  connect(bus2, two.bus) annotation (Line(
      points={{0,-40},{20,-40},{20,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus2.y1)
    annotation (Line(points={{-68,-20},{0,-20},{0,-40}}, color={255,0,255}));
  connect(non.port_b, bouAirLvg.ports[4]) annotation (Line(points={{30,-100},{60,
          -100},{60,61.5},{90,61.5}}, color={0,127,255}));
  connect(bouAirEnt.ports[4], res.port_a) annotation (Line(points={{-70,61.5},{-40,
          61.5},{-40,-100},{-30,-100}}, color={0,127,255}));
  connect(res.port_b, non.port_a)
    annotation (Line(points={{-10,-100},{10,-100}}, color={0,127,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Dampers.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=200),
  Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This model validates the various configurations of the model
<a href=\"modelica://Buildings.Templates.Components.Actuators.Damper\">
Buildings.Templates.Components.Actuators.Damper</a>
by exposing this model to a fixed pressure difference
and a control signal varying from <i>0</i> to <i>1</i>.
</p>
</html>"));
end Dampers;
