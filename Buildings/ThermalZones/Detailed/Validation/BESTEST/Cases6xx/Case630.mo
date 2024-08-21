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
    annualHea(Min=4.356*3.6e9, Max=5.139*3.6e9, Mean=4.821*3.6e9),
    annualCoo(Min=-2.573*3.6e9, Max=-3.074*3.6e9, Mean=-2.814*3.6e9),
    peakHea(Min=3.039*1000, Max=3.388*1000, Mean=3.203*1000),
    peakCoo(Min=-3.526*1000, Max=-4.212*1000, Mean=-3.963*1000)),
   heaCri(lowerLimit=3.69*3.6e9, upperLimit=6.12*3.6e9),
   cooCri(lowerLimit=-1.08*3.6e9, upperLimit=-4.42*3.6e9));

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
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
<li>
July 7, 2012, by Kaustubh Phalak:<br/>
Extended from case 620 for side fins and overhang.
</li>
</ul>
</html>"));
end Case630;
