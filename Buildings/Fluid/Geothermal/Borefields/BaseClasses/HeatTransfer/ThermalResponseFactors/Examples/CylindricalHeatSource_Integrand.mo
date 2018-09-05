within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Examples;
model CylindricalHeatSource_Integrand
  "Test case for cylindrical heat source integrand function"
  extends Modelica.Icons.Example;

  parameter Real Fo = 1.0 "Fourier time";
  parameter Real[4] p = {1, 2, 5, 10} "Ratio of distance over borehole radius";
  Real u "Integration variable";
  Real[4] y "Cylindrical heat source integrand";

equation
  u = time;
  for k in 1:4 loop
    y[k] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource_Integrand(
      u = u,
      Fo = Fo,
      p = p[k]);
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Examples/CylindricalHeatSource_Integrand.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.01, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of the
cylindrical heat source integrand function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end CylindricalHeatSource_Integrand;
