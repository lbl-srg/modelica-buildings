within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
model PartialStaticTwoPortCoolingTowerWetBulb
  "Partial test model for cooling tower with wet bulb temperature as potential for heat transfer"
  import Buildings;
  extends PartialStaticTwoPortCoolingTower(exp(redeclare package Medium =
          Medium_W));
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulTem(
                                                        redeclare package
      Medium = Medium_A) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}}, rotation=0)));
equation
  connect(weaBus.relHum, wetBulTem.Xi[1]) annotation (Line(
      points={{-60,50},{-42.5,50},{-42.5,50},{-21,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.pAtm, wetBulTem.p) annotation (Line(
      points={{-60,50},{-50,50},{-50,42},{-21,42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, wetBulTem.TDryBul) annotation (Line(
      points={{-60,50},{-50,50},{-50,58},{-21,58}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(graphics));
end PartialStaticTwoPortCoolingTowerWetBulb;
