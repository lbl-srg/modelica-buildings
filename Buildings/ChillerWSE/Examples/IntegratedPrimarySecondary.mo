within Buildings.ChillerWSE.Examples;
model IntegratedPrimarySecondary
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimarySecondary"
  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenter(
    redeclare Buildings.ChillerWSE.IntegratedPrimarySecondary chiWSE(
        addPowerToMedium=false, perPum=perPum));

  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.cooMod > 1.5
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(y=chiWSE.port_a2.m_flow*4180*
        (chiWSE.wseCHWST - CHWSTSet.y))     "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
  SpeedControlledPumpParallel secPum "Secondary pumps" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={72,-26})));
equation

  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{11,40},{40,40},{40,35},
          {124.4,35}}, color={0,0,127}));
  connect(CHWRT.port_a, ahu.port_b1) annotation (Line(
      points={{224,0},{232,0},{232,-86},{172,-86}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.wseCHWST, cooModCon.wseCHWST) annotation (Line(points={{147,36},
          {260,36},{260,200},{-150,200},{-150,106},{-132,106}}, color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-52,144}}, color={0,0,127}));
  connect(CHWST.port_b, secPum.port_a)
    annotation (Line(points={{84,0},{72,0},{72,-16}}, color={0,127,255}));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(points={{72,-36},{72,-86},{152,-86}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
  __Dymola_Commands(file=
  "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimaryLoadSide.mos"
        "Simulate and Plot"));
end IntegratedPrimarySecondary;
