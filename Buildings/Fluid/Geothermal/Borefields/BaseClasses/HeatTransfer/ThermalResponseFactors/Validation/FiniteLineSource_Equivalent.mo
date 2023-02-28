within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource_Equivalent
  "Test case for finite line source for equivalent boreholes"
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

  Modelica.Units.SI.Time t "Time";
  Real hRea "Finite line source solution (Real part)";
  Real hMir "Finite line source solution (Mirror part)";
  Real h "Finite line source solution";

equation

  t = exp(time) - 1.0;
  hRea =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
    t=t,
    aSoi=aSoi,
    dis=dis,
    wDis=wDis,
    n_dis=n_dis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2,
    includeMirrorSource=false);
  hMir =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
    t=t,
    aSoi=aSoi,
    dis=dis,
    wDis=wDis,
    n_dis=n_dis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2,
    includeRealSource=false);
  h =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Equivalent(
    t=t,
    aSoi=aSoi,
    dis=dis,
    wDis=wDis,
    n_dis=n_dis,
    len1=len1,
    burDep1=burDep1,
    len2=len2,
    burDep2=burDep2,
    nBor2=nBor2);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource_Equivalent.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=20.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
finite line source solution for equivalent boreholes. The solution is evaluated
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
end FiniteLineSource_Equivalent;
