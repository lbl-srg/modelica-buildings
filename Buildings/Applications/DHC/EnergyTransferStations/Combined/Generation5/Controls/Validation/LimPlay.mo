within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation;
model LimPlay "Validation of play hysteresis controller"
  extends Modelica.Icons.Example;

  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay
    conPlaDirP(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    hys=2) "Play hysteresis with P control, direct acting"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.TimeTable u_m(table=[0,0; 1,10; 2,10; 3,0])
    "Measurement values"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant u_s(k=5) "Set-point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay
    conPlaRevP(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    hys=2,
    reverseActing=true) "Play hysteresis with P control, reverse acting"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay
    conPlaDirPI(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    Ti=0.1,
    hys=2) "Play hysteresis with PI control, direct acting"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(u_s.y,conPlaDirP. u_s)
    annotation (Line(points={{-58,0},{-12,0}}, color={0,0,127}));
  connect(u_m.y,conPlaDirP. u_m)
    annotation (Line(points={{-59,-60},{0,-60},{0,-12}}, color={0,0,127}));
  connect(u_s.y,conPlaRevP. u_s) annotation (Line(points={{-58,0},{-40,0},{-40,
          -40},{28,-40}},
                     color={0,0,127}));
  connect(u_m.y,conPlaRevP. u_m)
    annotation (Line(points={{-59,-60},{40,-60},{40,-52}}, color={0,0,127}));
  connect(u_s.y, conPlaDirPI.u_s) annotation (Line(points={{-58,0},{-40,0},{-40,
          40},{68,40}}, color={0,0,127}));
  connect(u_m.y, conPlaDirPI.u_m)
    annotation (Line(points={{-59,-60},{80,-60},{80,28}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Controls/Validation/LimPlay.mos"
"Simulate and plot"));
end LimPlay;
