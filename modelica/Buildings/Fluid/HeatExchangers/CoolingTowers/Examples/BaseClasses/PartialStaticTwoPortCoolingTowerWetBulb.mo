within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
model PartialStaticTwoPortCoolingTowerWetBulb
  "Partial test model for cooling tower with wet bulb temperature as potential for heat transfer"
  import Buildings;
  extends PartialStaticTwoPortCoolingTower;
 package Medium_A = Buildings.Media.PerfectGases.MoistAir;
    Modelica.Blocks.Sources.Constant phi(k=0.5) "Relative air humidity" 
      annotation (Placement(transformation(extent={{0,80},{20,100}}, rotation=0)));
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulTem(
                                                        redeclare package
      Medium = Medium_A) "Model for wet bulb temperature" 
    annotation (Placement(transformation(extent={{-20,40},{0,60}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure" 
      annotation (Placement(transformation(extent={{-60,40},{-40,60}}, rotation=
           0)));
equation
  connect(PAtm.y, wetBulTem.p) 
    annotation (Line(points={{-39,50},{-19,50}}, color={0,0,127}));
  connect(TOut.y, wetBulTem.TDryBul) annotation (Line(points={{-39,90},{-30,90},
          {-30,58},{-19,58}}, color={0,0,127}));
  connect(phi.y, wetBulTem.phi) annotation (Line(points={{21,90},{38,90},{38,57},
          {-1,57}}, color={0,0,127}));
  annotation (Diagram(graphics));
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(points={{-1,50},{6,50},
          {6,20},{-28,20},{-28,-46},{-20,-46}}, color={0,0,127}));
end PartialStaticTwoPortCoolingTowerWetBulb;
