within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.BaseClasses;
record UACorrection "UA correction factors for Merkel cooling towers"
  extends Modelica.Icons.Record;

  parameter Real r_nominal(min=0)=0.5
    "Ratio between air-side and water-side convective heat transfer coefficient"
          annotation(Dialog(tab="General", group="Nominal condition"));

  parameter Real n_w(min=0, max=1)=0.85
    "Water-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Real n_a(min=0, max=1)=0.8
    "Air-side exponent for convective heat transfer coefficient, h~m_flow^n";

  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean airSideFlowDependent = true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean waterSideTemperatureDependent = true
    "Set to false to make water-side hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean airSideTemperatureDependent = true
    "Set to false to make air-side hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);

  annotation (
  defaultComponentName="UACor",
    Documentation(info="<html>
<p>
This data record specifies parameters for the flow and temperature
correction of the convective heat transfer coefficients used in the
model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler\">
Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 24, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end UACorrection;
