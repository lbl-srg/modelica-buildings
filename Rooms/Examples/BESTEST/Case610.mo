within Buildings.Rooms.Examples.BESTEST;
model Case610 "Case 600 with south shading"
  extends Buildings.Rooms.Examples.BESTEST.Case600(
  roo(
     datConExtWin(
      ove(
        wR={4.5,0.5},
        wL={0.5,4.5},
        each dep=1,
        each gap=0.5))),
   staRes(
    annualHea(Min=4.355*3.6e9, Max=5.786*3.6e9, Mean=5.146*3.6e9),
    annualCoo(Min=-3.915*3.6e9, Max=-5.778*3.6e9, Mean=-4.964*3.6e9),
    peakHea(Min=3.437*1000, Max=4.354*1000, Mean=3.998*1000),
    peakCoo(Min=-5.689*1000, Max=-6.371*1000, Mean=-5.988*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/BESTEST/Case610.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-006),
Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
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
