within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block SpeedSelect
  "Selects the lower specified speed ratio for multispeed model"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nSpe(min=1) "Number of standard compressor speeds";
  parameter Real speSet[nSpe] "Array of standard compressor speeds";
  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput speRat "Standard speed ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  final parameter Real speRatNor[nSpe](each min=0, max=1)=
    {speSet[i]/speSet[nSpe] for i in 1:nSpe}
    "Array of normalized speed ratios for the compressor";

algorithm
 assert(stage >= 0 and stage <= nSpe, "Compressor speed is out of range.
  Model has " + String(nSpe) + " speeds, but received control signal " +
  String(stage));
 speRat :=if stage == 0 then 0 else speRatNor[stage];
  annotation (defaultComponentName="speSel",Documentation(info="<html>
<p>
This blocks outputs the normalized speed of the compressor,
whereas the highest stage is assigned a normalized speed of one,
and all other stages are proportional to their actual speed.
  </p>
</html>",
revisions="<html>
<ul>
<li>
September 5, 2012 by Michael Wetter:<br>
Reimplemented model to use integer input as a control signal.
</li>
<li>
August 29, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={            Line(
          points={{-86,-64},{-26,-64},{-26,-26},{-10,-26},{-10,18},{14,18},{14,58},
              {84,58}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Diagram(graphics));
end SpeedSelect;
