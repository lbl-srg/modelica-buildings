within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.Examples;
model HeatFlow "Test model for HeatFlow"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp TInVol1(
    startTime=600,
    duration=1200,
    height=15,
    offset=273.15 + 15) "Medium1 inlet temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp mVol1_flow(
    height=1,
    offset=0,
    duration=2400,
    startTime=900) "Medium1 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Ramp TInVol2(
    startTime=600,
    height=5,
    duration=1200,
    offset=273.15 + 20) "Medium2 inlet temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Ramp mVol2_flow(
    startTime=600,
    offset=0,
    duration=2400,
    height=2) "Medium2 mass flow rate"
    annotation (Placement(transformation(extent={{-80,-98},{-60,-78}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatFlow
    heaFlo(datHP=datHP) "Calculates heat flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 100,0.0; 900,0.2;
        1800,0.8; 2700,0.75; 3600,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
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
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 60,0; 900,1; 1800,2;
        2700,1]) "Mode change"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Constant rho[4](k={985,990,980,980}) "Density"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(mVol2_flow.y,heaFlo. m2_flow) annotation (Line(
      points={{-59,-88},{-38,-88},{-38,-5},{39,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol2.y,heaFlo. T2) annotation (Line(
      points={{-59,-50},{-44,-50},{-44,-2},{39,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol1_flow.y,heaFlo. m1_flow) annotation (Line(
      points={{-59,-10},{-48,-10},{-48,1},{39,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol1.y,heaFlo. T1) annotation (Line(
      points={{-59,30},{-52.5,30},{-52.5,4},{39,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat.y,heaFlo. speRat) annotation (Line(
      points={{-59,70},{-40,70},{-40,7},{39,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTab.y, heaFlo.mode) annotation (Line(
      points={{1,70},{20,70},{20,10},{39,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(rho.y, heaFlo.rho) annotation (Line(
      points={{1,-50},{20,-50},{20,-8},{39,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToWater/BaseClasses/Examples/HeatFlow.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatFlow\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatFlow</a>. 
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
end HeatFlow;
