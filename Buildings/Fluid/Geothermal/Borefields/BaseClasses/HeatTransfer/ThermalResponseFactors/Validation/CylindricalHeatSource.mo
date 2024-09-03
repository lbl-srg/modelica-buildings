within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model CylindricalHeatSource "Test case for cylindrical heat source"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.ThermalDiffusivity aSoi=1.0e-6
    "Ground thermal diffusivity";
  parameter Modelica.Units.SI.Radius rSource=0.075 "Radius of cylinder source";
  parameter Modelica.Units.SI.Radius[5] r={rSource,2*rSource,5*rSource,10*
      rSource,20*rSource} "Radial position of evaluation of the solution";
  Modelica.Units.SI.Time t "Time";
  Real[5] G "Cylindrical heat source solution";

equation
  t = exp(time) - 1.0;
  for k in 1:5 loop
    G[k] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource(
      t = t,
      aSoi = aSoi,
      dis = r[k],
      rBor = rSource);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/CylindricalHeatSource.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
cylindrical heat source solution.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end CylindricalHeatSource;
