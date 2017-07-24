within Buildings.ChillerWSE.BaseClasses;
record FourPortResistanceChillerWSE
  "Flow resistance model for the chiller and WSE package"

  parameter Boolean computeFlowResistance1 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dp1 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance1,
                tab="Flow resistance", group="Medium 1"));
  parameter Modelica.SIunits.PressureDifference dpChiller1_nominal(
    min=0,displayUnit="Pa")
    "Pressure difference on medium 1 side in the chillers"
    annotation(Dialog(group = "Chiller"));
  parameter Modelica.SIunits.PressureDifference dpWSE1_nominal(
    min=0,displayUnit="Pa")
    "Pressure difference on medium 1 side in the watersie economizer"
    annotation(Dialog(group = "Waterside economizer"));
  parameter Boolean linearizeFlowResistance1 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance1,
               tab="Flow resistance", group="Medium 1"));
  parameter Real deltaM1 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance1,
                      tab="Flow resistance", group="Medium 1"));
  parameter Boolean computeFlowResistance2 = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));

  parameter Boolean from_dp2 = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance2,
                tab="Flow resistance", group="Medium 2"));
  parameter Modelica.SIunits.PressureDifference dpChiller2_nominal(
    min=0,displayUnit="Pa")
    "Pressure difference on medium 2 side in the chillers"
    annotation(Dialog(group = "Chiller"));
  parameter Modelica.SIunits.PressureDifference dpWSE2_nominal(
    min=0,displayUnit="Pa")
    "Pressure difference on medium 2 side in the waterside economizer"
    annotation(Dialog(group = "Waterside economizer"));
  parameter Boolean linearizeFlowResistance2 = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance2,
               tab="Flow resistance", group="Medium 2"));
  parameter Real deltaM2 = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance2,
                      tab="Flow resistance", group="Medium 2"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
This class contains parameters that are used to compute the pressure drop in the 
<a href=\"modelica://Buildings.ChillerWSE\">Buildings.ChillerWSE</a> package.
</html>"));
end FourPortResistanceChillerWSE;
