within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5;
model Chiller "ETS model for 5GDHC systems with heat recovery chiller"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_heaWat=true,
    final have_chiWat=true,
    final have_eleCoo=true,
    final have_fan=false,
    final have_pum=true,
    have_hotWat=false,
    have_eleHea=false,
    have_weaBus=false,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);

  parameter Boolean have_val1Hex=false
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Integer nAuxHea = 0
    "Number of auxiliary heating systems"
    annotation(Evaluate=true);
  parameter Integer nAuxCoo = 0
    "Number of auxiliary cooling systems"
    annotation(Evaluate=true);
  parameter Integer nSouAmb = 1
    "Number of ambient sources"
    annotation(Evaluate=true);
  final parameter Integer nConHeaWat = 2 + nAuxHea
    "Number of connections for heating water collector"
    annotation(Evaluate=true);
  final parameter Integer nConChiWat = 2 + nAuxCoo
    "Number of connections for chilled water collector"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop across heat exchanger on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.TemperatureDifference dT2HexSet[2]=
    abs(T_b2Hex_nominal - T_a2Hex_nominal) .* {1 + 1/datChi.COP_nominal, 1}
    "Secondary side deltaT set-point schedule (index 1 for heat rejection)"
    annotation (Dialog(group="District heat exchanger"));
  final parameter Modelica.SIunits.MassFlowRate m1Hex_flow_nominal=int.m1_flow_nominal
    "Nominal mass flow rate on district side"
    annotation (Dialog(group="District heat exchanger"));
  final parameter Modelica.SIunits.MassFlowRate m2Hex_flow_nominal=int.m2_flow_nominal
    "Nominal mass flow rate on building side"
    annotation (Dialog(group="District heat exchanger"));

  parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
    annotation (Dialog(tab="Dynamics"));

  parameter Modelica.SIunits.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Chiller"));
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Dialog(group="Chiller"),
      Placement(transformation(extent={{-10,222},{10,242}})));

  final parameter Modelica.SIunits.Volume VTanHeaWat=
    datChi.PLRMin * datChi.mCon_flow_nominal * 5 * 60 / 1000
    "Heating water tank volume (minimum cycling period of 5')"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Modelica.SIunits.Length hTanHeaWat=
    (VTanHeaWat * 16 / Modelica.Constants.pi)^(1/3)
    "Heating water tank height (assuming twice the diameter)"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Modelica.SIunits.Length dInsTanHeaWat = 0.1
    "Heating water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Modelica.SIunits.Volume VTanChiWat=
    datChi.PLRMin * datChi.mEva_flow_nominal * 5 * 60 / 1000
    "Chilled water tank volume (minimum cycling period of 5')"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Modelica.SIunits.Length hTanChiWat=
    (VTanChiWat * 16 / Modelica.Constants.pi)^(1/3)
    "Chilled water tank height (without insulation)"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Modelica.SIunits.Length dInsTanChiWat = 0.1
    "Chilled water tank insulation thickness"
    annotation (Dialog(group="Buffer Tank"));
  final parameter Integer nSegTan = 3
    "Number of volume segments for tanks"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.TemperatureDifference dTHys = 2
    "Temperature hysteresis for supervisory control"
    annotation (Dialog(group="Buffer Tank"));
  parameter Modelica.SIunits.TemperatureDifference dTDea = 0
    "Temperature dead band for supervisory control"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC") = datChi.TConEntMin + 5
    "Minimum value of heating water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(
    displayUnit="degC") = datChi.TEvaLvgMax
    "Maximum value of chilled water supply temperature set-point";

  parameter Modelica.SIunits.PressureDifference dpValIso_nominal(
    displayUnit="Pa") = 2E3
    "Nominal pressure drop of ambient circuit isolation valves"
    annotation (Dialog(group="Generic"));

  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"
    annotation (Placement(transformation(extent={{-340,80},{-300,120}}),
      iconTransformation(extent={{-380,40},{-300,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}}),
      iconTransformation(extent={{-380,-40},{-300, 40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),
      iconTransformation(extent={{-380,-120},{-300,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-380,-200},{-300,-120}})));

  // COMPONENTS
  Controls.Supervisory conSup(
    final nSouAmb=nSouAmb,
    final dTHys=dTHys,
    final dTDea=dTDea,
    final THeaWatSupSetMin=THeaWatSupSetMin,
    final TChiWatSupSetMax=TChiWatSupSetMax)
    "Supervisory controller"
    annotation (Placement(transformation(extent={{-260,12},{-240,32}})));

  Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    use_inputFilter=false)
    "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{70,-130},{50,-110}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=colAmbWat.mDis_flow_nominal,
    use_inputFilter=false)
    "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));

  Subsystems.Chiller chi(
    redeclare final package Medium = MediumBui,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi) "Base subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  Subsystems.HeatExchanger int(
    redeclare final package Medium1 = MediumDis,
    redeclare final package Medium2 = MediumBui,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui,
    final have_val1Hex=have_val1Hex,
    final dp1Hex_nominal=dp1Hex_nominal,
    final dp2Hex_nominal=dp2Hex_nominal,
    final QHex_flow_nominal=QHex_flow_nominal,
    final T_a1Hex_nominal=T_a1Hex_nominal,
    final T_b1Hex_nominal=T_b1Hex_nominal,
    final T_a2Hex_nominal=T_a2Hex_nominal,
    final T_b2Hex_nominal=T_b2Hex_nominal,
    final dT2HexSet=dT2HexSet)
    "Base subsystem for interconnection with district system"
    annotation (Placement(transformation(extent={{-10,-244},{10,-264}})));

  EnergyTransferStations.BaseClasses.StratifiedTank tanChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=colChiWat.mDis_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan) "Chilled water tank"
    annotation (Placement(transformation(extent={{200,96},{220,116}})));
  EnergyTransferStations.BaseClasses.StratifiedTank tanHeaWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=colHeaWat.mDis_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan) "Heating water tank"
    annotation (Placement(transformation(extent={{-220,96},{-200,116}})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colChiWat(
    redeclare final package Medium = MediumBui,
    final nCon=nConChiWat,
    mCon_flow_nominal={datChi.mEva_flow_nominal, colAmbWat.mDis_flow_nominal})
    "Collector/distributor for chilled water"
    annotation (Placement(
      transformation(
      extent={{-20,10},{20,-10}},
      rotation=180,
      origin={120,-34})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colHeaWat(
    redeclare final package Medium = MediumBui,
    final nCon=nConHeaWat,
    mCon_flow_nominal={datChi.mCon_flow_nominal, colAmbWat.mDis_flow_nominal})
    "Collector/distributor for heating water"
    annotation (Placement(
      transformation(
      extent={{20,10},{-20,-10}},
      rotation=180,
      origin={-120,-34})));
  EnergyTransferStations.BaseClasses.CollectorDistributor colAmbWat(
    redeclare final package Medium = MediumBui,
    final nCon=nSouAmb,
    mCon_flow_nominal={m2Hex_flow_nominal})
    "Collector/distributor for ambient water"
    annotation (Placement(
      transformation(
      extent={{20,-10},{-20,10}},
      rotation=180,
      origin={0,-106})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(nin=2)
    "Total pump power"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));

equation
  connect(int.PPum, totPPum.u[2]) annotation (Line(
      points={{12,-254},{36,-254},{36,-62},{258,-62},{258,-61}},
      color={0,0,127}));
  connect(chi.PPum, totPPum.u[1]) annotation (Line(
      points={{12,-9},{20,-9},{20,-59},{258,-59}},
      color={0,0,127}));
  connect(THeaWatSupSet, conSup.THeaWatSupPreSet) annotation (Line(points={{-320,
          -60},{-280,-60},{-280,26},{-262,26}}, color={0,0,127}));
  connect(port_aDis,int. port_a1) annotation (Line(points={{-300,-260},{-10,-260}},
                  color={0,127,255}));
  connect(int.port_b1, port_bDis) annotation (Line(points={{10,-260},{300,-260}},
                                                              color={0,127,255}));
  connect(conSup.yHea, chi.uHea) annotation (Line(points={{-238,31},{-20,31},{-20,
          -3},{-12,-3}},     color={255,0,255}));
  connect(conSup.yCoo, chi.uCoo) annotation (Line(points={{-238,28},{-24,28},{-24,
          -5},{-12,-5}},     color={255,0,255}));
  connect(ports_aHeaWat[1], tanHeaWat.port_aBot) annotation (Line(points={{-300,
          260},{-280,260},{-280,100},{-220,100}}, color={0,127,255}));
  connect(tanHeaWat.port_bTop, ports_bHeaWat[1]) annotation (Line(points={{-220,
          112},{-260,112},{-260,260},{300,260}}, color={0,127,255}));
  connect(tanHeaWat.TTop, conSup.THeaWatTop) annotation (Line(points={{-199,115},
          {-182,115},{-182,82},{-274,82},{-274,24},{-262,24}}, color={0,0,127}));
  connect(tanHeaWat.TBot, conSup.THeaWatBot) annotation (Line(points={{-199,97},
          {-184,97},{-184,84},{-276,84},{-276,22},{-262,22}},  color={0,0,127}));
  connect(tanChiWat.TTop, conSup.TChiWatTop) annotation (Line(points={{221,115},
          {238,115},{238,80},{-272,80},{-272,18},{-262,18}}, color={0,0,127}));
  connect(tanChiWat.TBot, conSup.TChiWatBot) annotation (Line(points={{221,97},{
          240,97},{240,78},{-270,78},{-270,16},{-262,16}},   color={0,0,127}));
  connect(int.port_b2, colAmbWat.ports_aCon[1]) annotation (Line(points={{-10,
          -248},{-20,-248},{-20,-160},{12,-160},{12,-116}},
                                                      color={0,127,255}));
  connect(int.port_a2, colAmbWat.ports_bCon[1]) annotation (Line(points={{10,-248},
          {20,-248},{20,-140},{-12,-140},{-12,-116}}, color={0,127,255}));
  connect(tanChiWat.port_bBot, ports_bChiWat[1]) annotation (Line(points={{220,100},
          {290,100},{290,200},{300,200}}, color={0,127,255}));
  connect(ports_aChiWat[1], tanChiWat.port_aTop) annotation (Line(points={{-300,
          200},{280,200},{280,112},{220,112}}, color={0,127,255}));
  connect(totPPum.y, PPum) annotation (Line(points={{282,-60},{320,-60}}, color={0,0,127}));
  connect(chi.PChi, PCoo) annotation (Line(
      points={{12,-6},{20,-6},{20,20},{320,20}},
      color={0,0,127}));
  connect(int.yValIso[1], valIsoCon.y_actual) annotation (Line(
      points={{-12,-251},{-40,-251},{-40,-113},{-55,-113}},
      color={0,0,127}));
  connect(int.yValIso[2], valIsoEva.y_actual) annotation (Line(
      points={{-12,-253},{-16,-253},{-16,-240},{40,-240},{40,-113},{55,-113}},
      color={0,0,127}));
  connect(colChiWat.ports_bCon[1], chi.port_aChiWat) annotation (Line(points={{132,-24},
          {132,-12},{10,-12}},      color={0,127,255}));
  connect(chi.port_bChiWat, colChiWat.ports_aCon[1])
    annotation (Line(points={{10,0},{108,0},{108,-24}}, color={0,127,255}));
  connect(valIsoEva.port_b, colAmbWat.port_bDisSup) annotation (Line(points={{50,
          -120},{30,-120},{30,-106},{20,-106}}, color={0,127,255}));
  connect(valIsoCon.port_b, colAmbWat.port_aDisSup) annotation (Line(points={{-50,
          -120},{-30,-120},{-30,-106},{-20,-106}}, color={0,127,255}));
  connect(TChiWatSupSet, conSup.TChiWatSupPreSet) annotation (Line(points={{-320,
          -20},{-266,-20},{-266,20},{-262,20}}, color={0,0,127}));
  connect(uCoo, conSup.uCoo) annotation (Line(points={{-320,60},{-292,60},{-292,
          28},{-262,28}}, color={255,0,255}));
  connect(uHea, conSup.uHea) annotation (Line(points={{-320,100},{-290,100},{-290,
          30},{-262,30}}, color={255,0,255}));
  connect(valIsoEva.port_a, colChiWat.ports_aCon[nConChiWat]) annotation (Line(points={{70,-120},
          {108,-120},{108,-24}},       color={0,127,255}));
  connect(colAmbWat.port_aDisRet, colChiWat.ports_bCon[nConChiWat]) annotation (Line(
        points={{20,-100},{132,-100},{132,-24}}, color={0,127,255}));
  connect(conSup.THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{-238,
          16},{-28,16},{-28,-7},{-12,-7}}, color={0,0,127}));
  connect(conSup.TChiWatSupSet, chi.TChiWatSupPreSet) annotation (Line(points={{
          -238,13},{-32,13},{-32,-9},{-12,-9}}, color={0,0,127}));
  connect(conSup.yIsoEva, valIsoEva.y) annotation (Line(points={{-238,19},{-216,
          19},{-216,-80},{60,-80},{60,-108}}, color={0,0,127}));
  connect(conSup.yIsoCon, valIsoCon.y) annotation (Line(points={{-238,22},{-228,
          22},{-228,22},{-220,22},{-220,-84},{-60,-84},{-60,-108}}, color={0,0,127}));
  connect(conSup.yAmb[nSouAmb], int.u) annotation (Line(points={{-238,25},{-200,
          25},{-200,-256},{-12,-256}}, color={0,0,127}));
  connect(colChiWat.port_bDisRet, tanChiWat.port_aBot) annotation (Line(points={
          {140,-40},{180,-40},{180,100},{200,100}}, color={0,127,255}));
  connect(colChiWat.port_aDisSup, tanChiWat.port_bTop) annotation (Line(points={
          {140,-34},{160,-34},{160,112},{200,112}}, color={0,127,255}));
  connect(chi.port_bHeaWat, colHeaWat.ports_aCon[1])
    annotation (Line(points={{-10,0},{-108,0},{-108,-24}}, color={0,127,255}));
  connect(chi.port_aHeaWat, colHeaWat.ports_bCon[1]) annotation (Line(points={{-10,
          -12},{-132,-12},{-132,-24}}, color={0,127,255}));
  connect(colHeaWat.port_bDisRet, tanHeaWat.port_aTop) annotation (Line(points={
          {-140,-40},{-160,-40},{-160,112},{-200,112}}, color={0,127,255}));
  connect(tanHeaWat.port_bBot, colHeaWat.port_aDisSup) annotation (Line(points={{-200,
          100},{-180,100},{-180,-34},{-140,-34}},       color={0,127,255}));
  connect(valIsoCon.port_a, colHeaWat.ports_aCon[nConHeaWat]) annotation (Line(points={{-70,
          -120},{-108,-120},{-108,-24}}, color={0,127,255}));
  connect(colAmbWat.port_bDisRet, colHeaWat.ports_bCon[nConHeaWat]) annotation (Line(
        points={{-20,-100},{-132,-100},{-132,-24}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false,
                  extent={{-300,-300},{300,300}}),
                  graphics={Line(
                  points={{86,92}},
                  color={28,108,200},
                  pattern=LinePattern.Dash)}),
        defaultComponentName="ets",
Documentation(info="<html>
<p>
colChiWat and colHeaWat connection index starts with 1 for the connection with the chiller
and ends with nConChiWat and nConHeaWat for the last connection before the buffer 
tank which corresponds to the ambient water loop. 


When extending this class 

nAuxCoo and colChiWat.mCon_flow_nominal must be updated if an additional cooling equipment is modeled,

nAuxHea and colHeaWat.mCon_flow_nominal must be updated if an additional heating equipment is modeled,

nSouAmb and colAmbWat.mCon_flow_nominal must be updated if an additional ambient source is modeled.


</p>
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
end Chiller;
