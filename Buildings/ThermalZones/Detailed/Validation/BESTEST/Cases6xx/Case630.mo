within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case630 "Case 620, but with added overhang and sidefins"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case620(
  roo(
    datConExtWin(
      ove(
        each wR=0.0,
        each wL=0.0,
        each dep=1.0,
        each gap=0.5),
      sidFin(
        each h=0.5,
        each dep=1.0,
        each gap=0.0))),
   staRes(
    annualHea(Min=5.050*3.6e9, Max=6.469*3.6e9, Mean=5.783*3.6e9),
    annualCoo(Min=-2.129*3.6e9, Max=-3.701*3.6e9, Mean=-2.832*3.6e9),
    peakHea(Min=3.592*1000, Max=4.280*1000, Mean=4.006*1000),
    peakCoo(Min=-3.072*1000, Max=-4.116*1000, Mean=-3.626*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case630.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model is case 630 of the BESTEST validation suite.
Case 630 differs from case 620 in that the
windows on the west and east walls have an overhang and side fins.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 7, 2012, by Kaustubh Phalak:<br/>
Extended from case 620 for side fins and overhang.
</li>
</ul>
</html>"));
end Case630;
