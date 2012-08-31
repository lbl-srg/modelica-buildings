within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model DryWetPredictor "Test model for DryWetPredictor"

extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp XADP(
    duration=20,
    startTime=20,
    height=-0.002,
    offset=0.006) "Mass fraction at ADP"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Ramp XIn(
    startTime=20,
    height=0.002,
    offset=0.004,
    duration=20) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor dryWetPre
    "Predicts dry-wet coil condition"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(XIn.y, dryWetPre.XIn) annotation (Line(
      points={{-19,30},{-10,30},{-10,5},{-1,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XADP.y, dryWetPre.XADP) annotation (Line(
      points={{-19,-30},{-10,-30},{-10,-5},{-1,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/DryWetPredictor.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DryWetPredictor block 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetPredictor</a>. 
</p>
</html>",
revisions="<html>
<ul>
<li>
August 29, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end DryWetPredictor;
