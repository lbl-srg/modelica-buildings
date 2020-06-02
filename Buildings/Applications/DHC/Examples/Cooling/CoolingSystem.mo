within Buildings.Applications.DHC.Examples.Cooling;
model CoolingSystem
  extends Modelica.Icons.Example;
  CentralPlants.Cooling.Plant pla(show_T=true)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Networks.Connection1stGen4PipeSections conBld4(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon4Dis_flow_nominal,
    mCon_flow_nominal=mCon4Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=length,
    lengthDisRet=length,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-6})));
  Networks.Connection1stGen4PipeSections conBld3(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon3Dis_flow_nominal,
    mCon_flow_nominal=mCon3Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=1,
    lengthDisRet=1,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,24})));
  Networks.Connection1stGen6PipeSections conBld12(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon12Dis_flow_nominal,
    mCon_flow_nominal=mCon12Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup_a=length,
    lengthDisRet_b=length,
    lengthDisSup_b=length,
    lengthDisRet_a=length,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,74})));
  Networks.Connection1stGen4PipeSections conBld8(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon8Dis_flow_nominal,
    mCon_flow_nominal=mCon8Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=length,
    lengthDisRet=length,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-6})));
  Networks.Connection1stGen4PipeSections conBld7(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon7Dis_flow_nominal,
    mCon_flow_nominal=mCon7Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=1,
    lengthDisRet=1,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,24})));
  Networks.Connection1stGen6PipeSections conBld56(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mCon56Dis_flow_nominal,
    mCon_flow_nominal=mCon56Con_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup_a=length,
    lengthDisRet_b=length,
    lengthDisSup_b=length,
    lengthDisRet_a=length,
    lengthConSup=length,
    lengthConRet=length) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,74})));
  Networks.Connection1stGen2PipeSections conPla(
    redeclare package MediumSup = MediumSte,
    redeclare package MediumRet = MediumWat,
    mDis_flow_nominal=mConPlaDis_flow_nominal,
    mCon_flow_nominal=mConPlaCon_flow_nominal,
    energyDynamics=energyDynamics,
    p_start=pSte,
    T_start=TSte,
    nSeg=nSeg,
    thicknessInsSup=thicknessIns,
    thicknessInsRet=thicknessIns,
    lambdaIns=lambdaIns,
    lengthDisSup=length,
    lengthDisRet=length)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final
      computeWetBulbTemperature=true, filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=8)
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Math.Gain gai(final k=-1)
    "Multiplier to convert cooling load to negative"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
equation
  connect(conPla.port_bDisSup,conBld8. port_aDisSup)
    annotation (Line(points={{0,-70},{90,-70},{90,-16}},     color={0,127,255}));
  connect(pla.port_b,conPla. port_aDisSup)
    annotation (Line(points={{-40,-75},{-30,-75},{-30,-70},{-20,-70}},
                                                     color={0,127,255}));
  connect(conPla.port_bCon,conBld4. port_aDisSup)
    annotation (Line(points={{-10,-60},{-10,-16}},  color={0,127,255}));
  connect(conPla.port_aCon,conBld4. port_bDisRet)
    annotation (Line(points={{-4,-60},{-4,-16}},    color={0,127,255}));
  connect(pla.port_a,conPla. port_bDisRet)
    annotation (Line(points={{-40,-65},{-30,-65},{-30,-76},{-20,-76}},
                                                     color={0,127,255}));
  connect(conPla.port_aDisRet,conBld8. port_bDisRet)
    annotation (Line(points={{0,-76},{96,-76},{96,-16}},     color={0,127,255}));
  connect(conBld4.port_bCon,bld4. port_a)
    annotation (Line(points={{-20,-6},{-60,-6}},   color={0,127,255}));
  connect(conBld4.port_aCon,bld4. port_b)
    annotation (Line(points={{-20,0},{-60,0}},     color={0,127,255}));
  connect(conBld3.port_bCon,bld3. port_a)
    annotation (Line(points={{-20,24},{-60,24}},   color={0,127,255}));
  connect(conBld3.port_aCon,bld3. port_b)
    annotation (Line(points={{-20,30},{-60,30}},   color={0,127,255}));
  connect(conBld12.port_bCon,bld2. port_a)
    annotation (Line(points={{-20,74},{-60,74}}, color={0,127,255}));
  connect(conBld12.port_aCon,bld2. port_b)
    annotation (Line(points={{-20,80},{-60,80}}, color={0,127,255}));
  connect(conBld12.port_bDisSup,bld1. port_a)
    annotation (Line(points={{-10,84},{-10,104},{-60,104}},
                                                          color={0,127,255}));
  connect(conBld12.port_aDisRet,bld1. port_b)
    annotation (Line(points={{-4,84},{-4,110},{-60,110}}, color={0,127,255}));
  connect(conBld4.port_bDisSup,conBld3. port_aDisSup)
    annotation (Line(points={{-10,4},{-10,14}},    color={0,127,255}));
  connect(conBld3.port_bDisSup,conBld12. port_aDisSup)
    annotation (Line(points={{-10,34},{-10,64}}, color={0,127,255}));
  connect(conBld12.port_bDisRet,conBld3. port_aDisRet)
    annotation (Line(points={{-4,64},{-4,34}},            color={0,127,255}));
  connect(conBld3.port_bDisRet,conBld4. port_aDisRet)
    annotation (Line(points={{-4,14},{-4,4}},      color={0,127,255}));
  connect(conBld8.port_bDisSup,conBld7. port_aDisSup)
    annotation (Line(points={{90,4},{90,14}},             color={0,127,255}));
  connect(conBld7.port_bDisSup,conBld56. port_aDisSup)
    annotation (Line(points={{90,34},{90,64}}, color={0,127,255}));
  connect(conBld56.port_bDisRet,conBld7. port_aDisRet)
    annotation (Line(points={{96,64},{96,34}},         color={0,127,255}));
  connect(conBld7.port_bDisRet,conBld8. port_aDisRet)
    annotation (Line(points={{96,14},{96,4}},             color={0,127,255}));
  connect(conBld8.port_bCon,bld8. port_a)
    annotation (Line(points={{80,-6},{40,-6}},   color={0,127,255}));
  connect(conBld8.port_aCon,bld8. port_b)
    annotation (Line(points={{80,0},{40,0}},     color={0,127,255}));
  connect(conBld7.port_bCon,bld7. port_a) annotation (Line(points={{80,24},{40,
          24}},               color={0,127,255}));
  connect(bld7.port_b,conBld7. port_aCon)
    annotation (Line(points={{40,30},{80,30}},   color={0,127,255}));
  connect(conBld56.port_bCon,bld6. port_a) annotation (Line(points={{80,74},{40,
          74}},                 color={0,127,255}));
  connect(bld6.port_b,conBld56. port_aCon) annotation (Line(points={{40,80},{80,
          80}},                 color={0,127,255}));
  connect(conBld56.port_bDisSup,bld5. port_a)
    annotation (Line(points={{90,84},{90,104},{40,104}},
                                                       color={0,127,255}));
  connect(conBld56.port_aDisRet,bld5. port_b)
    annotation (Line(points={{96,84},{96,110},{40,110}},
                                                       color={0,127,255}));
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-100,-100},{-90,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, pla.TWetBul) annotation (Line(
      points={{-90,-100},{-80,-100},{-80,-78},{-62,-78}},
      color={255,204,51},
      thickness=0.5));
  connect(on.y, pla.on) annotation (Line(points={{-99,-10},{-94,-10},{-94,-20},
          {-70,-20},{-70,-62},{-62,-62}}, color={255,0,255}));
  connect(bld5.Q_flow, mulSum.u[1]) annotation (Line(points={{41,118},{112,118},
          {112,31.75},{118,31.75}}, color={0,0,127}));
  connect(bld6.Q_flow, mulSum.u[2]) annotation (Line(points={{41,88},{112,88},{
          112,31.25},{118,31.25}}, color={0,0,127}));
  connect(bld7.Q_flow, mulSum.u[3]) annotation (Line(points={{41,38},{112,38},{
          112,31},{118,31},{118,30.75}}, color={0,0,127}));
  connect(bld8.Q_flow, mulSum.u[4]) annotation (Line(points={{41,8},{112,8},{
          112,30.25},{118,30.25}}, color={0,0,127}));
  connect(bld1.Q_flow, mulSum.u[5]) annotation (Line(points={{-59,118},{12,118},
          {12,50},{112,50},{112,31.5},{118,31.5},{118,29.75}}, color={0,0,127}));
  connect(bld2.Q_flow, mulSum.u[6]) annotation (Line(points={{-59,88},{12,88},{
          12,50},{112,50},{112,31.5},{118,31.5},{118,29.25}}, color={0,0,127}));
  connect(bld3.Q_flow, mulSum.u[7]) annotation (Line(points={{-59,38},{12,38},{
          12,50},{112,50},{112,31.5},{118,31.5},{118,28.75}}, color={0,0,127}));
  connect(bld4.Q_flow, mulSum.u[8]) annotation (Line(points={{-59,8},{12,8},{12,
          50},{112,50},{112,31.5},{118,31.5},{118,28.25}}, color={0,0,127}));
  connect(bld5.dp, pla.dpMea) annotation (Line(points={{41,114},{46,114},{46,
          126},{-130,126},{-130,-72.8},{-62,-72.8}}, color={0,0,127}));
  connect(mulSum.y, gai.u) annotation (Line(points={{142,30},{142,-34},{-126,
          -34},{-126,-50},{-122,-50}}, color={0,0,127}));
  connect(gai.y, pla.QLoa) annotation (Line(points={{-99,-50},{-80,-50},{-80,
          -67.4},{-62,-67.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-150,-150},{150,
            150}})));
end CoolingSystem;
