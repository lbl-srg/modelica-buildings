within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case660
  "Case 600, but with low-emissivity windows with Argon gas"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
   redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Win660 window600(
     UFra=3,
     haveExteriorShade=false,
     haveInteriorShade=false),
    staRes(
     annualHea(Min=3.574*3.6e9, Max=3.821*3.6e9, Mean=3.713*3.6e9),
     annualCoo(Min=-2.966*3.6e9, Max=-3.340*3.6e9, Mean=-3.172*3.6e9),
     peakHea(Min=2.620*1000, Max=2.955*1000, Mean=2.801*1000),
     peakCoo(Min=-3.343*1000, Max=-3.933*1000, Mean=-3.565*1000)));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case660.mos"
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
This model is the case 660 of the BESTEST validation suite. Case 660 differs from
case 600 in that it has low-emissivity windwos with Argon gas.
</p>
</html>"));
end Case660;
