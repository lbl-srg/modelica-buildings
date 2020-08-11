within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Controls.Validation;
model HeatingSystemControl
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Power QPla_flow_nominal=300E3
    "Nominal heating power of plant";

  Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Controls.HeatingSystemControl
    con(QPla_flow_nominal=QPla_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea1(
    table=[0,200E3; 6,200E3; 6,50E3; 18,50E3; 18,75E3; 24,75E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea2(
    table=[0,100E3; 6,100E3; 6,50E3; 18,50E3; 18,75E3; 24,75E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(QHea1.y[1], con.QBld_flow[1]) annotation (Line(points={{-59,30},{-40,30},
          {-40,0},{-10,0}}, color={0,0,127}));
  connect(QHea2.y[1], con.QBld_flow[2]) annotation (Line(points={{-59,-30},{-40,
          -30},{-40,0},{-10,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingSystemControl;
