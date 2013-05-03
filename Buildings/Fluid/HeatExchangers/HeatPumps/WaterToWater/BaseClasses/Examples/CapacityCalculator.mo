within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.Examples;
model CapacityCalculator "Test model for CapacityCalculator"
   extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CapacityCalculator
    capCal(datHP=datHP)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 60,0; 900,1; 1800,2;
        2700,1]) "Mode change"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TInVol1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 15) "Vol1 inlet temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp mVol1_flow(
    height=1,
    offset=0,
    duration=2400,
    startTime=900) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp TInVol2(
    startTime=600,
    height=5,
    duration=1200,
    offset=273.15 + 20) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Ramp mVol2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=2) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 600,0.25; 1200,0.8; 1800,
        1; 2400,0.8; 3000,0.25; 3600,0]) "Speed ratio "
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Data.HPData datHP(cooMod(
      nSta=2,
      m1_flow_nominal=1.89,
      m2_flow_nominal=1.89,
      cooPer={
          Data.BaseClasses.CoolingPerformance(
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
          cooP={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665})}),
      heaMod(
      nSta=2,
      m1_flow_nominal=1.89,
      m2_flow_nominal=1.89,
      heaPer={
          Data.BaseClasses.HeatingPerformance(
          spe=1200,
          QHea_flow_nominal=39040.92,
          PHea_nominal=5130,
          heaCap={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
          heaP={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378}),
          Data.BaseClasses.HeatingPerformance(
          spe=2400,
          QHea_flow_nominal=2*39040.92,
          PHea_nominal=2*5130,
          heaCap={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
          heaP={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378})}))
    "Heat  pump data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.Constant rho[4](k={985,990,980,980}) "Density"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation

  connect(mVol2_flow.y, capCal.m2_flow) annotation (Line(
      points={{-39,-90},{-20,-90},{-20,5},{19,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol2.y, capCal.T2) annotation (Line(
      points={{-39,-50},{-26,-50},{-26,8},{19,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol1_flow.y, capCal.m1_flow) annotation (Line(
      points={{-39,-10},{-32,-10},{-32,11},{19,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol1.y, capCal.T1) annotation (Line(
      points={{-39,30},{-32,30},{-32,14},{19,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y, capCal.speRat) annotation (Line(
      points={{-39,70},{-26,70},{-26,18},{19,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTab.y, capCal.mode) annotation (Line(
      points={{1,70},{8,70},{8,20},{19,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(rho.y, capCal.rho) annotation (Line(
      points={{11,-30},{14,-30},{14,2},{19,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToWater/BaseClasses/Examples/CapacityCalculator.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of   
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CapacityCalculator\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CapacityCalculator</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 07, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end CapacityCalculator;
