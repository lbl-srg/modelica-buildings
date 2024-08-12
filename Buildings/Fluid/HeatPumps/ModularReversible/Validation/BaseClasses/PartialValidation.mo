within Buildings.Fluid.HeatPumps.ModularReversible.Validation.BaseClasses;
partial model PartialValidation
  "Validation base case for the reversible heat pump model."

  replaceable package MediumSin = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium of sink side"
      annotation (choicesAllMatching=true);
  replaceable package MediumSou = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium of source side"
      annotation (choicesAllMatching=true);
  Buildings.Fluid.Sources.MassFlowSource_T souSidMasFlowSou(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare final package Medium = MediumSou,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
    annotation (Placement(transformation(extent={{-40,-82},{-20,-62}})));

  Buildings.Fluid.Sources.Boundary_pT souSidFixBou(
    nPorts=1,
    redeclare package Medium = MediumSou)
    "Fixed boundary at the outlet of the source side"
    annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={-33,-37})));
  Buildings.Fluid.HeatPumps.ModularReversible.Modular heaPum(
    redeclare final package MediumCon = MediumSin,
    redeclare final package MediumEva = MediumSou,
    final use_intSafCtr=false,
    TConHea_nominal=303.15,
    dTCon_nominal=5,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaHea_nominal=290.15,
    dTEva_nominal=5,
    mEva_flow_nominal=0.8,
    dpEva_nominal=0,
    dpCon_nominal=0,
    use_conCap=false,
    final use_rev=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    TEva_start=290.15,
    use_evaCap=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TCon_start=303.15,
    redeclare model RefrigerantCycleHeatPumpCooling =
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling)
    "Heat pump" annotation (Placement(transformation(
        extent={{-10.5,-10.5},{10.5,10.5}},
        rotation=0,
        origin={10.5,-30.5})));

  Buildings.Fluid.Sources.Boundary_pT sinSidFixBou(redeclare final package Medium =
        MediumSin, nPorts=1) "Fixed boundary at the outlet of the sink side"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={50,-24})));
  Buildings.Fluid.Sources.MassFlowSource_T sinSidMasFlowSou(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare final package Medium = MediumSin,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));

  Modelica.Blocks.Math.Gain mEva_flow(final k=heaPum.mEva_flow_nominal)
    "Gain to scale the time table output to flow rate"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Math.Gain mCon_flow(final k=heaPum.mCon_flow_nominal)
    "Gain to scale the time table output to flow rate" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,8})));
  Modelica.Blocks.Sources.CombiTimeTable tabMea(
    tableOnFile=true,
    tableName="MeasuredData",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/Validation/MeasuredHeatPumpData.txt"),
    columns=2:10,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Table with measurement data"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Modelica.Blocks.Interfaces.RealOutput TConOutMea(unit="K", displayUnit="degC")
    "Measured condenser outlet"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput TEvaOutMea(unit="K", displayUnit="degC")
    "Measured evaporator outlet"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PEleMea(unit="W")
    "Measured electrical power consumption"
    annotation (Placement(transformation(extent={{100,-78},{120,-58}})));
  Modelica.Blocks.Interfaces.RealOutput PEleSim(unit="W")
    "Simulated electrical power consumption"
    annotation (Placement(transformation(extent={{100,-102},{120,-82}})));
  Modelica.Blocks.Interfaces.RealOutput TConOutSim(unit="K", displayUnit="degC")
    "Simulated condenser outlet"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput TEvaOutSim(unit="K", displayUnit="degC")
    "Simulated evaporator outlet"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Sources.RealExpression reaPEle(y=heaPum.refCyc.PEle)
    "Use of internal heat pump state for PEle"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression reaTEvaOut(y=heaPum.eva.T)
    "Use of internal heat pump state for TEvaOut"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Modelica.Blocks.Sources.RealExpression reaTConOut(y=heaPum.con.T)
    "Use of internal heat pump state for TConOut"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation

  connect(souSidMasFlowSou.ports[1], heaPum.port_a2) annotation (Line(points={{-20,-72},
          {32,-72},{32,-36.8},{21,-36.8}},           color={0,127,255}));
  connect(heaPum.port_b2, souSidFixBou.ports[1]) annotation (Line(points={{0,-36.8},
          {-8,-36.8},{-8,-37},{-22,-37}},color={0,127,255}));
  connect(heaPum.port_b1, sinSidFixBou.ports[1]) annotation (Line(points={{21,
          -24.2},{36,-24.2},{36,-24},{40,-24}},
                                     color={0,127,255}));
  connect(heaPum.port_a1, sinSidMasFlowSou.ports[1]) annotation (Line(points={{0,-24.2},
          {0,-24},{-4,-24},{-4,0},{-20,0}},   color={0,127,255}));
  connect(mEva_flow.y, souSidMasFlowSou.m_flow_in)
    annotation (Line(points={{-59,-50},{-50,-50},{-50,-64},{-42,-64}},
                                                             color={0,0,127}));
  connect(sinSidMasFlowSou.m_flow_in, mCon_flow.y)
    annotation (Line(points={{-42,8},{-59,8}},         color={0,0,127}));
  connect(tabMea.y[5], mEva_flow.u) annotation (Line(points={{-69,80},{-54,80},
          {-54,26},{-88,26},{-88,-50},{-82,-50}}, color={0,0,127}));
  connect(tabMea.y[7], mCon_flow.u) annotation (Line(points={{-69,80},{-54,80},
          {-54,26},{-88,26},{-88,8},{-82,8}},
                             color={0,0,127}));
  connect(tabMea.y[6], heaPum.ySet) annotation (Line(points={{-69,80},{-54,80},
          {-54,26},{-12,26},{-12,-28},{-1.155,-28},{-1.155,-28.505}},
                                                color={0,0,127}));
  connect(tabMea.y[9], souSidMasFlowSou.T_in) annotation (Line(points={{-69,80},
          {-54,80},{-54,26},{-88,26},{-88,-68},{-42,-68}}, color={0,0,127}));
  connect(sinSidMasFlowSou.T_in, tabMea.y[1]) annotation (Line(points={{-42,4},
          {-54,4},{-54,80},{-69,80}},          color={0,0,127}));
  connect(tabMea.y[2], TConOutMea)
    annotation (Line(points={{-69,80},{22,80},{22,90},{110,90}},
                                                 color={0,0,127}));
  connect(tabMea.y[8], TEvaOutMea) annotation (Line(points={{-69,80},{92,80},{92,
          10},{110,10}}, color={0,0,127}));
  connect(tabMea.y[3], PEleMea) annotation (Line(points={{-69,80},{92,80},{92,-68},
          {110,-68}}, color={0,0,127}));
  connect(reaPEle.y, PEleSim) annotation (Line(points={{61,-90},{82,-90},{82,
          -92},{110,-92}}, color={0,0,127}));
  connect(TEvaOutSim, reaTEvaOut.y)
    annotation (Line(points={{110,-10},{81,-10}}, color={0,0,127}));
  connect(TConOutSim, reaTConOut.y)
    annotation (Line(points={{110,70},{81,70}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
<p>
  Partial model for the validation of different modular heat pump approaches
  based on measured data of a brine-to-water heat pump at the Institute for
  Energy Efficient Building and Indoor Climate.</p>
<p>
  If questions regarding the data or model
  arises, please raise an issue and link FWuellhorst.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialValidation;
