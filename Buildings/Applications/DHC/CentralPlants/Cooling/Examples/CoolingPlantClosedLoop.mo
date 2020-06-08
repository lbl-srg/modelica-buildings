within Buildings.Applications.DHC.CentralPlants.Cooling.Examples;
model CoolingPlantClosedLoop "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate";

  Fluid.FixedResistances.Pipe pip(
    redeclare package Medium=Medium,
    m_flow_nominal=mCHW_flow_nominal,
    nSeg=1,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100) "Distribution pipe"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final
      computeWetBulbTemperature=true, filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Plant                                                  pla(
    perChi=perChi,
    perCHWPum=perCHWPum,
    perCWPum=perCWPum,
    mCHW_flow_nominal=mCHW_flow_nominal,
    dpCHW_nominal=dpCHW_nominal,
    QEva_nominal=QEva_nominal,
    mMin_flow=mMin_flow,
    mCW_flow_nominal=mCW_flow_nominal,
    dpCW_nominal=dpCW_nominal,
    TAirInWB_nominal=298.7,
    TCW_nominal=308.15,
    dT_nominal=5.56,
    TMin=288.15,
    PFan_nominal=5000,
    dpCHWPum_nominal=dpCHWPum_nominal,
    dpCWPum_nominal=dpCWPum_nominal,
    tWai=tWai,
    TCHWSet=TCHWSet,
    dpSetPoi=dpSetPoi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "District cooling plant"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Applications.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesCooling
    bui "Building with cooling load"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
equation
  connect(pip.port_a, cooPla.port_b) annotation (Line(points={{20,-20},{8,-20},{
          8,5},{0,5}}, color={0,127,255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,-30},{-50,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(on.y, cooPla.on) annotation (Line(points={{-39,50},{-30,50},{-30,18},
          {-22,18}},color={255,0,255}));
  connect(weaBus.TWetBul, pla.TWetBul) annotation (Line(
      points={{-50,-30},{-30,-30},{-30,2},{-22,2}},
      color={255,204,51},
      thickness=0.5));
  connect(pip.port_b, bui.port_a) annotation (Line(points={{40,-20},{50,-20},{
          50,4},{60,4}}, color={0,127,255}));
  connect(bui.port_b, pla.port_a) annotation (Line(points={{60,10},{50,10},{50,
          15},{0,15}}, color={0,127,255}));
  connect(pla.dpMea, bui.dp) annotation (Line(points={{-22,10},{-68,10},{-68,68},
          {54,68},{54,14},{59,14}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=15552000,
      StopTime=15638400,
      Tolerance=1e-06));
end CoolingPlantClosedLoop;
