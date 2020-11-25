within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.CentralPlants;
model SewageHeatRecovery "Model for sewage heat recovery plant"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
    annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.MassFlowRate mSew_flow_nominal
    "Sewage water nominal mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "District water nominal mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.PressureDifference dpSew_nominal
    "Sewage side pressure drop at nominal mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal
    "District side pressure drop at nominal mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Efficiency epsHex
    "Heat exchanger effectiveness";
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDis(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water inlet port" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDis(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "District water outlet port" annotation (Placement(transformation(extent={{90,
            -10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput TSewWat(
    final unit="K",
    displayUnit="degC")
    "Sewage water temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput mPum_flow(
    final unit="kg/s")
    "Pumps mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  // COMPONENTS
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_nominal=mSew_flow_nominal,
    final m2_flow_nominal=mDis_flow_nominal,
    final dp1_nominal=dpSew_nominal,
    final dp2_nominal=dpDis_nominal,
    final eps=epsHex)
    "Heat exchanger (primary is sewage water side)"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,14})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final dp_nominal=dpDis_nominal,
    final allowFlowReversal=allowFlowReversal)
    "District water pump"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,0})));
  Fluid.Sources.Boundary_pT souSew(
    redeclare final package Medium = Medium,
    final use_T_in=true,
    final nPorts=2)
    "Source of sewage water"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-70,76})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumSew(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mSew_flow_nominal,
    final dp_nominal=dpSew_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Sewage water pump"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,80})));
  Fluid.Sensors.TemperatureTwoPort senTSewOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mSew_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-40,20})));
equation
  connect(senTSewOut.port_b, souSew.ports[1])
    annotation (Line(points={{-46,20},{-60,20},{-60,78}}, color={0,127,255}));
  connect(souSew.ports[2], pumSew.port_a)
    annotation (Line(points={{-60,74},{-60,80},{-10,80}},
                                                 color={0,127,255}));
  connect(pumDis.port_b, port_bDis)
    annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
  connect(souSew.T_in, TSewWat) annotation (Line(points={{-82,80},{-120,80}},
                          color={0,0,127}));
  connect(mPum_flow, pumSew.m_flow_in)
    annotation (Line(points={{-120,40},{0,40},{0,68}}, color={0,0,127}));
  connect(pumSew.port_b, hex.port_a1) annotation (Line(points={{10,80},{62,80},{
          62,20},{10,20}},                 color={0,127,255}));
  connect(hex.port_b1, senTSewOut.port_a) annotation (Line(points={{-10,20},{-34,
          20}},                   color={0,127,255}));
  connect(port_aDis, hex.port_a2) annotation (Line(points={{-100,0},{-20,0},{-20,
          8},{-10,8}}, color={0,127,255}));
  connect(hex.port_b2, pumDis.port_a) annotation (Line(points={{10,8},{20,8},{20,
          0},{30,0}},     color={0,127,255}));
  connect(mPum_flow, pumDis.m_flow_in)
    annotation (Line(points={{-120,40},{40,40},{40,12}}, color={0,0,127}));
  annotation (
  DefaultComponentName="pla",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{-50,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-50,30},{20,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,2},{100,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{72,-14},{44,14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,0},{58,14},{58,-14},{72,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,-110},{150,-150}},
        textString="%name",
        lineColor={0,0,255})}),             Diagram(coordinateSystem(
          preserveAspectRatio=false), graphics={Rectangle(extent={{-100,100},{100,
              -100}}, lineColor={0,0,0})}));
end SewageHeatRecovery;
