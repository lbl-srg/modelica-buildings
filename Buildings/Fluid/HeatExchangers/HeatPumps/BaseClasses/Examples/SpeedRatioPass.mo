within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model SpeedRatioPass "Test model for SpeedRatioPass"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.TimeTable heaSpeRat(table=[0,0; 1,0.5; 2,1; 3,0; 4,0;
        5,0; 6,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.TimeTable cooSpeRat(table=[0,0; 1,0; 2,0; 3,0; 4,0.5;
        5,1; 6,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioPass
    speRatPas "Passes the speed ratio depending on the boolean input"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.BooleanStep heaOn(startTime=3, startValue=true)
    "Heating mode on"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.BooleanStep cooOn(startTime=3, startValue=false)
    "Cooling mode on"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation

  connect(heaOn.y, speRatPas.heaModOn) annotation (Line(
      points={{-19,70},{0,70},{0,10},{18,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(heaSpeRat.y, speRatPas.heaSpeRat) annotation (Line(
      points={{-19,30},{-10,30},{-10,4},{18,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat.y, speRatPas.cooSpeRat) annotation (Line(
      points={{-19,-30},{-10,-30},{-10,-4},{18,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooOn.y, speRatPas.cooModOn) annotation (Line(
      points={{-19,-70},{0,-70},{0,-10},{18,-10}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/SpeedRatioPass.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioPass\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioPass</a>. 
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
end SpeedRatioPass;
