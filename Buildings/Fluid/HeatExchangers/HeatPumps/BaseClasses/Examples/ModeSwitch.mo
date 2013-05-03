within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model ModeSwitch "Test model for ModeSwitch"
  import Buildings;

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable intTab(table=[0,0; 1,1; 2,2])
    "Stage change"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSwitch
    modSwi annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Constant heaInp(final k=1) "Heating mode input"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Constant cooInp(final k=-1) "Cooling mode input"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation

  connect(intTab.y, modSwi.mod) annotation (Line(
      points={{-19,10},{-2,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaInp.y, modSwi.hea) annotation (Line(
      points={{-19,50},{-12,50},{-12,18},{-2,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooInp.y, modSwi.coo) annotation (Line(
      points={{-19,-30},{-12,-30},{-12,2},{-2,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ModeSwitch.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of   
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSwitch\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSwitch</a>. 
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
end ModeSwitch;
