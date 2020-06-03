within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5;
model ChillerBoreField
  "Energy transfer station model for fifth generation DHC systems with heat recovery chiller and borefield"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_heaWat=true,
    final have_chiWat=true,
    have_hotWat=false,
    final have_eleHea=true,
    final have_eleCoo=true,
    final have_fan=false,
    final have_weaBus=false,
    final have_pum=true,
    final nPorts_aDis=1,
    final nPorts_bDis=1,
    nPorts_aBui=2,
    nPorts_bBui=2);

  parameter Boolean have_val1Hex=false
    "Set to true in case of control valve on district side, false in case of a pump"
    annotation(Evaluate=true);
  parameter Boolean have_borFie
    "Set to true to include a geothermal borefield"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dp1Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop on primary side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp2Hex_nominal(displayUnit="Pa")
    "Nominal pressure drop on secondary side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.HeatFlowRate QHex_flow_nominal
    "Nominal heat flow rate through heat exchanger (from district to building)"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a1Hex_nominal
    "Nominal water inlet temperature on district side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b1Hex_nominal
    "Nominal water outlet temperature on district side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a2Hex_nominal
    "Nominal water inlet temperature on building side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  parameter Modelica.SIunits.Temperature T_b2Hex_nominal
    "Nominal water outlet temperature on building side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));

  parameter Modelica.Fluid.Types.Dynamics fixedEnergyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
    annotation (Dialog(group="Dynamics"));

  parameter Modelica.SIunits.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Chiller"));
  parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Dialog(group="Chiller"),
      Placement(transformation(extent={{20,184},{40,204}})));

  final parameter Modelica.SIunits.Volume VTanHeaWat=
    dat.PLRMin * dat.mCon_flow_nominal * 5 * 60 / 1000
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
    dat.PLRMin * dat.mEva_flow_nominal * 5 * 60 / 1000
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
  parameter Modelica.SIunits.TemperatureDifference THys = 1
    "Temperature hysteresis for supervisory control"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.SIunits.Temperature TBorWatEntMax(
    displayUnit="degC") = 30 + 273.15
    "Maximum value of borefield water entering temperature"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  parameter Modelica.SIunits.TemperatureDifference dTBorFieSet(
    min=0, unit="K") = 5
    "Set-point for temperature difference accross borefield (absolute value)"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  parameter Fluid.Geothermal.Borefields.Data.Borefield.Template datBorFie
    "Borefield parameters"
    annotation (Dialog(group="Borefield", enable=have_borFie),
      Placement(transformation(extent={{-40,184},{-20,204}})));

  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-340,0},{-300,40}}),
      iconTransformation(extent={{-382,40},{-300,122}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point (may be reset down)"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
      iconTransformation(extent={{-382,-122},{-300,-40}})));

  // COMPONENTS
  FifthGeneration.Controls.Supervisory conSup
    "Supervisory controller"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValAmb_nominal,
    final m_flow_nominal=datChi.mEva_flow_nominal)
    "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{90,-110},{70,-90}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValAmb_nominal,
    final m_flow_nominal=datChi.mCon_flow_nominal)
    "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manAmbWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {-1,-1,1})
    "Ambient water supply manifold"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manAmbWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {1,1,-1})
    "Ambient water return manifold"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manChiWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {1,-1,-1})
    "Chilled water supply manifold"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manChiWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {1,-1,-1})
    "Chilled water return manifold"
    annotation (Placement(transformation(extent={{170,-50},{150,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manHeaWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {1,-1,-1})
    "Heating water supply manifold"
    annotation (Placement(transformation(extent={{-90,30},{-110,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manHeaWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=sum(m2Hex_flow_nominal, mBorFie_flow_nominal) .* {1,-1,-1})
    "Heating water return manifold"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    junBorFieInl(redeclare final package Medium = MediumBui, final
      m_flow_nominal={sum(m2Hex_flow_nominal, mBorFie_flow_nominal),-
        m2Hex_flow_nominal,-mBorFie_flow_nominal}) "Borefield inlet junction"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-118,-210})));

  Subsystems.Chiller chi(
    redeclare final package Medium = MediumBui,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi) "Base subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-8,24},{12,44}})));
  Subsystems.Borefield borFie(
    redeclare final package Medium = MediumBui,
    final TBorWatEntMax=TBorWatEntMax,
    final dTBorFieSet=dTBorFieSet,
    final dat=datBorFie) if have_bor
    "Auxiliary subsystem with geothermal borefield"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Subsystems.HeatExchanger hex(
    redeclare final package Medium1 = MediumDis,
    redeclare final package Medium2 = MediumBui,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui,
    final dp1Hex_nominal=dp1Hex_nominal,
    final dp2Hex_nominal=dp2Hex_nominal,
    final QHex_flow_nominal=QHex_flow_nominal,
    final T_a1Hex_nominal=T_a1Hex_nominal,
    final T_b1Hex_nominal=T_b1Hex_nominal,
    final T_a2Hex_nominal=T_a2Hex_nominal,
    final T_b2Hex_nominal=T_b2Hex_nominal)
    "Base subsystem with district heat exchanger"
    annotation (Placement(transformation(extent={{-80,-256},{-60,-276}})));

  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.StratifiedTank
    tanChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=dat.mEva_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan) "Chilled water buffer tank"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.StratifiedTank
    tanHeaWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan) "Heating water buffer tank"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor
    colDis annotation (Placement(transformation(
        extent={{-20,10},{20,-10}},
        rotation=-90,
        origin={40,-230})));
equation
  connect(valIsoCon.port_b, manAmbWatRet.ports_b[1])
    annotation (Line(points={{-70,-100},{-8,-100}}, color={0,127,255}));
  connect(THeaWatSupSet, conSup.THeaWatSupSet) annotation (Line(points={{-320,20},
          {-280,20},{-280,58},{-262,58}}, color={0,0,127}));
  connect(TChiWatSupSet, conSup.TChiWatSupSet) annotation (Line(points={{-320,-20},
          {-276,-20},{-276,49},{-262,49}}, color={0,0,127}));
  connect(conSup.yIsoEva, valIsoEva.y) annotation (Line(points={{-238,41},{-194,
          41},{-194,-80},{80,-80},{80,-88}},   color={0,0,127}));
  connect(conSup.yIsoCon, valIsoCon.y) annotation (Line(points={{-238,44},{-192,
          44},{-192,-76},{-80,-76},{-80,-88}},   color={0,0,127}));
  connect(conSup.yHeaRej, borFie.uHeaRej) annotation (Line(points={{-238,53},{
          -186,53},{-186,-192},{-82,-192}}, color={255,0,255}));
  connect(conSup.yColRej, borFie.uColRej) annotation (Line(points={{-238,50},{
          -188,50},{-188,-196},{-82,-196}}, color={255,0,255}));
  connect(conSup.yIsoEva, borFie.uIsoEva) annotation (Line(points={{-238,43},{-194,
          43},{-194,-198},{-82,-198}},      color={0,0,127}));
  connect(conSup.yIsoCon, borFie.uIsoCon) annotation (Line(points={{-238,46},{-192,
          46},{-192,-196},{-82,-196}},      color={0,0,127}));
  connect(ports_aDis[1], hex.port_a1) annotation (Line(points={{-300,-260},{-280,
          -260},{-280,-280},{-120,-280},{-120,-272},{-80,-272}},
          color={0,127,255}));
  connect(hex.port_b1, ports_bDis[1]) annotation (Line(points={{-60,-272},{-20,-272},
          {-20,-280},{280,-280},{280,-260},{300,-260}},       color={0,127,255}));
  connect(chi.port_bChiWat, manChiWatSup.port_1) annotation (Line(points={{12,40},
          {110,40}},                  color={0,127,255}));
  connect(manHeaWatRet.port_2, chi.port_aHeaWat) annotation (Line(points={{-130,
          -40},{-20,-40},{-20,28},{-8,28}},    color={0,127,255}));
  connect(manChiWatRet.port_2, chi.port_aChiWat) annotation (Line(points={{150,-40},
          {20,-40},{20,28},{12,28}},   color={0,127,255}));
  connect(chi.port_bHeaWat, manHeaWatSup.port_1) annotation (Line(points={{-8,40},
          {-90,40}},                     color={0,127,255}));
  connect(manHeaWatRet.port_3, manAmbWatSup.port_1) annotation (Line(points={{-140,
          -50},{-140,-160},{-10,-160}}, color={0,127,255}));
  connect(manAmbWatSup.port_2, manChiWatRet.port_3) annotation (Line(points={{10,-160},
          {160,-160},{160,-50}}, color={0,127,255}));
  connect(manHeaWatSup.port_3, valIsoCon.port_a) annotation (Line(points={{-100,30},
          {-100,-100},{-90,-100}},     color={0,127,255}));
  connect(manChiWatSup.port_3, valIsoEva.port_a) annotation (Line(points={{120,30},
          {120,-100},{90,-100}},  color={0,127,255}));
  connect(manAmbWatRet.port_1, valIsoEva.port_b)
    annotation (Line(points={{10,-100},{70,-100}}, color={0,127,255}));
  connect(conSup.yHea, chi.uHea) annotation (Line(points={{-238,59},{-40,59},{
          -40,37},{-10,37}},
                           color={255,0,255}));
  connect(conSup.yCoo, chi.uCoo) annotation (Line(points={{-238,56},{-140,56},{
          -140,54},{-44,54},{-44,35},{-10,35}},
                           color={255,0,255}));
  connect(THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{-320,20},
          {-42,20},{-42,33},{-10,33}},  color={0,0,127}));
  connect(TChiWatSupSet, chi.TChiWatSupPreSet) annotation (Line(points={{-320,-20},
          {-40,-20},{-40,31},{-10,31}}, color={0,0,127}));
  connect(conSup.yColRej, hex.uColRej) annotation (Line(points={{-238,49},{-188,
          49},{-188,-266},{-82,-266}}, color={255,0,255}));
  connect(conSup.yHeaRej,hex.uEnaHex)  annotation (Line(points={{-238,53},{-186,
          53},{-186,-275},{-82,-275}}, color={255,0,255}));
  connect(manChiWatSup.port_2, tanChiWat.port_aBot) annotation (Line(points={{130,
          40},{160,40},{160,204},{200,204}}, color={0,127,255}));
  connect(ports_aHeaWat[1], tanHeaWat.port_aBot) annotation (Line(points={{-300,
          260},{-300,240},{-272,240},{-272,204},{-220,204}}, color={0,127,255}));
  connect(manHeaWatSup.port_2, tanHeaWat.port_aTop) annotation (Line(points={{-110,
          40},{-140,40},{-140,216},{-200,216}}, color={0,127,255}));
  connect(tanHeaWat.port_bBot, manHeaWatRet.port_1) annotation (Line(points={{-200,
          204},{-160,204},{-160,-40},{-150,-40}}, color={0,127,255}));
  connect(tanHeaWat.port_bTop, ports_bHeaWat[1]) annotation (Line(points={{-220,
          216},{-240,216},{-240,260},{300,260}}, color={0,127,255}));
  connect(tanChiWat.port_bBot, ports_bHeaWat[2]) annotation (Line(points={{220,
          204},{280,204},{280,260},{300,260}}, color={0,127,255}));
  connect(ports_aHeaWat[2], tanChiWat.port_aTop) annotation (Line(points={{-300,
          260},{240,260},{240,216},{220,216}}, color={0,127,255}));
  connect(tanChiWat.port_bTop, manChiWatRet.port_1) annotation (Line(points={{200,
          216},{180,216},{180,-40},{170,-40}}, color={0,127,255}));
  connect(tanHeaWat.TTop, conSup.THeaWatTop) annotation (Line(points={{-199,219},
          {-180,219},{-180,82},{-274,82},{-274,55},{-262,55}}, color={0,0,127}));
  connect(tanHeaWat.TBot, conSup.THeaWatBot) annotation (Line(points={{-199,201},
          {-182,201},{-182,84},{-276,84},{-276,52},{-262,52}}, color={0,0,127}));
  connect(tanChiWat.TTop, conSup.TChiWatTop) annotation (Line(points={{221,219},
          {238,219},{238,80},{-272,80},{-272,46},{-262,46}}, color={0,0,127}));
  connect(tanChiWat.TBot, conSup.TChiWatBot) annotation (Line(points={{221,201},
          {240,201},{240,78},{-270,78},{-270,43},{-262,43}}, color={0,0,127}));
  connect(junBorFieInl.port_1, manAmbWatRet.port_3) annotation (Line(points={{-118,
          -200},{-118,-120},{0,-120},{0,-110}}, color={0,127,255}));
  connect(manAmbWatSup.port_3, colDis.port_bDisRet) annotation (Line(points={{0,
          -170},{26,-170},{26,-176},{46,-176},{46,-210}}, color={0,127,255}));
  connect(hex.port_b2, colDis.ports_aCon[1]) annotation (Line(points={{-80,-260},
          {-100,-260},{-100,-242},{30,-242}}, color={0,127,255}));
  connect(borFie.port_b, colDis.ports_aCon[2]) annotation (Line(points={{-60,
          -200},{-46,-200},{-46,-204},{-2,-204},{-2,-242},{30,-242}}, color={0,
          127,255}));
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
end ChillerBoreField;
