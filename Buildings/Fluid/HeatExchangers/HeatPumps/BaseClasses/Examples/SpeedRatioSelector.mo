within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model SpeedRatioSelector "Test model for SpeedRatioSelector"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.TimeTable heaSpeRat(table=[0,0; 1,0.5; 2,1; 3,0; 4,0;
        5,0; 6,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.TimeTable cooSpeRat(table=[0,0; 1,0; 2,0; 3,0; 4,0.5;
        5,1; 6,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioSelector
    speRatSel(cooModMinSpeRat=0.2, heaModMinSpeRat=0.2)
    "Selects speed ratio and decides mode of operation for heat pump"
              annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation

  connect(heaSpeRat.y, speRatSel.heaSpeRat) annotation (Line(
      points={{-19,30},{0,30},{0,5},{18,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat.y, speRatSel.cooSpeRat) annotation (Line(
      points={{-19,-30},{0,-30},{0,-5},{18,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/SpeedRatioSelector.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioSelector\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioSelector</a>. 
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
end SpeedRatioSelector;
