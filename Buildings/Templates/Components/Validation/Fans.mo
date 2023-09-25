within Buildings.Templates.Components.Validation;
model Fans "Validation model for fans components"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = MediumAir,
    nPorts=8) "Boundary conditions"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Components.Fans.ArrayVariable arr(
    redeclare final package Medium=MediumAir,
    have_senFlo=true,
    final energyDynamics=energyDynamics,
    dat(m_flow_nominal=1, dp_nominal=1000),
    nFan=4)
    "Fan array"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=arr.dat.m_flow_nominal,
    final dp_nominal=arr.dat.dp_nominal)
    "Ducts and coils equivalent flow resistance"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Controls.OBC.CDL.Reals.Sources.Ramp y(height=1, duration=10)
    "Fan control signal"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Interfaces.Bus bus "Control bus"
                     annotation (Placement(transformation(extent={{-40,100},{0,140}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,0; 1,1],
    timeScale=10,
    period=100) "Fan start/stop signal"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Templates.Components.Fans.SingleVariable var(
    redeclare final package Medium=MediumAir,
    have_senFlo=true,
    final energyDynamics=energyDynamics,
    dat(m_flow_nominal=1, dp_nominal=1000)) "Variable speed fan"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Interfaces.Bus bus1 "Control bus"
                     annotation (Placement(transformation(extent={{-40,0},{0,40}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Templates.Components.Fans.SingleConstant cst(
    redeclare final package Medium=MediumAir,
    have_senFlo=true,
    final energyDynamics=energyDynamics,
    dat(m_flow_nominal=1, dp_nominal=1000)) "Constant speed fan"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=cst.dat.m_flow_nominal,
    final dp_nominal=cst.dat.dp_nominal)
    "Ducts and coils equivalent flow resistance"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Fluid.FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=var.dat.m_flow_nominal,
    final dp_nominal=var.dat.dp_nominal)
    "Ducts and coils equivalent flow resistance"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Interfaces.Bus bus2
    "Control bus"    annotation (Placement(transformation(extent={{-40,-80},{0,-40}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Templates.Components.Fans.None non(
    redeclare final package Medium = MediumAir)
    "No fan"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Fluid.FixedResistances.PressureDrop res3(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=1,
    final dp_nominal=1000)
    "Ducts and coils equivalent flow resistance"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Controls.OBC.CDL.Logical.Sources.TimeTable y1Mul[arr.nFan](
    each table=[0,0; 1,1],
    each timeScale=10,
    each period=100) "Fan array start/stop signal"
    annotation (Placement(transformation(extent={{60,150},{40,170}})));
equation
  connect(bou.ports[1], arr.port_a) annotation (Line(points={{-60,-1.75},{-60,80},
          {-10,80}},         color={0,127,255}));
  connect(res.port_b, bou.ports[2]) annotation (Line(points={{60,80},{80,80},{80,
          -1.25},{-60,-1.25}},    color={0,127,255}));
  connect(arr.port_b, res.port_a)
    annotation (Line(points={{10,80},{40,80}}, color={0,127,255}));
  connect(y.y, bus.y) annotation (Line(points={{-58,120},{-20,120}},
        color={0,0,127}));
  connect(bus, arr.bus) annotation (Line(
      points={{-20,120},{0,120},{0,90}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus1.y1) annotation (Line(points={{-58,160},{-34,160},{-34,40},
          {-20,40},{-20,20}},
        color={255,0,255}));
  connect(cst.port_b, res1.port_a) annotation (Line(points={{10,-20},{40,-20}},
                          color={0,127,255}));
  connect(bou.ports[3], cst.port_a) annotation (Line(points={{-60,-0.75},{-60,-20},
          {-10,-20}},      color={0,127,255}));
  connect(res1.port_b, bou.ports[4]) annotation (Line(points={{60,-20},{80,-20},
          {80,-0.25},{-60,-0.25}},       color={0,127,255}));
  connect(res2.port_b, bou.ports[5]) annotation (Line(points={{60,-80},{80,-80},
          {80,0.25},{-60,0.25}},
                           color={0,127,255}));
  connect(bou.ports[6], var.port_a) annotation (Line(points={{-60,0.75},{-60,-80},
          {-10,-80}},                   color={0,127,255}));
  connect(var.port_b, res2.port_a)
    annotation (Line(points={{10,-80},{40,-80}},   color={0,127,255}));
  connect(bus2, var.bus) annotation (Line(
      points={{-20,-60},{0,-60},{0,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus1, cst.bus) annotation (Line(
      points={{-20,20},{0,20},{0,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus2.y) annotation (Line(points={{-58,120},{-40,120},{-40,-60},{-20,
          -60}},  color={0,0,127}));
  connect(bou.ports[7], non.port_a) annotation (Line(points={{-60,1.25},{-60,-140},
          {-10,-140}}, color={0,127,255}));
  connect(non.port_b, res3.port_a) annotation (Line(points={{10,-140},{25,-140},
          {25,-140},{40,-140}}, color={0,127,255}));
  connect(res3.port_b, bou.ports[8]) annotation (Line(points={{60,-140},{80,-140},
          {80,1.75},{-60,1.75}},  color={0,127,255}));
  connect(y1.y[1], bus2.y1) annotation (Line(points={{-58,160},{-34,160},{-34,-40},
          {-20,-40},{-20,-60}},
        color={255,0,255}));
  connect(y1Mul.y[1], bus.y1) annotation (Line(points={{38,160},{-20,160},{-20,120}},
        color={255,0,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Fans.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=200),
    Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
    Documentation(info="<html>
<p> 
This model validates the models within 
<a href=\"modelica://Buildings.Templates.Components.Fans\">
Buildings.Templates.Components.Fans</a>
by exposing them to a control signal varying from <i>0</i> to <i>1</i>
and connecting them to an air loop with a fixed flow resistance, which 
is sized based on the nominal operating point of the fan model.
</p>
</html>"));
end Fans;
