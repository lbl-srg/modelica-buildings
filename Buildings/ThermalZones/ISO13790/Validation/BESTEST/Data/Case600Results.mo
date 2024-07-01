within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data;
record Case600Results "BESTEST comparison results"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Energy EHeaMax= 20.5524E+09 "Maximum annual heating load";
  parameter Modelica.Units.SI.Energy EHeaMin= 15.4656E+09 "Minimum annaul heating load";
  parameter Modelica.Units.SI.Energy ECooMax=-26.2008E+09 "Maximum annual cooling load";
  parameter Modelica.Units.SI.Energy ECooMin=-22.0932E+09 "Minimum annual cooling load";
  parameter Modelica.Units.SI.Power PHeaMax=4354 "Maximum peak heating load";
  parameter Modelica.Units.SI.Power PHeaMin=3437 "Minimum peak heating load";
  parameter Modelica.Units.SI.Power PCooMax=-6827 "Maximum peak cooling load";
  parameter Modelica.Units.SI.Power PCooMin=-5965 "Minimum peak cooling load";

  annotation (defaultComponentName="annComBESTEST",Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
BESTEST results for annual heating and cooling loads.
</p>
</html>",
revisions="
<html>
<ul>
<li>
May 8, 2024, by Michael Wetter:<br/>
Changed number format to avoid a warning in Optimica about number to be too large
to be represented as an Integer.
</li>
</ul>
</html>"));
end Case600Results;
