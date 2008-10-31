model Printer "Test model for printer" 
  annotation(Diagram, Commands(file="Printer.mos" "run"));
  Buildings.Utilities.Reports.Printer pri1(
    header="time ramp",
    nin=2,
    fileName="testPrinter1.txt") annotation (extent=[-20,40; 0,60]);
  Modelica.Blocks.Sources.Clock clo annotation (extent=[-80,40; -60,60]);
  Modelica.Blocks.Sources.Ramp ram annotation (extent=[-80,0; -60,20]);
  annotation (Diagram);
  Buildings.Utilities.Reports.Printer pri2(
    header="time ramp",
    nin=2,
    configuration=2,
    fileName="testPrinter2.txt") annotation (extent=[-20,0; 0,20]);
  Buildings.Utilities.Reports.Printer pri3(
    header="time ramp",
    nin=2,
    configuration=3,
    fileName="testPrinter3.txt") annotation (extent=[-20,-40; 0,-20]);
equation 
  connect(clo.y, pri1.x[1]) annotation (points=[-59,50; -40,50; -40,49; -22,49],
      style(color=74, rgbcolor={0,0,127}));
  connect(ram.y, pri1.x[2]) annotation (points=[-59,10; -40,10; -40,51; -22,51],
      style(color=74, rgbcolor={0,0,127}));
  connect(clo.y, pri2.x[1]) annotation (points=[-59,50; -40,50; -40,9; -22,9],
      style(color=74, rgbcolor={0,0,127}));
  connect(ram.y, pri2.x[2]) annotation (points=[-59,10; -40,10; -40,11; -22,11],
      style(color=74, rgbcolor={0,0,127}));
  connect(clo.y, pri3.x[1]) annotation (points=[-59,50; -40,50; -40,-31; -22,
        -31], style(color=74, rgbcolor={0,0,127}));
  connect(ram.y, pri3.x[2]) annotation (points=[-59,10; -40,10; -40,-29; -22,
        -29], style(color=74, rgbcolor={0,0,127}));
end Printer;
