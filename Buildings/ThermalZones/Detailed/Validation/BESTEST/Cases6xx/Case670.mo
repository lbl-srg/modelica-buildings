within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case670 "Case 600, but has single pane window with clear glass"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
   redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win670 window600(
     UFra=3,
     haveExteriorShade=false,
     haveInteriorShade=false),
    staRes(
     annualHea(Min=5.300*3.6e9, Max=6.140*3.6e9, Mean=5.681*3.6e9),
     annualCoo(Min=-5.954*3.6e9, Max=-6.623*3.6e9, Mean=-6.402*3.6e9),
     peakHea(Min=3.655*1000, Max=4.221*1000, Mean=3.943*1000),
     peakCoo(Min=-5.839*1000, Max=-6.925*1000, Mean=-6.445*1000)));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case670.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the case 670 of the BESTEST validation suite. Case 670 differs from
case 600 in that it has single pane window with clear glass.
</p>
</html>"));
end Case670;
