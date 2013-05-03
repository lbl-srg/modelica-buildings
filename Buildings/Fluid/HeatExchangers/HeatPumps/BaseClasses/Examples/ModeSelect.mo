within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model ModeSelect "Test model for ModeSelect"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.IntegerTable intTabHea(table=[0,0; 1,1; 2,2; 3,0; 4,0;
        5,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSelect
    modSel "Selects mode based on input stages"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.IntegerTable intTabCoo(table=[0,0; 1,0; 2,0; 3,1; 4,2;
        5,0]) "Stage change"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation

  connect(intTabHea.y, modSel.heaSta) annotation (Line(
      points={{-19,30},{-12,30},{-12,4},{-2,4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(intTabCoo.y, modSel.cooSta) annotation (Line(
      points={{-19,-30},{-12,-30},{-12,-4},{-2,-4}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/ModeSelect.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSelect\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSelect</a>. 
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
end ModeSelect;
