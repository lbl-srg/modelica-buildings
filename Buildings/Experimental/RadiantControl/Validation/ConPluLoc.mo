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
  SlabTempSignal.Validation.BaseClasses.SlabSetCore slabSetCore(TSlaCor=
        TSlaSetCor)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    amplitude=TSlaSetCor/15,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TSlaSetCor)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  ControlPlusLockouts controlPlusLockouts
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(booleanPulse1.y, controlPlusLockouts.nitFluSig) annotation (Line(
        points={{-39,-90},{-20,-90},{-20,10},{-1.81818,10}}, color={255,0,255}));
  connect(sin1.y, controlPlusLockouts.TWaRet) annotation (Line(points={{-38,-50},
          {-20,-50},{-20,2},{-1.81818,2}},
                                     color={0,0,127}));
  connect(sin.y, controlPlusLockouts.TRooAir) annotation (Line(points={{-38,-10},
          {-20,-10},{-20,6},{-1.81818,6}}, color={0,0,127}));
  connect(slabSetCore.TSlaSetCor, controlPlusLockouts.TSlaSet) annotation (Line(
        points={{-38,31},{-20,31},{-20,14},{-1.81818,14}},
                                                         color={0,0,127}));
  connect(sin2.y, controlPlusLockouts.TSla) annotation (Line(points={{-38,70},{
          -20,70},{-20,18},{-1.81818,18}},
                                 color={0,0,127}));
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
