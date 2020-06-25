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
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end ChillerBorefield;
