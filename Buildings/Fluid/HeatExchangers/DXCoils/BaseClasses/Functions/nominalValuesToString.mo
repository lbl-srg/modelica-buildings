within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions;
function nominalValuesToString
  "Converts the nominal values to a string representation"
  extends Modelica.Icons.Function;
  input
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues
    nomVal "Nominal values";
  output String s "A string representation of the nominal values";
algorithm
 s :="Nominal values:
    Q_flow_nominal = " + String(nomVal.Q_flow_nominal) + "
    COP_nominal    = " + String(nomVal.COP_nominal) + "
    m_flow_nominal = " + String(nomVal.m_flow_nominal) + "
    TEvaIn_nominal = " + String(nomVal.TEvaIn_nominal) + " (= " + String(nomVal.TEvaIn_nominal-273.15) + " degC)
    TConIn_nominal = " + String(nomVal.TConIn_nominal) + " (= " + String(nomVal.TConIn_nominal-273.15) + " degC)
    phiIn_nominal  = " + String(nomVal.phiIn_nominal) + "
    tWet           = " + String(nomVal.tWet) + "
    gamma          = " + String(nomVal.gamma) + "
    p_nominal      = " + String(nomVal.p_nominal) + "
";

  annotation (Documentation(info="<html>
<p>
Returns a string representation of the nominal values.
</p>
</html>", revisions="<html>
<ul>
<li>
October 2, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end nominalValuesToString;
