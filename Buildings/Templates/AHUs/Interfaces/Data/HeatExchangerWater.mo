within Buildings.Templates.AHUs.Interfaces.Data;
record HeatExchangerWater
  extends Modelica.Icons.Record;

  outer parameter String funStr
    "String used to fetch coil parameters";
  outer parameter String id=""
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerWater;
