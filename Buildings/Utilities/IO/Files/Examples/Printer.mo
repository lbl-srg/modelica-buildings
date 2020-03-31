within Buildings.Utilities.IO.Files.Examples;
model Printer "Test model for printer"
  extends Modelica.Icons.Example;
  Buildings.Utilities.IO.Files.Printer pri1(
    header="time ramp",
    nin=2,
    samplePeriod=0.1)            annotation (Placement(transformation(extent={{-20,40},
            {0,60}})));
  Modelica.Blocks.Sources.ContinuousClock clo
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp ram(duration=2)
                                   annotation (Placement(transformation(extent=
            {{-80,0},{-60,20}})));
  Buildings.Utilities.IO.Files.Printer pri2(
    header="time ramp",
    nin=2,
    configuration=2,
    samplePeriod=0.1)            annotation (Placement(transformation(extent={{
            -20,0},{0,20}})));
  Buildings.Utilities.IO.Files.Printer pri3(
    header="time ramp",
    nin=2,
    configuration=3,
    samplePeriod=0.1)            annotation (Placement(transformation(extent={{
            -20,-40},{0,-20}})));
equation
  connect(clo.y, pri1.x[1]) annotation (Line(points={{-59,50},{-40,50},{-40,49},
          {-22,49}}, color={0,0,127}));
  connect(ram.y, pri1.x[2]) annotation (Line(points={{-59,10},{-40,10},{-40,51},
          {-22,51}}, color={0,0,127}));
  connect(clo.y, pri2.x[1]) annotation (Line(points={{-59,50},{-40,50},{-40,9},
          {-22,9}}, color={0,0,127}));
  connect(ram.y, pri2.x[2]) annotation (Line(points={{-59,10},{-40,10},{-40,11},
          {-22,11}}, color={0,0,127}));
  connect(clo.y, pri3.x[1]) annotation (Line(points={{-59,50},{-40,50},{-40,-31},
          {-22,-31}}, color={0,0,127}));
  connect(ram.y, pri3.x[2]) annotation (Line(points={{-59,10},{-40,10},{-40,-29},
          {-22,-29}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/Printer.mos"
        "Simulate and plot"));
end Printer;
