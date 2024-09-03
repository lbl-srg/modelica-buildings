within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model TimeGeometric
  "Test case for geometric expansion of time vector"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Duration dt=2.0 "Minimum time step";
  parameter Modelica.Units.SI.Time t_max=20.0 "Maximum value of time";
  parameter Integer nTim = 5 "Number of time values";

  final parameter Modelica.Units.SI.Time[nTim] t(each fixed=false)
    "Time vector";

initial equation
  t = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.timeGeometric(
    dt=dt,
    t_max=t_max,
    nTim=nTim);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/TimeGeometric.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    Documentation(info="<html>
<p>
This example demonstrates the construction of vector of geometrically expanding
time values.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end TimeGeometric;
