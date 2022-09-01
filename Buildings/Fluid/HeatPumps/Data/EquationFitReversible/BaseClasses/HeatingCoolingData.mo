within Buildings.Fluid.HeatPumps.Data.EquationFitReversible.BaseClasses;

record HeatingCoolingData "Record for performance data that are used for heating and cooling separately"
  parameter Modelica.Units.SI.HeatFlowRate Q_flow
   "Nominal capacity"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.Units.SI.Power P
  "Nominal compressor power"
    annotation (Dialog(group="Nominal conditions at load heat exchanger side"));
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow
   "Nominal mass flow rate at load heat exchanger side";
  parameter Modelica.Units.SI.MassFlowRate mSou_flow
   "Nominal mass flow rate at source heat exchanger side";
  parameter Real coeQ[5]
   "Load ratio coefficients"
    annotation (Dialog(group="Performance coefficients"));
  parameter Real coeP[5]
   "Power ratio coefficients"
    annotation (Dialog(group="Electrical power performance coefficients"));
  parameter Modelica.Units.SI.Temperature TRefLoa
   "Reference temperature used to normalize the load heat exchanger inlet water temperature"
    annotation (Dialog(group="Reference conditions"));
  parameter Modelica.Units.SI.Temperature TRefSou
   "Reference temperature used to normalize the source heat exchanger inlet water temperature"
    annotation (Dialog(group="Reference conditions"));
  annotation (
     defaultComponentPrefixes="parameter",
     Documentation(info="<html>
<p>
Performance data for the heating or cooling mode of the reverse heat pump
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 16, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3009\">issue 3009</a>.
</li>
</ul>
</html>"));
end HeatingCoolingData;
