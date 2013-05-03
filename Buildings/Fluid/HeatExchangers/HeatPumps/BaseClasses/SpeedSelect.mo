within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block SpeedSelect
  "Selects the lower specified speed ratio for multispeed model"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nHeaSta(min=1)
    "Number of standard compressor speeds in heating mode";
  parameter Real heaSpeSet[nHeaSta]
    "Array of standard compressor speeds in heating mode";
  parameter Integer nCooSta(min=1)
    "Number of standard compressor speeds in cooling mode";
  parameter Real cooSpeSet[nCooSta]
    "Array of standard compressor speeds in cooling mode";

//  Integer nSta "Number of standard compressor speeds";
  // parameter Real speSet[nSta] "Array of standard compressor speeds";

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput speRat "Standard speed ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
protected
  final parameter Real cooSpeRatNor[nCooSta](each min=0, max=1)=
    {cooSpeSet[i]/cooSpeSet[nCooSta] for i in 1:nCooSta}
    "Array of normalized speed ratios for the compressor";
  final parameter Real heaSpeRatNor[nHeaSta](each min=0, max=1)=
    {heaSpeSet[i]/heaSpeSet[nHeaSta] for i in 1:nHeaSta}
    "Array of normalized speed ratios for the compressor";
//  Real speRatNor[nSta] "Array of normalized speed ratios for the compressor";

algorithm
//   if mode ==1 then
//     nSta=nHeaSta ;
//   elseif mode==2 then
//     nSta=nCooSta;
//   else
//     nSta=1;
//   end if;
//
//   if mode ==1 then
//     speRatNor[nSta]:=heaSpeRatNor[nHeaSta];
//   else
//     speRatNor[nSta]:=cooSpeRatNor[nCooSta];
//   end if;

  if mode ==1 then
   assert(stage >= 0 and stage <= nHeaSta,
    "XCompressor speed is out of range.
    Model has " + String(nHeaSta) + " speeds, but received control signal " +
    String(stage));
   speRat :=if stage == 0 then 0 else heaSpeRatNor[stage];
  else
   assert(stage >= 0 and stage <= nCooSta,
    "YCompressor speed is out of range.
    Model has " + String(nCooSta) + " speeds, but received control signal " +
    String(stage));
   speRat :=if stage == 0 then 0 else cooSpeRatNor[stage];
  end if;
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
