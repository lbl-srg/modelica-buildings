within Buildings.DHC.Loads.BaseClasses.Controls.Validation;
model MixingValveControl
  "Validation of mixing valve control in change-over mode"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Source side medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Mass flow rate at nominal conditions";
  Buildings.DHC.Loads.BaseClasses.FlowDistribution disFlo(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    typDis=Buildings.DHC.Loads.BaseClasses.Types.DistributionType.ChangeOver,
    have_pum=true,
    have_val=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Secondary distribution system"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Fluid.Sources.Boundary_pT souPri(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=1)
    "Primary supply stream"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-10,20})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TPriHea(
    k=313.15,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water primary supply temperature"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TPriChi(
    k=280.15,
    y(final unit="K",
      displayUnit="degC"))
    "Chilled water primary supply temperature"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TPri(
    y(final unit="K",
      displayUnit="degC"))
    "Actual primary supply temperature"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetSecHea(
    k=303.15,
    y(final unit="K",
      displayUnit="degC"))
    "Heating water secondary supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetSecChi(
    k=291.15)
    "Chilled water secondary supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetSecAct(
    y(final unit="K",
      displayUnit="degC"))
    "Actual secondary supply temperature set point"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T souSec(
    use_m_flow_in=true,
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=1)
    "Secondary return stream"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,60})));
  Buildings.Fluid.Sources.Boundary_pT sinSec(
    redeclare package Medium=Medium,
    nPorts=1)
    "Sink for secondary stream"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,100})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTSecHea(
    k=-5)
    "Secondary temperature difference between supply and return"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSecSup(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSecRet(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{90,50},{70,70}})));
  Buildings.Fluid.Sources.Boundary_pT sinPri(
    redeclare package Medium=Medium,
    nPorts=1)
    "Sink for primary stream"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,20})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse mSec_flow(
    amplitude=m_flow_nominal,
    period=200,
    offset=0)
    "Secondary mass flow rate"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Reals.Add add
    "Computation of secondary return temperature"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTPriSup(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (measured)"
    annotation (Placement(transformation(extent={{8,10},{28,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch dTSec(
    y(final unit="K",
      displayUnit="degC"))
    "Actual secondary delta T"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dTSecCoo(
    k=5)
    "Secondary temperature difference between supply and return"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger modInd(
    final integerTrue=1,
    final integerFalse=2)
    "Mode index, 1 for heating, 2 for cooling"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse modCha(
    period=1000)
    "Boolean pulse for changing mode"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not mod
    "Operating mode, true for heating, false for cooling"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(TPri.y,souPri.T_in)
    annotation (Line(points={{-38,80},{-32,80},{-32,24},{-22,24}},color={0,0,127}));
  connect(TSetSecAct.y,disFlo.TSupSet)
    annotation (Line(points={{-38,-80},{32,-80},{32,12},{39,12}},color={0,0,127}));
  connect(disFlo.ports_b1[1],senTSecSup.port_a)
    annotation (Line(points={{40,26},{36,26},{36,100},{70,100}},color={0,127,255}));
  connect(souSec.ports[1],senTSecRet.port_a)
    annotation (Line(points={{100,60},{90,60}},color={0,127,255}));
  connect(senTSecRet.port_b,disFlo.ports_a1[1])
    annotation (Line(points={{70,60},{64,60},{64,26},{60,26}},color={0,127,255}));
  connect(disFlo.port_b,sinPri.ports[1])
    annotation (Line(points={{60,20},{100,20}},color={0,127,255}));
  connect(senTSecSup.port_b,sinSec.ports[1])
    annotation (Line(points={{90,100},{100,100}},color={0,127,255}));
  connect(mSec_flow.y,disFlo.mReq_flow[1])
    annotation (Line(points={{-118,160},{32,160},{32,16},{39,16}},color={0,0,127}));
  connect(mSec_flow.y,souSec.m_flow_in)
    annotation (Line(points={{-118,160},{140,160},{140,68},{122,68}},color={0,0,127}));
  connect(add.y,souSec.T_in)
    annotation (Line(points={{122,-80},{140,-80},{140,64},{122,64}},color={0,0,127}));
  connect(souPri.ports[1],senTPriSup.port_a)
    annotation (Line(points={{0,20},{8,20}},color={0,127,255}));
  connect(senTPriSup.port_b,disFlo.port_a)
    annotation (Line(points={{28,20},{40,20}},color={0,127,255}));
  connect(TSetSecChi.y,TSetSecAct.u3)
    annotation (Line(points={{-118,-100},{-100,-100},{-100,-88},{-62,-88}},color={0,0,127}));
  connect(TSetSecHea.y,TSetSecAct.u1)
    annotation (Line(points={{-118,-60},{-100,-60},{-100,-72},{-62,-72}},color={0,0,127}));
  connect(TPriChi.y,TPri.u3)
    annotation (Line(points={{-118,80},{-80,80},{-80,72},{-62,72}},color={0,0,127}));
  connect(TPriHea.y,TPri.u1)
    annotation (Line(points={{-118,120},{-80,120},{-80,88},{-62,88}},color={0,0,127}));
  connect(TSetSecAct.y,add.u1)
    annotation (Line(points={{-38,-80},{32,-80},{32,-74},{98,-74}},color={0,0,127}));
  connect(dTSec.y,add.u2)
    annotation (Line(points={{42,-120},{80,-120},{80,-86},{98,-86}},color={0,0,127}));
  connect(dTSecHea.y,dTSec.u1)
    annotation (Line(points={{2,-100},{10,-100},{10,-112},{18,-112}},color={0,0,127}));
  connect(dTSecCoo.y,dTSec.u3)
    annotation (Line(points={{2,-140},{10,-140},{10,-128},{18,-128}},color={0,0,127}));
  connect(modCha.y,mod.u)
    annotation (Line(points={{-118,0},{-102,0}},color={255,0,255}));
  connect(mod.y,TPri.u2)
    annotation (Line(points={{-78,0},{-70,0},{-70,80},{-62,80}},color={255,0,255}));
  connect(mod.y,TSetSecAct.u2)
    annotation (Line(points={{-78,0},{-70,0},{-70,-80},{-62,-80}},color={255,0,255}));
  connect(mod.y,modInd.u)
    annotation (Line(points={{-78,0},{-62,0}},color={255,0,255}));
  connect(modInd.y,disFlo.modChaOve)
    annotation (Line(points={{-38,0},{36,0},{36,14},{39,14}},color={255,127,0}));
  connect(mod.y,dTSec.u2)
    annotation (Line(points={{-78,0},{-70,0},{-70,-120},{18,-120}},color={255,0,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.Controls.MixingValveControl\">
Buildings.DHC.Loads.BaseClasses.Controls.MixingValveControl</a>
(as part of
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.DHC.Loads.BaseClasses.FlowDistribution</a>)
in change-over mode.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-200},{180,200}})),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/BaseClasses/Controls/Validation/MixingValveControl.mos" "Simulate and plot"));
end MixingValveControl;
