within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data;
record Case600FFResults "BESTEST comparison results free-floating"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Temperature TavgMax=299.05 "Maximum average annual air temperature";
  parameter Modelica.Units.SI.Temperature TavgMin=297.35 "Minimum average annual air temperature";
  annotation (defaultComponentName="annComBESTESTFF",Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
BESTEST results for annual heating and cooling loads in free-floating mode.
</p>
</html>"));
end Case600FFResults;
