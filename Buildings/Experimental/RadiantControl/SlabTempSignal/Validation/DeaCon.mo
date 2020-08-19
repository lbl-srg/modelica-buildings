within Buildings.Experimental.RadiantControl.SlabTempSignal.Validation;
model DeaCon "Validation model for deadband control"
  final parameter Real TemDeaRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger heating or cooling during occupied hours";
  final parameter Real TemDeaNor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.28
                                           "Difference from slab temp setpoint required to trigger heating or cooling during unoccpied hours";
  final parameter Real LastOcc(min=0,max=24)=16 "Last occupied hour";
  final parameter Boolean OffTru=true "True: both heating and cooling signals turn off when slab setpoint is within deadband";
  final parameter Boolean OffFal=false "False: signals may be on when slab setpoint is within deadband";
  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=TemDeaNor,
    freqHz=1/14400,
    phase(displayUnit="rad"),
    offset=0)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=TemDeaRel,
    freqHz=1/14400,
    phase(displayUnit="rad"),
    offset=0)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Experimental.RadiantControl.SlabTempSignal.DeadbandControlErrSwi
    deadbandControlErrSwi(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffTru)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Experimental.RadiantControl.SlabTempSignal.DeadbandControlErrSwi
    deadbandControlErrSwi1(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffFal)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Experimental.RadiantControl.SlabTempSignal.DeadbandControlErrSwi
    deadbandControlErrSwi2(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffTru)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Experimental.RadiantControl.SlabTempSignal.DeadbandControlErrSwi
    deadbandControlErrSwi3(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffFal)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  DeadbandControlErrSwi deadbandControlErrSwiTest(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffTru)
    annotation (Placement(transformation(extent={{50,60},{80,92}})));
  DeadbandControlErrSwi deadbandControlErrSwiTestFAL(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffFal)
    annotation (Placement(transformation(extent={{50,8},{80,40}})));
  DeadbandControlErrSwi deadbandControlErrSwiTest1(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffTru)
    annotation (Placement(transformation(extent={{50,-40},{80,-8}})));
  DeadbandControlErrSwi deadbandControlErrSwiTestFAL1(
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffFal)
    annotation (Placement(transformation(extent={{50,-92},{80,-60}})));
equation
  connect(sin.y, deadbandControlErrSwi.slaTemErr) annotation (Line(points={{-38,
          30},{-24,30},{-24,40.8},{-21.7333,40.8}}, color={0,0,127}));
  connect(sin1.y, deadbandControlErrSwi2.slaTemErr) annotation (Line(points={{-38,
          -50},{-24,-50},{-24,-39.2},{-21.7333,-39.2}}, color={0,0,127}));
  connect(sin1.y, deadbandControlErrSwi3.slaTemErr) annotation (Line(points={{-38,
          -50},{-24,-50},{-24,-79.2},{-21.7333,-79.2}}, color={0,0,127}));
  connect(sin.y, deadbandControlErrSwi1.slaTemErr) annotation (Line(points={{-38,
          30},{-24,30},{-24,0.8},{-21.7333,0.8}}, color={0,0,127}));
  connect(sin.y, deadbandControlErrSwiTest.slaTemErr) annotation (Line(points={
          {-38,30},{20,30},{20,61.28},{47.4,61.28}}, color={0,0,127}));
  connect(sin.y, deadbandControlErrSwiTestFAL.slaTemErr) annotation (Line(
        points={{-38,30},{20,30},{20,9.28},{47.4,9.28}}, color={0,0,127}));
  connect(sin1.y, deadbandControlErrSwiTest1.slaTemErr) annotation (Line(points=
         {{-38,-50},{22,-50},{22,-38.72},{47.4,-38.72}}, color={0,0,127}));
  connect(sin1.y, deadbandControlErrSwiTestFAL1.slaTemErr) annotation (Line(
        points={{-38,-50},{22,-50},{22,-90.72},{47.4,-90.72}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This validates the deadband control, which determines whether the slab is in heating or in cooling. 
Two error sizes were tested, as well as two options- one in which the slab is allowed to receive no flow if it is within deadband, and the other in which the slab must receive either heating or cooling at all times.
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),Icon(
        coordinateSystem(extent={{-100,-120},{100,100}}),         graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DeaCon;
