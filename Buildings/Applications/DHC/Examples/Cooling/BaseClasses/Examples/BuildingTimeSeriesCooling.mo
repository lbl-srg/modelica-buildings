within Buildings.Applications.DHC.Examples.Cooling.BaseClasses.Examples;
model BuildingTimeSeriesCooling
  "Example for testing the building model with prescribed cooling load profile"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.Power Q_flow_nominal=-50E3
    "Nominal heat flow rate, negative";

  parameter Modelica.SIunits.Power QCooLoa[:, :]= [0, -20E3; 6, -30E3; 12, -50E3; 18, -30E3; 24, -20E3]
    "Cooling load table matrix, negative";


  Buildings.Applications.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesCooling
    bui(
    redeclare package Medium = Medium,
    Q_flow_nominal=Q_flow_nominal,
    TSetDisRet(displayUnit="K"),
    mDis_flow_nominal=0.5,
    mByp_flow_nominal=0.01,
    tableOnFile=false,
    QCooLoa=QCooLoa)     "Building model"
    annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));

  Buildings.Fluid.Sources.Boundary_pT watSin(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1) "Water sink"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));

  Buildings.Fluid.Sources.Boundary_pT watSou(
    redeclare package Medium = Medium,
    p=350000,
    T=280.15,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));

  inner Modelica.Fluid.System system
    "System properties and default values"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(watSou.ports[1], bui.port_a) annotation (Line(points={{40,-30},{-12,-30},
          {-12,-4},{-20,-4}}, color={0,127,255}));
  connect(bui.port_b, watSin.ports[1]) annotation (Line(points={{-20,2},{-12,2},
          {-12,30},{40,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Examples/Cooling/BaseClasses/Examples/BuildingTimeSeriesCooling.mos"
        "Simulate and Plot"));
end BuildingTimeSeriesCooling;
