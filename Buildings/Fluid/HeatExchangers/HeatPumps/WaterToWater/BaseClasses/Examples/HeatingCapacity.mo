within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.Examples;
model HeatingCapacity "Test model for HeatingCapacity"

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
    height=1,
    offset=1,
    startTime=1800) "Stage change"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity
    heaCap(heaMod=heaMod) "Calculates heating capacity"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.HeatingMode
    heaMod(
    m1_flow_nominal=1.89,
    m2_flow_nominal=1.89,
    nSta=2,
    heaPer={Data.BaseClasses.HeatingPerformance(
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
              heaP={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378})})
            annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant rho[4](k={985,990,980,980}) "Density"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(intSte.y,heaCap. mode) annotation (Line(
      points={{1,70},{20,70},{20,20},{39,20}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(TInVol1.y,heaCap. T1) annotation (Line(
      points={{-59,70},{-30,70},{-30,14},{39,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol1_flow.y,heaCap. m1_flow) annotation (Line(
      points={{-59,30},{-40,30},{-40,11},{39,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TInVol2.y,heaCap. T2) annotation (Line(
      points={{-59,-10},{-40,-10},{-40,8},{39,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mVol2_flow.y,heaCap. m2_flow) annotation (Line(
      points={{-59,-50},{-30,-50},{-30,5},{39,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rho.y, heaCap.rho) annotation (Line(
      points={{1,-50},{20,-50},{20,2},{39,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/WaterToWater/BaseClasses/Examples/HeatingCapacity.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity</a>. 
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
end HeatingCapacity;
