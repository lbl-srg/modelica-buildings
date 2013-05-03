within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.Examples;
model CoolingCapacity "Test model for CoolingCapacity"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp TInVol1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 15) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp mVol1_flow(
    height=1,
    offset=0,
    duration=2400,
    startTime=900) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TInVol2(
    startTime=600,
    height=5,
    duration=1200,
    offset=273.15 + 20) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Ramp mVol2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=2) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.IntegerStep intSte(
    offset=1,
    startTime=1800,
    height=1) "Stage change"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity
    cooCap(cooMod=cooMod) "Calculates cooling capacity"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingMode
    cooMod(
    m1_flow_nominal=1.89,
    m2_flow_nominal=1.89,
    nSta=2,
    cooPer={Data.BaseClasses.CoolingPerformance(
              spe=1200,
              Q_flow_nominal=-39890.91,
              P_nominal=4790,
              cooCap={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
              cooP={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665}),
        Data.BaseClasses.CoolingPerformance(
              spe=2400,
              Q_flow_nominal=2*(-39890.91),
              P_nominal=2*4790,
              cooCap={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
              cooP={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665})})
            annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant rho[4](k={985,990,980,980}) "Density"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(intSte.y,cooCap. mode) annotation (Line(
      points={{1,70},{20,70},{20,20},{39,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TInVol1.y,cooCap. T1) annotation (Line(
      points={{-59,70},{-30,70},{-30,14},{39,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol1_flow.y,cooCap. m1_flow) annotation (Line(
      points={{-59,30},{-40,30},{-40,11},{39,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol2.y,cooCap. T2) annotation (Line(
      points={{-59,-10},{-40,-10},{-40,8},{39,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol2_flow.y,cooCap. m2_flow) annotation (Line(
      points={{-59,-50},{-30,-50},{-30,5},{39,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rho.y, cooCap.rho) annotation (Line(
      points={{1,-50},{20,-50},{20,2},{39,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToWater/BaseClasses/Examples/CoolingCapacity.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 12, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end CoolingCapacity;
