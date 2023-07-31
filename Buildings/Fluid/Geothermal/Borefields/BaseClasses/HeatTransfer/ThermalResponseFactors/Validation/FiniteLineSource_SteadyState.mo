within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model FiniteLineSource_SteadyState
  "Test case for steady-state solution of the finite line source"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Height len1=150.0 "Length of emitting source";
  parameter Modelica.Units.SI.Height burDep1=4.0
    "Buried depth of emitting source";
  parameter Modelica.Units.SI.Height len2=125.0
    "Length of receiving line";
  parameter Modelica.Units.SI.Height burDep2=3.5
    "Buried depth of receiving line";

  Modelica.Units.SI.Distance dis "Radial distance";
  Real hRea "Finite line source solution (Real part)";
  Real hMir "Finite line source solution (Mirror part)";
  Real h "Finite line source solution";

protected
  constant Real uniCon(unit="m/s") = 1 "Constant to satisify unit check";
equation

  dis = 0.075 + uniCon*time;

  hRea = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState(
    dis = dis,
    len1 = len1,
    burDep1 = burDep1,
    len2 = len2,
    burDep2 = burDep2,
    includeMirrorSource=false);
  hMir = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState(
    dis = dis,
    len1 = len1,
    burDep1 = burDep1,
    len2 = len2,
    burDep2 = burDep2,
    includeRealSource=false);
  h = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState(
    dis = dis,
    len1 = len1,
    burDep1 = burDep1,
    len2 = len2,
    burDep2 = burDep2);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/FiniteLineSource_SteadyState.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=50.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
steady-state finite line source solution. The solution is evaluated at different
distances between the emitting and receiving boreholes.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiniteLineSource_SteadyState;
