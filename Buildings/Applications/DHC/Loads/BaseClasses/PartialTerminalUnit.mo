within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Partial model for HVAC terminal unit"
  import funSpe = Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec
    "Specifications of heating or cooling function";
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
  parameter Integer facSca = 1
    "Scaling factor to be applied to on each extensive quantity";
  parameter funSpe funHeaSpe = funSpe.Water
    "Specification of the heating function";
  parameter funSpe funCooSpe = funSpe.Water
    "Specification of the cooling function";
  parameter Boolean have_heaPor = false
    "Set to true for heat ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean have_fluPor = false
    "Set to true for fluid ports on the load side"
    annotation(Evaluate=true);
  parameter Boolean have_QReq_flow = false
    "Set to true for required heat flow rate as an input"
    annotation(Evaluate=true);
  parameter Boolean have_weaBus = false
    "Set to true for weather bus"
    annotation(Evaluate=true);
  parameter Boolean have_fan = false
    "Set to true if the system has a fan"
    annotation(Evaluate=true);
  parameter Boolean have_pum = false
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=0)
    "Heating thermal power at nominal conditions (always positive)"
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe <> funSpe.None));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(min=0)
    "Cooling thermal power at nominal conditions (always positive)"
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe <> funSpe.None));
  parameter Modelica.SIunits.MassFlowRate m1Hea_flow_nominal(min=0)
    "Heating water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.MassFlowRate m1Coo_flow_nominal(min=0)
    "Chilled water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.MassFlowRate m2Hea_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe <> funSpe.None));
  parameter Modelica.SIunits.MassFlowRate m2Coo_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe <> funSpe.None));
  parameter Modelica.SIunits.Temperature T_a1Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Heating water inlet temperature at nominal conditions "
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_b1Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a1Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Chilled water inlet temperature at nominal conditions "
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_b1Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Chilled water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a2Hea_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver));
  parameter Modelica.SIunits.Temperature T_a2Coo_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexConHea=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heating heat exchanger configuration"
    annotation(Dialog(
      enable=funHeaSpe == funSpe.Water));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexConCoo=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Cooling heat exchanger configuration"
    annotation(Dialog(
      enable=funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver));
  final parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput TSetHea if funHeaSpe <> funSpe.None
    "Heating set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,80})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo if funCooSpe <> funSpe.None
    "Cooling set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,40})));
  Modelica.Blocks.Interfaces.RealInput QReqHea_flow(
    quantity="HeatFlowRate") if have_QReq_flow and funHeaSpe <> funSpe.None
    "Required heat flow rate to meet heating set point (>=0)"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Modelica.Blocks.Interfaces.RealInput QReqCoo_flow(
    quantity="HeatFlowRate") if have_QReq_flow and funCooSpe <> funSpe.None
    "Required heat flow rate to meet cooling set point (<=0)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-40})));
  Modelica.Blocks.Interfaces.RealOutput m1ReqHea_flow(
    quantity="MassFlowRate") if
    funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver
    "Required heating water flow to meet heating set point" annotation (
      Placement(transformation(extent={{200,80},{240,120}}),
        iconTransformation(extent={{120,-40},{140,-20}})));
  Modelica.Blocks.Interfaces.RealOutput m1ReqCoo_flow(
    quantity="MassFlowRate") if
    funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver
    "Required chilled water flow to meet cooling set point"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{120,-60},{140,-40}})));
  Modelica.Blocks.Interfaces.RealOutput QActHea_flow(
    quantity="HeatFlowRate") if funHeaSpe <> funSpe.None
    "Heat flow rate transferred to the load for heating (>=0)"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
        iconTransformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput QActCoo_flow(
    quantity="HeatFlowRate") if funCooSpe <> funSpe.None
    "Heat flow rate transferred to the load for cooling (<=0)" annotation (
      Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    quantity="Power", final unit="W") if have_fan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
        iconTransformation(extent={{120,0},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    quantity="Power", final unit="W") if have_pum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{120,-20},{140,0}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    quantity="Power", final unit="W") if funHeaSpe == funSpe.Electric
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power", final unit="W") if funCooSpe == funSpe.Electric
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
        iconTransformation(extent={{120,20},{140,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (
      Placement(transformation(
      extent={{190,-10},{210,10}}),
      iconTransformation(extent={{110,100},{130,120}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (
      Placement(transformation(extent={{-190,-10},{-210,10}}),
      iconTransformation(extent={{-110,100},{-130,120}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCon if have_heaPor
    "Heat port transferring convective heat to the load"
    annotation (
      Placement(transformation(extent={{190,30},{210,50}}),
      iconTransformation(extent={{-50,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorRad if have_heaPor
    "Heat port transferring radiative heat to the load"
    annotation (
      Placement(transformation(extent={{190,-50},{210,-30}}),
      iconTransformation(extent={{30,-10},{50,10}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(
      transformation(extent={{-216,44},{-182,76}}),
      iconTransformation(extent={{-18,104},{16,136}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1Hea(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    funHeaSpe == funSpe.Water
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}}),
        iconTransformation(extent={{-130,-120},{-110,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1Coo(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}}),
        iconTransformation(extent={{-130,-90},{-110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1Hea(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    funHeaSpe == funSpe.Water
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{210,-230},{190,-210}}),
        iconTransformation(extent={{130,-120},{110,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1Coo(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if
    funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{210,-190},{190,-170}}),
        iconTransformation(extent={{130,-90},{110,-70}})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqHea_flow(k=1/facSca) if
    have_QReq_flow and funHeaSpe <> funSpe.None
    "Scaling"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqCoo_flow(k=1/facSca) if
    have_QReq_flow and funCooSpe <> funSpe.None
    "Scaling"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActHea_flow(k=facSca) if
    funHeaSpe <> funSpe.None
    "Scaling"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActCoo_flow(k=facSca) if
    funCooSpe <> funSpe.None
    "Scaling"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPHea(k=facSca) if
    funHeaSpe == funSpe.Electric
    "Scaling"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPCoo(k=facSca) if
    funCooSpe == funSpe.Electric
    "Scaling"
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPFan(k=facSca) if have_fan
    "Scaling"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPPum(k=facSca) if have_pum
    "Scaling"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain sca_m1ReqHea_flow(k=facSca) if
    funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver
    "Scaling"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain sca_m1ReqCoo_flow(k=facSca) if
    funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver
    "Scaling" annotation (Placement(transformation(extent={{160,70},{180,90}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1Hea_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_a1Hea_nominal))
    "Source side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1Coo_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_a1Coo_nominal))
    "Source side specific heat capacity at nominal conditions in cooling mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2Hea_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_a2Hea_nominal))
    "Load side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2Coo_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_a2Coo_nominal))
    "Load side specific heat capacity at nominal conditions in cooling mode";
equation
  if have_QReq_flow and funHeaSpe <> funSpe.None then
    connect(QReqHea_flow, scaQReqHea_flow.u)
      annotation (Line(points={{-220,140},{-182,140}}, color={0,0,127}));
  end if;
  if have_QReq_flow and funCooSpe <> funSpe.None then
    connect(QReqCoo_flow, scaQReqCoo_flow.u)
      annotation (Line(points={{-220,100},{-182,100}}, color={0,0,127}));
  end if;
  if funHeaSpe <> funSpe.None then
    connect(scaQActHea_flow.y, QActHea_flow)
      annotation (Line(points={{182,220},{220,220}}, color={0,0,127}));
  end if;
  if funCooSpe <> funSpe.None then
    connect(scaQActCoo_flow.y, QActCoo_flow)
      annotation (Line(points={{182,200},{192, 200},{192,200},{220,200}}, color={0,0,127}));
  end if;
  if funHeaSpe == funSpe.Electric then
    connect(scaPHea.y, PHea)
      annotation (Line(points={{182,180},{220,180}}, color={0,0,127}));
  end if;
  if funCooSpe == funSpe.Electric then
    connect(scaPCoo.y, PCoo)
      annotation (Line(points={{182,160},{220,160}}, color={0,0,127}));
  end if;
  if have_fan then
    connect(scaPFan.y, PFan)
      annotation (Line(points={{182,140},{220,140}}, color={0,0,127}));
  end if;
  if have_pum then
    connect(scaPPum.y, PPum)
      annotation (Line(points={{182,120},{220,120}}, color={0,0,127}));
  end if;
  if funHeaSpe == funSpe.Water or funHeaSpe == funSpe.ChangeOver then
    connect(sca_m1ReqHea_flow.y, m1ReqHea_flow)
      annotation (Line(points={{182,100},{220,100}}, color={0,0,127}));
  end if;
  if funCooSpe == funSpe.Water or funCooSpe == funSpe.ChangeOver then
    connect(sca_m1ReqCoo_flow.y, m1ReqCoo_flow)
      annotation (Line(points={{182,80},{220,80}}, color={0,0,127}));
  end if;
annotation (
  defaultComponentName="terUni",
  Documentation(info="<html>
<p>
Partial model to be used for modeling the building terminal units, in conjunction
with
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution</a>.
</p>
<p>
The models derived from this class are typically used in conjunction with
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution</a>. They must
compute a so-called required mass flow rate defined as the heating or chilled 
water mass flow rate needed to meet the load.
It can be approximated using a control loop to avoid inverting the heat
exchanger models as described in 
<a href=\"modelica://Buildings.Applications.DHC.Loads.Validation\">
Buildings.Applications.DHC.Loads.Validation</a>.
</p>
<p>
The fluid ports suffixed with <code>1</code> represent the connection with the 
heating or chilled water distribution system.
</p>
<p>
The fluid ports suffixed with <code>2</code> represent the connection with the 
fluid stream on the load side (domestic hot water or supplied air). Alternatively
heat ports can be used to model the heat transfer to the load.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-120,-120},{120,120}}),
    graphics={
    Rectangle(extent={{-120,120},{120,-120}}, lineColor={95,95,95}),
    Rectangle(
    extent={{-80,80},{80,-80}},
    lineColor={0,0,255},
    pattern=LinePattern.None,
    fillColor={95,95,95},
    fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
    extent={{-200,-240},{200,240}})));
end PartialTerminalUnit;
