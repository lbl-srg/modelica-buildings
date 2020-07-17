within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation;
model LimPIDSequence "Validation of PID hysteresis in sequence"
  extends Modelica.Icons.Example;

  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPIDSequence
    conPlaDirP(
    nCon=3,
    hys=1,
    dea=1)
    "Play hysteresis with P control, direct acting"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.TimeTable u_m(table=[0,0; 1,10; 2,10; 3,0])
    "Measurement values"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant u_s(k=0) "Set-point"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPIDSequence
    conPlaRevP(
    nCon=3,
    hys=1,
    dea=1,
    reverseActing=true) "Play hysteresis with P control, reverse acting"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPIDSequence
    conPlaDirPI(
    nCon=3,
    hys=1,
    dea=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=fill(0.2, 3),
    Ti=fill(2, 3)) "Play hysteresis with PI control, direct acting"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant u_s1(k=10) "Set-point"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPIDSequence
    conPlaDirPIEna(
    have_enaSig=true,
    nCon=3,
    yThr=0.99,
    hys=1,
    dea=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=fill(0.2, 3),
    Ti=fill(2, 3)) "Play hysteresis with PI control, direct acting"
    annotation (Placement(transformation(extent={{50,60},{70,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=true)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(u_s.y, conPlaDirP.u_s)
    annotation (Line(points={{-58,0},{-12,0}}, color={0,0,127}));
  connect(u_m.y, conPlaDirP.u_m)
    annotation (Line(points={{-59,-80},{0,-80},{0,-12}}, color={0,0,127}));
  connect(u_m.y,conPlaRevP. u_m)
    annotation (Line(points={{-59,-80},{40,-80},{40,-52}}, color={0,0,127}));
  connect(u_s.y, conPlaDirPI.u_s) annotation (Line(points={{-58,0},{-40,0},{-40,
          40},{68,40}}, color={0,0,127}));
  connect(u_m.y, conPlaDirPI.u_m)
    annotation (Line(points={{-59,-80},{80,-80},{80,28}}, color={0,0,127}));
  connect(u_s1.y, conPlaRevP.u_s)
    annotation (Line(points={{-58,-40},{28,-40}}, color={0,0,127}));
  connect(u_s.y, conPlaDirPIEna.u_s) annotation (Line(points={{-58,0},{-40,0},{
          -40,70},{48,70}}, color={0,0,127}));
  connect(u_m.y, conPlaDirPIEna.u_m)
    annotation (Line(points={{-59,-80},{60,-80},{60,58}}, color={0,0,127}));
  connect(tru.y, conPlaDirPIEna.uEna)
    annotation (Line(points={{-58,50},{56,50},{56,58}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=3,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Controls/Validation/LimPlaySequence.mos"
"Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence</a>.
</p>
</html>"));
end LimPIDSequence;
