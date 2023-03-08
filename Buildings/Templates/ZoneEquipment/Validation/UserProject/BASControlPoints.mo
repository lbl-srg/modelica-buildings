within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block BASControlPoints "Emulation of control points from the BAS"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nZon = 2
    "Number of served zones";

  Interfaces.Bus busTer[nZon]
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));
  Controls.OBC.CDL.Logical.Sources.Constant y1OccSch[nZon](
    each k=true)
    "Scheduled occupancy"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Controls.OBC.CDL.Integers.Sources.Constant yOveFloSet[nZon](each k=0)
    "Override flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Controls.OBC.CDL.Logical.Sources.Constant y1OveHeaOff[nZon](
    each k=false)
    "Override heating coil valve position, true: close valve"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Controls.OBC.CDL.Integers.Sources.Constant yOveDamPos[nZon](each k=0)
    "Override damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaOccSet[nZon](
    each k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonCooOccSet[nZon](
    each k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaUnoSet[nZon](
    each k=285.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TZonCooUnoSet[nZon](
    each k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant ppmCO2Set[nZon](
    each k=1000)
    "Zone CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
equation
  connect(y1OccSch.y, busTer.y1OccSch);
  connect(yOveFloSet.y, busTer.yOveFloSet);
  connect(yOveDamPos.y, busTer.yOveDamPos);
  connect(y1OveHeaOff.y, busTer.y1OveHeaOff);

  connect(TZonHeaOccSet.y, busTer.TZonHeaOccSet);
  connect(TZonCooOccSet.y, busTer.TZonCooOccSet);
  connect(TZonHeaUnoSet.y, busTer.TZonHeaUnoSet);
  connect(TZonCooUnoSet.y, busTer.TZonCooUnoSet);
  connect(ppmCO2Set.y, busTer.ppmCO2Set);
  annotation (
    defaultComponentName="sigBAS",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})),
    Documentation(info="<html>
<p>
This class generates signals typically provided by the BAS.
It is aimed for validation purposes only.
</p>
</html>"));
end BASControlPoints;
