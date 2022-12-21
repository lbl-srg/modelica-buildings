within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup "Group of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWatChi_flow_nominal,
    final m2_flow_nominal = mChiWatChi_flow_nominal);

  parameter Integer nChi(final min=1, start=1)
    "Number of chillers operating at design conditions"
    annotation(Evaluate=true);

  final parameter Modelica.Units.SI.HeatFlowRate capChi_nominal(
    final min=0)=abs(dat.QEva_flow_nominal)
    "Chiller design capacity (each chiller, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Chiller CW design mass flow rate (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=nChi * mChiWatChi_flow_nominal
    "CHW design mass flow rate (all chillers)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nChi * mConWatChi_flow_nominal
    "CW design mass flow rate (all chillers)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller CHW design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller CW design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "CHW balancing valve design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalConWatChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "CW balancing valve design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Real RChiWat_nominal=
    (dpChiWatChi_nominal + dpBalChiWatChi_nominal) / mChiWatChi_flow_nominal^2
    "CHW flow resistance (each chiller, barrel and valves)";

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters"
    annotation (Placement(transformation(extent={{-10,72},{10,92}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  replaceable Fluid.Chillers.ElectricReformulatedEIR chi(final per=dat)
    constrainedby Buildings.Fluid.Chillers.BaseClasses.PartialElectric(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final dp1_nominal=dpConWatChi_nominal + dpBalConWatChi_nominal,
    final dp2_nominal=0,
    final energyDynamics=energyDynamics,
    final show_T=show_T)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.BaseClasses.MassFlowRateMultiplier mulConWatInl(
    redeclare final package Medium=Medium1,
    final use_input=true)
    "Multiplier for CW flow"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConWatOut(
    redeclare final package Medium=Medium1,
    final use_input=true)
    "Multiplier for CW flow"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatInl(
    redeclare final package Medium=Medium2,
    final use_input=true)
    "Multiplier for CHW flow"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatOut(
    redeclare final package Medium=Medium2,
    final use_input=true)
    "Multiplier for CHW flow"
    annotation (Placement(transformation(extent={{-72,-70},{-92,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1On[nChi]
    "Chiller On/Off signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet
    "CHW supply temperature setpoint"
    annotation (Placement(
        transformation(extent={{-140,-40},{-100,0}})));
  Controls.BaseClasses.ChillerGroupCommand com(final nChi=nChi)
    "Convert command signals"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P "Power drawn" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(
          extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale chiller power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Fluid.Movers.BaseClasses.IdealSource dpChiWat(
    redeclare final package Medium = Medium2,
    m_flow_small=1E-6*mChiWat_flow_nominal,
    final control_m_flow=false,
    final control_dp=true)
    annotation (Placement(transformation(extent={{86,-70},{66,-50}})));

  Real RChiWat=Buildings.Utilities.Math.Functions.regNonZeroPower(
    com.nChiOn / RChiWat_nominal^2, 0.5);
  Real RChiWat1=(com.nChiOn / RChiWat_nominal^2)^0.5;
  Modelica.Blocks.Sources.RealExpression exp(
    y=RChiWat * port_a2.m_flow^2)
    annotation (Placement(transformation(extent={{98,-46},{78,-26}})));


equation

  connect(mulConWatOut.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(mulChiWatOut.port_b, port_b2)
    annotation (Line(points={{-92,-60},{-100,-60}}, color={0,127,255}));
  connect(chi.port_b1, mulConWatOut.port_a) annotation (Line(points={{10,6},{20,
          6},{20,60},{70,60}}, color={0,127,255}));
  connect(mulChiWatInl.port_b, chi.port_a2) annotation (Line(points={{30,-60},{20,
          -60},{20,-6},{10,-6}}, color={0,127,255}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-120,-20},{-30,-20},
          {-30,-3},{-12,-3}},
                            color={0,0,127}));
  connect(u1On, com.u1On)
    annotation (Line(points={{-120,20},{-82,20}}, color={255,0,255}));
  connect(com.y1On, chi.on) annotation (Line(points={{-58,20},{-30,20},{-30,3},{
          -12,3}},           color={255,0,255}));
  connect(com.nChiOnBou, mulConWatOut.u) annotation (Line(points={{-58,26},{40,26},
          {40,66},{68,66}}, color={0,0,127}));
  connect(mulConWatOut.uInv, mulConWatInl.u) annotation (Line(points={{92,66},{94,
          66},{94,40},{-60,40},{-60,66},{-52,66}}, color={0,0,127}));
  connect(com.nChiOnBou, mulChiWatOut.u) annotation (Line(points={{-58,26},{-40,
          26},{-40,-54},{-70,-54}}, color={0,0,127}));
  connect(mulChiWatOut.uInv, mulChiWatInl.u) annotation (Line(points={{-94,-54},
          {-96,-54},{-96,-40},{60,-40},{60,-54},{52,-54}}, color={0,0,127}));
  connect(chi.port_b2, mulChiWatOut.port_a) annotation (Line(points={{-10,-6},{-20,
          -6},{-20,-60},{-72,-60}},                color={0,0,127}));
  connect(port_a1, mulConWatInl.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(com.nChiOnBou, mulP.u1) annotation (Line(points={{-58,26},{64,26},{64,
          6},{68,6}}, color={0,0,127}));
  connect(mulP.y, P)
    annotation (Line(points={{92,0},{120,0}}, color={0,0,127}));
  connect(chi.P, mulP.u2)
    annotation (Line(points={{11,9},{60,9},{60,-6},{68,-6}}, color={0,0,127}));
  connect(mulConWatInl.port_b, chi.port_a1) annotation (Line(points={{-30,60},{-20,
          60},{-20,6},{-10,6}}, color={0,127,255}));
  connect(port_a2, dpChiWat.port_a)
    annotation (Line(points={{100,-60},{86,-60}}, color={0,127,255}));
  connect(dpChiWat.port_b, mulChiWatInl.port_a)
    annotation (Line(points={{66,-60},{50,-60}}, color={0,127,255}));
  connect(exp.y, dpChiWat.dp_in)
    annotation (Line(points={{77,-36},{70,-36},{70,-52}}, color={0,0,127}));
  annotation (
    defaultComponentName="chi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerGroup;
