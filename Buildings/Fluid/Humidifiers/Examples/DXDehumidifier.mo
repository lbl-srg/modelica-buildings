within Buildings.Fluid.Humidifiers.Examples;
model DXDehumidifier
  "Example model for DX dehumidifier"

  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  Buildings.Fluid.Humidifiers.DXDehumidifier dxDeh(
    redeclare package Medium = Medium,
    final m_flow_nominal=0.1,
    final dp_nominal=0,
    final per=per)
    "DX dehumidifier instance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Ramp TIn(
    final duration=7200,
    final height=1,
    final offset=273.15 + 25,
    final startTime=7200)
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-90,-6},{-70,14}})));

  Modelica.Fluid.Sources.MassFlowSource_T sou(
    final use_T_in=true,
    redeclare package Medium = Medium,
    final use_X_in=false,
    final m_flow=0.1,
    final use_m_flow_in=false,
    final nPorts=1)
    "Flow source"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));

  Buildings.Fluid.Humidifiers.Examples.Data.DXDehumidifier per
    "Data record for DX dehumidifier"
    annotation (Placement(transformation(extent={{40,62},{60,82}})));

  Modelica.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium,
    final nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));

  Modelica.Blocks.Sources.BooleanStep on(
    final startTime=7200,
    final startValue=true)
    "Enable signal"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

equation
  connect(TIn.y, sou.T_in)
    annotation (Line(points={{-69,4},{-48,4}}, color={0,0,127}));

  connect(dxDeh.port_a, sou.ports[1])
    annotation (Line(points={{-10,0},{-26,0}},color={0,127,255}));
  connect(on.y, dxDeh.uEna) annotation (Line(points={{-29,-40},{-18,-40},{-18,-5},
          {-11,-5}}, color={255,0,255}));
  connect(sin1.ports[1], dxDeh.port_b)
    annotation (Line(points={{62,0},{10,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=14400, __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Examples/DXDehumidifier.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>
    This is an example model for the zone air DX dehumidifier model with simple 
    inputs.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    June 20, 2023, by Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end DXDehumidifier;
