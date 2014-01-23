within Districts.Utilities.Reports.Examples;
model Printer "Test model for printer"
  extends Modelica.Icons.Example;
  Districts.Utilities.Reports.Printer pri1(
    header="time ramp",
    nin=2)                       annotation (Placement(transformation(extent={{-20,40},
            {0,60}},         rotation=0)));
  Modelica.Blocks.Sources.Clock clo annotation (Placement(transformation(extent=
           {{-80,40},{-60,60}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp ram annotation (Placement(transformation(extent=
            {{-80,0},{-60,20}}, rotation=0)));
  Districts.Utilities.Reports.Printer pri2(
    header="time ramp",
    nin=2,
    configuration=2)             annotation (Placement(transformation(extent={{
            -20,0},{0,20}}, rotation=0)));
  Districts.Utilities.Reports.Printer pri3(
    header="time ramp",
    nin=2,
    configuration=3)             annotation (Placement(transformation(extent={{
            -20,-40},{0,-20}}, rotation=0)));
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
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Reports/Examples/Printer.mos"
        "Simulate and plot"),
              Diagram);
end Printer;
