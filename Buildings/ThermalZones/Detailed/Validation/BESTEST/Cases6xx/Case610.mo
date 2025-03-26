within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case610 "Case 600 with south shading"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
  roo(
     datConExtWin(
      ove(
        wR={0.5},
        wL={0.5},
        dep={1},
        gap={0.5}))),
   staRes(
    annualHea(Min=4.066*3.6e9, Max=4.592*3.6e9, Mean=4.311*3.6e9),
    annualCoo(Min=-4.117*3.6e9, Max=-4.382*3.6e9, Mean=-4.256*3.6e9),
    peakHea(Min=3.021*1000, Max=3.360*1000, Mean=3.168*1000),
    peakCoo(Min=-5.331*1000, Max=-6.432*1000, Mean=-5.861*1000)),
   heaCri(lowerLimit=3.61*3.6e9, upperLimit=5.27*3.6e9),
   cooCri(lowerLimit=-2.74*3.6e9, upperLimit=-6.03*3.6e9));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case610.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(
    info="<html>
<p>
This model is the case 610 of the BESTEST validation suite.
Case 610 differs from case 600 in that the window has an overhang.
</p>
<h4>Implementation</h4>
<p>
Two overhangs have been added, one for each window, because
each window only sees its own overhang.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
<li>
March 25, 2015, by Michael Wetter:<br/>
Corrected <code>wR={4.5,0.5}</code> and <code>wL={0.5,4.5}</code>
to <code>wR={0.5}</code> and <code>wL={0.5}</code>
as there is only one overhang.
</li>
<li>
July 6, 2012, by Michael Wetter:<br/>
Changed implementation to extend from Case 600, rather
than copying Case 600.
This better shows what is different relative to Case 600
as it avoid duplicate code.
</li>
<li>
May 1, 2012, by Kaustubh Phalak:<br/>
Modified the Case 600 for implementation of Case 610.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation of Case 600.
</li>
</ul>
</html>"));
end Case610;
