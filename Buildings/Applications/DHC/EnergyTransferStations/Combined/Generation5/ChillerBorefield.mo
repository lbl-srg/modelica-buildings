within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5;
model ChillerBorefield
  "ETS model for 5GDHC systems with heat recovery chiller and optional borefield"
  extends BaseClasses.PartialHeatExchanger(
    final have_eleCoo=true,
    final have_fan=false,
    nSysHea=1,
    nSouAmb=if have_borFie then 2 else 1,
    dT2HexSet=abs(T_b2Hex_nominal - T_a2Hex_nominal) .* {1 + 1/datChi.COP_nominal, 1},
    VTanHeaWat=datChi.PLRMin * datChi.mCon_flow_nominal * 5 * 60 / 1000,
    VTanChiWat=datChi.PLRMin * datChi.mEva_flow_nominal * 5 * 60 / 1000,
    THeaWatSupSetMin=datChi.TConEntMin + 5,
    TChiWatSupSetMax=datChi.TEvaLvgMax,
    colChiWat(mCon_flow_nominal=
      {colAmbWat.mDis_flow_nominal, datChi.mEva_flow_nominal}),
    colHeaWat(mCon_flow_nominal=
      {colAmbWat.mDis_flow_nominal, datChi.mCon_flow_nominal}),
    colAmbWat(mCon_flow_nominal=if have_borFie then
      {hex.m2_flow_nominal, datBorFie.conDat.mBorFie_flow_nominal} else
      {hex.m2_flow_nominal}),
    totPPum(nin=3),
    totPHea(nin=1),
    totPCoo(nin=1));

  parameter Boolean have_borFie=false
    "Set to true in case a borefield is used in addition of the district HX"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Chiller"));
  parameter Modelica.SIunits.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Chiller"));
  replaceable parameter Fluid.Chillers.Data.ElectricEIR.Generic datChi
    "Chiller performance data"
    annotation (Dialog(group="Chiller"),
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,222},{10,242}})));

  parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie
    "Borefield parameters"
    annotation (Dialog(group="Borefield", enable=have_borFie),
      Placement(transformation(extent={{20,222},{40,242}})));
  parameter Modelica.SIunits.Temperature TBorWatEntMax=313.15
    "Maximum value of borefield water entering temperature"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed"
    annotation (Dialog(group="Borefield", enable=have_borFie));
  parameter Modelica.SIunits.Pressure dpBorFie_nominal(displayUnit="Pa") = 5E4
    "Pressure losses for the entire borefield (control valve excluded)"
    annotation (Dialog(group="Borefield", enable=have_borFie));

  replaceable Subsystems.Chiller chi(
    redeclare final package Medium = MediumBui,
    final dpCon_nominal=dpCon_nominal,
    final dpEva_nominal=dpEva_nominal,
    final dat=datChi)
    "Chiller"
    annotation (
      Dialog(group="Chiller"),
      Placement(transformation(extent={{-10,-16},{10,4}})));

  replaceable Subsystems.Borefield borFie(
    redeclare final package Medium = MediumBui,
    final dat=datBorFie,
    final TBorWatEntMax=TBorWatEntMax,
    final spePumBorMin=spePumBorMin,
    final dp_nominal=dpBorFie_nominal) if have_borFie
    "Borefield"
    annotation (
      Dialog(group="Borefield", enable=have_borFie),
      Placement(transformation(extent={{-80,-230},{-60,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPPum(final k=0) if
    not have_borFie "Zero power"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerPHea(final k=0)
    "Zero power"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
equation
  connect(chi.port_bHeaWat, colHeaWat.ports_aCon[2])
    annotation (Line(points={{-10,0},{-108,0},{-108,-24}}, color={0,127,255}));
  connect(chi.port_aHeaWat, colHeaWat.ports_bCon[2]) annotation (Line(points={{-10,
          -12},{-132,-12},{-132,-24}}, color={0,127,255}));
  connect(chi.port_bChiWat, colChiWat.ports_aCon[2])
    annotation (Line(points={{10,0},{108,0},{108,-24}}, color={0,127,255}));
  connect(colChiWat.ports_bCon[2], chi.port_aChiWat) annotation (Line(points={{132,
          -24},{132,-12},{10,-12},{10,-12}}, color={0,127,255}));
  connect(conSup.yHea, chi.uHea) annotation (Line(points={{-238,31},{-20,31},{-20,
          -3},{-12,-3}}, color={255,0,255}));
  connect(conSup.yCoo, chi.uCoo) annotation (Line(points={{-238,28},{-22,28},{-22,
          -5},{-12,-5}}, color={255,0,255}));
  connect(conSup.THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{-238,
          16},{-24,16},{-24,-7},{-12,-7}}, color={0,0,127}));
  connect(conSup.TChiWatSupSet, chi.TChiWatSupSet) annotation (Line(points={{-238,
          13},{-26,13},{-26,-9},{-12,-9}}, color={0,0,127}));
  connect(chi.PPum, totPPum.u[2]) annotation (Line(points={{12,-8},{20,-8},{20,-58},
          {258,-58},{258,-60}}, color={0,0,127}));
  connect(colAmbWat.ports_aCon[2], borFie.port_b) annotation (Line(points={{12,-116},
          {14,-116},{14,-220},{-60,-220}}, color={0,127,255}));
  connect(colAmbWat.ports_bCon[2], borFie.port_a) annotation (Line(points={{-12,
          -116},{-14,-116},{-14,-140},{-100,-140},{-100,-220},{-80,-220}},
        color={0,127,255}));
  connect(conSup.yAmb[1], borFie.u) annotation (Line(points={{-238,25},{-200,25},
          {-200,-212},{-82,-212}}, color={0,0,127}));
  connect(valIsoCon.y_actual, borFie.yValIso[1]) annotation (Line(points={{-55,
          -113},{-40,-113},{-40,-198},{-90,-198},{-90,-217},{-82,-217}}, color=
          {0,0,127}));
  connect(valIsoEva.y_actual, borFie.yValIso[2]) annotation (Line(points={{55,-113},
          {40,-113},{40,-200},{-88,-200},{-88,-215},{-82,-215}},       color={0,
          0,127}));
  connect(borFie.PPum, totPPum.u[3]) annotation (Line(points={{-58,-212},{240,-212},
          {240,-62},{258,-62},{258,-60}}, color={0,0,127}));
  connect(zerPPum.y, totPPum.u[3]) annotation (Line(points={{222,-80},{254,-80},
          {254,-62},{258,-62},{258,-60}}, color={0,0,127}));
  connect(zerPHea.y, totPHea.u[1])
    annotation (Line(points={{222,60},{258,60}}, color={0,0,127}));
  connect(chi.PChi, totPCoo.u[1]) annotation (Line(points={{12,-4},{20,-4},{20,20},
          {258,20}}, color={0,0,127}));
annotation (
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
end ChillerBorefield;
