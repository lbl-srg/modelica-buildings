within Buildings.Fluids.Interfaces;
record TwoPortFlowResistanceParameters
  "Parameters for flow resistance for models with two ports"

annotation (Documentation(info="<html>
This class contains parameters that are used to
compute the pressure drop in models that have one fluid stream.
Note that the nominal mass flow rate is not declared here because
the model 
<a href=\"Modelica:Buildings.Fluids.Interfaces.PartialStaticTwoPortInterface\">
PartialStaticTwoPortInterface</a>
already declares it.
</html>",
revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Boolean computeFlowResistance = true
    "=true, compute flow resistance. Set to false to assume no friction" 
    annotation (Evaluate=true, Dialog(tab="Flow resistance"), choices(__Dymola_checkBox=true));

  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                tab="Flow resistance"), choices(__Dymola_checkBox=true));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
    "Pressure"                                annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(enable = computeFlowResistance,
               tab="Flow resistance"), choices(__Dymola_checkBox=true));
  parameter Real deltaM = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar" 
    annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

end TwoPortFlowResistanceParameters;
