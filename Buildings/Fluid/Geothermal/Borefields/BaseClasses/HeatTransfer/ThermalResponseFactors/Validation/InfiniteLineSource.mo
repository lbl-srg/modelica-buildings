within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model InfiniteLineSource "Test case for infinite line source"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.ThermalDiffusivity aSoi=1.0e-6
    "Ground thermal diffusivity";
  parameter Modelica.Units.SI.Radius rSource=0.075 "Minimum radius";
  parameter Modelica.Units.SI.Radius[5] r={rSource,2*rSource,5*rSource,10*
      rSource,20*rSource} "Radial position of evaluation of the solution";
  Modelica.Units.SI.Time t "Time";
  Real[5] E "Infinite line source solution";

equation

  t = exp(time) - 1.0;

  for k in 1:5 loop
    E[k] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.infiniteLineSource(t, aSoi, r[k]);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/InfiniteLineSource.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
infinite line source solution.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end InfiniteLineSource;
