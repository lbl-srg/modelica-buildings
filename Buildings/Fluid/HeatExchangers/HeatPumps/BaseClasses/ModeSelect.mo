within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block ModeSelect "Selects mode from stage input"
  extends Modelica.Blocks.Interfaces.BlockIcon;
    Modelica.Blocks.Interfaces.IntegerOutput mode
    "Mode of operation of heatpump (mode=0: off, mode=1: heating, mode=2: cooling)"
annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.IntegerInput heaSta(final min=0)
    "Heating mode stage"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.IntegerInput cooSta(final min=0)
    "Heating mode stage"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.IntegerOutput stage "Stage of the heat pump"
annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
algorithm
  assert(not (heaSta>0 and cooSta>0), "Only one control input to the heat pump is allowed to be non-zero at a time.");
  mode :=if heaSta > 0 then 1 else if cooSta > 0 then 2 else 0;
  stage:=if mode == 0 then 0 else if mode == 1 then heaSta else cooSta;
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
end ModeSelect;
