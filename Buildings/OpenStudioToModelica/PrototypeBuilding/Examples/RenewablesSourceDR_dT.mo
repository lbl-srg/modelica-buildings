within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model RenewablesSourceDR_dT
  import Buildings;
  extends RenewableSources(
    bui1(useDeltaTSP=true, use_pfControl=true),
    bui2(useDeltaTSP=true, use_pfControl=true),
    bui3(useDeltaTSP=true, use_pfControl=true),
    bui4(useDeltaTSP=true, use_pfControl=true),
    bui5(useDeltaTSP=true, use_pfControl=true),
    bui6(useDeltaTSP=true, use_pfControl=true),
    bui7(useDeltaTSP=true, use_pfControl=true));
  Buildings.Controls.SetPoints.Table conDR(table=[0.9,2; 0.92,0])
    "Controller for demand response signal"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Modelica.Blocks.Continuous.FirstOrder filV(
    initType=Modelica.Blocks.Types.Init.InitialState,
    T=10,
    k=1,
    y_start=1) "Filter for control input to decouple algebraic system"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
equation
  connect(conDR.y, bui7.dTSp) annotation (Line(points={{241,-70},{250,-70},{250,
          -90},{-110,-90},{-110,72},{220,72},{220,52},{210,52}}, color={0,0,127}));
  connect(bui6.dTSp, conDR.y) annotation (Line(points={{170,52},{180,52},{180,
          72},{-110,72},{-110,-90},{250,-90},{250,-70},{241,-70}}, color={0,0,
          127}));
  connect(bui5.dTSp, conDR.y) annotation (Line(points={{130,52},{136,52},{136,
          54},{140,54},{140,72},{-110,72},{-110,-90},{250,-90},{250,-70},{241,
          -70}}, color={0,0,127}));
  connect(bui4.dTSp, conDR.y) annotation (Line(points={{90,52},{96,52},{96,72},
          {-110,72},{-110,-90},{250,-90},{250,-70},{241,-70}}, color={0,0,127}));
  connect(conDR.y, bui3.dTSp) annotation (Line(points={{241,-70},{250,-70},{250,
          -90},{-110,-90},{-110,72},{58,72},{58,52},{50,52}}, color={0,0,127}));
  connect(conDR.y, bui2.dTSp) annotation (Line(points={{241,-70},{250,-70},{250,
          -90},{-110,-90},{-110,72},{18,72},{18,52},{10,52}}, color={0,0,127}));
  connect(conDR.y, bui1.dTSp) annotation (Line(points={{241,-70},{246,-70},{250,
          -70},{250,-90},{-110,-90},{-110,72},{-22,72},{-22,52},{-30,52}},
        color={0,0,127}));
  connect(sen8.V, filV.u) annotation (Line(points={{207,-13},{210,-13},{210,-40},
          {168,-40},{168,-70},{178,-70}}, color={0,0,127}));
  connect(filV.y, conDR.u) annotation (Line(points={{201,-70},{209.5,-70},{218,
          -70}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            380,100}})),
    experiment(
      StopTime=86400,
      Tolerance=1e-05,
      __Dymola_Algorithm="Radau"),
    __Dymola_experimentSetupOutput);
end RenewablesSourceDR_dT;
