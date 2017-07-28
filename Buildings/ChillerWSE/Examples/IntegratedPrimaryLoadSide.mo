within Buildings.ChillerWSE.Examples;
model IntegratedPrimaryLoadSide
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"
  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenter(
    redeclare Buildings.ChillerWSE.IntegratedPrimaryLoadSide chiWSE(
        addPowerToMedium=false, perPum=perPum));

  Modelica.Blocks.Sources.Constant yVal7(k=0) "Conrol signal for valve 7"
    annotation (Placement(transformation(extent={{-52,26},{-32,46}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.cooMod > 1.5
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if cooModCon.cooMod < 0.5
         then 1 else 0) "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(y=chiWSE.port_a2.m_flow*4180*
        (chiWSE.wseCHWST - CHWSTSet.y))     "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
equation

  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{11,40},{40,40},{40,35},
          {124.4,35}}, color={0,0,127}));
  connect(yVal6.y, chiWSE.yVal6) annotation (Line(points={{11,20},{11,20},{40,20},
          {40,31.8},{124.4,31.8}}, color={0,0,127}));
  connect(pumSpeSig.y, chiWSE.yPum) annotation (Line(points={{12.8,-14},{40,-14},
          {40,27.6},{124.4,27.6}}, color={0,0,127}));
  connect(CHWST.port_b, ahu.port_a1) annotation (Line(
      points={{84,0},{72,0},{72,-86},{152,-86}},
      color={0,127,255},
      thickness=0.5));
  connect(CHWRT.port_a, ahu.port_b1) annotation (Line(
      points={{224,0},{232,0},{232,-86},{172,-86}},
      color={0,127,255},
      thickness=0.5));
  connect(yVal7.y, chiWSE.yVal7) annotation (Line(points={{-31,36},{-20,36},{-20,
          10},{40,10},{40,28},{116,28},{116,10},{132.8,10},{132.8,20.4}}, color=
         {0,0,127}));
  connect(chiWSE.wseCHWST, cooModCon.wseCHWST) annotation (Line(points={{147,36},
          {260,36},{260,200},{-150,200},{-150,106},{-132,106}}, color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-52,144}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
  __Dymola_Commands(file=
  "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimaryLoadSide.mos"
        "Simulate and Plot"));
end IntegratedPrimaryLoadSide;
