within Buildings.Fluid.FixedResistances.Validation;
model PressureDropNotFullyTurbulent
  "Validation model for pressure drop for not fully turbulent flow"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water "Medium model";
  Buildings.Fluid.Sources.Boundary_ph sou(
   redeclare package Medium = Medium,
    nPorts=7,
    p(displayUnit="Pa") = 300000,
    use_p_in=true) "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-40,90},{-20,110}})));

  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=300000,
    nPorts=7)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{140,90},{120,110}})));

  Buildings.Fluid.FixedResistances.PressureDrop res11(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=5000) "Flow resistance"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent
                                                res12(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=5000,
    m=0.5)        "Flow resistance"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Modelica.Blocks.Sources.Ramp P(
    duration=2,
    height=20000,
    offset=300000 - 10000,
    startTime=-1)  "Signal source"
  annotation (Placement(transformation(extent={{-80,98},{-60,118}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo2(
    redeclare package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(threShold=1E-1)
    "Assert equality of the two mass flow rates"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  PressureDrop res22(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=5000,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent res23(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=5000,
    linearized=true,
    m=0.5) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Sensors.MassFlowRate                 senMasFlo3(redeclare package Medium =
        Medium)                        "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Sensors.MassFlowRate                 senMasFlo4(redeclare package Medium =
        Medium)                        "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu2(threShold=1E-1)
    "Assert equality of the two mass flow rates"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  PressureDrop res31(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=2,
    dp_nominal=5000,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent res32(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=5000,
    m=1) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Sensors.MassFlowRate                 senMasFlo5(redeclare package Medium =
        Medium)                        "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Sensors.MassFlowRate                 senMasFlo6(redeclare package Medium =
        Medium)                        "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu3(threShold=1E-1)
    "Assert equality of the two mass flow rates"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent res08(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=5000,
    m=0.8) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Sensors.MassFlowRate                 senMasFlo7(redeclare package Medium =
        Medium)                        "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,-230},{80,-210}})));
equation
  connect(sou.ports[1], res11.port_a)
    annotation (Line(
      points={{-20,98.2857},{-10,98.2857},{-10,100},{0,100}},
      color={0,127,255}));
  connect(P.y, sou.p_in) annotation (Line(
      points={{-59,108},{-42,108}},
      color={0,0,127}));
  connect(senMasFlo1.m_flow, assEqu1.u1)
    annotation (Line(points={{70,111},{70,136},{118,136}}, color={0,0,127}));
  connect(senMasFlo2.m_flow, assEqu1.u2) annotation (Line(points={{70,71},{70,80},
          {88,80},{88,124},{118,124}}, color={0,0,127}));
  connect(res11.port_b, senMasFlo1.port_a)
    annotation (Line(points={{20,100},{60,100}}, color={0,127,255}));
  connect(res12.port_b, senMasFlo2.port_a)
    annotation (Line(points={{20,60},{60,60}}, color={0,127,255}));
  connect(senMasFlo3.m_flow, assEqu2.u1)
    annotation (Line(points={{70,-9},{70,16},{118,16}}, color={0,0,127}));
  connect(senMasFlo4.m_flow, assEqu2.u2) annotation (Line(points={{70,-49},{70,-40},
          {88,-40},{88,4},{118,4}}, color={0,0,127}));
  connect(res22.port_b, senMasFlo3.port_a)
    annotation (Line(points={{20,-20},{60,-20}}, color={0,127,255}));
  connect(res23.port_b, senMasFlo4.port_a)
    annotation (Line(points={{20,-60},{60,-60}}, color={0,127,255}));
  connect(res12.port_a, sou.ports[2]) annotation (Line(points={{0,60},{-10,60},
          {-10,98.8571},{-20,98.8571}},color={0,127,255}));
  connect(res22.port_a, sou.ports[3]) annotation (Line(points={{0,-20},{-10,-20},
          {-10,99.4286},{-20,99.4286}}, color={0,127,255}));
  connect(res23.port_a, sou.ports[4]) annotation (Line(points={{0,-60},{-10,-60},
          {-10,100},{-20,100}}, color={0,127,255}));
  connect(senMasFlo5.m_flow, assEqu3.u1)
    annotation (Line(points={{70,-109},{70,-84},{118,-84}}, color={0,0,127}));
  connect(senMasFlo6.m_flow, assEqu3.u2) annotation (Line(points={{70,-149},{70,
          -140},{88,-140},{88,-96},{118,-96}}, color={0,0,127}));
  connect(res31.port_b, senMasFlo5.port_a)
    annotation (Line(points={{20,-120},{60,-120}}, color={0,127,255}));
  connect(res32.port_b, senMasFlo6.port_a)
    annotation (Line(points={{20,-160},{60,-160}}, color={0,127,255}));
  connect(sou.ports[5], res31.port_a) annotation (Line(points={{-20,100.571},{
          -10,100.571},{-10,-120},{0,-120}},
                                         color={0,127,255}));
  connect(sou.ports[6], res32.port_a) annotation (Line(points={{-20,101.143},{
          -10,101.143},{-10,-160},{0,-160}},
                                         color={0,127,255}));
  connect(res08.port_a, sou.ports[7]) annotation (Line(points={{0,-220},{-10,
          -220},{-10,101.714},{-20,101.714}},
                                        color={0,127,255}));
  connect(res08.port_b, senMasFlo7.port_a)
    annotation (Line(points={{20,-220},{60,-220}}, color={0,127,255}));
  connect(senMasFlo1.port_b, sin.ports[1]) annotation (Line(points={{80,100},{
          100,100},{100,98.2857},{120,98.2857}}, color={0,127,255}));
  connect(senMasFlo2.port_b, sin.ports[2]) annotation (Line(points={{80,60},{
          100,60},{100,98.8571},{120,98.8571}}, color={0,127,255}));
  connect(senMasFlo3.port_b, sin.ports[3]) annotation (Line(points={{80,-20},{
          100,-20},{100,99.4286},{120,99.4286}}, color={0,127,255}));
  connect(senMasFlo4.port_b, sin.ports[4]) annotation (Line(points={{80,-60},{
          100,-60},{100,100},{120,100}}, color={0,127,255}));
  connect(senMasFlo5.port_b, sin.ports[5]) annotation (Line(points={{80,-120},{
          100,-120},{100,100.571},{120,100.571}}, color={0,127,255}));
  connect(senMasFlo6.port_b, sin.ports[6]) annotation (Line(points={{80,-160},{
          100,-160},{100,101.143},{120,101.143}}, color={0,127,255}));
  connect(senMasFlo7.port_b, sin.ports[7]) annotation (Line(points={{80,-220},{
          100,-220},{100,101.714},{120,101.714}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,-260},
            {160,160}}),       graphics={Text(
          extent={{-116,92},{-56,68}},
          textColor={0,0,255},
          textString="Non-linearized, fully turbulent."),
                                         Text(
          extent={{-114,-6},{-20,-28}},
          textColor={0,0,255},
          textString="Linearized, fully turbulent (rendering it laminar)."),
                                         Text(
          extent={{-114,-106},{-20,-128}},
          textColor={0,0,255},
          textString="Linearized vs setting m=1."),
                                         Text(
          extent={{-114,-212},{-20,-234}},
          textColor={0,0,255},
          textString="Non-linearized, m=0.8")}),
experiment(
      StartTime=-1,
      Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PressureDropNotFullyTurbulent.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent\">
Buildings.Fluid.FixedResistances.PressureDropNotFullyTurbulent</a>
for different values of the flow coefficient <i>m</i>
by comparing it against solutions computed by
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>.
</p>
<p>
For those configurations where the results should be the same,
an assertion checks for equality, within a small tolerance.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PressureDropNotFullyTurbulent;
