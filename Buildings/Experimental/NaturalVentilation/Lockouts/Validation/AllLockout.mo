within Buildings.Experimental.NaturalVentilation.Lockouts.Validation;
model AllLockout "Validation model for slab temperature alarm"
   final parameter Real TimErr(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=3600  "Time threshhold zone temp must be out of range to trigger alarm";
  final parameter Real TemErr(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1 "Difference from zone temp setpoint required to trigger alarm";

  Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  AllLockouts allLoc
    annotation (Placement(transformation(extent={{4,-40},{50,20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.1, period=3600)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(width=0.1, period=86400)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul2(width=0.25, period=14400)
    annotation (Placement(transformation(extent={{-100,38},{-80,58}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul3(width=0.8, period=14400)
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=2,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=8.94)
    annotation (Placement(transformation(extent={{-102,-82},{-82,-62}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin3(
    amplitude=2*4.44,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=293.15)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin4(
    amplitude=2,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=293.15)
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=20,
    duration=86400,
    offset=278)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(booPul.y, allLoc.uManOveRid) annotation (Line(points={{-38,90},{-20,
          90},{-20,16.4},{-0.6,16.4}}, color={255,0,255}));
  connect(booPul1.y, allLoc.uNitFlu) annotation (Line(points={{-58,70},{-36,70},
          {-36,10.4},{-0.6,10.4}}, color={255,0,255}));
  connect(booPul2.y, allLoc.uRai) annotation (Line(points={{-78,48},{-40,48},{-40,
          4.4},{-0.6,4.4}}, color={255,0,255}));
  connect(booPul3.y, allLoc.uOcc) annotation (Line(points={{-98,30},{-22,30},{-22,
          -2},{-12,-2},{-12,-1.6},{-0.6,-1.6}}, color={255,0,255}));
  connect(con.y, allLoc.uRooSet) annotation (Line(points={{-78,-30},{-30,-30},{
          -30,-19},{-0.6,-19}}, color={0,0,127}));
  connect(sin1.y, allLoc.uWinSpe) annotation (Line(points={{-80,-72},{-12,-72},
          {-12,-31},{-0.6,-31}}, color={0,0,127}));
  connect(sin3.y, allLoc.uWetBul) annotation (Line(points={{-38,-10},{-20,-10},
          {-20,-13},{-0.6,-13}}, color={0,0,127}));
  connect(sin4.y, allLoc.uRooMea) annotation (Line(points={{-18,-90},{-8,-90},{
          -8,-37},{-0.6,-37}}, color={0,0,127}));
  connect(ram.y, allLoc.uDryBul) annotation (Line(points={{-38,-50},{-20,-50},{
          -20,-25},{-0.6,-25}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the slab temperature alarm, which should show true if slab has been a user-specified amount of of range for a user-specified amount of time.  
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/Lockouts/Validation/AllLockout.mos"
        "Simulate and plot"), Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}),                graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-180},{100,
            100}})));
end AllLockout;
