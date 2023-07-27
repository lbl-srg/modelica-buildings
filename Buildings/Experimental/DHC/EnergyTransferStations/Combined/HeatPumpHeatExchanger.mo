within Buildings.Experimental.DHC.EnergyTransferStations.Combined;
model HeatPumpHeatExchanger
  "Model of a substation with heat pump and compressor-less cooling"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.BaseClasses.PartialHeatPumpHeatExchanger(
     volMix_a(nPorts=4), volMix_b(nPorts=4));
  Subsystems.HeatPump                                                            proHotWat(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumSer,
    final have_pumCon=false,
    final have_varFloEva=have_varFloEva,
    final COP_nominal=COPHotWat_nominal,
    final TCon_nominal=THotWatSup_nominal,
    final TEva_nominal=TDisWatMin - dT_nominal,
    final Q1_flow_nominal=QHotWat_flow_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalSer,
    final dT1_nominal=THotWatSup_nominal - TColWat_nominal,
    final dT2_nominal=-dT_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal) if have_hotWat
    "Subsystem for hot water production"
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Fluid.Sources.MassFlowSource_T souColWat(
    redeclare final package Medium = MediumBui,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) if have_hotWat
    "Source for cold water"
    annotation (Placement(transformation(extent={{-48,-50},{-28,-30}})));
  Fluid.Sources.Boundary_pT sinSHW(redeclare final package Medium = MediumBui,
      nPorts=1)
               if have_hotWat
    "Sink for service hot water" annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-60,60})));
equation
  connect(souColWat.ports[1], proHotWat.port_a1) annotation (Line(points={{-28,-40},
          {-20,-40},{-20,28},{-10,28}}, color={0,127,255}));
  connect(conFloEvaSHW.m_flow, proHotWat.m2_flow) annotation (Line(points={{-38,
          100},{-16,100},{-16,31},{-12,31}}, color={0,0,127}));
  connect(sinSHW.ports[1], proHotWat.port_b1) annotation (Line(points={{-50,60},
          {-20,60},{-20,40},{-10,40}}, color={0,127,255}));
  connect(THotWatSupSet, proHotWat.TSupSet) annotation (Line(points={{-320,-40},
          {-160,-40},{-160,36},{-86,36},{-86,37},{-12,37}},
                                          color={0,0,127}));
  connect(enaSHW.y, proHotWat.uEna) annotation (Line(points={{-118,80},{-114,80},
          {-114,43},{-12,43}}, color={255,0,255}));
  connect(proHotWat.PHea, toSub.u) annotation (Line(points={{12,37},{18,37},{18,
          80},{-78,80}}, color={0,0,127}));
  connect(proHotWat.PPum, PPumHeaTot.u[2]) annotation (Line(points={{12,34},{176,
          34},{176,420},{188,420},{188,420.5}},
                                              color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHeaTot.u[2]) annotation (Line(points={{12,31},
          {218,31},{218,-139.5},{268,-139.5}},
                                           color={0,0,127}));
  connect(proHotWat.mEva_flow, masFloHea.u2) annotation (Line(points={{12,31},{18,
          31},{18,-240},{-6,-240},{-6,-252}}, color={0,0,127}));
  connect(proHotWat.PHea, PHeaTot.u[2]) annotation (Line(points={{12,37},{240,
          37},{240,80},{256,80},{256,80},{268,80}},
                              color={0,0,127}));
  connect(TColWat, souColWat.T_in) annotation (Line(points={{-320,-80},{-60,-80},
          {-60,-36},{-50,-36}}, color={0,0,127}));
  connect(div1.y, souColWat.m_flow_in) annotation (Line(points={{-78,-40},{-68,-40},
          {-68,-32},{-50,-32}}, color={0,0,127}));
  connect(proHotWat.port_a2, volMix_a.ports[4]) annotation (Line(points={{10,28},
          {14,28},{14,20},{-260,20},{-260,-360}}, color={0,127,255}));
  connect(proHotWat.port_b2, volMix_b.ports[4])
    annotation (Line(points={{10,40},{260,40},{260,-360}}, color={0,127,255}));
end HeatPumpHeatExchanger;
