within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Partial model for HVAC terminal unit"
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
    annotation (choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Buildings.Media.Air
    "Load side medium"
    annotation(choices(
      choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  parameter Integer nPorts1 = 0
    "Number of inlet fluid ports on the source side"
    annotation(Evaluate=true);
  parameter Boolean haveHeaPor = false
    "Set to true for heat ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean haveFluPor = true
    "Set to true for fluid ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean haveQ_flowReq = false
    "Set to true for required heat flow rate input"
    annotation(Evaluate=true);
  parameter Boolean haveFanPum
    "Set to true if the system has a fan or a pump"
    annotation(Evaluate=true);
  parameter Boolean haveEleHeaCoo
    "Set to true if the system has electric heating or cooling"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal[nPorts1](min=0)
    "Sensible thermal power at nominal conditions (always positive)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal[nPorts1](
    each min=0) = fill(0, nPorts1)
    "Source side mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal[nPorts1](
    each min=0) = fill(0, nPorts1)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal[nPorts1](
    each min=0, each displayUnit="Pa") = fill(0, nPorts1)
    "Source side pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal[nPorts1](
    each min=0, each displayUnit="Pa") = fill(0, nPorts1)
    "Load side pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal[nPorts1](
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
   parameter Modelica.SIunits.Temperature T_b1_nominal[nPorts1](
     min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
     "Source side return temperature at nominal conditions"
     annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal[nPorts1](
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon[nPorts1]=
    fill(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow, nPorts1)
    "Heat exchanger configuration";
  final parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if nPorts1>0
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (visible=DynamicSelect(true, nPorts1>0),
      Placement(transformation(extent={{-210,-240},{-190,-160}}),
      iconTransformation(extent={{-110,-100},{-90,-20}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if nPorts1>0
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (visible=DynamicSelect(true, nPorts1>0),
      Placement(transformation(extent={{190,-240},{210,-160}}),
      iconTransformation(extent={{90,-100},{110,-20}})));
  // TODO: update for electric terminal (heater or DX) => nPorts1=0 but uSet required.
  Modelica.Blocks.Interfaces.RealInput uSet[nPorts1] "Set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,220}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Modelica.Blocks.Interfaces.RealInput Q_flow2Req[nPorts1](
   each quantity="HeatFlowRate") if haveQ_flowReq
    "Required heat flow rate to meet set point (>0 for heating)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));
  Modelica.Blocks.Interfaces.RealOutput m_flow1Req[nPorts1](
    each quantity="MassFlowRate") if nPorts1>0
    "Required heating or chilled water flow to meet set point"
    annotation (
      Placement(transformation(extent={{200,200},{240,240}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if haveFluPor
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (visible=DynamicSelect(true, haveFluPor),
      Placement(transformation(
      extent={{190,-10},{210,10}}),
      iconTransformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if haveFluPor
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (visible=DynamicSelect(true, haveFluPor),
      Placement(transformation(extent={{-190,-10},{-210,10}}),
      iconTransformation(extent={{-90,70},{-110,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCon if haveHeaPor
    "Heat port transfering convective heat to the load"
    annotation (visible=DynamicSelect(true, haveHeaPor),
      Placement(transformation(extent={{190,30},{210,50}}),
      iconTransformation(extent={{-48,-10},{-28,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorRad if haveHeaPor
    "Heat port transfering radiative heat to the load"
    annotation (visible=DynamicSelect(true, haveHeaPor),
      Placement(transformation(extent={{190,-50},{210,-30}}),
      iconTransformation(extent={{32,-10},{52,10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow2Act[nPorts1](
    each quantity="HeatFlowRate") if nPorts1>0
    "Heat flow rate transferred to the load (>0 for heating)"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput PFanPum(
    quantity="Power", final unit="W") if haveFanPum
    "Power drawn by fans and pumps motors"
    annotation (visible=DynamicSelect(true, haveFanPum),
      Placement(transformation(extent={{200,120},{240,160}}),
      iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput PHeaCoo(
    quantity="Power", final unit="W") if haveEleHeaCoo
    "Power drawn by heating and cooling equipment"
    annotation (visible=DynamicSelect(true, haveEleHeaCoo),
      Placement(transformation(extent={{200,80},{240,120}}),
      iconTransformation(extent={{100,-10},{120,10}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal[nPorts1]=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_a1_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal[nPorts1]=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_a2_nominal))
    "Load side specific heat capacity at nominal conditions";
annotation (Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}}),
    graphics={
    Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95}),
    Rectangle(
    extent={{-70,80},{70,-80}},
    lineColor={0,0,255},
    pattern=LinePattern.None,
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-240},{200,240}})));
end PartialTerminalUnit;
