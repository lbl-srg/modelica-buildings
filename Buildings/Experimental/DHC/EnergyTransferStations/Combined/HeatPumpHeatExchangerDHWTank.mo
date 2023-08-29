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
      origin={-40,-10})));
  Subsystems.HeatPumpDHWTank proHotWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_varFloEva=have_varFloEva,
    final COP_nominal=COPHotWat_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    mHw_flow_nominal=QHotWat_flow_nominal/cpBui_default/(THotWatSup_nominal -
        TColWat_nominal),
    datWatHea=datWatHea) if have_hotWat
    "Subsystem for hot water production"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  parameter Loads.DHW.Data.GenericHeatPumpWaterHeater datWatHea
    "Performance data"
    annotation (Placement(transformation(extent={{-6,6},{6,18}})));
  Fluid.Sources.MassFlowSource_T sinDHW(
    redeclare final package Medium = MediumBui,
    use_m_flow_in=true,
    nPorts=1) if have_hotWat "Sink for domestic hot water"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter toSin(final k=-1)
    if have_hotWat "Convert to sink"
    annotation (Placement(transformation(extent={{-98,50},{-78,70}})));
equation

  connect(toSin.u, div1.y) annotation (Line(points={{-100,60},{-108,60},{-108,32},
          {-70,32},{-70,-40},{-78,-40}}, color={0,0,127}));
  connect(souDCW.ports[1], proHotWat.port_a1) annotation (Line(points={{-30,-10},
          {-20,-10},{-20,28},{-10,28}}, color={0,127,255}));
  connect(sinDHW.ports[1], proHotWat.port_b1) annotation (Line(points={{-40,60},
          {-20,60},{-20,40},{-10,40}}, color={0,127,255}));
  connect(conFloEvaSHW.m_flow, proHotWat.m2_flow) annotation (Line(points={{-38,
          100},{-16,100},{-16,31},{-12,31}}, color={0,0,127}));
  connect(THotWatSupSet, proHotWat.TSupSet) annotation (Line(points={{-320,-40},
          {-160,-40},{-160,36},{-86,36},{-86,37},{-12,37}},
                                          color={0,0,127}));
  connect(souDCW.T_in, delT.u2) annotation (Line(points={{-52,-14},{-60,-14},{-60,
          -80},{-156,-80},{-156,-6},{-152,-6}},     color={0,0,127}));
  connect(enaSHW.y, proHotWat.uEna) annotation (Line(points={{-118,80},{-114,80},
          {-114,43},{-12,43}}, color={255,0,255}));
  connect(proHotWat.port_b2, volMix_b.ports[4])
    annotation (Line(points={{10,40},{260,40},{260,-360}}, color={0,127,255}));
  connect(proHotWat.PHea, toSub.u) annotation (Line(points={{12,37},{14,37},{14,
          80},{-78,80}}, color={0,0,127}));
  connect(proHotWat.PHea, PHeaTot.u[2]) annotation (Line(points={{12,37},{24,37},
          {24,38},{252,38},{252,84},{260,84},{260,80.5},{268,80.5}},
        color={0,0,127}));
  connect(proHotWat.PPum, PPumHeaTot.u[2]) annotation (Line(points={{12,34},{176,
          34},{176,420.5},{188,420.5}},
                                    color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{12,31},
          {26,31},{26,30},{214,30},{214,-139.5},{268,-139.5}},
                                                           color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHea.u2) annotation (Line(points={{12,31},{16,
          31},{16,-242},{-6,-242},{-6,-252}}, color={0,0,127}));
  connect(toSin.y, sinDHW.m_flow_in) annotation (Line(points={{-76,60},{-68,60},
          {-68,68},{-62,68}}, color={0,0,127}));
  connect(proHotWat.port_a2, volMix_a.ports[4]) annotation (Line(points={{10,28},
          {14,28},{14,20},{-262,20},{-262,-360},{-260,-360}}, color={0,127,255}));
end HeatPumpHeatExchangerDHWTank;
