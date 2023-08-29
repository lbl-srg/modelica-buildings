within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block ZoneControlPoints "Emulation of control points from zone sensors and thermostats"
  extends Modelica.Blocks.Icons.Block;

  Interfaces.Bus bus
    "Terminal unit control bus"
    annotation (Placement(
        transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1Occ(k=true)
    "Occupancy sensor status"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Controls.OBC.CDL.Logical.Sources.Constant y1Win(k=true)
    "Window switch status"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Controls.OBC.CDL.Reals.Sources.Constant TZon(k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Controls.OBC.CDL.Logical.Sources.Constant y1OveOccZon(
    k=false)
    "Zone occupancy override"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Controls.OBC.CDL.Reals.Sources.Constant ppmCO2(k=1000)
    "Zone CO2 concentration"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

equation
  connect(y1Occ.y, bus.y1Occ);
  connect(y1Win.y, bus.y1Win);
  connect(TZon.y, bus.TZon);
  connect(ppmCO2.y, bus.ppmCO2);
  connect(y1OveOccZon.y, bus.y1OveOccZon);

  annotation (
    defaultComponentName="sigZon",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})),
    Documentation(info="<html>
<p>
This class generates signals typically provided by the zone equipment.
It is aimed for validation purposes only.
</p>
</html>"));
end ZoneControlPoints;
