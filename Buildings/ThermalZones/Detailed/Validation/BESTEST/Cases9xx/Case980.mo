within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case980
  "Case 900, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900(
    matExtWal = extWalCase980,
    roof =    roofCase680,
    staRes(
     annualHea(Min=0.246*3.6e9, Max=0.720*3.6e9, Mean=0.407*3.6e9),
     annualCoo(Min=-3.501*3.6e9, Max=-3.995*3.6e9, Mean=-3.710*3.6e9),
     peakHea(Min=1.254*1000, Max=1.693*1000, Mean=1.489*1000),
     peakCoo(Min=-2.930*1000, Max=-3.668*1000, Mean=-3.348*1000)),
   heaCri(LowerLimit=-0.61*3.6e9, UpperLimit=1.28*3.6e9),
   cooCri(LowerLimit=-3.52*3.6e9, UpperLimit=-4.49*3.6e9));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase980 extWalCase980(
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,20},{74,34}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680
    "Roof"
    annotation (Placement(transformation(extent={{80,20},{94,34}})));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case980.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the case 980 of the BESTEST validation suite. Case 980 differs from
case 900 in that it has increased exterior wall and roof insulation.
</p>
</html>"));
end Case980;
