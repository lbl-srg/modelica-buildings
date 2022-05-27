within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case910 "Case 900, but the window has an overhang"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900(
  roo(
     datConExtWin(
      ove(
        wR={0.5},
        wL={0.5},
        dep={1},
        gap={0.5}))),
   staRes(
    annualHea(Min=1.648*3.6e9, Max=2.163*3.6e9, Mean=1.971*3.6e9),
    annualCoo(Min=-1.191*3.6e9, Max=-1.490*3.6e9, Mean=-1.374*3.6e9),
    peakHea(Min=2.469*1000, Max=2.799*1000, Mean=2.648*1000),
    peakCoo(Min=-2.081*1000, Max=-2.722*1000, Mean=-2.306*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case910.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(
    info="<html>
<p>
This model is the case 910 of the BESTEST validation suite.
Case 910 differs from case 900 in that the window has an overhang.
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
May 18, 2022, by Jianjun Hu:<br/>
First implementation of Case 910.
</li>
</ul>
</html>"));
end Case910;
