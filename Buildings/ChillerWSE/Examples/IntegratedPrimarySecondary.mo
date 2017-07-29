within Buildings.ChillerWSE.Examples;
model IntegratedPrimarySecondary
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimarySecondary"
  extends Modelica.Icons.Example;
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenterIntegratedWSE(
    redeclare Buildings.ChillerWSE.IntegratedPrimarySecondary chiWSE(
        addPowerToMedium=false, perPum=perPum));

  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.cooMod > 1.5
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Modelica.Blocks.Sources.RealExpression cooLoaChi(y=chiWSE.port_a2.m_flow*4180*
        (chiWSE.wseCHWST - CHWSTSet.y))     "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-130,134},{-110,154}})));
  SpeedControlledPumpParallel secPum(
    redeclare package Medium = MediumW,
    dpValve_nominal=6000,
    per=perPum,
    addPowerToMedium=false,
    m_flow_nominal=mChiller2_flow_nominal)
                                     "Secondary pumps" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={72,-26})));
  BaseClasses.Controls.ConstantSpeedPumpStageControl
    PriPumCon(
             tWai=0) "Chilled water primary pump controller"
    annotation (Placement(transformation(extent={{-92,22},{-72,42}})));
  Modelica.Blocks.Math.Gain gai2[
                                nChi](each k=mChiller2_flow_nominal)
                                                                "Gain effect"
    annotation (Placement(transformation(extent={{-50,22},{-30,42}})));
equation

  connect(yVal5.y, chiWSE.yVal5) annotation (Line(points={{11,40},{40,40},{40,35},
          {124.4,35}}, color={0,0,127}));
  connect(CHWRT.port_a, ahu.port_b1) annotation (Line(
      points={{192,0},{232,0},{232,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.wseCHWST, cooModCon.wseCHWST) annotation (Line(points={{147,36},
          {260,36},{260,200},{-150,200},{-150,106},{-132,106}}, color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot)
    annotation (Line(points={{-109,144},{-52,144}}, color={0,0,127}));
  connect(CHWST.port_b, secPum.port_a)
    annotation (Line(points={{84,0},{72,0},{72,-16}}, color={0,127,255},
      thickness=0.5));
  connect(secPum.port_b, ahu.port_a1)
    annotation (Line(points={{72,-36},{72,-114},{154,-114}},
                                                           color={0,127,255},
      thickness=0.5));
  connect(pumSpeSig.y, secPum.u) annotation (Line(points={{12.8,-14},{40,-14},{
          40,0},{67,0},{67,-15}}, color={0,0,127}));
  connect(chiNumOn.y, PriPumCon.chiNumOn) annotation (Line(points={{-109,74},{
          -102,74},{-102,36},{-94,36}}, color={0,0,127}));
  connect(cooModCon.cooMod, PriPumCon.cooMod) annotation (Line(points={{-109,110},
          {-102,110},{-102,108},{-102,40},{-94,40}},                color={0,0,
          127}));
  connect(PriPumCon.y, gai2.u)
    annotation (Line(points={{-71,32},{-52,32}}, color={0,0,127}));
  connect(gai2.y, chiWSE.m_flow_in) annotation (Line(points={{-29,32},{30,32},{
          30,28.5},{124.5,28.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimarySecondary.mos"
        "Simulate and Plot"));
end IntegratedPrimarySecondary;
