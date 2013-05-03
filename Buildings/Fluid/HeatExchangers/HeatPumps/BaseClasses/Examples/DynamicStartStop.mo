within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.Examples;
model DynamicStartStop "Test model for DynamicStartStop"
  import Buildings;
extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.TimeTable heaInp(table=[0,0; 100,0; 100,1000; 200,1000;
        200,0; 300,0; 300,1000; 400,1000; 400,0; 800,0])
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop dynStaSto[3](tauOff=
       {50,50,50},
    tauOn={10,10,10},
    each steadyStateOpe=false)
    annotation (Placement(transformation(extent={{58,-10},{78,10}})));
  Modelica.Blocks.Sources.IntegerTable intTab1(table=[0,0; 100,1; 200,0; 300,1;
        400,0; 800,0]) "Heating mode input"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.Blocks.Sources.TimeTable cooInp(table=[0,0; 100,0; 100,-1000; 200,-1000;
        200,0; 300,0; 300,-1000; 400,-1000; 400,0; 800,0]) "Cooling mode input"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Modelica.Blocks.Sources.IntegerTable intTab2(table=[0,0; 100,2; 200,0; 300,2;
        400,0; 800,0]) "Cooling mode input"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.TimeTable heaCooInp(table=[0,0; 100,0; 100,1000; 200,1000;
        200,0; 300,0; 300,-1000; 400,-1000; 400,0; 800,0])
    "Heating and cooling mode input"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Sources.IntegerTable intTab3(table=[0,0; 100,1; 200,0; 300,2;
        400,0; 800,0]) "Heating and cooling mode inputs"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
equation
  connect(intTab1.y, dynStaSto[1].mode)      annotation (Line(
      points={{1,80},{40,80},{40,10},{56,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(intTab2.y, dynStaSto[2].mode)       annotation (Line(
      points={{21,-20},{40,-20},{40,10},{56,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaInp.y, dynStaSto[1].u)     annotation (Line(
      points={{1,40},{48,40},{48,6.66134e-16},{56,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooInp.y, dynStaSto[2].u)     annotation (Line(
      points={{21,-60},{48,-60},{48,6.66134e-16},{56,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intTab3.y, dynStaSto[3].mode)       annotation (Line(
      points={{-39,20},{-20,20},{-20,10},{56,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaCooInp.y, dynStaSto[3].u)  annotation (Line(
      points={{-39,-20},{-20,-20},{-20,6.66134e-16},{56,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/HeatPumps/BaseClasses/Examples/DynamicStartStop.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop\">
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop</a>. 
This example also demostrates how this block will perform in heating cooling and combination of both modes. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 17, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end DynamicStartStop;
