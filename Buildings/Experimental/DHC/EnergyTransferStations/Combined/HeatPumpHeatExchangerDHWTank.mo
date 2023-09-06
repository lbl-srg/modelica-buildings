within Buildings.Experimental.DHC.EnergyTransferStations.Combined;
model HeatPumpHeatExchangerDHWTank
  "Model of a substation with heat pump and compressor-less cooling with domestic hot water served by a heat pump with storage tank"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialHeatPumpHeatExchanger(
    volMix_b(nPorts=4),
    volMix_a(nPorts=4));
  Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = MediumBui,
    use_T_in=true,
    nPorts=1)  if have_hotWat "Source for domestic cold water"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-50,-10})));
  Subsystems.HeatPumpDHWTank proHotWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_varFloEva=have_varFloEva,
    final COP_nominal=COPHotWat_nominal,
    TCon_nominal=datWatHea.THex_nominal,
    TEva_nominal=TDisWatMin - dT_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    mHw_flow_nominal=QHotWat_flow_nominal/cpBui_default/(THotWatSup_nominal -
        TColWat_nominal),
    datWatHea=datWatHea) if have_hotWat
    "Subsystem for hot water production"
    annotation (Placement(transformation(extent={{32,24},{52,44}})));
  parameter Loads.DHW.Data.GenericHeatPumpWaterHeater datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{36,48},{48,60}})));
  Fluid.Sources.MassFlowSource_T sinDHW(
    redeclare final package Medium = MediumBui,
    use_m_flow_in=true,
    nPorts=1) if have_hotWat "Sink for domestic hot water"
    annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter toSin(final k=-1)
    if have_hotWat "Convert to sink"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Loads.DHW.ThermostaticMixingValve tmv(
    redeclare package Medium = MediumBui,
    mDhw_flow_nominal=QHotWat_flow_nominal/cpBui_default/(THotWatSup_nominal -
        TColWat_nominal),
    dpValve_nominal=1000) "Thermostatic mixing valve"
    annotation (Placement(transformation(extent={{-20,48},{-40,70}})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction dcwSpl(
      redeclare final package Medium = MediumBui, final m_flow_nominal=
        proHeaWat.m1_flow_nominal*{1,-1,-1}) "Splitter for domestic cold water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,4})));
equation

  connect(toSin.u, div1.y) annotation (Line(points={{-102,60},{-108,60},{-108,
          32},{-70,32},{-70,-40},{-78,-40}},
                                         color={0,0,127}));
  connect(conFloEvaSHW.m_flow, proHotWat.m2_flow) annotation (Line(points={{-38,100},
          {28,100},{28,31},{30,31}},         color={0,0,127}));
  connect(souDCW.T_in, delT.u2) annotation (Line(points={{-62,-14},{-64,-14},{
          -64,-60},{-156,-60},{-156,-6},{-152,-6}}, color={0,0,127}));
  connect(enaSHW.y, proHotWat.uEna) annotation (Line(points={{-118,80},{-114,80},
          {-114,43},{30,43}},  color={255,0,255}));
  connect(proHotWat.port_b2, volMix_b.ports[4])
    annotation (Line(points={{52,40},{260,40},{260,-360}}, color={0,127,255}));
  connect(proHotWat.PHea, toSub.u) annotation (Line(points={{54,37},{56,37},{56,
          80},{-78,80}}, color={0,0,127}));
  connect(proHotWat.PHea, PHeaTot.u[2]) annotation (Line(points={{54,37},{66,37},
          {66,38},{268,38},{268,80.5}},
        color={0,0,127}));
  connect(proHotWat.PPum, PPumHeaTot.u[2]) annotation (Line(points={{54,34},{
          176,34},{176,420.5},{188,420.5}},
                                    color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{54,31},
          {68,31},{68,30},{256,30},{256,-139.5},{268,-139.5}},
                                                           color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHea.u2) annotation (Line(points={{54,31},{
          58,31},{58,-242},{-6,-242},{-6,-252}},
                                              color={0,0,127}));
  connect(toSin.y, sinDHW.m_flow_in) annotation (Line(points={{-78,60},{-76,60},
          {-76,68},{-70,68}}, color={0,0,127}));
  connect(proHotWat.port_a2, volMix_a.ports[4]) annotation (Line(points={{52,28},
          {56,28},{56,20},{-260,20},{-260,-360}},             color={0,127,255}));
  connect(tmv.port_tw, sinDHW.ports[1]) annotation (Line(points={{-40,59},{-45,
          59},{-45,60},{-48,60}}, color={0,127,255}));
  connect(souDCW.ports[1], dcwSpl.port_1) annotation (Line(points={{-40,-10},{
          -12,-10},{-12,-6}}, color={0,127,255}));
  connect(dcwSpl.port_3, proHotWat.port_a1)
    annotation (Line(points={{-2,4},{0,4},{0,28},{32,28}}, color={0,127,255}));
  connect(dcwSpl.port_2, tmv.port_cw) annotation (Line(points={{-12,14},{-12,
          54.6},{-20,54.6}}, color={0,127,255}));
  connect(proHotWat.port_b1, tmv.port_hw) annotation (Line(points={{32,40},{0,
          40},{0,63.4},{-20,63.4}}, color={0,127,255}));
  connect(tmv.TSet, delT.u1) annotation (Line(points={{-18,67.8},{-12,67.8},{
          -12,68},{-8,68},{-8,26},{-160,26},{-160,6},{-152,6}}, color={0,0,127}));
  connect(proHotWat.QCon_flow, heaFloEvaSHW.u1) annotation (Line(points={{54,24},
          {68,24},{68,120},{-108,120},{-108,106},{-102,106}}, color={0,0,127}));
end HeatPumpHeatExchangerDHWTank;
