within Buildings.Applications.DHC.Examples;
package FirstGeneration "Package with example models of first generation DHC systems"
  extends Modelica.Icons.VariantsPackage;

  model CoolingSystem
    extends Modelica.Icons.Example;
    CentralPlants.Gen1st.Cooling.CoolingPlant                            pla(show_T=
        true)
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    BaseClasses.BuildingTimeSeriesCooling
      bld1(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
    BaseClasses.BuildingTimeSeriesCooling
      bld2(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    BaseClasses.BuildingTimeSeriesCooling
      bld3(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    BaseClasses.BuildingTimeSeriesCooling
      bld4(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
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
    lengthConRet=length)   annotation (Placement(transformation(
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
    lengthConRet=length)   annotation (Placement(transformation(
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
    lengthConRet=length)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-10,74})));
    BaseClasses.BuildingTimeSeriesCooling bld5(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{40,100},{60,120}})));
    BaseClasses.BuildingTimeSeriesCooling bld6(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{40,70},{60,90}})));
    BaseClasses.BuildingTimeSeriesCooling bld7(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    BaseClasses.BuildingTimeSeriesCooling bld8(Q_flow_nominal=QBld_flow_nominal)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
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
    lengthConRet=length)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={110,-6})));
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
    lengthConRet=length)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={110,24})));
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
    lengthConRet=length)   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={110,74})));
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
    Modelica.Blocks.Sources.Pulse QTot(
    amplitude=0.6*cooPla.QEva_nominal,
    period=43200,
    offset=0.2*cooPla.QEva_nominal,
    startTime=21600) "Total district cooling load"
      annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
    Modelica.Blocks.Sources.Constant dpMea(k=0.6*cooPla.dpSetPoi)
      "Measured demand side pressure difference"
      annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
    BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final
      computeWetBulbTemperature=true, filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
      annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
    Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
    BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  equation
    connect(conPla.port_bDisSup,conBld8. port_aDisSup)
      annotation (Line(points={{0,-70},{110,-70},{110,-16}},   color={0,127,255}));
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
      annotation (Line(points={{0,-76},{116,-76},{116,-16}},   color={0,127,255}));
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
      annotation (Line(points={{110,4},{110,14}},           color={0,127,255}));
    connect(conBld7.port_bDisSup,conBld56. port_aDisSup)
      annotation (Line(points={{110,34},{110,64}},
                                                 color={0,127,255}));
    connect(conBld56.port_bDisRet,conBld7. port_aDisRet)
      annotation (Line(points={{116,64},{116,34}},       color={0,127,255}));
    connect(conBld7.port_bDisRet,conBld8. port_aDisRet)
      annotation (Line(points={{116,14},{116,4}},           color={0,127,255}));
    connect(conBld8.port_bCon,bld8. port_a)
      annotation (Line(points={{100,-6},{60,-6}},  color={0,127,255}));
    connect(conBld8.port_aCon,bld8. port_b)
      annotation (Line(points={{100,0},{60,0}},    color={0,127,255}));
    connect(conBld7.port_bCon,bld7. port_a) annotation (Line(points={{100,24},{
          60,24}},              color={0,127,255}));
    connect(bld7.port_b,conBld7. port_aCon)
      annotation (Line(points={{60,30},{100,30}},  color={0,127,255}));
    connect(conBld56.port_bCon,bld6. port_a) annotation (Line(points={{100,74},
          {60,74}},               color={0,127,255}));
    connect(bld6.port_b,conBld56. port_aCon) annotation (Line(points={{60,80},{
          100,80}},               color={0,127,255}));
    connect(conBld56.port_bDisSup,bld5. port_a)
      annotation (Line(points={{110,84},{110,104},{60,104}},
                                                         color={0,127,255}));
    connect(conBld56.port_aDisRet,bld5. port_b)
      annotation (Line(points={{116,84},{116,110},{60,110}},
                                                         color={0,127,255}));
    connect(weaDat.weaBus,weaBus)  annotation (Line(
        points={{-100,-100},{-90,-100}},
        color={255,204,51},
        thickness=0.5));
  connect(weaBus.TWetBul, pla.TWetBul) annotation (Line(
      points={{-90,-100},{-80,-100},{-80,-78},{-62,-78}},
      color={255,204,51},
      thickness=0.5));
  connect(dpMea.y, pla.dpMea) annotation (Line(points={{-99,-70},{-80,-70},{-80,
          -72.8},{-62,-72.8}}, color={0,0,127}));
  connect(QTot.y, pla.QLoa) annotation (Line(points={{-99,-40},{-80,-40},{-80,
          -67.4},{-62,-67.4}}, color={0,0,127}));
  connect(on.y, pla.on) annotation (Line(points={{-99,-10},{-94,-10},{-94,-20},
          {-70,-20},{-70,-62},{-62,-62}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-150,-150},{150,
              150}})));
  end CoolingSystem;
end FirstGeneration;
