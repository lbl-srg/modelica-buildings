within Buildings.Applications.DHC.Examples.Cooling;
model CoolingSystem
  extends Modelica.Icons.Example;
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
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  BaseClasses.BuildingTimeSeriesCooling bld1
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  BaseClasses.BuildingTimeSeriesCooling bld2
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  BaseClasses.BuildingTimeSeriesCooling bld3
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  BaseClasses.BuildingTimeSeriesCooling bld4
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BaseClasses.BuildingTimeSeriesCooling bld5
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  BaseClasses.BuildingTimeSeriesCooling bld6
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  BaseClasses.BuildingTimeSeriesCooling bld7
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  BaseClasses.BuildingTimeSeriesCooling bld8
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CentralPlants.Cooling.Plant plant
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(conPla.port_bDisSup,conBld8. port_aDisSup)
    annotation (Line(points={{0,-70},{90,-70},{90,-16}},     color={0,127,255}));
  connect(conPla.port_bCon,conBld4. port_aDisSup)
    annotation (Line(points={{-10,-60},{-10,-16}},  color={0,127,255}));
  connect(conPla.port_aCon,conBld4. port_bDisRet)
    annotation (Line(points={{-4,-60},{-4,-16}},    color={0,127,255}));
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
  connect(on.y, pla.on) annotation (Line(points={{-99,-50},{-80,-50},{-80,-62},
          {-62,-62}}, color={255,0,255}));
  connect(plant.dpMea, bld5.dp) annotation (Line(points={{-62,-70},{-130,-70},{
          -130,128},{50,128},{50,114},{41,114}}, color={0,0,127}));
  connect(conPla.port_bDisRet, plant.port_a) annotation (Line(points={{-20,-76},
          {-30,-76},{-30,-65},{-40,-65}}, color={0,127,255}));
  connect(plant.port_b, conPla.port_aDisSup) annotation (Line(points={{-40,-75},
          {-32,-75},{-32,-70},{-20,-70}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-150,-150},{150,
            150}})));
end CoolingSystem;
