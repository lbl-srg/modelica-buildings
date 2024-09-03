within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource "Test case for finite line source"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.ThermalDiffusivity aSoi=1.0e-6
    "Ground thermal diffusivity";
  parameter Modelica.Units.SI.Distance[2] r={0.075,7.0}
    "Radial position of evaluation of the solution";
  parameter Modelica.Units.SI.Height len1=12.5 "Length of emitting source";
  parameter Modelica.Units.SI.Height burDep1=29.0
    "Buried depth of emitting source";
  parameter Modelica.Units.SI.Height[7] len2={12.5,8.0,15.0,14.0,6.0,20.0,3.0}
    "Length of receiving line";
  parameter Modelica.Units.SI.Height[7] burDep2={29.0,25.0,34.0,2.0,32.0,27.0,
      44.0} "Buried depth of receiving line";
  Modelica.Units.SI.Time t "Time";
  Real[2,7] hRea "Finite line source solution (Real part)";
  Real[2,7] hMir "Finite line source solution (Mirror part)";
  Real[2,7] h "Finite line source solution";

equation

  t = exp(time) - 1.0;

  for i in 1:2 loop
    for j in 1:7 loop
        hRea[i,j] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
          t = t,
          aSoi = aSoi,
          dis = r[i],
          len1 = len1,
          burDep1 = burDep1,
          len2 = len2[j],
          burDep2 = burDep2[j],
          includeMirrorSource=false);
        hMir[i,j] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
          t = t,
          aSoi = aSoi,
          dis = r[i],
          len1 = len1,
          burDep1 = burDep1,
          len2 = len2[j],
          burDep2 = burDep2[j],
          includeRealSource=false);
        h[i,j] = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource(
          t = t,
          aSoi = aSoi,
          dis = r[i],
          len1 = len1,
          burDep1 = burDep1,
          len2 = len2[j],
          burDep2 = burDep2[j]);
    end for;
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=20.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
finite line source solution. The solution is evaluated at different positions
and averaged over different lengths around line heat sources.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource;
