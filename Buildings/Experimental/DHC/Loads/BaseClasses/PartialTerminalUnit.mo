within Buildings.Experimental.DHC.Loads.BaseClasses;
partial model PartialTerminalUnit
  "Partial model for HVAC terminal unit"
  replaceable package Medium1=Modelica.Media.Interfaces.PartialMedium
    "Source side medium (heating or chilled water)"
    annotation (choices(choice(redeclare package Medium1=Buildings.Media.Water "Water"),choice(redeclare
          package                                                                                                Medium1=
            Buildings.Media.Antifreeze.PropyleneGlycolWater (                                                                                                            property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2=Modelica.Media.Interfaces.PartialMedium
    "Load side medium"
    annotation (choices(choice(redeclare package Medium2=Buildings.Media.Air "Moist air"),choice(redeclare
          package                                                                                                  Medium2=
            Buildings.Media.Water                                                                                                                "Water")));
  parameter Boolean allowFlowReversal=false
    "Set to true to allow flow reversal on the source side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversalLoa=true
    "Set to true to allow flow reversal on the load side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Real facSca=1
    "Scaling factor to be applied to each extensive quantity"
    annotation (Dialog(group="Scaling"));
  parameter Boolean have_scaLoa=true
    "Set to true to apply the scaling factor to the heat or mass flow rate on the load side"
    annotation (Dialog(group="Scaling"));
  parameter Boolean have_watHea=false
    "Set to true if the system has a heating water based heat exchanger"
    annotation (Evaluate=true);
  parameter Boolean have_watCoo=false
    "Set to true if the system has a chilled water based heat exchanger"
    annotation (Evaluate=true);
  parameter Boolean have_chaOve=false
    "Set to true if the chilled water based heat exchanger operates in change-over"
    annotation (Evaluate=true);
  parameter Boolean have_eleHea=false
    "Set to true if the system has an electric heating equipment"
    annotation (Evaluate=true);
  parameter Boolean have_eleCoo=false
    "Set to true if the system has an electric cooling equipment"
    annotation (Evaluate=true);
  parameter Boolean have_heaPor=false
    "Set to true for heat ports on the load side"
    annotation (Evaluate=true);
  parameter Boolean have_fluPor=false
    "Set to true for fluid ports on the load side"
    annotation (Evaluate=true);
  parameter Boolean have_TSen=false
    "Set to true for measured temperature as an input"
    annotation (Evaluate=true);
  parameter Boolean have_QReq_flow=false
    "Set to true for required heat flow rate as an input"
    annotation (Evaluate=true);
  parameter Boolean have_weaBus=false
    "Set to true to enable the weather bus"
    annotation (Evaluate=true);
  parameter Boolean have_fan=false
    "Set to true if the system has a fan"
    annotation (Evaluate=true);
  parameter Boolean have_pum=false
    "Set to true if the system has a pump"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=0)=0
    "Heat flow rate for water based heating at nominal conditions (>=0)"
    annotation (Dialog(group="Nominal condition",enable=have_watHea));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=0)=0
    "Heat flow rate for water based cooling at nominal conditions (<=0)"
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(
    min=0)=0
    "Heating water mass flow rate at nominal conditions"
    annotation (Dialog(group="Nominal condition",enable=have_watHea));
  parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(
    min=0)=0
    "Chilled water mass flow rate at nominal conditions"
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(
    min=0)=0
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition",enable=have_watHea));
  parameter Modelica.SIunits.MassFlowRate mLoaCoo_flow_nominal(
    min=0)=0
    "Load side mass flow rate at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  // AHRI 440 Standard Heating
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=273.15+60
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition",enable=have_watHea and not have_chaOve));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-22.2
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition",enable=have_watHea and not have_chaOve));
  // AHRI 440 Standard Cooling
  parameter Modelica.SIunits.Temperature T_aChiWat_nominal(
    min=273.15,
    displayUnit="degC")=273.15+7.2
    "Chilled water inlet temperature at nominal conditions "
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  parameter Modelica.SIunits.Temperature T_bChiWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aChiWat_nominal+5.6
    "Chilled water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15,
    displayUnit="degC")=273.15+21.1
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition",enable=have_watHea and not have_chaOve));
  parameter Modelica.SIunits.Temperature T_aLoaCoo_nominal(
    min=273.15,
    displayUnit="degC")=273.15+26.7
    "Load side inlet temperature at nominal conditions in cooling mode"
    annotation (Dialog(group="Nominal condition",enable=have_watCoo));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics",group="Nominal condition"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput TSen(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if have_TSen
    "Temperature (measured)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-220,140}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,20})));
  Modelica.Blocks.Interfaces.RealInput TSetHea(
    quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if have_watHea or have_chaOve or have_eleHea
    "Heating set point"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-220,220}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,60})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if have_watCoo or have_eleCoo
    "Cooling set point"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-220,180}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,40})));
  Modelica.Blocks.Interfaces.RealInput QReqHea_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_QReq_flow and
                                         (have_watHea or have_chaOve or have_eleHea)
    "Required heat flow rate to meet heating set point (>=0)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-220,100}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,-20})));
  Modelica.Blocks.Interfaces.RealInput QReqCoo_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_QReq_flow and
                                         (have_watCoo or have_eleCoo)
    "Required heat flow rate to meet cooling set point (<=0)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-220,60}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,-42})));
  Modelica.Blocks.Interfaces.RealOutput QActHea_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_watHea or have_chaOve or have_eleHea
    "Heating heat flow rate transferred to the load (>=0)"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),iconTransformation(extent={{120,70},{140,90}})));
  Modelica.Blocks.Interfaces.RealOutput QActCoo_flow(
    final quantity="HeatFlowRate",
    final unit="W") if have_watCoo or have_eleCoo
    "Cooling heat flow rate transferred to the load (<=0)"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),iconTransformation(extent={{120,50},{140,70}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final quantity="Power",
    final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),iconTransformation(extent={{120,30},{140,50}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    final quantity="Power",
    final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),iconTransformation(extent={{120,10},{140,30}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W") if have_fan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),iconTransformation(extent={{120,-10},{140,10}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power",
    final unit="W") if have_pum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),iconTransformation(extent={{120,-30},{140,-10}})));
  Modelica.Blocks.Interfaces.RealOutput mReqHeaWat_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") if have_watHea
    "Required heating water flow rate to meet heating set point"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),iconTransformation(extent={{120,-50},{140,-30}})));
  Modelica.Blocks.Interfaces.RealOutput mReqChiWat_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") if have_watCoo
    "Required chilled water flow rate to meet cooling set point"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),iconTransformation(extent={{120,-70},{140,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aLoa(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(
      min=
        if allowFlowReversalLoa then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium2.h_default,
      nominal=Medium2.h_default)) if have_fluPor
    "Fluid stream inlet port on the load side"
    annotation (Placement(transformation(extent={{190,-10},{210,10}}),iconTransformation(extent={{110,90},{130,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bLoa(
    redeclare final package Medium=Medium2,
    p(start=Medium2.p_default),
    m_flow(
      max=
        if allowFlowReversalLoa then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium2.h_default,
      nominal=Medium2.h_default)) if have_fluPor
    "Fluid stream outlet port on the load side"
    annotation (Placement(transformation(extent={{-190,-10},{-210,10}}),iconTransformation(extent={{-110,90},{-130,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorCon if have_heaPor
    "Heat port transferring convective heat to the load"
    annotation (Placement(transformation(extent={{190,30},{210,50}}),iconTransformation(extent={{-50,-10},{-30,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorRad if have_heaPor
    "Heat port transferring radiative heat to the load"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}}),iconTransformation(extent={{30,-10},{50,10}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-16,224},{18,256}}),iconTransformation(extent={{-18,104},{16,136}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1.h_default,
      nominal=Medium1.h_default)) if have_watHea
    "Heating water inlet port"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}}),iconTransformation(extent={{-130,-110},{-110,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1.h_default,
      nominal=Medium1.h_default)) if have_watCoo
    "Chilled water inlet port"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}}),iconTransformation(extent={{-130,-90},{-110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1.h_default,
      nominal=Medium1.h_default)) if have_watHea
    "Heating water outlet port"
    annotation (Placement(transformation(extent={{210,-230},{190,-210}}),iconTransformation(extent={{130,-110},{110,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    p(start=Medium1.p_default),
    redeclare final package Medium=Medium1,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium1.h_default,
      nominal=Medium1.h_default)) if have_watCoo
    "Chilled water outlet port"
    annotation (Placement(transformation(extent={{210,-190},{190,-170}}),iconTransformation(extent={{130,-90},{110,-70}})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqHea_flow(
    k=1/facSca) if have_QReq_flow and
                                     (have_watHea or have_chaOve or have_eleHea)
    "Scaling"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQReqCoo_flow(
    k=1/facSca) if have_QReq_flow and
                                     (have_watCoo or have_eleCoo)
    "Scaling"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActHea_flow(
    k=facSca) if have_watHea or have_chaOve or have_eleHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaQActCoo_flow(
    k=facSca) if have_watCoo or have_eleCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPHea(
    k=facSca) if have_eleHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPCoo(
    k=facSca) if have_eleCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPFan(
    k=facSca) if have_fan
    "Scaling"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaPPum(
    k=facSca) if have_pum
    "Scaling"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaMasFloReqHeaWat(
    k=facSca) if have_watHea
    "Scaling"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain scaMasFloReqChiWat(
    k=facSca) if have_watCoo
    "Scaling"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaHeaWatFloInl(
    redeclare final package Medium=Medium1,
    final k=1/facSca,
    final allowFlowReversal=allowFlowReversal) if have_watHea
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaHeaWatFloOut(
    redeclare final package Medium=Medium1,
    final k=facSca,
    final allowFlowReversal=allowFlowReversal) if have_watHea
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaChiWatFloInl(
    redeclare final package Medium=Medium1,
    final k=1/facSca,
    final allowFlowReversal=allowFlowReversal) if have_watCoo
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaChiWatFloOut(
    redeclare final package Medium=Medium1,
    final k=facSca,
    final allowFlowReversal=allowFlowReversal) if have_watCoo
    "Mass flow rate scaling"
    annotation (Placement(transformation(extent={{160,-190},{180,-170}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaLoaMasFloOut(
    redeclare final package Medium=Medium2,
    final k=
      if have_scaLoa then
        facSca
      else
        1,
    final allowFlowReversal=allowFlowReversalLoa) if have_fluPor
    "Load side mass flow rate scaling"
    annotation (Placement(transformation(extent={{-160,-10},{-180,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier scaLoaMasFloInl(
    redeclare final package Medium=Medium2,
    final k=
      if have_scaLoa then
        1/facSca
      else
        1,
    final allowFlowReversal=allowFlowReversalLoa) if have_fluPor
    "Load side mass flow rate scaling"
    annotation (Placement(transformation(extent={{180,-10},{160,10}})));
  Fluid.HeatExchangers.RadiantSlabs.BaseClasses.HeatFlowRateMultiplier scaHeaFloCon(
    k=if have_scaLoa then
        facSca
      else
        1) if have_heaPor
    "Convective heat flow rate scaling"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Fluid.HeatExchangers.RadiantSlabs.BaseClasses.HeatFlowRateMultiplier scaHeaFloRad(
    k=if have_scaLoa then
        facSca
      else
        1) if have_heaPor
    "Radiative heat flow rate scaling"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cpHeaWat_nominal=Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(
      Medium1.p_default,
      T_aHeaWat_nominal))
    "Heating water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cpChiWat_nominal=Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(
      Medium1.p_default,
      T_aChiWat_nominal))
    "Chilled water specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cpLoaHea_nominal=Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(
      Medium2.p_default,
      T_aLoaHea_nominal))
    "Load side fluid specific heat capacity at nominal conditions in heating mode";
  parameter Modelica.SIunits.SpecificHeatCapacity cpLoaCoo_nominal=Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(
      Medium2.p_default,
      T_aLoaCoo_nominal))
    "Load side fluid specific heat capacity at nominal conditions in cooling mode";
equation
  connect(QReqHea_flow,scaQReqHea_flow.u)
    annotation (Line(points={{-220,100},{-182,100}},color={0,0,127}));
  connect(QReqCoo_flow,scaQReqCoo_flow.u)
    annotation (Line(points={{-220,60},{-182,60}},color={0,0,127}));
  connect(scaQActHea_flow.y,QActHea_flow)
    annotation (Line(points={{182,220},{220,220}},color={0,0,127}));
  connect(scaQActCoo_flow.y,QActCoo_flow)
    annotation (Line(points={{182,200},{192,200},{192,200},{220,200}},color={0,0,127}));
  connect(scaPHea.y,PHea)
    annotation (Line(points={{182,180},{220,180}},color={0,0,127}));
  connect(scaPCoo.y,PCoo)
    annotation (Line(points={{182,160},{220,160}},color={0,0,127}));
  connect(scaPFan.y,PFan)
    annotation (Line(points={{182,140},{220,140}},color={0,0,127}));
  connect(scaPPum.y,PPum)
    annotation (Line(points={{182,120},{220,120}},color={0,0,127}));
  connect(scaMasFloReqHeaWat.y,mReqHeaWat_flow)
    annotation (Line(points={{182,100},{220,100}},color={0,0,127}));
  connect(scaMasFloReqChiWat.y,mReqChiWat_flow)
    annotation (Line(points={{182,80},{220,80}},color={0,0,127}));
  connect(port_aHeaWat,scaHeaWatFloInl.port_a)
    annotation (Line(points={{-200,-220},{-180,-220}},color={0,127,255}));
  connect(scaHeaWatFloOut.port_b,port_bHeaWat)
    annotation (Line(points={{180,-220},{200,-220}},color={0,127,255}));
  connect(port_aChiWat,scaChiWatFloInl.port_a)
    annotation (Line(points={{-200,-180},{-180,-180}},color={0,127,255}));
  connect(scaChiWatFloOut.port_b,port_bChiWat)
    annotation (Line(points={{180,-180},{192,-180},{192,-180},{200,-180}},color={0,127,255}));
  connect(scaLoaMasFloOut.port_b,port_bLoa)
    annotation (Line(points={{-180,0},{-200,0}},color={0,127,255}));
  connect(port_aLoa,scaLoaMasFloInl.port_a)
    annotation (Line(points={{200,0},{180,0}},color={0,127,255}));
  connect(scaHeaFloCon.port_b,heaPorCon)
    annotation (Line(points={{180,40},{200,40}},color={191,0,0}));
  connect(scaHeaFloRad.port_b,heaPorRad)
    annotation (Line(points={{180,-40},{200,-40}},color={191,0,0}));
  annotation (
    defaultComponentName="ter",
    Documentation(
      info="<html>
<p>
Partial model to be used for modeling an HVAC terminal unit.
</p>
<p>
The models inheriting from this class are typically used in conjunction with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>. They must
compute a so-called required mass flow rate defined as the heating or chilled
water mass flow rate needed to meet the load.
It can be approximated using a control loop to avoid inverting a heat
exchanger model as illustrated in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Examples\">
Buildings.Experimental.DHC.Loads.Examples</a>.
</p>
<p>
The model connectivity can be modified to address various use cases:
</p>
<ul>
<li>
On the source side (typically connected to
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>):
<ul>
<li>
Fluid ports for chilled water and heating water can be conditionally
instantiated by respectively setting <code>have_watCoo</code> and
<code>have_watHea</code> to true.
</li>
</ul>
<li>
On the load side (typically connected to a room model):
<ul>
<li>
Fluid ports can be conditionally instantiated by setting
<code>have_fluPor</code> to true.
</li>
<li>
Alternatively heat ports (for convective and radiative heat transfer)
can be conditionally instantiated by setting <code>have_heaPor</code> to true.
</li>
<li>
Real input connectors can be conditionally instantiated by setting
<code>have_QReq_flow</code> to true. Those connectors can be used to provide
heating and cooling loads as time series, see
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Examples.CouplingTimeSeries\">
Buildings.Experimental.DHC.Loads.Examples.CouplingTimeSeries</a>
for an illustration of that use case.
The impact on the room air temperature of an unmet load can be assessed with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.SimpleRoomODE\">
Buildings.Experimental.DHC.Loads.SimpleRoomODE</a>.
</li>
</ul>
</ul>
<p>
The heating or cooling nominal capacity is provided for the water based heat
exchangers only. Electric heating or cooling equipment is supposed to have
an infinite capacity.
</p>
<h4>Connection with the flow distribution model</h4>
<p>
When connecting the model to
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>:
</p>
<ul>
<li>
The nominal pressure drop on the source side (heating or chilled water) is
irrelevant as the computation of the pump head relies on a specific algorithm
described in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>.
</li>
<li>
The parameter <code>allowFlowReversal</code> must be set to <code>false</code> (default)
in consistency with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>.
This requirement only applies to the source side.
On the load side one is free to use whatever option suitable for the modeling needs.
Note that typically for an air flow network connected to the outdoor
(either at the room level for modeling infiltration or at the system level
for the fresh air source), the unidirectional air flow condition cannot be guaranted.
The reason is the varying pressure of the outdoor air that can lead to a negative
pressure difference at the terminal unit boundaries when the fan is off.
</li>
</ul>
<h4>Scaling factor</h4>
<p>
Scaling is implemented by means of a scaling factor <code>facSca</code> being
applied on each extensive quantity (mass and heat flow rate, electric power),
except the heat or mass flow rate on the load side depending on
the value of <code>have_scaLoa</code>.
</p>
<ul>
<li>
If <code>have_scaLoa</code> is <code>true</code> (default), then the heat or mass flow rate
on the load side is scaled. This allows modeling, with a single instance,
multiple identical units serving an aggregated load, for instance,
a thermal zone representing several rooms.
</li>
<li>
If <code>have_scaLoa</code> is <code>false</code>, then the heat or mass flow rate
on the load side is not scaled. This allows modeling, with a single instance,
multiple identical units serving multiple identical rooms, for instance,
with only one zone model representing a single room.
</li>
</ul>
<p>
The scaling factor type is real (not integer) to allow idealized modeling of
a set of terminal units based on manufacturer data, while still being able to
size the full set based on a peak load.
See
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Validation.TerminalUnitScaling\">
Buildings.Experimental.DHC.Loads.Validation.TerminalUnitScaling</a>
for an illustration of the use case when heating and cooling loads are
provided by means of time series.
</p>
<h4>Change-over mode</h4>
<p>
When modeling a change-over system:
</p>
<ul>
<li>
The parameters <code>have_watCoo</code> and <code>have_chaOve</code> must both be set to
<code>true</code> and <code>have_watHea</code> must be set to <code>false</code>.
</li>
<li>
The heat exchanger is sized by providing the nominal parameters for the cooling
configuration (suffix <code>ChiWat</code>). The nominal mass flow rate on the
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
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}}),
      graphics={
        Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-130},{150,-170}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-120,-1.46958e-14},{-80,-9.79717e-15},{-40,60},{40,-60},{80,9.79717e-15},{120,1.46958e-14}},
          color={255,255,255},
          thickness=1,
          origin={0,0},
          rotation=180),
        Line(
          points={{-118,-118},{120,120}},
          color={255,255,255},
          thickness=1),
        Polygon(
          points={{46,62},{70,70},{62,46},{46,62}},
          lineColor={255,255,255},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        extent={{-200,-240},{200,240}})));
end PartialTerminalUnit;
