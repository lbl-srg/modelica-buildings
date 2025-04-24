within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
partial model PartialLoadValveControl
  "Partial model of a load on hydronic circuit with flow rate modulation by control valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal);

  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  replaceable package MediumLiq = Buildings.Media.Water
    "Medium model for liquid (CHW or HHW)";

  parameter Buildings.Fluid.HydronicConfigurations.Types.Control typ
    "Load type" annotation (Evaluate=true);

  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Liquid mass flow rate at design conditions";

  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(
    displayUnit="Pa")=3E4
    "Liquid pressure drop across terminal unit at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")=dpTer_nominal
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Control valve"));
  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(
    displayUnit="Pa")=0
    "Balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    abs(Q_flow_nominal) / 10 / 1015
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
      then 20+273.15 else 26+273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEntChg_nominal=20+273.15
    "Air entering temperature in change-over mode"
    annotation(Dialog(
      enable=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver));
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions"
    annotation(Dialog(
      enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Control.Heating));
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
      then 60+273.15 else 7+273.15
    "Liquid entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal+(
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
      then -10 else +5)
    "Liquid leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEntChg_nominal=
    60+273.15
    "Liquid entering temperature in change-over mode"
    annotation(Dialog(
      enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Control.Heating));

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
   (MediumLiq.specificEnthalpy_pTX(MediumLiq.p_default, TLiqEnt_nominal, X=MediumLiq.X_default)-
    MediumLiq.specificEnthalpy_pTX(MediumLiq.p_default, TLiqLvg_nominal, X=MediumLiq.X_default))*
    mLiq_flow_nominal
    "Transmitted heat flow rate at design conditions"
    annotation(Evaluate=true);

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=100*Modelica.Constants.eps)=0.1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(unit="s")=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode "Operating mode"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load
    loa(
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final mLiq_flow_nominal=mLiq_flow_nominal,
    final dpLiq_nominal=0,
    final mAir_flow_nominal=mAir_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final phiAirEnt_nominal=phiAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    final TAirEntChg_nominal=TAirEntChg_nominal,
    final TLiqEntChg_nominal=TLiqEntChg_nominal,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final energyDynamics=energyDynamics) "Load"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  replaceable HydronicConfigurations.Interfaces.PartialHydronicConfiguration con
    constrainedby
    HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    redeclare final package Medium=MediumLiq,
    final use_siz=false,
    final dp2_nominal=dpTer_nominal,
    final m2_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpBal1_nominal,
    use_lumFloRes=true,
    final energyDynamics=energyDynamics)
    "Diversion connection"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLoa_actual(final unit="1")
    "Actual load fraction met" annotation (Placement(transformation(extent={{100,20},
            {140,60}}),     iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(final unit="W")
    "Total heat flow rate transferred to the load" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}),  iconTransformation(
          extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal_actual(final unit="1")
    "Valve position feedback" annotation (Placement(transformation(extent={{100,
            60},{140,100}}), iconTransformation(extent={{100,60},{140,100}})));
equation
  connect(port_a, con.port_a1)
    annotation (Line(points={{-100,0},{-6,0}}, color={0,127,255}));
  connect(con.port_b1, port_b)
    annotation (Line(points={{6,0},{100,0}}, color={0,127,255}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{-6,20},{-6,40},{-10,
          40},{-10,60}}, color={0,127,255}));
  connect(con.port_a2, loa.port_b) annotation (Line(points={{6,20},{6,40},{10,
          40},{10,60}}, color={0,127,255}));
  connect(loa.yVal, con.yVal) annotation (Line(points={{12,68},{20,68},{20,80},{
          -20,80},{-20,10},{-12,10}},  color={0,0,127}));
  connect(u, loa.u) annotation (Line(points={{-120,80},{-40,80},{-40,68},{-12,68}},
        color={0,0,127}));
  connect(loa.yLoa_actual, yLoa_actual) annotation (Line(points={{12,64},{90,64},
          {90,40},{120,40}}, color={0,0,127}));
  connect(loa.Q_flow, Q_flow) annotation (Line(points={{12,51},{80,51},{80,-60},
          {120,-60}}, color={0,0,127}));
  connect(con.yVal_actual, yVal_actual) annotation (Line(points={{12,10},{70,10},
          {70,80},{120,80}}, color={0,0,127}));
  connect(mode, loa.mode) annotation (Line(points={{-120,40},{-40,40},{-40,64},{
          -12,64}}, color={255,127,0}));
  connect(mode, con.mode) annotation (Line(points={{-120,40},{-40,40},{-40,18},
          {-12,18}}, color={255,127,0}));
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-72,50},{28,-50}},     lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-58,36},{14,-36}}, lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-48.5,-24.5},{1.5,27.5}},              color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{40,10},{40,-10},{60,0},{40,10}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={70,0},
          rotation=180),
        Line(
          points={{-100,0},{-72,0}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{28,0},{40,0}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{80,0},{100,0}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{50,34},{70,14}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-22,50},{-22,62}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,72},{-12,72}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),
        Line(
          points={{10,82},{30,72},{10,62}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{10,82},{50,62}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{50,72},{60,72},{60,34}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Ellipse(
          extent={{-32,82},{-12,62}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-22,68},{-22,76}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-26,76},{-18,76}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={60,0},
          rotation=270)}),                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a partial model of a thermal load on a hydronic circuit that
is composed of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.Load</a>
and a replaceable configuration component derived from 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration\">
Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration</a>
that is used to modulate the flow rate through the load component.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialLoadValveControl;
