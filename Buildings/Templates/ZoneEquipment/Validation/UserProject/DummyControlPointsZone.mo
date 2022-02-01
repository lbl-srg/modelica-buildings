within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block DummyControlPointsZone
  "Control points from zone-level equipment"
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
  Controls.OBC.CDL.Continuous.Sources.Constant TAirZonHeaOccSet(k=293.15)
                "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirZonCooOccSet(k=297.15)
                "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirZonHeaUnoSet(k=285.15)
                "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirZonCooUnoSet(k=303.15)
                "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirZon(k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
equation
  connect(uOcc.y, bus.uOcc);
  connect(uWin.y, bus.uWin);
  connect(TAirZonHeaOccSet.y, bus.TAirZonHeaOccSet);
  connect(TAirZonCooOccSet.y, bus.TAirZonCooOccSet);
  connect(TAirZonHeaUnoSet.y, bus.TAirZonHeaUnoSet);
  connect(TAirZonCooUnoSet.y, bus.TAirZonCooUnoSet);
  connect(TAirZon.y, bus.TAirZon);

  annotation (
    defaultComponentName="conPoiDum",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsZone;
