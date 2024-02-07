within Buildings.Templates.Components.Validation;
model Routing "Validation model for routing components"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bouLiqEnt(
    redeclare final package Medium = Medium,
    p=bouLiqLvg.p + min(res.dp_nominal),
    nPorts=3) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Fluid.Sources.Boundary_pT bouLiqLvg(redeclare final package Medium = Medium,
      nPorts=3)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Fluid.FixedResistances.PressureDrop res[3](
    redeclare final package Medium = Medium,
    each m_flow_nominal=1,
    each dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple mulMul(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    nPorts_a=3,
    m_flow_nominal=3) "Multiple to multiple without common leg"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Fluid.Sources.Boundary_pT bouLiqEnt1(
    redeclare final package Medium = Medium,
    p=bouLiqLvg.p + min(res1.dp_nominal) + min(res2.dp_nominal),
    nPorts=3) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Fluid.Sources.Boundary_pT bouLiqLvg1(redeclare final package Medium = Medium,
      nPorts=3)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Fluid.FixedResistances.PressureDrop res1
                                         [3](
    redeclare final package Medium = Medium,
    each m_flow_nominal=1,
    each dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple mulMulCom(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    nPorts_a=3,
    have_comLeg=true,
    m_flow_nominal=3) "Multiple to multiple with common leg"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Fluid.FixedResistances.PressureDrop res2[3](
    redeclare final package Medium = Medium,
    each m_flow_nominal=1,
    each dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Fluid.Sources.Boundary_pT bouLiqEnt2(
    redeclare final package Medium = Medium,
    p=bouLiqLvg.p + min(res3.dp_nominal),
    nPorts=3) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT bouLiqLvg2(redeclare final package Medium = Medium,
      nPorts=1)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Fluid.FixedResistances.PressureDrop res3
                                         [3](
    redeclare final package Medium = Medium,
    each m_flow_nominal=1,
    each dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle mulSin(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    nPorts=3,
    m_flow_nominal=3) "Multiple to single"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.Sources.Boundary_pT bouLiqEnt3(
    redeclare final package Medium = Medium,
    p=bouLiqLvg.p + min(res5.dp_nominal),
    nPorts=1) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Fluid.Sources.Boundary_pT bouLiqLvg3(redeclare final package Medium = Medium,
      nPorts=3)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Buildings.Templates.Components.Routing.SingleToMultiple sinMul(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    nPorts=3,
    m_flow_nominal=3) "Single to multiple"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Fluid.FixedResistances.PressureDrop res5[3](
    redeclare final package Medium = Medium,
    each m_flow_nominal=1,
    each dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Fluid.Sources.Boundary_pT bouLiqEnt4(
    redeclare final package Medium = Medium,
    p=bouLiqLvg.p + res4.dp_nominal,
    nPorts=1) "Boundary conditions for entering liquid"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Fluid.Sources.Boundary_pT bouLiqLvg4(redeclare final package Medium = Medium,
      nPorts=1)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas(redeclare final
      package Medium = Medium) "Pass through"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Fluid.FixedResistances.PressureDrop res4(
    redeclare final package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(res.port_b, mulMul.ports_a)
    annotation (Line(points={{-20,80},{0,80}}, color={0,127,255}));
  connect(mulMul.ports_b, bouLiqLvg.ports)
    annotation (Line(points={{20,80},{60,80}}, color={0,127,255}));
  connect(bouLiqEnt.ports, res.port_a)
    annotation (Line(points={{-60,80},{-40,80}}, color={0,127,255}));
  connect(res1.port_b, mulMulCom.ports_a)
    annotation (Line(points={{-20,40},{0,40}}, color={0,127,255}));
  connect(bouLiqEnt1.ports, res1.port_a)
    annotation (Line(points={{-60,40},{-40,40}}, color={0,127,255}));
  connect(mulMulCom.ports_b, res2.port_a)
    annotation (Line(points={{20,40},{30,40}}, color={0,127,255}));
  connect(res2.port_b, bouLiqLvg1.ports) annotation (Line(points={{50,40},{56,40},
          {56,40},{60,40}}, color={0,127,255}));
  connect(res3.port_b, mulSin.ports_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(bouLiqEnt2.ports,res3. port_a)
    annotation (Line(points={{-60,0},{-40,0}},   color={0,127,255}));
  connect(mulSin.port_b, bouLiqLvg2.ports[1])
    annotation (Line(points={{20,0},{60,0}}, color={0,127,255}));
  connect(bouLiqEnt3.ports[1], sinMul.port_a) annotation (Line(points={{-60,-40},
          {-30,-40},{-30,-40},{0,-40}}, color={0,127,255}));
  connect(sinMul.ports_b, res5.port_a)
    annotation (Line(points={{20,-40},{30,-40}}, color={0,127,255}));
  connect(res5.port_b, bouLiqLvg3.ports)
    annotation (Line(points={{50,-40},{60,-40}}, color={0,127,255}));
  connect(pas.port_b, bouLiqLvg4.ports[1]) annotation (Line(points={{20,-80},{40,
          -80},{40,-80},{60,-80}}, color={0,127,255}));
  connect(bouLiqEnt4.ports[1], res4.port_a)
    annotation (Line(points={{-60,-80},{-40,-80}}, color={0,127,255}));
  connect(res4.port_b, pas.port_a)
    annotation (Line(points={{-20,-80},{0,-80}}, color={0,127,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Routing.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=1),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Documentation(info="<html>
<p> 
This model validates the models within 
<a href=\"modelica://Buildings.Templates.Components.Routing\">
Buildings.Templates.Components.Routing</a>
by exposing them to a fixed pressure difference.
</p>
</html>"));
end Routing;
