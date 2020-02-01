within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit "Partial model for HVAC terminal unit"
  replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
    "Source side medium (heating or chilled water)"
    annotation (choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
    "Load side medium"
    annotation(choices(
      choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium2 = Buildings.Media.Water "Water")));
  final parameter Boolean allowFlowReversal = false
    "Set to true to allow flow reversal on the source side."
    annotation(tab="Assumptions", Evaluate=true);
  parameter Integer facSca = 1
    "Scaling factor to be applied to each extensive quantity";
  parameter Boolean have_watHea = false
    "Set to true if the system has a heating water based heat exchanger"
    annotation(Evaluate=true);
  parameter Boolean have_watCoo = false
    "Set to true if the system has a chilled water based heat exchanger"
    annotation(Evaluate=true);
  parameter Boolean have_chaOve = false
    "Set to true if the chilled water based heat exchanger operates in change-over"
    annotation(Evaluate=true);
  parameter Boolean have_eleHea = false
    "Set to true if the system has an electric heating equipment"
    annotation(Evaluate=true);
  parameter Boolean have_eleCoo = false
    "Set to true if the system has an electric cooling equipment"
    annotation(Evaluate=true);
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
    "Heat flow rate for water based heating at nominal conditions (>=0)"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=0)
    "Heat flow rate for water based cooling at nominal conditions (<=0)"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(min=0)
    "Heating water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea));
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(min=0)
    "Chilled water mass flow rate at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal(min=0) = 0
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15, displayUnit="degC")
    "Heating water inlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea and not have_chaOve));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15, displayUnit="degC")
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea and not have_chaOve));
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal(
    min=273.15, displayUnit="degC")
    "Chilled water inlet temperature at nominal conditions "
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15, displayUnit="degC")
    "Chilled water outlet temperature at nominal conditions"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15, displayUnit="degC")
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watHea and not have_chaOve));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal(
    min=273.15, displayUnit="degC")
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation(Dialog(
      group="Nominal condition",
      enable=have_watCoo));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput TSetHea(
    quantity="ThermodynamicTemperature",
    displayUnit="degC") if have_watHea or have_chaOve or have_eleHea
    "Heating set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,80})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(
    quantity="ThermodynamicTemperature",
    displayUnit="degC") if have_watCoo or have_eleCoo
    "Cooling set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,40})));
  Modelica.Blocks.Interfaces.RealInput QReqHea_flow(
    quantity="HeatFlowRate") if
    have_QReq_flow and (have_watHea or have_chaOve or have_eleHea)
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
    quantity="HeatFlowRate") if
    have_QReq_flow and (have_watCoo or have_eleCoo)
    "Required heat flow rate to meet cooling set point (<=0)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-40})));
  Modelica.Blocks.Interfaces.RealOutput QActHea_flow(
    quantity="HeatFlowRate") if have_watHea or have_chaOve or have_eleHea
    "Heat flow rate transferred to the load for heating (>=0)"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
      iconTransformation(extent={{120,70},{140,90}})));
  Modelica.Blocks.Interfaces.RealOutput QActCoo_flow(
    quantity="HeatFlowRate") if have_watCoo or have_eleCoo
    "Heat flow rate transferred to the load for cooling (<=0)"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{120,50},{140,70}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    quantity="Power") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
      iconTransformation(extent={{120,30},{140,50}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
      iconTransformation(extent={{120,10},{140,30}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    quantity="Power", final unit="W") if have_fan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
      iconTransformation(extent={{120,-10},{140,10}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    quantity="Power", final unit="W") if have_pum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
      iconTransformation(extent={{120,-30},{140,-10}})));
  Modelica.Blocks.Interfaces.RealOutput mReqHeaWat_flow(
    quantity="MassFlowRate") if have_watHea
    "Required heating water flow rate to meet heating set point"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
      iconTransformation(extent={{120,-50},{140,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mReqChiWat_flow(
    quantity="MassFlowRate") if have_watCoo
    "Required chilled water flow rate to meet cooling set point"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{120,-70},{140,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aLoa(
    redeclare final package Medium = Medium2,
    p(start=Medium2.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid stream inlet port on the load side"
    annotation (Placement(transformation(
      extent={{190,-10},{210,10}}), iconTransformation(extent={{110,90},{
      130,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bLoa(
    redeclare final package Medium = Medium2,
    p(start=Medium2.p_default),
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default, nominal=Medium2.h_default)) if have_fluPor
    "Fluid stream outlet port on the load side"
    annotation (Placement(transformation(
      extent={{-190,-10},{-210,10}}), iconTransformation(extent={{-110,90},
      {-130,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCon if have_heaPor
    "Heat port transferring convective heat to the load"
    annotation (Placement(transformation(extent={{190,30},{210,50}}),
      iconTransformation(extent={{-50,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorRad if have_heaPor
    "Heat port transferring radiative heat to the load"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}}),
      iconTransformation(extent={{30,-10},{50,10}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-216,44},{-182,76}}),
      iconTransformation(extent={{-18,104},{16,136}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    p(start=Medium1.p_default),
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if have_watHea
    "Heating water inlet port"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}}),
      iconTransformation(extent={{-130,-110},{-110,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    p(start=Medium1.p_default),
    redeclare final package Medium = Medium1,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if have_watCoo
    "Chilled water inlet port"
    annotation (Placement(transformation(extent={{-210, -190},{-190,-170}}),
      iconTransformation(extent={{-130,-90},{-110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    p(start=Medium1.p_default),
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if have_watHea
    "Heating water outlet port"
    annotation (Placement(transformation(extent={{210,-230},{190,-210}}),
      iconTransformation(extent={{130,-110},{110,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    p(start=Medium1.p_default),
    redeclare final package Medium = Medium1,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium1.h_default, nominal=Medium1.h_default)) if have_watCoo
    "Chilled water outlet port"
    annotation (Placement(transformation(extent={{210,-190},{190,-170}}),
      iconTransformation(extent={{130,-90},{110,-70}})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqHea_flow(k=1/facSca) if
    have_QReq_flow and (have_watHea or have_chaOve or have_eleHea)
    "Scaling"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqCoo_flow(k=1/facSca) if
    have_QReq_flow and (have_watCoo or have_eleCoo)
    "Scaling"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActHea_flow(k=facSca) if
    have_watHea or have_chaOve or have_eleHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActCoo_flow(k=facSca) if
    have_watCoo or have_eleCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPHea(k=facSca) if
    have_eleHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPCoo(k=facSca) if
    have_eleCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPFan(k=facSca) if have_fan
    "Scaling"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPPum(k=facSca) if have_pum
    "Scaling"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaMasFloReqHeaWat(k=facSca) if
    have_watHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaMasFloReqChiWat(k=facSca) if
    have_watCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpHeaWat_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_aHeaWat_nominal))
    "Source side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cpChiWat_nominal=
    Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, T_aChiWat_nominal))
    "Source side specific heat capacity at nominal conditions in cooling mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cpLoaHea_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_aLoaHea_nominal))
    "Load side specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cpLoaCoo_nominal=
    Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, T_aLoaCoo_nominal))
    "Load side specific heat capacity at nominal conditions in cooling mode";
equation
  if have_QReq_flow and (have_watHea or have_chaOve or have_eleHea) then
    connect(QReqHea_flow, scaQReqHea_flow.u)
      annotation (Line(points={{-220,140},{-182,140}}, color={0,0,127}));
  end if;
  if have_QReq_flow and (have_watCoo or have_eleCoo) then
    connect(QReqCoo_flow, scaQReqCoo_flow.u)
      annotation (Line(points={{-220,100},{-182,100}}, color={0,0,127}));
  end if;
  if have_watHea or have_chaOve or have_eleHea then
    connect(scaQActHea_flow.y, QActHea_flow)
      annotation (Line(points={{182,220},{220,220}}, color={0,0,127}));
  end if;
  if have_watCoo or have_eleCoo then
    connect(scaQActCoo_flow.y, QActCoo_flow)
      annotation (Line(points={{182,200},{192, 200},{192,200},{220,200}}, color={0,0,127}));
  end if;
  if have_eleHea then
    connect(scaPHea.y, PHea)
      annotation (Line(points={{182,180},{220,180}}, color={0,0,127}));
  end if;
  if have_eleCoo then
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
  if have_watHea then
    connect(scaMasFloReqHeaWat.y, mReqHeaWat_flow)
      annotation (Line(points={{182,100},{220,100}}, color={0,0,127}));
  end if;
  if have_watCoo then
    connect(scaMasFloReqChiWat.y, mReqChiWat_flow)
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
<p>
The heating or cooling nominal capacity is provided for the water based heat
exchangers only: electric heating and cooling equipment is supposed to have
an infinite capacity.
</p>
<p>
When modeling a change-over coil:
</p>
<ul>
<li>
<code>have_watCoo</code> and <code>have_chaOve</code> must both be set to 
<code>true</code> and <code>have_watHea</code> must be set to <code>false</code>.
</li>
<li>
The heat exchanger is sized by providing the nominal parameters for the cooling
configuration (suffix <code>ChiWat</code>). The monimal mass flow rate on the 
source and the load side must also be provided for the heating configuration
(suffix <code>HeaWat</code>) as it can differ from the cooling configuration.
</li>
<li>
The computed heat flow rate must be split into its positive part that gets
connected to <code>QActHea_flow</code> and its negative part that gets connected 
to <code>QActCoo_flow</code>.
</li>
<li>
The computed required mass flow rate must be connected to 
<code>mReqChiWat_flow</code>. 
</li>
</ul>
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
