within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Validation;
model Borefield
  "Validation of the base subsystem model with geothermal borefield"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Integer nBorHol=100
    "Number of boreholes (must be a square number)";
  parameter Modelica.SIunits.Distance dxy=6
    "Distance in x-axis (and y-axis) between borehole axes";
  final parameter Modelica.SIunits.Distance cooBor[nBorHol,2]=.Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.computeCoordinates(
    nBorHol,
    dxy)
    "Coordinates of boreholes";
  Generation5.Subsystems.Borefield borFie(
    redeclare final package Medium=Medium,
    final datBorFie=datBorFie,
    dp_nominal=5E4,
    TBorWatEntMax=313.15)
    "Subsystem with heat recovery chiller"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Fluid.Sources.Boundary_pT conWat(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Condenser water boundary conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-40,-2})));
  Fluid.Sensors.TemperatureTwoPort senTInl(
    redeclare final package Medium=Medium,
    m_flow_nominal=borFie.pum.m_flow_nominal)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-10,20})));
  Fluid.Sensors.TemperatureTwoPort senTOut(
    redeclare final package Medium=Medium,
    m_flow_nominal=borFie.pum.m_flow_nominal)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-10,-20})));
  parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie(
    conDat=Fluid.Geothermal.Borefields.Data.Configuration.Example(
      cooBor=cooBor,
      dp_nominal=0))
    "Borefield design data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.TimeTable TInlVal(
    y(
      final unit="K",
      displayUnit="degC"),
    table=[
      0,2;
      2,2;
      3,15;
      7,15;
      9,35;
      10,45;
      11,30;
      20,30],
    timeScale=1000,
    offset=273.15)
    "Inlet temperature values"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp u(
    duration=1000,
    startTime=2500)
    "Control signal"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
equation
  connect(senTInl.port_b,conWat.ports[1])
    annotation (Line(points={{-20,20},{-30,20},{-30,0}},color={0,127,255}));
  connect(conWat.ports[2],senTOut.port_a)
    annotation (Line(points={{-30,-4},{-30,-20},{-20,-20}},color={0,127,255}));
  connect(senTInl.port_a,borFie.port_a)
    annotation (Line(points={{0,20},{20,20},{20,0},{40,0}},color={0,127,255}));
  connect(borFie.port_b,senTOut.port_b)
    annotation (Line(points={{60,0},{80,0},{80,-20},{0,-20}},color={0,127,255}));
  connect(TInlVal.y,conWat.T_in)
    annotation (Line(points={{-89,0},{-70,0},{-70,2},{-52,2}},color={0,0,127}));
  connect(zer.y,borFie.yValIso_actual[2])
    annotation (Line(points={{-88,40},{30,40},{30,5},{38,5}},color={0,0,127}));
  connect(u.y,borFie.u)
    annotation (Line(points={{-88,80},{32,80},{32,8},{38,8}},color={0,0,127}));
  connect(u.y,borFie.yValIso_actual[1])
    annotation (Line(points={{-88,80},{32,80},{32,3},{38,3}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-100},{100,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Generation5/Subsystems/Validation/Borefield.mos" "Simulate and plot"),
    experiment(
      StopTime=20000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Borefield\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Subsystems.Borefield</a>.
</p>
</html>"));
end Borefield;
