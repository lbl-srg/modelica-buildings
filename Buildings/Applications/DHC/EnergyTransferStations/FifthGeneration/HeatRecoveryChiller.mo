within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration;
model HeatRecoveryChiller
  "Energy transfer station model for fifth generation DHC systems with heat recovery chiller"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    redeclare replaceable package MediumBui = Buildings.Media.Water,
    redeclare replaceable package MediumDis = Buildings.Media.Water,
    final allowFlowReversalBui=false,
    final allowFlowReversalDis=false,
    have_heaWat=true,
    have_chiWat=true,
    have_hotWat=false,
    have_eleHea=false,
    have_eleCoo=true,
    have_fan=false,
    have_weaBus=false,
    have_pum=true);

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
      annotation (Placement(transformation(extent={{-260,-280},{-240,-260}})));
    final parameter Fluid.Geothermal.Borefields.Data.Filling.Bentonite filDat(kFil=2.1)
      annotation (Placement(transformation(extent={{-260,-184},{-240,-164}})));
    final parameter Fluid.Geothermal.Borefields.Data.Soil.SandStone soiDat(
      kSoi=2.42,
      dSoi=1920,
      cSoi=1210)
      "Soil data"
      annotation (Placement(transformation(extent={{-260,-208},{-240,-188}})));
    final parameter Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template conDat(
      final borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
      final use_Rb=false,
      final mBor_flow_nominal=mBor_flow_nominal,
      final mBorFie_flow_nominal=mGeo_flow_nominal,
      final hBor=244,
      final dBor=1,
      final rBor=0.2,
      final rTub=rTub,
      final kTub=0.5,
      final eTub=0.002,
      final cooBor={{dBorHol*mod((i - 1), nXBorHol),dBorHol*floor((i - 1)/
                     nXBorHol)} for i in 1:nBorHol},
      final xC=0.075,
      final dp_nominal=dpBorFie_nominal)
    "Borefield configuration"
      annotation (Placement(transformation(extent={{-260,-232},{-240,-212}})));
    final parameter Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat(
       final filDat=filDat,
       final soiDat=soiDat,
       final conDat=conDat)
      "Borefield parameters"
      annotation (Placement(transformation(extent={{-260,-256},{-240,-236}})));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCooMin(
    final unit="K",displayUnit="degC")
    "Minimum cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-340,20},{-300,60}}),
    iconTransformation(extent={{-380,-20},{-300,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxBorEnt(
    final unit="K",displayUnit="degC")
    "Maximum allowed enetring water temperature to the borefiled holes"
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
      iconTransformation(extent={{-380,-198},{-300,-118}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMinConEnt(
    final unit="K",displayUnit="degC")
    "Minimum condenser entering water temperature"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-380,-80},{-300,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMaxEvaEnt(
    final unit="K",displayUnit="degC")
    "Maximum evaporator entering water temperature"
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
    iconTransformation(extent={{-380,-140},{-300,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(
    final unit="K",displayUnit="degC")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-340,140},{-300,180}}),
      iconTransformation(extent={{-380,100},{-300,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo( final unit="K",displayUnit="degC")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-338,80},{-298,120}}),
    iconTransformation(extent={{-380,100},{-300,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput modRej
    "Surplus heat or cold rejection mode" annotation (Placement(transformation(
          extent={{300,-100},{320,-80}}), iconTransformation(extent={{300,-200},
            {380,-120}})));
  // COMPONENTS
  //// TANKS
  FifthGeneration.BaseClasses.StratifiedTank tanHeaWat(
    redeclare final package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    nSeg=nSegTan,
    show_T=show_T,
    energyDynamics=fixedEnergyDynamics,
    m_flow_nominal=mCon_flow_nominal,
    T_start=293.15,
    TFlu_start=(20 + 273.15)*ones(nSegTan),
    tau(displayUnit="s")) "Heating water buffer tank"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  FifthGeneration.BaseClasses.StratifiedTank tanChiWat(
    redeclare final package Medium = Medium,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    nSeg=nSegTan,
    show_T=show_T,
    m_flow_nominal=mEva_flow_nominal,
    energyDynamics=fixedEnergyDynamics,
    T_start=288.15,
    TFlu_start=(15 + 273.15)*ones(nSegTan),
    tau(displayUnit="s")) "Chilled water buffer tank"
    annotation (Placement(transformation(extent={{-236,50},{-216,70}})));
  //// BOREFIELD
  //// DISTRICT HX
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    use_Q_flow_nominal = false,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=false,
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=dpHex_nominal,
    eps_nominal=eps_nominal,
    dp2_nominal=dpHex_nominal,
    m1_flow_nominal=mHex_flow_nominal,
    m2_flow_nominal=mHex_flow_nominal)
    "Heat exchanger"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={192,-234})));
  Fluid.Movers.FlowControlled_m_flow pumHexDis(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHex_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpHex_nominal,0}, V_flow={0,mHex_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10)
    "Pump (or valve) that forces the flow rate to be set to the control signal"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=270,
      origin={110,-110})));
  //// CONTROLLERS
  FifthGeneration.Controls.Supervisory ETSCon(THys=THys)
    "ETS supervisory controller"
    annotation (Placement(transformation(extent={{-198,200},{-178,220}})));
  FifthGeneration.Controls.AmbientCircuit ambCon(dTGeo=dTGeo, dTHex=dTHex)
    "Control of the ambient circuit"
    annotation (Placement(transformation(extent={{-248,-132},{-228,-112}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMDisHex(k=mHex_flow_nominal)
    "Gain for mass flow of heat exchanger"
    annotation (Placement(transformation(extent={{40,-262},{60,-242}})));
  //// SENSORS
  Fluid.Sensors.TemperatureTwoPort senTDisHX2Ent(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    tau=10,
    m_flow_nominal=mHex_flow_nominal)
    "District heat exchanger secondary water entering temperature (sensed)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={110,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopChiWat
    "Chilled water tank top temperature"
    annotation (Placement(transformation(extent={{-230,90},{-250,110}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotChiWat
    "Chilled water tank bottom temperature"
    annotation (Placement(transformation(extent={{-230,10},{-250,30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTopHeaWat
    "Heating water tank top temperature (sensed)"
    annotation (Placement(transformation(extent={{208,90},{188,110}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBotHeaWat
    "Heating water tank bottom temperature (sensed)"
    annotation (Placement(transformation(extent={{176,-42},{196,-22}})));
//------hydraulic header------------------------------------------------------------
 //-----------------------------Valves----------------------------------------------
  BaseClasses.SubsystemChiller chi "Subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
equation
  connect(senTTopHeaWat.T, ETSCon.TTanHeaTop) annotation (Line(
      points={{188,100},{84,100},{84,246},{-204,246},{-204,219},{-199,219}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(senTTopChiWat.T, ETSCon.TTanCooTop) annotation (Line(
      points={{-250,100},{-266,100},{-266,201},{-199,201}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(senTBotChiWat.T, ETSCon.TTanCooBot) annotation (Line(
      points={{-250,20},{-274,20},{-274,203},{-199,203}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(hex.port_a1, pumHexDis.port_b)
    annotation (Line(points={{186,-224},{186,-154},{110,-154},{110,-120}},
                                                               color={0,127,
          255}, thickness=0.5));
  connect(pumHexDis.port_a, senTDisHX2Ent.port_b) annotation (Line(
      points={{110,-100},{110,-80}},
      color={0,127,255},
      thickness=0.5));
  connect(TMaxBorEnt, ambCon.TBorMaxEnt) annotation (Line(
      points={{-320,-80},{-172,-80},{-172,-127},{-249,-127}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(ambCon.TDisHexEnt, senTDisHX2Ent.T) annotation (Line(
      points={{-249,-128},{-162,-128},{-162,-288},{90,-288},{90,-70},{99,-70}},
      color={0,0,127},
      pattern=LinePattern.Dot));

  connect(gaiMDisHex.y, pumHexDis.m_flow_in) annotation (Line(
      points={{62,-252},{80,-252},{80,-110},{98,-110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ETSCon.reqCoo, ambCon.reqCoo) annotation (Line(
      points={{-177,201},{-166,201},{-166,-118},{-249,-118}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.reqHea, ETSCon.reqHea) annotation (Line(
      points={{-249,-113},{-156,-113},{-156,219},{-177,219}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valHea, ambCon.valHea) annotation (Line(
      points={{-177,217},{-158,217},{-158,-114},{-249,-114}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.valCoo, ambCon.valCoo) annotation (Line(
      points={{-177,215},{-160,215},{-160,-115},{-249,-115}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.rejCooFulLoa,ETSCon. rejColFulLoa) annotation (Line(
      points={{-249,-117},{-164,-117},{-164,202.8},{-177,202.8}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ETSCon.rejHeaFulLoa, ambCon.rejHeaFulLoa) annotation (Line(
      points={{-177,204.8},{-162,204.8},{-162,-116},{-249,-116}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(ambCon.modRej, modRej) annotation (Line(points={{-227,-122},{60,-122},
          {60,-90},{310,-90}}, color={255,127,0}));
  connect(ambCon.yDisHexPum, gaiMDisHex.u) annotation (Line(points={{-227,-130},
          {-120,-130},{-120,-252},{38,-252}},  color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={
       Text(
          extent={{-150,146},{150,106}},
          textString="%name",
          lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash),
        Text(
          extent={{206,-190},{292,-236}},
          lineColor={255,0,255},
          textString="correct side 1 and 2"),
        Text(
          extent={{204,-122},{290,-168}},
          lineColor={255,0,255},
          textString="have_val
have_pum")}),
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
end HeatRecoveryChiller;
