within Buildings.Examples.VAVReheat.Controls.Examples;
model RoomVAV "Test model for the room VAV controller"
  extends Modelica.Icons.Example;

  Buildings.Examples.VAVReheat.Controls.RoomVAV vavBoxCon(ratVFloMin=0.15,
      ratVFloHea=0.3)
    "VAV terminal unit single maximum controller"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSet(k=273.15 + 21)
    "Heating setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSet(k=273.15 + 22)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=4,
    duration=3600,
    offset=-4) "Ramp source"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=1,
    freqHz=1/3600,
    offset=273.15 + 23.5) "Sine source"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add rooTem "Room temperature"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

equation
  connect(rooTem.y, vavBoxCon.TRoo) annotation (Line(points={{2,-50},{20,-50},{20,
          -7},{39,-7}}, color={0,0,127}));
  connect(cooSet.y, vavBoxCon.TRooCooSet)
    annotation (Line(points={{-18,20},{0,20},{0,0},{38,0}}, color={0,0,127}));
  connect(heaSet.y, vavBoxCon.TRooHeaSet) annotation (Line(points={{-18,70},{20,
          70},{20,7},{38,7}}, color={0,0,127}));
  connect(sin.y, rooTem.u2) annotation (Line(points={{-58,-70},{-40,-70},{-40,-56},
          {-22,-56}}, color={0,0,127}));
  connect(ram.y, rooTem.u1) annotation (Line(points={{-58,-30},{-40,-30},{-40,-44},
          {-22,-44}}, color={0,0,127}));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Controls/Examples/RoomVAV.mos"
        "Simulate and plot"),
    experiment(StopTime=3600, Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model tests the VAV box contoller of transition from heating control to cooling
control.
</p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end RoomVAV;
