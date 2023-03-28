within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data;
record Case600Results "BESTEST comparison results"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Energy EHeaMax=20552400000 "Maximum annual heating load";
  parameter Modelica.Units.SI.Energy EHeaMin=15465600000 "Minimum annaul heating load";
  parameter Modelica.Units.SI.Energy ECooMax=-26200800000 "Maximum annual cooling load";
  parameter Modelica.Units.SI.Energy ECooMin=-22093200000 "Minimum annual cooling load";
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
</html>"));
end Case600Results;
