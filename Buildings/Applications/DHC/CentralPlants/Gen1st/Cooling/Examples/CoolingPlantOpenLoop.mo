within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Examples;
model CoolingPlantOpenLoop
  "Example to test the chiller cooling plant"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal chilled water mass flow rate";

  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.CoolingPlant cooPla(
    redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes perChi,
    mCHW_flow_nominal=mCHW_flow_nominal,
    dpCHW_nominal=500000,
    QEva_nominal=-200*3.517*1000,
    mMin_flow=20,
    mCW_flow_nominal=30,
    dpCW_nominal=500000,
    TAirInWB_nominal=288.15,
    TCW_nominal=291.15,
    dT_nominal=5.56,
    TMin=283.15,
    PFan_nominal=4800,
    dpCHWPum_nominal=60000,
    dpCWPum_nominal=100000,
    tWai=30,
    TCHWSet=280.15,
    dpSetPoi=68900) "Cooling plant"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Fluid.Sources.Boundary_pT watSin(          redeclare package Medium=Medium,
      nPorts=1)                                                               "Water sink"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Fluid.FixedResistances.Pipe pip(
    redeclare package Medium=Medium,
    m_flow_nominal=mCHW_flow_nominal,
    nSeg=1,
    thicknessIns=0.01,
    lambdaIns=0.04,
    length=100) "Distribution pipe"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Fluid.Sources.Boundary_pT watSou(nPorts=1, redeclare package Medium=Medium) "Water source"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
  Modelica.Blocks.Sources.Pulse QTot(
    amplitude=0.6*cooPla.QEva_nominal,
    period=43200,
    offset=0.2*cooPla.QEva_nominal,
    startTime=21600)
                   "Total district cooling load"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant dpMea(k=0.6*cooPla.dpSetPoi)
    "Measured demand side pressure difference"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final
      computeWetBulbTemperature=true, filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.BooleanConstant on "On signal of the plant"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(pip.port_b, watSou.ports[1])
    annotation (Line(points={{40,-20},{60,-20}}, color={0,127,255}));
  connect(pip.port_a, cooPla.port_b) annotation (Line(points={{20,-20},{8,-20},{
          8,5},{0,5}}, color={0,127,255}));
  connect(QTot.y, cooPla.QLoa) annotation (Line(points={{-39,30},{-34,30},{-34,12.6},
          {-22,12.6}}, color={0,0,127}));
  connect(dpMea.y, cooPla.dpMea) annotation (Line(points={{-39,-10},{-34,-10},{-34,
          7.2},{-22,7.2}}, color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,-50},{-50,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, cooPla.TWetBul) annotation (Line(
      points={{-50,-50},{-30,-50},{-30,2},{-22,2}},
      color={255,204,51},
      thickness=0.5));
  connect(watSin.ports[1], cooPla.port_a) annotation (Line(points={{60,30},{8,30},
          {8,15},{0,15}}, color={0,127,255}));
  connect(on.y, cooPla.on) annotation (Line(points={{-39,70},{-30,70},{-30,18},{
          -22,18}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=15552000,
      StopTime=15638400,
      Tolerance=1e-06));
end CoolingPlantOpenLoop;
