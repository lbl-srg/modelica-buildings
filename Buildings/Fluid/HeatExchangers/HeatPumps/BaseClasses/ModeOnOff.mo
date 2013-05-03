within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block ModeOnOff "Switches on and off specific modes"
  extends Modelica.Blocks.Interfaces.BlockIcon;
    Modelica.Blocks.Interfaces.IntegerOutput heaOn "Heating mode on-off signal"
annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.IntegerInput mode(final min=0) "Mode of operation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput cooOn "Cooling mode on-off signal"
annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
algorithm
//  assert((mode=>0 and mode<=2), "Mode of operation input can only be 0: off, 1: heating mode, 2: cooling mode.");
  heaOn :=if mode == 1 then 1 else  0;
  cooOn :=if mode == 2 then 2 else  0;
  annotation (defaultComponentName="modSel", Diagram(graphics), Documentation(info="<html>
<p>
This block is used in multi-stage heat pump models for example 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWaterHP.MultiStage\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWaterHP.MultiStage</a>. 
Multi stage heat pump has two control signals one 
for heating mode and one for cooling mode operation. 
This block takes both signals as input and selects mode based on the input signal. 
Only one input stage signal can operate the heat pump at a time, 
this block takes care of this issue by passing only one control signal forward.
At output mode of operation is given out and for <i>mode</i> = 0 heat pump is off, 
<i>mode</i> = 1 indicates heating 
and <i>mode</i> = 2 indicates cooling operation. 
The stage output is then given to  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SpeedSelect</a> 
which converts the stage input into speed ratio.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 14, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics), Diagram(graphics));
end ModeOnOff;
