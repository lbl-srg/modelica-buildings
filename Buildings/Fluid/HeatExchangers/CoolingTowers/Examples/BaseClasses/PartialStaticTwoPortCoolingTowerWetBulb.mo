within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
model PartialStaticTwoPortCoolingTowerWetBulb
  "Partial test model for cooling tower with wet bulb temperature as potential for heat transfer"
  extends PartialStaticTwoPortCoolingTower;

  package Medium_A = Buildings.Media.Air "Medium model for air";

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulTem(
    redeclare package Medium = Medium_A) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
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
  connect(weaBus.relHum, wetBulTem.phi) annotation (Line(
      points={{-60,50},{-21,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -260},{140,100}}),
                      graphics));
end PartialStaticTwoPortCoolingTowerWetBulb;
