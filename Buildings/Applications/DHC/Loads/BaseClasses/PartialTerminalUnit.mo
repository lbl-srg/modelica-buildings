within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Prtial model for HVAC terminal unit"
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
  parameter Integer nPorts1=1
    "Number of inlet fluid ports on the source side"
    annotation(Evaluate=true);
  parameter Boolean haveFanPum
    "Set to true if the system has a fan or a pump"
    annotation(Evaluate=true);
  parameter Boolean haveEleHeaCoo
    "Set to true if the system has electric heating or cooling"
    annotation(Evaluate=true);
  final parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal[nPorts1](each min=0) = fill(0, nPorts1)
    "Source side total mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal[nPorts1](each min=0) = fill(0, nPorts1)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal[nPorts1](
    each min=0, each displayUnit="Pa") = fill(0, nPorts1)
    "Source side pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal[nPorts1](
    each min=0, each displayUnit="Pa") = fill(0, nPorts1)
    "Load side pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon[nPorts1]=
    fill(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow, nPorts1)
    "Heat exchanger configuration";
  parameter Modelica.SIunits.Temperature T_a1_nominal[nPorts1](
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
   parameter Modelica.SIunits.Temperature T_b1_nominal[nPorts1](
     min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
     "Source side return temperature at nominal conditions"
     annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal[nPorts1](
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal[nPorts1](min=0)
    "Sensible thermal power exchanged with the load i at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-210,-240},{-190,-160}}),
      iconTransformation(extent={{-110,-94},{-90,-14}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{190,-240},{210,-160}}),
      iconTransformation(extent={{90,-94},{110,-14}})));
  Modelica.Blocks.Interfaces.RealInput uSet[nPorts1] "Setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,210}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,30})));
  Modelica.Blocks.Interfaces.RealOutput m_flow1Req[nPorts1](
    each quantity="MassFlowRate") if nPorts1>0
    "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{200,190},{240,230}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if nPorts1>0
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(
      extent={{190,-10},{210,10}}),
                                  iconTransformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if nPorts1>0
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-190,-10},{-210,10}}),
      iconTransformation(extent={{-90,70},{-110,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow1Act[nPorts1](
    each quantity="HeatFlowRate") if nPorts1>0
    "Heat flow rate transferred to the source (<0 for heating)"
    annotation (Placement(transformation(extent={{200,150},{240,190}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFanPum(quantity="Power", final unit="W") if haveFanPum
    "Power drawn by fans and pumps"
    annotation (Placement(transformation(extent={{200,110},{240,150}}), iconTransformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PHeaCoo(quantity="Power", final unit="W") if haveEleHeaCoo
    "Power drawn by heating and cooling equipment"
    annotation (Placement(transformation(extent={{200,70},{240,110}}), iconTransformation(extent={{100,0},{120,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),graphics={
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
