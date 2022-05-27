within Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses;
model LoadThreeWayValveControl
  "Model of a load on hydronic circuit with flow rate modulation by three-way valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal);

  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  replaceable package MediumLiq = Buildings.Media.Water
    "Medium model for liquid (CHW or HHW)";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Liquid mass flow rate at design conditions";

  parameter Modelica.Units.SI.Pressure dpTer_nominal(displayUnit="Pa")=3E4
    "Liquid pressure drop across terminal unit at design conditions";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    Q_flow_nominal / 10 / 1015
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=293.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions";
  final parameter Modelica.Units.SI.MassFraction XAirEnt_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      MediumAir.p_default, TAirEnt_nominal, phiAirEnt_nominal)
    "Air entering water mass fraction at design conditions (kg/kg air)";
  final parameter Modelica.Units.SI.MassFraction xAirEnt_nominal=
    XAirEnt_nominal / (1 - XAirEnt_nominal)
    "Air entering humidity ratio at design conditions (kg/kg dry air)";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=333.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=323.15
    "Hot water leaving temperature at design conditions";

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    (TLiqEnt_nominal - TLiqLvg_nominal) * mLiq_flow_nominal * 4186
    "Coil capacity at design conditions"
    annotation(Evaluate=true);

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=100*Modelica.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(unit="s")=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Data.Generic dat(
    have_ctl=con.have_ctl,
    typFun=con.typFun,
    have_pum=con.have_pum,
    typPum=con.typPum,
    m_flow_nominal=m_flow_nominal,
    dpSec_nominal=dpTer_nominal,
    dpValve_nominal=dpTer_nominal,
    dpBal1_nominal=0,
    dpBal2_nominal=0)
    "Sizing and operating parameters"
    annotation(Placement(transformation(extent={{78,78},{98,98}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput  u
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Load loa(
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final dpLiq_nominal=0,
    final mAir_flow_nominal=mAir_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final phiAirEnt_nominal=phiAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final energyDynamics=energyDynamics)
    "Load"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  ActiveNetworks.Diversion con(
    final dat=dat, use_lumFloRes=true)
    "Diversion connection"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

equation
  connect(port_a, con.port_a1)
    annotation (Line(points={{-100,0},{-6,0}}, color={0,127,255}));
  connect(con.port_b1, port_b)
    annotation (Line(points={{6,0},{100,0}}, color={0,127,255}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{-6,20},{-6,40},{-10,
          40},{-10,60}}, color={0,127,255}));
  connect(con.port_a2, loa.port_b) annotation (Line(points={{6,19.8},{6,40},{10,
          40},{10,60}}, color={0,127,255}));
  connect(loa.y, con.yVal) annotation (Line(points={{12,66},{20,66},{20,80},{-20,
          80},{-20,10},{-12,10}}, color={0,0,127}));
  connect(u, loa.u) annotation (Line(points={{-120,60},{-40,60},{-40,66},{-12,66}},
        color={0,0,127}));
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-50,92},{50,-8}},      lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-40,82},{40,2}},   lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-28.5,13.5},{27.5,71.5}},      color={0,0,0},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LoadThreeWayValveControl;
