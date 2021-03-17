within Buildings.Templates.TerminalUnits.Validation.UserProject;
block DummyControlPoints
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaOccSet(final k=
        293.15) "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooOccSet(final k=
        297.15) "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaUnoSet(final k=
        285.15) "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooUnoSet(final k=
        303.15) "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  BaseClasses.Connectors.BusTerminalUnit busTer
    "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}),  iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(final k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(final k=15 + 273.15)
    "AHU supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uOpeMod(final k=1)
    "Operating mode"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uHeaDemLimLev(final k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uCooDemLimLev(final k=1)
    "Demand limiter level"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
equation
  connect(TZon.y, busTer.inp.TZon);

  connect(TZonHeaOccSet.y, busTer.sof.TZonHeaOccSet);
  connect(TZonCooOccSet.y, busTer.sof.TZonCooOccSet);
  connect(TZonHeaUnoSet.y, busTer.sof.TZonHeaUnoSet);
  connect(TZonCooUnoSet.y, busTer.sof.TZonCooUnoSet);
  connect(TSupSet.y, busTer.sof.TSupSet);
  connect(uOpeMod.y, busTer.sof.uOpeMod);
  connect(uHeaDemLimLev.y, busTer.sof.uHeaDemLimLev);
  connect(uCooDemLimLev.y, busTer.sof.uCooDemLimLev);

  annotation (
    defaultComponentName="conPoiDum",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPoints;
