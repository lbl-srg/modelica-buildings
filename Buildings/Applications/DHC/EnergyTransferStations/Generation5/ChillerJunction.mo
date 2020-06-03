within Buildings.Applications.DHC.EnergyTransferStations.Generation5;
model ChillerJunction
  "Energy transfer station model for fifth generation DHC systems with heat recovery chiller"
  extends DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_heaWat=true,
    final have_chiWat=true,
    have_hotWat=false,
    have_eleHea=false,
    final have_eleCoo=true,
    final have_fan=false,
    have_weaBus=false,
    final have_pum=true,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);

  parameter Boolean have_val1Hex=false
    "Set to true in case of control valve on district side, false in case of a pump"
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
  final parameter Modelica.SIunits.MassFlowRate m1Hex_flow_nominal=
    hex.m1_flow_nominal
    "Nominal mass flow rate on primary side of heat exchanger"
    annotation (Dialog(group="District heat exchanger"));
  final parameter Modelica.SIunits.MassFlowRate m2Hex_flow_nominal=
    hex.m2_flow_nominal
    "Nominal mass flow rate on secondary side of heat exchanger"
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
  parameter Modelica.SIunits.TemperatureDifference THys = 1
    "Temperature hysteresis for supervisory control"
    annotation (Dialog(group="Buffer Tank"));

  parameter Modelica.SIunits.PressureDifference dpValIso_nominal = 2E3
    "Nominal pressure drop of isolation valve"
    annotation (Dialog(group="Generic"));

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
  Generation5.Controls.Supervisory conSup(final THys=THys)
    "Supervisory controller"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Fluid.Actuators.Valves.TwoWayLinear valIsoEva(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=datChi.mEva_flow_nominal)
    "Evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{90,-110},{70,-90}})));
  Fluid.Actuators.Valves.TwoWayLinear valIsoCon(
    redeclare final package Medium = MediumBui,
    final dpValve_nominal=dpValIso_nominal,
    final m_flow_nominal=datChi.mCon_flow_nominal)
    "Condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manAmbWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {-1,-1,1})
    "Ambient water supply manifold"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manAmbWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {1,1,-1})
    "Ambient water return manifold"
    annotation (Placement(transformation(extent={{30,-110},{10,-90}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manChiWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {1,-1,-1})
    "Chilled water supply manifold"
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manChiWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {1,-1,-1})
    "Chilled water return manifold"
    annotation (Placement(transformation(extent={{170,-50},{150,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manHeaWatSup(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {1,-1,-1})
    "Heating water supply manifold"
    annotation (Placement(transformation(extent={{-90,30},{-110,50}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction
    manHeaWatRet(redeclare final package Medium = MediumBui, final
      m_flow_nominal=m2Hex_flow_nominal .* {1,-1,-1})
    "Heating water return manifold"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));

  Subsystems.Chiller chi(
    redeclare final package Medium = MediumBui,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi) "Base subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{-8,24},{12,44}})));
  Subsystems.HeatExchanger hex(
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
    final T_b2Hex_nominal=T_b2Hex_nominal)
    "Base subsystem with district heat exchanger"
    annotation (Placement(transformation(extent={{-8,-256},{12,-276}})));

  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.StratifiedTank
    tanChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=datChi.mEva_flow_nominal,
    final VTan=VTanChiWat,
    final hTan=hTanChiWat,
    final dIns=dInsTanChiWat,
    final nSeg=nSegTan) "Chilled water buffer tank"
    annotation (Placement(transformation(extent={{200,196},{220,216}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.StratifiedTank
    tanHeaWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=datChi.mCon_flow_nominal,
    final VTan=VTanHeaWat,
    final hTan=hTanHeaWat,
    final dIns=dInsTanHeaWat,
    final nSeg=nSegTan) "Heating water buffer tank"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum totPPum(nin=2)
    "Total pump power"
    annotation (Placement(transformation(extent={{262,-70},{282,-50}})));
equation
  connect(THeaWatSupSet, conSup.THeaWatSupSet) annotation (Line(points={{-320,20},
          {-280,20},{-280,58},{-262,58}}, color={0,0,127}));
  connect(TChiWatSupSet, conSup.TChiWatSupSet) annotation (Line(points={{-320,-20},
          {-276,-20},{-276,49},{-262,49}}, color={0,0,127}));
  connect(conSup.yIsoEva, valIsoEva.y) annotation (Line(points={{-238,41},{-194,
          41},{-194,-80},{80,-80},{80,-88}},   color={0,0,127}));
  connect(conSup.yIsoCon, valIsoCon.y) annotation (Line(points={{-238,44},{-192,
          44},{-192,-76},{-80,-76},{-80,-88}},   color={0,0,127}));
  connect(port_aDis, hex.port_a1) annotation (Line(points={{-300,-260},{-280,
          -260},{-280,-280},{-20,-280},{-20,-272},{-8,-272}},
          color={0,127,255}));
  connect(hex.port_b1, port_bDis) annotation (Line(points={{12,-272},{20,-272},
          {20,-280},{280,-280},{280,-260},{300,-260}},        color={0,127,255}));
  connect(chi.port_bChiWat, manChiWatSup.port_1) annotation (Line(points={{12,40},
          {110,40}},                  color={0,127,255}));
  connect(manHeaWatRet.port_2, chi.port_aHeaWat) annotation (Line(points={{-130,
          -40},{-20,-40},{-20,28},{-8,28}},    color={0,127,255}));
  connect(manChiWatRet.port_2, chi.port_aChiWat) annotation (Line(points={{150,-40},
          {20,-40},{20,28},{12,28}},   color={0,127,255}));
  connect(chi.port_bHeaWat, manHeaWatSup.port_1) annotation (Line(points={{-8,40},
          {-90,40}},                     color={0,127,255}));
  connect(manHeaWatRet.port_3, manAmbWatSup.port_1) annotation (Line(points={{-140,
          -50},{-140,-160},{-30,-160}}, color={0,127,255}));
  connect(manAmbWatSup.port_2, manChiWatRet.port_3) annotation (Line(points={{-10,
          -160},{160,-160},{160,-50}},
                                 color={0,127,255}));
  connect(manHeaWatSup.port_3, valIsoCon.port_a) annotation (Line(points={{-100,30},
          {-100,-100},{-90,-100}},     color={0,127,255}));
  connect(manChiWatSup.port_3, valIsoEva.port_a) annotation (Line(points={{120,30},
          {120,-100},{90,-100}},  color={0,127,255}));
  connect(manAmbWatRet.port_1, valIsoEva.port_b)
    annotation (Line(points={{30,-100},{70,-100}}, color={0,127,255}));
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
          49},{-188,-266},{-10,-266}}, color={255,0,255}));
  connect(conSup.yHeaRej,hex.uEnaHex)  annotation (Line(points={{-238,53},{-186,
          53},{-186,-275},{-10,-275}}, color={255,0,255}));
  connect(manChiWatSup.port_2, tanChiWat.port_aBot) annotation (Line(points={{130,40},
          {160,40},{160,200},{200,200}},     color={0,127,255}));
  connect(ports_aHeaWat[1], tanHeaWat.port_aBot) annotation (Line(points={{-300,
          260},{-260,260},{-260,204},{-220,204}},            color={0,127,255}));
  connect(manHeaWatSup.port_2, tanHeaWat.port_aTop) annotation (Line(points={{-110,
          40},{-140,40},{-140,216},{-200,216}}, color={0,127,255}));
  connect(tanHeaWat.port_bBot, manHeaWatRet.port_1) annotation (Line(points={{-200,
          204},{-160,204},{-160,-40},{-150,-40}}, color={0,127,255}));
  connect(tanHeaWat.port_bTop, ports_bHeaWat[1]) annotation (Line(points={{-220,
          216},{-240,216},{-240,260},{300,260}}, color={0,127,255}));
  connect(tanChiWat.port_bTop, manChiWatRet.port_1) annotation (Line(points={{200,212},
          {180,212},{180,-40},{170,-40}},      color={0,127,255}));
  connect(tanHeaWat.TTop, conSup.THeaWatTop) annotation (Line(points={{-199,219},
          {-180,219},{-180,82},{-274,82},{-274,55},{-262,55}}, color={0,0,127}));
  connect(tanHeaWat.TBot, conSup.THeaWatBot) annotation (Line(points={{-199,201},
          {-182,201},{-182,84},{-276,84},{-276,52},{-262,52}}, color={0,0,127}));
  connect(tanChiWat.TTop, conSup.TChiWatTop) annotation (Line(points={{221,215},
          {238,215},{238,80},{-272,80},{-272,46},{-262,46}}, color={0,0,127}));
  connect(tanChiWat.TBot, conSup.TChiWatBot) annotation (Line(points={{221,197},
          {240,197},{240,78},{-270,78},{-270,43},{-262,43}}, color={0,0,127}));
  connect(manAmbWatRet.port_3, hex.port_a2) annotation (Line(points={{20,-110},{
          20,-260},{12,-260}}, color={0,127,255}));
  connect(valIsoCon.port_b, manAmbWatRet.port_2)
    annotation (Line(points={{-70,-100},{10,-100}}, color={0,127,255}));
  connect(manAmbWatSup.port_3, hex.port_b2) annotation (Line(points={{-20,-170},
          {-20,-260},{-8,-260}}, color={0,127,255}));
  connect(totPPum.y, PPum) annotation (Line(points={{284,-60},{292,-60},{292,-60},
          {320,-60}}, color={0,0,127}));
  connect(chi.PChi, PCoo) annotation (Line(points={{13,37},{60,37},{60,20},{320,
          20}}, color={0,0,127}));
  connect(chi.PPum, totPPum.u[1]) annotation (Line(points={{13,31},{40,31},{40,-59},
          {260,-59}}, color={0,0,127}));
  connect(hex.PPum, totPPum.u[2]) annotation (Line(points={{13,-266},{242,-266},
          {242,-61},{260,-61}}, color={0,0,127}));
  connect(tanChiWat.port_bBot, ports_bChiWat[1])
    annotation (Line(points={{220,200},{300,200}}, color={0,127,255}));
  connect(tanChiWat.port_aTop, ports_aChiWat[1]) annotation (Line(points={{220,
          212},{260,212},{260,240},{-280,240},{-280,200},{-300,200}}, color={0,
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
end ChillerJunction;
