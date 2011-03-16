within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
model PartialStaticTwoPortCoolingTowerWetBulb
  "Partial test model for cooling tower with wet bulb temperature as potential for heat transfer"
  import Buildings;
  extends PartialStaticTwoPortCoolingTower(redeclare
      Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulTem(
                                                        redeclare package
      Medium = Medium_A) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}}, rotation=0)));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-74,40},{-54,60}})));
equation
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(
      points={{1,50},{10,50},{10,-10},{-28,-10},{-28,-46},{-20,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, wetBulTem.TDryBul) annotation (Line(
      points={{-39,90},{-30,90},{-30,58},{-21,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,50},{-64,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.relHum, wetBulTem.Xi[1]) annotation (Line(
      points={{-64,50},{-21,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.pAtm, wetBulTem.p) annotation (Line(
      points={{-64,50},{-50,50},{-50,42},{-21,42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(graphics));
end PartialStaticTwoPortCoolingTowerWetBulb;
