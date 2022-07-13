within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case930 "Case 920, but with added overhang and sidefins"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case920(
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
    annualHea(Min=3.524*3.6e9, Max=4.384*3.6e9, Mean=4.064*3.6e9),
    annualCoo(Min=-1.654*3.6e9, Max=-2.161*3.6e9, Mean=-1.898*3.6e9),
    peakHea(Min=2.537*1000, Max=2.968*1000, Mean=2.751*1000),
    peakCoo(Min=-2.335*1000, Max=-3.052*1000, Mean=-2.656*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case930.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model is case 930 of the BESTEST validation suite.
Case 930 differs from case 920 in that the
windows on the west and east walls have an overhang and side fins.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case930;
