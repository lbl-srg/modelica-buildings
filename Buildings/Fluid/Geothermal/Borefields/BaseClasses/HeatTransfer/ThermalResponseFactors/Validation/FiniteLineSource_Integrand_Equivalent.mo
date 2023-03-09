within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource_Integrand_Equivalent
  "Test case for finite line source integrand function for equivalent boreholes"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.ThermalDiffusivity aSoi=1.0e-6
    "Ground thermal diffusivity";
  parameter Modelica.Units.SI.Distance[2] dis={7.0, 7.0*sqrt(2)}
    "Radial distance between borehole axes";
  parameter Integer[2] wDis={4, 2}
    "Number of occurences of each distance";
  parameter Modelica.Units.SI.Height len1=150.0 "Length of emitting sources";
  parameter Modelica.Units.SI.Height burDep1=4.0
    "Buried depth of emitting sources";
  parameter Modelica.Units.SI.Height len2=150.0 "Length of receiving lines";
  parameter Modelica.Units.SI.Height burDep2=4.0
    "Buried depth of receiving lines";
  parameter Integer nBor2=3 "Number of receiving lines";
  parameter Integer n_dis=2 "Number of unique distances";

  Real u "Integration variable";
  Real yRea "Finite line source integrand (Real part)";
  Real yMir "Finite line source integrand (Mirror part)";
  Real y "Finite line source integrand";

equation
  u = time;
  yRea =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent(
    u=u,
    dis=dis,
    wDis=wDis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2,
    n_dis=n_dis,
    includeMirrorSource=false);
  yMir =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent(
    u=u,
    dis=dis,
    wDis=wDis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2,
    n_dis=n_dis,
    includeRealSource=false);
  y =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand_Equivalent(
    u=u,
    dis=dis,
    wDis=wDis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2,
    n_dis=n_dis);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource_Integrand_Equivalent.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.01, StopTime=1.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
finite line source integrand for equivalent boreholes. The solution is evaluated
for the interactions between 3 interacting boreholes on a right triangle pattern
with coordinates (x,y) = {(0,0), (0,7), (7,0)}.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_Integrand_Equivalent;
