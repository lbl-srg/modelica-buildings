within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.Merkel.BaseClasses;
record UACorrection "UA correction factors for Merkel cooling towers"
  extends Modelica.Icons.Record;

  parameter Real cAirFra[4]={1.0, 0.0, 0.0, 0.0}
    "Polynomial coefficients for the air flow rate correction";
  parameter Real cWatFra[4]={1.0, 0.0, 0.0, 0.0}
    "Polynomial coefficients for the water flow rate correction";
  parameter Real cDifWB[4]={1.0, 0.0, 0.0, 0.0}
    "Polynomial coefficients for the differential wet bulb temperature correction";
  parameter Real FRAirMin(min=0, max=1) = 0.2
    "Minimum fraction of design air flow rate";
  parameter Real FRAirMax(min=0, max=1) = 1.2
    "Maximum fraction of design air flow rate";
  parameter Real FRWatMin(min=0, max=1) = 0.2
    "Minimum fraction of design water flow rate";
  parameter Real FRWatMax(min=0, max=1) = 1.2
    "Maximum fraction of design water flow rate";
  parameter Modelica.Units.SI.TemperatureDifference TDiffWBMin=-5
    "Minimum differential wet bulb temperature";
  parameter Modelica.Units.SI.TemperatureDifference TDiffWBMax=+10
    "Maximum differential wet bulb temperature";

  annotation(
    defaultComponentName="UACor",
    defaultComponentPrefixes="parameter",
    Documentation(
      info="<html>
<p>
Record with UA correction factors for Merkel's cooling tower model.
</p>
<p>
These correction factors are used in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.Merkel.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.Merkel.Merkel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 24, 2026, by Michael Wetter:<br/>
Moved from
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.UAMerkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.UAMerkel</a>
and renamed to <code>UACorrection</code>.
</li>
<li>
April 10, 2025, by Antoine Gautier and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end UACorrection;
