within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
model PartialStaticTwoPortCoolingTowerWetBulb
  "Partial test model for cooling tower with wet bulb temperature as potential for heat transfer"
  import Buildings;
  extends PartialStaticTwoPortCoolingTower;
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
    Modelica.Blocks.Sources.Constant Xi(k=0.01) "Water vapor concentration"
      annotation (Placement(transformation(extent={{-92,40},{-72,60}},
                                                                     rotation=0)));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulTem(
                                                        redeclare package
      Medium = Medium_A) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-60,20},{-40,40}}, rotation=
           0)));
equation
  connect(PAtm.y, wetBulTem.p)
    annotation (Line(points={{-39,30},{-30,30},{-30,42},{-21,42}},
                                                 color={0,0,127}));
  connect(Xi.y, wetBulTem.Xi[1]) annotation (Line(
      points={{-71,50},{-21,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(
      points={{1,50},{10,50},{10,-10},{-28,-10},{-28,-46},{-20,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, wetBulTem.TDryBul) annotation (Line(
      points={{-39,90},{-30,90},{-30,58},{-21,58}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end PartialStaticTwoPortCoolingTowerWetBulb;
