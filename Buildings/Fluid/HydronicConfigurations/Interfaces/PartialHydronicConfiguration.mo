within Buildings.Fluid.HydronicConfigurations.Interfaces;
model PartialHydronicConfiguration
  replaceable package Medium =
    Buildings.Media.Water "Medium in the component"
    annotation (choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  parameter Boolean have_ctl = false
    "Set to true in case of built-in controls"
    annotation(Dialog(group="Controls"), Evaluate=true);

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal
    "Mass flow rate in primary circuit at design conditions"
    annotation (Dialog(group="Nominal condition", enable=have_bypFix));

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa")
    "Consumer circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic typCha=
    Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Control valve characteristic"
    annotation(Dialog(group="Control valve"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.Pump typPum=
    Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable
    "Type of secondary pump"
    annotation(Dialog(group="Pump", enable=have_pum), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.PumpModel typPumMod=
    Buildings.Fluid.HydronicConfigurations.Types.PumpModel.SpeedFractional
    "Type of pump model"
    annotation(Dialog(group="Pump", enable=have_pum), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.ControlFunction typFun(
    start=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating)
    "Circuit function (in case of built-in controls)"
    annotation(Dialog(group="Controls", enable=have_ctl), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.ControlVariable typCtl=
    Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature
    "Controlled variable (in case of built-in controls)"
    annotation(Dialog(group="Controls", enable=have_ctl), Evaluate=true);

  final parameter Boolean have_yPum = have_pum and
    typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable
    "Set to true if an analog input is used for pump control"
    annotation(Dialog(group="Configuration"));
  final parameter Boolean have_y1Pum = have_pum and
    typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant
    "Set to true if a digital input is used for pump control"
    annotation(Dialog(group="Configuration"));
  final parameter Boolean have_yVal = not have_ctl
    "Set to true if an analog input is used for valve control"
    annotation(Dialog(group="Configuration"));
  final parameter Boolean have_set = have_ctl
    "Set to true if an analog input is used as a set point"
    annotation(Dialog(group="Configuration"));
  final parameter Boolean have_mod = have_ctl or have_pum
    "Set to true if an analog input is used as a control mode selector"
    annotation(Dialog(group="Configuration"));

  parameter Boolean use_lumFloRes = true
    "Set to true to use a lumped flow resistance when possible"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Control valve"));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(displayUnit=
        "Pa")=0
    "Primary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(displayUnit=
        "Pa")=0
    "Secondary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));

  parameter Actuators.Valves.Data.Generic flowCharacteristics(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics"
     annotation (
     Dialog(group="Control valve",
     enable=typVal==Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay
     and typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
     choicesAllMatching=true);
  parameter Actuators.Valves.Data.Generic flowCharacteristics1(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for direct flow path at port_1"
     annotation (
     Dialog(group="Control valve",
     enable=typVal==Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay
     and typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
     choicesAllMatching=true);
  parameter Actuators.Valves.Data.Generic flowCharacteristics3(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for bypass flow path at port_3"
    annotation (
    Dialog(group="Control valve",
     enable=typVal==Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay
     and typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
    choicesAllMatching=true);

  replaceable parameter Movers.Data.Generic perPum
    constrainedby Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * m2_flow_nominal / 996,
        dp={1.2, 1, 0.4} * dp2_nominal))
    "Pump parameters"
    annotation (
    Dialog(group="Pump", enable=have_pum),
    Placement(transformation(extent={{74,74},{94,94}})));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Controls", enable=have_ctl), Evaluate=true);
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Gain of controller"
    annotation (Dialog(group="Controls", enable=have_ctl));
  parameter Real Ti(unit="s")=120
    "Time constant of integrator block"
    annotation (Dialog(group="Controls",
    enable=have_ctl and (controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  // FIXME: DynamicFixedInitial differs from MBL default DynamicFreeInitial
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Primary supply port"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Primary return port"
    annotation (Placement(transformation(extent={{70,-110},{50,-90}}),
        iconTransformation(extent={{70,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Secondary return port"
    annotation (Placement(transformation(extent={{50,90},{70,110}}),
        iconTransformation(extent={{50,88},{70,108}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Secondary return port"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}}),
        iconTransformation(extent={{-50,90},{-70,110}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal if have_yVal
    "Valve control signal"
    annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealInput set if have_set
    "Set point"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealInput yPum if have_yPum
    "Pump control signal (variable speed)"
    annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));
  .Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mod if have_mod
    "Operating mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,
            100}}),      iconTransformation(extent={{-140,60},{-100,100}})));

  Medium.MassFlowRate m1_flow = port_a1.m_flow
    "Mass flow rate from port_a1 to port_b1 (m1_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp1(displayUnit="Pa") = port_a1.p - port_b1.p
    "Pressure difference between port_a1 and port_b1";

  Medium.MassFlowRate m2_flow = port_a2.m_flow
    "Mass flow rate from port_a2 to port_b2 (m2_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dp2(displayUnit="Pa") = port_a2.p - port_b2.p
    "Pressure difference between port_a2 and port_b2";

  Medium.ThermodynamicState sta_a1=
    if allowFlowReversal then
      Medium.setState_phX(port_a1.p,
                          noEvent(actualStream(port_a1.h_outflow)),
                          noEvent(actualStream(port_a1.Xi_outflow)))
    else
      Medium.setState_phX(port_a1.p,
                          inStream(port_a1.h_outflow),
                          inStream(port_a1.Xi_outflow))
      if show_T "Medium properties in port_a1";
  Medium.ThermodynamicState sta_b1=
    if allowFlowReversal then
      Medium.setState_phX(port_b1.p,
                          noEvent(actualStream(port_b1.h_outflow)),
                          noEvent(actualStream(port_b1.Xi_outflow)))
    else
      Medium.setState_phX(port_b1.p,
                          port_b1.h_outflow,
                          port_b1.Xi_outflow)
       if show_T "Medium properties in port_b1";

  Medium.ThermodynamicState sta_a2=
    if allowFlowReversal then
      Medium.setState_phX(port_a2.p,
                          noEvent(actualStream(port_a2.h_outflow)),
                          noEvent(actualStream(port_a2.Xi_outflow)))
    else
      Medium.setState_phX(port_a2.p,
                          inStream(port_a2.h_outflow),
                          inStream(port_a2.Xi_outflow))
      if show_T "Medium properties in port_a2";
  Medium.ThermodynamicState sta_b2=
    if allowFlowReversal then
      Medium.setState_phX(port_b2.p,
                          noEvent(actualStream(port_b2.h_outflow)),
                          noEvent(actualStream(port_b2.Xi_outflow)))
    else
      Medium.setState_phX(port_b2.p,
                          port_b2.h_outflow,
                          port_b2.Xi_outflow)
       if show_T "Medium properties in port_b2";

protected
  parameter Boolean have_bypFix
    "Set to true in case of a fixed bypass"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Boolean have_pum
    "Set to true if a secondary pump is used"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Buildings.Fluid.HydronicConfigurations.Types.Valve typVal
    "Type of control valve"
    annotation(Dialog(group="Control valve"), Evaluate=true);

  Medium.ThermodynamicState state_a1_inflow=
    Medium.setState_phX(port_a1.p, inStream(port_a1.h_outflow), inStream(port_a1.Xi_outflow))
    "state for medium inflowing through port_a1";
  Medium.ThermodynamicState state_b1_inflow=
    Medium.setState_phX(port_b1.p, inStream(port_b1.h_outflow), inStream(port_b1.Xi_outflow))
    "state for medium inflowing through port_b1";
  Medium.ThermodynamicState state_a2_inflow=
    Medium.setState_phX(port_a2.p, inStream(port_a2.h_outflow), inStream(port_a2.Xi_outflow))
    "state for medium inflowing through port_a2";
  Medium.ThermodynamicState state_b2_inflow=
    Medium.setState_phX(port_b2.p, inStream(port_b2.h_outflow), inStream(port_b2.Xi_outflow))
    "state for medium inflowing through port_b2";

  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false),
      graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={175,175,175},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(
      coordinateSystem(preserveAspectRatio=false)));
end PartialHydronicConfiguration;
