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

  parameter Boolean use_siz = true
    "Set to true for built-in sizing of control valve and optional pump"
    annotation (Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)
    "Mass flow rate in primary circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp1_nominal(
    displayUnit="Pa",
    start=0)
    "Primary circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition", enable=use_dp1));

  parameter Modelica.Units.SI.PressureDifference dp2_nominal(
    displayUnit="Pa",
    start=0)
    "Consumer circuit pressure differential at design conditions"
    annotation (Dialog(group="Nominal condition", enable=use_dp2));

  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic typCha=
    Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Control valve characteristic"
    annotation(Dialog(group="Control valve"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.Pump typPum=
    Buildings.Fluid.HydronicConfigurations.Types.Pump.VariableInput
    "Type of secondary pump"
    annotation(Dialog(group="Pump"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.PumpModel typPumMod=
    Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Speed
    "Type of pump model"
    annotation(Dialog(group="Pump",
    enable=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
    Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.Control typCtl=
    Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Type of built-in controls"
    annotation (Dialog(group="Controls"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.ControlVariable
    typVar=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature
    "Controlled variable"
    annotation(Dialog(group="Controls",
      enable=typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None
      and have_typVar),
      Evaluate=true);

  parameter Boolean use_lumFloRes = true
    "Set to true to use a lumped flow resistance when possible"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa")
    "Control valve pressure drop at design conditions"
    annotation (Dialog(group="Control valve", enable=not use_siz));

  parameter Modelica.Units.SI.PressureDifference dpBal1_nominal(
    displayUnit="Pa")=0
    "Primary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));
  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(
    displayUnit="Pa")=0
    "Secondary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Balancing valves"));
  parameter Modelica.Units.SI.PressureDifference dpBal3_nominal(
    displayUnit="Pa")=0
    "Bypass balancing valve pressure drop at design conditions"
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

  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=m2_flow_nominal
    "Pump head at design conditions"
    annotation (Dialog(group="Pump",
      enable=not use_siz and typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None));

  parameter Modelica.Units.SI.PressureDifference dpPum_nominal(
    displayUnit="Pa")= dp2_nominal + dpBal2_nominal
    "Pump head at design conditions"
    annotation (Dialog(group="Pump",
      enable=not use_siz and typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None));

  replaceable parameter Movers.Data.Generic perPum
    constrainedby Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * mPum_flow_nominal / rho_default,
        dp=if typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None then
          {1.14, 1, 0.42} * dpPum_nominal else {1.14, 1, 0.42}))
    "Pump parameters"
    annotation (
    Dialog(group="Pump",
    enable=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
    Placement(transformation(extent={{74,74},{94,94}})));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Controls",
      enable=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None),
      Evaluate=true);
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Gain of controller"
    annotation (Dialog(group="Controls",
      enable=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None));
  parameter Real Ti(unit="s")=120
    "Time constant of integrator block"
    annotation (Dialog(group="Controls",
    enable=typCtl <> Buildings.Fluid.HydronicConfigurations.Types.Control.None
           and (controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

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

  /* Workaround for Dymola 2022x (#SR00922000-01):
  The parameters below should be located inside the protected section. 
  However, doing so yields an incorrect interpretation of the enable 
  annotation attribute.
  The temporary workaround is to declare them in the public section 
  and systematically assign them final values in the derived models.
  */
  parameter Boolean use_dp1
    "Set to true to enable dp1_nominal"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Boolean use_dp2
    "Set to true to enable dp2_nominal"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Buildings.Fluid.HydronicConfigurations.Types.Valve typVal
    "Type of control valve"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Boolean have_typVar = true
    "Set to true to enable the choice of the controlled variable"
    annotation(Dialog(group="Configuration"), Evaluate=true);

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
        iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Secondary supply port"
    annotation (Placement(transformation(extent={{-50,90},{-70,110}}),
        iconTransformation(extent={{-50,90},{-70,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal(
    final unit="1", final min=0, final max=1) if have_yVal
    "Valve control signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                         iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput set if have_set
    "Set point"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yPum(
    final unit="1", final min=0, final max=1) if have_yPum
    "Pump control signal (variable speed)"
    annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode(final min=0, final
      max=if typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver
         then 2 else 1) if have_mod "Operating mode" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal_actual(
    final unit="1")
    if typVal <> Buildings.Fluid.HydronicConfigurations.Types.Valve.None
    "Valve position feedback"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
                         iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum_actual(
    final unit="1") if typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Actual pump input value that is used for computations"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    quantity="Power",
    final unit="W") if typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Pump electrical power"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,60},{140,100}})));

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
  final parameter Boolean have_yPum=
    typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None and
    typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.VariableInput
    "Set to true if an analog input is used for pump control"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  final parameter Boolean have_y1Pum=
    typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None and
    typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput
    "Set to true if a digital input is used for pump control"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  final parameter Boolean have_yVal=
    typCtl==Buildings.Fluid.HydronicConfigurations.Types.Control.None and
    typVal<>Buildings.Fluid.HydronicConfigurations.Types.Valve.None
    "Set to true if an analog input is used for valve control"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  parameter Boolean have_set=
    typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None
    "Set to true if an analog input is used as a set point"
    annotation(Dialog(group="Configuration"), Evaluate=true);
  final parameter Boolean have_mod=
    typCtl<>Buildings.Fluid.HydronicConfigurations.Types.Control.None
    or typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Set to true if an analog input is used as a control mode selector"
    annotation(Dialog(group="Configuration"), Evaluate=true);

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

  final parameter Modelica.Units.SI.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

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
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is the interface class for all models of hydronic
configurations in
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks</a>
and
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks</a>.
</p>
<p>
This interface class (conditionally) instantiates all possible
outside connectors that any derived class may use.
This provides plug-compatibility across all the models extending this
class.
</p>
</html>"));
end PartialHydronicConfiguration;
