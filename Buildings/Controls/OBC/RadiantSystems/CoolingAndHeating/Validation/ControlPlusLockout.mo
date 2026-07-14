within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Validation;
model ControlPlusLockout "Validation model for radiant control"
  final parameter Real TSlaSetCor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3
    "Slab setpoint temperature offset";

  final parameter Real TZonHigLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air room temperature offset";

  final parameter Real WatTemLowSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Water return temperature offset";

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TZonHigLim) "Varying room air temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=WatTemLowSet) "Varying water return temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    amplitude=TSlaSetCor/15,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TSlaSetCor) "Varying slab temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TIntSet(k=294)
    "Flat temperature setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts conPluLoc "Control plus lockouts"
    annotation (Placement(transformation(extent={{0,0},{22,20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=43000)
    "Varying night flush signal"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
equation
  connect(sin2.y, conPluLoc.TSla) annotation (Line(points={{-38,70},{-20,70},{
          -20,18},{-2.2,18}},
                       color={0,0,127}));
  connect(TIntSet.y, conPluLoc.TSlaSet) annotation (Line(points={{-38,30},{-30,
          30},{-30,14},{-2.2,14}},
                                color={0,0,127}));
  connect(sin.y, conPluLoc.TRooAir) annotation (Line(points={{-38,-10},{-20,-10},
          {-20,6},{-2.2,6}},
                          color={0,0,127}));
  connect(sin1.y, conPluLoc.TSlaWatRet) annotation (Line(points={{-38,-50},{-8,
          -50},{-8,2},{-2.2,2}},
                         color={0,0,127}));
  connect(booPul.y, conPluLoc.uNigFlu) annotation (Line(points={{-38,-90},{-26,
          -90},{-26,10},{-2.2,10}},     color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This models the radiant slab control scheme with inputs not tied to a physical room.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation
</li>
</ul>
</html>"),experiment(StartTime=0.0, StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Validation/ControlPlusLockout.mos"
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
end ControlPlusLockout;
