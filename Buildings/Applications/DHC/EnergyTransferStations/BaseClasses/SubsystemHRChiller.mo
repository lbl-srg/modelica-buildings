within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model SubsystemHRChiller "Central subsystem based on heat recovery chiller"
    package Medium = Buildings.Media.Water "Medium model";

    final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
        max(mSecHea_flow_nominal,mSecCoo_flow_nominal)
    "Nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecHea_flow_nominal
      "Secondary(building side) heatng circuit nominal water flow rate";
    parameter Modelica.SIunits.MassFlowRate mSecCoo_flow_nominal
      "Secondary(building side) cooling circuit nominal water flow rate";
    parameter Modelica.SIunits.TemperatureDifference dTChi=2
      "Temperature difference between entering and leaving water of EIR chiller(+ve)";
    parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
      "Formulation of energy balance for mixing volume at inlet and outlet"
      annotation (Dialog(group="Dynamics"));
    parameter Boolean show_T=true
      "= true, if actual temperature at port is computed"
      annotation (Dialog(tab="Advanced"));

    final parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa")=1000
      "Pressure difference at nominal flow rate"
        annotation (Dialog(group="Design Parameter"));

  //----------------------water to water chiller or heat pump system-----------------
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=datChi.mEva_flow_nominal
     "Condenser nominal water flow rate" annotation (Dialog(group="EIR CHILLER system"));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=datChi.mEva_flow_nominal
     "Evaporator nominal water flow rate" annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpCon_nominal
      "Pressure difference accross the condenser"
        annotation (Dialog(group="EIR Chiller system"));
    parameter Modelica.SIunits.PressureDifference dpEva_nominal
      "Pressure difference accross the evaporator"
        annotation (Dialog(group="EIR Chiller system"));
//---------------------------------Buffer tanks-------------------
    final parameter Modelica.SIunits.Volume VTan = 5*60*mCon_flow_nominal/1000
      "Tank volume, ensure at least 5 minutes buffer flow"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length hTan = 5
      "Height of tank (without insulation)"
      annotation (Dialog(group="Water Buffer Tank"));
    final parameter Modelica.SIunits.Length dIns = 0.3
      "Thickness of insulation"
        annotation (Dialog(group="Water Buffer Tank"));
    final parameter Integer nSegTan=10   "Number of volume segments"
        annotation (Dialog(group="Water Buffer Tank"));
    parameter Modelica.SIunits.TemperatureDifference THys
      "Temperature hysteresis"
        annotation (Dialog(group="Water Buffer Tank"));
 //----------------------------Borefield system----------------------------------
    parameter Modelica.SIunits.TemperatureDifference dTGeo
      "Temperature difference between entering and leaving water of the borefield (+ve)"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mGeo_flow_nominal= m_flow_nominal*dTChi/dTGeo
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal= mGeo_flow_nominal/(nXBorHol*nYBorHol)
      "Borefiled nominal water flow rate"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length xBorFie
      "Borefield length"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Length yBorFie
      "Borefield width"
        annotation (Dialog(group="Borefield"));
    final parameter Modelica.SIunits.Length dBorHol = 5
      "Distance between two boreholes"
        annotation (Dialog(group="Borefield"));
    parameter Modelica.SIunits.Pressure dpBorFie_nominal
      "Pressure losses for the entire borefield"
        annotation (Dialog(group="Borefield"));
    final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
      "Number of boreholes in x-direction"
        annotation(Dialog(group="Borefield"));
    final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
      "Number of boreholes in y-direction"
        annotation(Dialog(group="Borefield"));
    final parameter  Integer nBorHol = nXBorHol*nYBorHol
     "Number of boreholes"
        annotation(Dialog(group="Borefield"));
    parameter Modelica.SIunits.Radius rTub =  0.05
     "Outer radius of the tubes"
        annotation(Dialog(group="Borefield"));
    parameter Boolean allowFlowReversal = false
      "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

//---------------------------DistrictHeatExchanger----------
    final parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal= m_flow_nominal*dTChi/dTHex
      "District heat exhanger nominal water flow rate"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Real eps_nominal=0.71
      "Heat exchanger effectiveness"
      annotation (Dialog(group="DistrictHeatExchanger"));
   final parameter  Modelica.SIunits.PressureDifference dpHex_nominal(displayUnit="Pa")=50000
      "Pressure difference across heat exchanger"
      annotation (Dialog(group="DistrictHeatExchanger"));
    parameter Modelica.SIunits.TemperatureDifference dTHex
      "Temperature difference between entering and leaving water of the district heat exchanger(+ve)"
      annotation (Dialog(group="DistrictHeatExchanger"));
 //----------------------------Performance data records-----------------------------
    parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "EIR chiller performance data."
      annotation (Placement(transformation(extent={{-292,-280},{-272,-260}})));
  // IO CONNECTORS
  // COMPONENTS
  Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    show_T=true,
    from_dp1=true,
    dp1_nominal=dpCon_nominal,
    linearizeFlowResistance1=true,
    from_dp2=true,
    dp2_nominal=dpEva_nominal,
    linearizeFlowResistance2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datChi,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium)
    "Water cooled EIR chiller."
      annotation (Placement(transformation(extent={{-10,230},{10,250}})));
  Buildings.Fluid.Movers.SpeedControlled_y pumCon(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpCon_nominal,0}, V_flow={0,mCon_flow_nominal/1000})),
    allowFlowReversal=false)
    "Condenser variable speed pump-primary circuit"
      annotation (Placement(transformation(extent={{60,230},{80,250}})));
   Buildings.Fluid.Movers.SpeedControlled_y pumEva(
    redeclare final package Medium = Medium,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpEva_nominal,0}, V_flow={0,mEva_flow_nominal/1000})),
    allowFlowReversal=false)
    "Evaporator variable speed pump-primary circuit"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-84,272})));
  //// TANKS
  //// BOREFIELD
  //// DISTRICT HX
  //// CONTROLLERS
  Controls.HRChiller conChi "Chiller controller"
    annotation (Placement(transformation(extent={{-240,188},{-220,208}})));
  Controls.PrimaryPumpsConstantSpeed conPumPri "Primary pumps controller"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  //// SENSORS
  Buildings.Fluid.Sensors.TemperatureTwoPort TConLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    "Condenser leaving water temperature"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TConEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{174,10},{154,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0)
    "Evaporator entering water temperature"
    annotation (Placement(
    transformation(
    extent={{10,10},{-10,-10}},
    rotation=180,
    origin={-30,270})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TEvaLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=30)
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-90,-50}})));
  Fluid.Sensors.TemperatureTwoPort TValEnt(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mEva_flow_nominal,
    tau=0) "Evaporator entering water temperature"
     annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-106,60})));
  Fluid.Sensors.TemperatureTwoPort senTAmbLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal,
    tau=30) "Ambient circuit leaving water temperature (sensed)"
    annotation (Placement(transformation(extent={{-112,-170},{-132,-150}})));
//------hydraulic header------------------------------------------------------------
  BaseClasses.HydraulicHeader hdrSupHed(
    redeclare final package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_b=1,
    nPorts_a=1) "Heating water circuit supply header"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
  BaseClasses.HydraulicHeader hdrHeaRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    nPorts_b=2) "Heating water circuit return header"
    annotation (Placement(transformation(extent={{220,-50},{200,-70}})));
  BaseClasses.HydraulicHeader hdrChiRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    allowFlowReversal=true,
    nPorts_a=1,
    nPorts_b=1) "Chilled water circuit return header"
    annotation (Placement(transformation(extent={{-240,70},{-220,50}})));
  BaseClasses.HydraulicHeader hdrChiSup(
    redeclare final package Medium = Medium,
    m_flow_nominal=mEva_flow_nominal,
    nPorts_a=1,
    nPorts_b=1) "Chilled water circuit supply header"
    annotation (Placement(transformation(extent={{-218,-70},{-238,-50}})));
  BaseClasses.HydraulicHeader hdrAmbRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
    nPorts_a=2) "Ambient water circuit return header"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  BaseClasses.HydraulicHeader hdrAmbSup(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal + mGeo_flow_nominal,
    nPorts_b=2) "Ambient water circuit supply header"
    annotation (Placement(transformation(extent={{-10,-130},{10,-152}})));
  Fluid.FixedResistances.Junction splEva(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mEva_flow_nominal,-mEva_flow_nominal,-mEva_flow_nominal},
    redeclare final package Medium = Medium)
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,78})));
  Fluid.FixedResistances.Junction splCon(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dp_nominal=200*{1,-1,-1},
    from_dp=false,
    tau=1,
    m_flow_nominal={mCon_flow_nominal,-mCon_flow_nominal,-mCon_flow_nominal},
    redeclare final package Medium = Medium)
    "Flow splitter for the condenser water circuit"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={42,132})));
 //-----------------------------Valves----------------------------------------------
  Fluid.Actuators.Valves.TwoWayLinear valSupHea(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Fluid.Actuators.Valves.TwoWayLinear valSupCoo(
    redeclare final package Medium = Medium,
    use_inputFilter=false,
    dpFixed_nominal=0,
    show_T=true,
    dpValve_nominal=dp_nominal,
    riseTime=10,
    l=1e-8,
    m_flow_nominal=mGeo_flow_nominal + mHex_flow_nominal)
    "Two way modulating valve"
      annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mEva_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the evaporator"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
                                        rotation=270,
                                        origin={-156,116})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mCon_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three way valve modulated to control the entering water temperature to the condenser"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,30})));
equation
  connect(TEvaLvg.port_b, hdrChiSup.ports_a[1]) annotation (Line(
      points={{-90,-60},{-218,-60}},
      color={0,127,255},
      thickness=0.5));
  connect(hdrChiSup.ports_b[1], valSupCoo.port_a) annotation (Line(
      points={{-238,-60},{-260,-60},{-260,0},{-100,0}},
      color={0,127,255},
      thickness=0.5));
  connect(splEva.port_3, valEva.port_3)
    annotation (Line(points={{-70,78},{-102,78},{-102,116},{-146,116}},
                                                 color={0,127,255}));
  connect(chi.port_b2, splEva.port_1) annotation (Line(
      points={{-10,234},{-60,234},{-60,88}},
      color={0,127,255},
      thickness=0.5));
  connect(splEva.port_2, TEvaLvg.port_a) annotation (Line(
      points={{-60,68},{-60,-60},{-70,-60}},
      color={0,127,255},
      thickness=0.5));
  connect(hdrSupHed.ports_b[1], valSupHea.port_a)
    annotation (Line(points={{220,60},{240,60},{240,0},{100,0}},           color={0,127,
          255},
      thickness=0.5));
  connect(TConEnt.port_b, valCon.port_1)
    annotation (Line(points={{154,20},{-40,20}},          color={0,127,255},thickness=0.5));
  connect(chi.port_a1, valCon.port_2) annotation (Line(
      points={{-10,246},{-10,40},{-40,40}},
      color={0,127,255},
      thickness=0.5));
  connect(TConLvg.port_a, splCon.port_2)
    annotation (Line(points={{100,140},{58,140},{58,132},{52,132}},
                                                 color={0,127,255}));
  connect(TConLvg.port_b,hdrSupHed. ports_a[1])
    annotation (Line(points={{120,140},{180,140},{180,60},{200,60}},
                                                                color={238,46,47},
      thickness=0.5));
  connect(valCon.port_3, splCon.port_3) annotation (Line(
      points={{-30,30},{42,30},{42,122}},
      color={0,127,255},
      thickness=0.5));
  connect(valSupCoo.port_b, hdrAmbRet.ports_a[1]) annotation (Line(
      points={{-80,0},{20,0},{20,-98},{10,-98}},
      color={0,127,255},
      thickness=0.5));
  connect(hdrAmbRet.ports_a[2], valSupHea.port_b) annotation (Line(
      points={{10,-102},{10,-100},{40,-100},{40,0},{80,0}},
      color={0,127,255},
      thickness=0.5));
  connect(TConEnt.T,conChi. TConEnt) annotation (Line(
      points={{164,31},{164,180},{-260,180},{-260,189.2},{-241,189.2}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TEvaEnt.T,conChi. TEvaEnt) annotation (Line(
      points={{-30,281},{-30,116},{-62,116},{-62,192},{-126,192},{-126,193},{
          -241,193}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(conPumPri.yPumCon, pumCon.y) annotation (Line(
      points={{-218,156},{-196,156},{-196,252},{70,252}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(conPumPri.yPumEva, pumEva.y) annotation (Line(
      points={{-218,144},{-148,144},{-148,284},{-84,284}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TConLvg.T,conChi. TConLvg) annotation (Line(
      points={{110,151},{110,194},{-124,194},{-124,191},{-241,191}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(conChi.yChiMod, chi.on) annotation (Line(points={{-219,198},{-188,198},
          {-188,242},{-12,242},{-12,243}},color={255,0,255}));
  connect(conChi.TSetChi, chi.TSet) annotation (Line(points={{-219,204},{-42,
          204},{-42,237},{-12,237}},   color={0,0,127}));
  connect(TConEnt.port_a, hdrHeaRet.ports_b[1]) annotation (Line(points={{174,
          20},{180,20},{180,-58},{200,-58}}, color={0,127,255}));
  connect(conChi.yValEva, valEva.y) annotation (Line(points={{-219,190},{-96,
          190},{-96,130},{-114,130},{-114,116},{-168,116}}, color={0,0,127}));
  connect(conChi.yValCon, valCon.y) annotation (Line(points={{-219,194},{-184,
          194},{-184,30},{-52,30}},
                              color={0,0,127}));
  connect(hdrChiRet.ports_b[1], TValEnt.port_a)
    annotation (Line(points={{-220,60},{-116,60}}, color={0,127,255}));
  connect(valEva.port_1, TValEnt.port_b) annotation (Line(points={{-156,106},{
          -156,64},{-96,64},{-96,60}},
                                  color={0,127,255}));
  connect(hdrHeaRet.ports_b[2], hdrAmbSup.ports_b[1]) annotation (Line(points={
          {200,-62},{66,-62},{66,-140},{10,-140},{10,-138.8}}, color={0,127,255}));
  connect(hdrAmbSup.ports_b[2], senTAmbLvg.port_a) annotation (Line(points={{10,
          -143.2},{10,-144},{20,-144},{20,-160},{-112,-160}}, color={0,127,255}));
  connect(senTAmbLvg.port_b, hdrChiRet.ports_a[1]) annotation (Line(points={{
          -132,-160},{-280,-160},{-280,60},{-240,60}}, color={0,127,255}));
  connect(pumEva.port_b, TEvaEnt.port_a) annotation (Line(points={{-74,272},{
          -58,272},{-58,270},{-40,270}}, color={0,127,255}));
  connect(chi.port_a2, TEvaEnt.port_b) annotation (Line(points={{10,234},{26,
          234},{26,232},{42,232},{42,270},{-20,270}}, color={0,127,255}));
  connect(chi.port_b1, pumCon.port_a) annotation (Line(points={{10,246},{42,246},
          {42,240},{60,240}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,60},{62,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ets",
Documentation(info="<html>
<p>
This models represents an energy transfer station (ETS) for fifth generation 
district heating and cooling systems. 
The control logic is based on five operating modes:
</p>
<ul>
<li>
heating only,
</li>
<li>
cooling only,
</li>
<li>
simultaneous heating and cooling,
</li>
<li>
part surplus heat or cold rejection,
</li>
<li>
full surplus heat or cold rejection.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image the 5th generation of district heating and cooling substation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/SubstationModifiedLayout.png\"/>
<p>
The substation layout consists in three water circuits:
</p>
<ol>
<li>
the heating water circuit, which is connected to the building heating water
distribution system,
</li>
<li>
the chilled water circuit, which is connected to the building chilled water
distribution system,
</li>
<li>
the ambient water circuit, which is connected to the district heat exchanger 
(and optionally to the geothermal borefield).
</li>
</ol>
<h4>Heating water circuit</h4>
<p>
It satisfies the building heating requirements and consists in:
</p>
<ol>
<li>
the heating/cooling generating source, where the EIR chiller i.e. condenser heat exchanger operates to satisfy the heating setpoint
<code>TSetHea</code>.
</li>
<li>
The constant speed condenser water pump <code>pumCon</code>.
</li>
<li>
The hot buffer tank, is implemented to provide hydraulic decoupling between the primary (the ETS side) and secondary (the building side)
water circulators i.e. pumps and to eliminate the cycling of the heat generating source machine i.e EIR chiller.
</li>
<li>
Modulating mixing three way valve <code>valCon</code> to control the condenser entering water temperature.
</li>
</ol>
<h4>Chilled water circuit</h4>
<p>
It operates to satisfy the building cooling requirements and consists of
</p>
<ol>
<li>
The heating/cooling generating source, where the  EIR chiller i.e evaporator heat
exchanger operates to satisfy the cooling setpoint <code>TSetCoo</code>.
</li>
<li>
The constant speed evaporator water pump <code>pumEva</code>.
</li>
<li>
The chilled water buffer tank, is implemented obviously for the same mentioned reasons of the hot buffer tank.
</li>
<li>
Modulating mixing three way valve <code>valEva</code> to control the evaporator entering water temperature.
</li>
</ol>
<p>
For more detailed description of
</p>
<p>
The controller of heating/cooling generating source, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ChillerController.</a>
</p>
<p>
The evaporator pump <code>pumEva</code> and the condenser pump <code>pumCon</code>, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed\">
Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed.</a>
</p>
<h4>Ambient water circuit</h4>
<p>
The ambient water circuit operates to maximize the system exergy by rejecting surplus i.e. heating or cooling energy
first to the borefield system and second to either or both of the borefield and the district systems.
It consists of
</p>
<ol>
<li>
The borefield component model <code>borFie</code>.
</li>
<li>
The borefield pump <code>pumBor</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Modulating mixing three way valve <code>valBor</code> to control the borefield entering water temperature.
</li>
<li>
The heat exchanger component model <code>hex</code>.
</li>
<li>
The heat exchanger district pump <code>pumHexDis</code>, where its mass flow rate is modulated using a reverse action PI controller.
</li>
<li>
Two on/off 2-way valves <code> valHea</code>, <code>valCoo</code>
which separates the ambient from the chilled water and heating water circuits.
</ol>
<p>
For more detailed description of the ambient circuit control concept see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.AmbientCircuitController.</a>
</p>
<h4>Notes</h4>
<p>
For more detailed description of the finite state machines which transitions the ETS between
different operational modes, see
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.HotSideController</a> and
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ColdSideController</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
January 18, 2020, by Hagar Elarga: <br/>
First implementation
</li>
</ul>
</html>"));
end SubsystemHRChiller;
