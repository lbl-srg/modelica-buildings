within Buildings.Fluid.HeatPumps.Data.EquationFitReversible;
record Generic
  "Generic data record for reverse water to water heat pump implementing the equation fit method"
  extends Modelica.Icons.Record;

  parameter BaseClasses.HeatingCoolingData hea "Performance data for heating mode";
  parameter BaseClasses.HeatingCoolingData coo(
     mLoa_flow = hea.mLoa_flow,
     mSou_flow = hea.mSou_flow)
   "Performance data for cooling mode (set coo.P = 0 to disable operation in cooling mode)";
  parameter Modelica.Units.SI.PressureDifference dpHeaLoa_nominal(min=0) =
    30000 "Nominal pressure drop at load heat exchanger side at hea.mLoa_flow";
  parameter Modelica.Units.SI.PressureDifference dpHeaSou_nominal(min=0) =
    30000 "Nominal pressure drop at load heat exchanger side at hea.mSou_flow";

  final parameter Boolean reverseCycle=coo.P > Modelica.Constants.eps
    "= true, if the heat pump can be reversed to also operate in cooling mode"
      annotation(Evaluate=true);

annotation (
defaultComponentName="per",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record is used as a template for performance data
for the heat pump model
<a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
</p>
</html>",  revisions="<html>
<ul>
<li>
May 16, 2022, by Michael Wetter:<br/>
Removed <code>protected</code> keyword as the Modelica Language Specification only
allows public sections in a record.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3009\">issue 3009</a>.
</li>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
