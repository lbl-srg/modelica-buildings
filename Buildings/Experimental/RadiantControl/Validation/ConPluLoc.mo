within Buildings.Experimental.RadiantControl.Validation;
model ConPluLoc "Validation model for radiant control"
   final parameter Real TSlaSetCor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3;
    final parameter Real TAirHiLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6;
    final parameter Real TempWaLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9;

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TAirHiLim)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TempWaLoSet)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse1(period=43000)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    amplitude=TSlaSetCor/15,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TSlaSetCor)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           InteriorSetpoint2(k=294)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  ControlPlusLockouts ControlPlusLockouts1
    annotation (Placement(transformation(extent={{2,0},{24,20}})));
equation
  connect(sin2.y, ControlPlusLockouts1.TSla) annotation (Line(points={{-38,70},
          {-20,70},{-20,18},{0,18}}, color={0,0,127}));
  connect(InteriorSetpoint2.y, ControlPlusLockouts1.TSlaSet) annotation (Line(
        points={{-38,30},{-30,30},{-30,14},{0,14}}, color={0,0,127}));
  connect(sin.y, ControlPlusLockouts1.TRooAir) annotation (Line(points={{-38,
          -10},{-20,-10},{-20,6},{0,6}}, color={0,0,127}));
  connect(sin1.y, ControlPlusLockouts1.TWaRet) annotation (Line(points={{-38,
          -50},{-8,-50},{-8,2},{0,2}}, color={0,0,127}));
  connect(booleanPulse1.y, ControlPlusLockouts1.nitFluSig) annotation (Line(
        points={{-39,-90},{-32,-90},{-32,10},{0,10}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This models the radiant slab control scheme with inputs not tied to a physical room.
</p>
</html>"),experiment(StartTime=0.0, StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/Validation/ConPluLoc.mos"
        "Simulate and plot"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConPluLoc;
