within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model ModeOnOff "Test model for ModeOnOff"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 1,1; 2,2; 3,0; 4,2; 5,
        1]) "Mode change"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeOnOff modOnOff
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation

  connect(intTab.y, modOnOff.mode)
                                 annotation (Line(
      points={{-19,6.10623e-16},{-11.5,6.10623e-16},{-11.5,6.66134e-16},{-2,
          6.66134e-16}},
      color={255,127,0},
      smooth=Smooth.None));

  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ModeOnOff.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeOnOff\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeOnOff</a>. 
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
end ModeOnOff;
