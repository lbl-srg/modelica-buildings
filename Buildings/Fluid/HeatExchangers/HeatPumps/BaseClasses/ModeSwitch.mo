within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block ModeSwitch "Switches the output depending  upon mode input "
 extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput hea "Heating mode input signal"
                                 annotation (Placement(transformation(extent=
            {{-140,60},{-100,100}}, rotation=0)));
  Modelica.Blocks.Interfaces.IntegerInput mod( min=0,max=2)
    "Mode 0:off, 1:heating, 2:cooling"
                                    annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput coo "Cooling mode input signal"
                                 annotation (Placement(transformation(extent=
            {{-140,-100},{-100,-60}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
                                 annotation (Placement(transformation(extent=
            {{100,-10},{120,10}}, rotation=0)));

equation
  y = if mod==0 then 0 elseif mod==1 then hea else coo;
  annotation (defaultComponentName="modSwi",Diagram(graphics), Documentation(info="<html>
<p>
Heating and cooling inputs are provided at input of this block. 
Depending on the mode input signal heating value, cooling value or 0 is given at output. 
If <i>mode</i> = 0 then heat pump operations is considered to be turned off thus 0 is given as output. 
For <i>mode</i> = 1 heating input value is given at output and for <i>mode</i> = 2 cooling input value is passed on at output. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 09, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"));
end ModeSwitch;
