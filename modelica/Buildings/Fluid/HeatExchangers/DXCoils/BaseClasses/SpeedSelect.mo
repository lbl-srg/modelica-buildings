within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block SpeedSelect
  "Selects the lower specified speed ratio for multispeed model"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput speRatIn "Speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput speRat "Standard speed ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Integer nSpe "Number of standard compressor speeds";
  parameter Real speSet[nSpe] "Array of standard compressor speeds";
protected
  Real speRatSet[nSpe] "Array of standard speed ratio for the compressor";
  Integer i "Integer to select speed index";
algorithm
//fixme
//These if statements causing state events
  for k in 1:nSpe-1 loop
    if (speRatIn >= speRatSet[k])  and (speRatIn < speRatSet[k+1]) then
      i :=k;
    else
      if (speRatIn < speRatSet[1]) then
        i :=1;
      else
        if (speRatIn >= speRatSet[nSpe]) then
          i :=nSpe;
        end if;
      end if;
    end if;
  end for;
equation
  speRatSet*speSet[nSpe]= speSet;
  speRat= speRatSet[i];
  annotation (defaultComponentName="speSel",Documentation(info="<html>
<p>
This block converts continuous speed ratio control signal into stepwise signal using compressor 
standard speeds entered in coil data. This block doesn't let the speed ratio to fall 
below the minimum standard speed ratio (speed ratio corresponding to minimum standard speed 
of the compressor).</p> 
<p align=\"center\" style=\"font-style:italic;\">
  minimum standard speed ratio = minimum standard speed / maximum standard speed 
</p>
<p>
This minimum standard speed ratio is not same as minimum speed ratio. 
Minimum speed ratio is irrespective of standard speeds entered in the coil data and overrides 
minimum standard speed ratio.
  </p>
</html>",
revisions="<html>
<ul>
<li>
August 29, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={Line(
          points={{-88,-86},{-54,-80},{-38,-66},{-32,-48},{-24,-18},{-12,16},{4,
              44},{20,68},{48,84},{76,90},{80,90}},
          color={255,0,0},
          smooth=Smooth.None), Line(
          points={{-86,-64},{-26,-64},{-26,-26},{-10,-26},{-10,18},{14,18},{14,58},
              {84,58}},
          color={0,0,255},
          smooth=Smooth.None)}));
end SpeedSelect;
