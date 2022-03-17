within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block ZoneControlPoints "Emulation of control points from zone sensors and thermostats"
  extends Modelica.Blocks.Icons.Block;

  Interfaces.Bus                 bus "AHU control bus" annotation (Placement(
        transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOcc(k=true)
    "Occupancy sensor status"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Controls.OBC.CDL.Logical.Sources.Constant uWin(k=true)
    "Window swirtch status"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaOccSet(k=293.15)
    "Occupied heating set point"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonCooOccSet(k=297.15)
     "Occupied cooling set point"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaUnoSet(k=285.15)
     "Unoccupied heating set point"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonCooUnoSet(k=303.15)
    "Unoccupied cooling set point"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZon(k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
equation
  connect(uOcc.y, bus.uOcc);
  connect(uWin.y, bus.uWin);
  connect(TZonHeaOccSet.y, bus.TZonHeaOccSet);
  connect(TZonCooOccSet.y, bus.TZonCooOccSet);
  connect(TZonHeaUnoSet.y, bus.TZonHeaUnoSet);
  connect(TZonCooUnoSet.y, bus.TZonCooUnoSet);
  connect(TZon.y, bus.TZon);

  annotation (
    defaultComponentName="conPoiDum",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end ZoneControlPoints;
