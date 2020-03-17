within Buildings.Applications.DHC.Controls.Validation;
model MixingValveControl
  "Validation of mixing valve control in change-over mode"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water
    "Source side medium";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Mass flow rate at nominal conditions";
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFlo(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    typDis=Buildings.Applications.DHC.Loads.Types.DistributionType.ChangeOver,
    have_pum=true,
    have_val=true,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1) "Secondary distribution system"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Fluid.Sources.Boundary_pT souPri(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)
    "Primary supply stream"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,20})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TPriHea(k=40 + 273.15,
      y(final unit="K", displayUnit="degC"))
    "Heating water primary supply temperature"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TPriChi(k=7 + 273.15,
      y(final unit="K", displayUnit="degC"))
    "Chilled water primary supply temperature"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch TPri(
    y(final unit="K", displayUnit="degC"))
    "Actual primary supply temperature"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse mod(
    amplitude=2,
    period=1000,
    offset=-1) "Operating mode (1 for heating, -1 for cooling)"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSecHea(k=30 +
        273.15, y(final unit="K", displayUnit="degC"))
    "Heating water secondary supply temperature setpoint (C)"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetSecChi(k=18 +
        273.15)
    "Chilled water secondary supply temperature setpoint (C)"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch TSetSecAct(
    y(final unit="K", displayUnit="degC"))
    "Actual secondary supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger modInt(integerFalse=-1)
    "Operating mode in integer format "
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souSec(
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1)
    "Secondary return stream"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,60})));
  Buildings.Fluid.Sources.Boundary_pT sinSec(
    redeclare package Medium = Medium, nPorts=1) "Sink for secondary stream"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dTSec(k=-5)
    "Secondary temperature difference between supply and return"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSecSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal) "Secondary supply temperature (sensed)"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSecRet(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (sensed)"
    annotation (Placement(transformation(extent={{90,50},{70,70}})));
  Buildings.Fluid.Sources.Boundary_pT sinPri(redeclare package Medium = Medium, nPorts=1)
    "Sink for primary stream" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,20})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse mSec_flow(
    amplitude=m_flow_nominal,
    period=200,
    offset=0) "Secondary mass flow rate"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Computation of secondary return temperature"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTPriSup(redeclare package
      Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (sensed)"
    annotation (Placement(transformation(extent={{8,10},{28,30}})));
equation
  connect(mod.y, greEqu.u1)
    annotation (Line(points={{-118,40},{-102,40}}, color={0,0,127}));
  connect(greEqu.y, TPri.u2) annotation (Line(points={{-78,40},{-74,40},{-74,90},
          {-62,90}}, color={255,0,255}));
  connect(zero.y, greEqu.u2) annotation (Line(points={{-119,0},{-110,0},{-110,
          32},{-102,32}},
                        color={0,0,127}));
  connect(TPri.y, souPri.T_in) annotation (Line(points={{-38,90},{-32,90},{-32,24},
          {-22,24}}, color={0,0,127}));
  connect(TSetSecAct.y, disFlo.TSupSet) annotation (Line(points={{-38,-80},{32,-80},
          {32,12},{39,12}}, color={0,0,127}));
  connect(greEqu.y, modInt.u) annotation (Line(points={{-78,40},{-74,40},{-74,
          -20},{-62,-20}}, color={255,0,255}));
  connect(modInt.y, disFlo.modChaOve) annotation (Line(points={{-38,-20},{36,-20},
          {36,14},{39,14}}, color={255,127,0}));
  connect(greEqu.y, TSetSecAct.u2) annotation (Line(points={{-78,40},{-74,40},{-74,
          -80},{-62,-80}}, color={255,0,255}));
  connect(dTSec.y, pro.u2) annotation (Line(points={{42,-100},{56,-100},{56,-66},
          {58,-66}}, color={0,0,127}));
  connect(disFlo.ports_b1[1], senTSecSup.port_a) annotation (Line(points={{40,
          26},{36,26},{36,100},{70,100}}, color={0,127,255}));
  connect(souSec.ports[1], senTSecRet.port_a)
    annotation (Line(points={{100,60},{90,60}}, color={0,127,255}));
  connect(senTSecRet.port_b, disFlo.ports_a1[1]) annotation (Line(points={{70,
          60},{64,60},{64,26},{60,26}}, color={0,127,255}));
  connect(disFlo.port_b, sinPri.ports[1])
    annotation (Line(points={{60,20},{100,20}}, color={0,127,255}));
  connect(senTSecSup.port_b, sinSec.ports[1])
    annotation (Line(points={{90,100},{100,100}}, color={0,127,255}));
  connect(mSec_flow.y, disFlo.mReq_flow[1]) annotation (Line(points={{-118,160},
          {32,160},{32,16},{39,16}}, color={0,0,127}));
  connect(mSec_flow.y, souSec.m_flow_in) annotation (Line(points={{-118,160},{
          140,160},{140,68},{122,68}},
                              color={0,0,127}));
  connect(TSetSecAct.y, add.u2) annotation (Line(points={{-38,-80},{52,-80},{52,
          -86},{98,-86}}, color={0,0,127}));
  connect(pro.y, add.u1) annotation (Line(points={{82,-60},{94,-60},{94,-74},{
          98,-74}}, color={0,0,127}));
  connect(add.y, souSec.T_in) annotation (Line(points={{122,-80},{140,-80},{140,
          64},{122,64}},                     color={0,0,127}));
  connect(souPri.ports[1], senTPriSup.port_a)
    annotation (Line(points={{0,20},{8,20}}, color={0,127,255}));
  connect(senTPriSup.port_b, disFlo.port_a)
    annotation (Line(points={{28,20},{40,20}}, color={0,127,255}));
  connect(mod.y, pro.u1) annotation (Line(points={{-118,40},{-114,40},{-114,-40},
          {40,-40},{40,-54},{58,-54}}, color={0,0,127}));
  connect(TSetSecChi.y, TSetSecAct.u3) annotation (Line(points={{-118,-100},{
          -100,-100},{-100,-88},{-62,-88}}, color={0,0,127}));
  connect(TSetSecHea.y, TSetSecAct.u1) annotation (Line(points={{-118,-60},{
          -100,-60},{-100,-72},{-62,-72}}, color={0,0,127}));
  connect(TPriChi.y, TPri.u3) annotation (Line(points={{-118,80},{-100,80},{
          -100,82},{-62,82}}, color={0,0,127}));
  connect(TPriHea.y, TPri.u1) annotation (Line(points={{-118,120},{-100,120},{
          -100,98},{-62,98}}, color={0,0,127}));
  annotation (
Documentation(
info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Applications.DHC.Controls.MixingValveControl\">
Buildings.Applications.DHC.Controls.MixingValveControl</a>
(as part of
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution</a>)
in change-over mode.
</p>
</html>"),
  Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{180,200}})),
  experiment(
      StopTime=1000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Controls/Validation/MixingValveControl.mos"
    "Simulate and plot"));
end MixingValveControl;
