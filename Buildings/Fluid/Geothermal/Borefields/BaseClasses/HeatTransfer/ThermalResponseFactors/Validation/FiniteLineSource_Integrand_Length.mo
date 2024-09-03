within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource_Integrand_Length
  "Test case for finite line source integrand function"
  extends Modelica.Icons.Example;

  parameter Real dis_over_len = 0.0005 "Radial distance between borehole axes";
  parameter Modelica.Units.SI.Height len150=150.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height len75=75.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height len25=25.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height len5=5.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height len1=1.0 "Length of emitting borehole";
  parameter Modelica.Units.SI.Height burDep=4.
    "Buried depth of emitting borehole";
  Real u "Integration variable";
  Real logy150 "Logarithm of finite line source integrand";
  Real logy75 "Logarithm of finite line source integrand";
  Real logy25 "Logarithm of finite line source integrand";
  Real logy5 "Logarithm of finite line source integrand";
  Real logy1 "Logarithm of finite line source integrand";

equation
  u = time;
  logy150 = log10(max(Modelica.Constants.small,
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      u=u,
      dis=dis_over_len*len150,
      len1=len150,
      burDep1=burDep,
      len2=len150,
      burDep2=burDep)));
  logy75 = log10(max(Modelica.Constants.small,
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      u=u,
      dis=dis_over_len*len75,
      len1=len75,
      burDep1=burDep,
      len2=len75,
      burDep2=burDep)));
  logy25 = log10(max(Modelica.Constants.small,
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      u=u,
      dis=dis_over_len*len25,
      len1=len25,
      burDep1=burDep,
      len2=len25,
      burDep2=burDep)));
  logy5 = log10(max(Modelica.Constants.small,
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      u=u,
      dis=dis_over_len*len5,
      len1=len5,
      burDep1=burDep,
      len2=len5,
      burDep2=burDep)));
  logy1 = log10(max(Modelica.Constants.small,
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_Integrand(
      u=u,
      dis=dis_over_len*len1,
      len1=len1,
      burDep1=burDep,
      len2=len1,
      burDep2=burDep)));

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource_Integrand_Length.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.01, StopTime=500.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of the
finite line source integrand function.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2019, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_Integrand_Length;
