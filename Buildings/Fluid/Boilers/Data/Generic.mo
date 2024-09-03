within Buildings.Fluid.Boilers.Data;
record Generic "Generic data record for boiler performance"
  extends Modelica.Icons.Record;

  parameter Real effCur[:,:]=
    [0, 1; 1, 1]
    "Efficiency curves as a table: First row = inlet temp(K), First column = firing rates or PLR";
  final parameter Modelica.Units.SI.Efficiency eta_nominal=
      Buildings.Utilities.Math.Functions.smoothInterpolation(
      x=TIn_nominal,
      xSup=effCur[1, 2:end],
      ySup=effCur[end, 2:end]) "Efficiency at TIn_nominal";
  parameter Modelica.Units.SI.Temperature TIn_nominal=323.15
    "Nominal inlet temperature for efficiency calculations";

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  parameter Modelica.Units.SI.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.Units.SI.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.Units.SI.Volume VWat=1.5E-6*Q_flow_nominal
    "Water volume of boiler";
  parameter Modelica.Units.SI.Mass mDry=1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=3000
    "Pressure drop at m_flow_nominal";

  annotation (
  defaultComponentName="per",
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
This record is used as a template for performance data
for the boiler model
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>.
</p>
<p>
Note that if the parameter <code>fue</code> is for the upper (or lower) heating value of the fuel,
then the effiency curve must be specified for the upper (or lower) heating value.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2021 by Hongxiang Fu:<br/>
First implementation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end Generic;
