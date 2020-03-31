within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource_Integrand
  "Test case for finite line source integrand function"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Distance dis=0.075
    "Radial distance between borehole axes";
  parameter Modelica.Units.SI.Height len1=150.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height burDep1=4.0
    "Buried depth of emitting borehole";
  parameter Modelica.Units.SI.Height len2=150.0 "Length of receiving borehole";
  parameter Modelica.Units.SI.Height burDep2=4.0
    "Buried depth of receiving borehole";
  Real u "Integration variable";
  Real y "Finite line source integrand";

equation
  u = time;
  y = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
    u=u,
    dis=dis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource_Integrand.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.01, StopTime=15.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of the
finite line source integrand function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_Integrand;
