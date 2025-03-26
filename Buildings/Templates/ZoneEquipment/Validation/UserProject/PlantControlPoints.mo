within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block PlantControlPoints
  "Emulation of control points from plant"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nZon = 2
    "Number of served zones";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1PlaHeaWat[nZon](
    each k=true) "Heating hot water plant status"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Interfaces.Bus busTer[nZon]
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));
equation

  connect(y1PlaHeaWat.y, busTer.y1PlaHeaWat) annotation (Line(points={{22,0},{
          200,0}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="sigPla",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})),
    Documentation(info="<html>
<p>
This class generates signals typically provided by the HHW and CHW plant
controller.
It is aimed for validation purposes only.
</p>
</html>"));
end PlantControlPoints;
