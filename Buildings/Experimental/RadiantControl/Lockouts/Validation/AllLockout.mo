within Buildings.Experimental.RadiantControl.Lockouts.Validation;
model AllLockout "Validation model for all lockouts"
    final parameter Real TAirHiLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
   final parameter Real TAirLoLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
     final parameter Real TempWaLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   final parameter Real TimeCHW(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=3600 "Time for which cooling is locked out if CHW return is too cold";
   final parameter Real TimHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
  final parameter Real TimCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TAirHiLim)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TempWaLoSet)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  AllLockouts allLoc(
    TAirHiSet=TAirHiLim,
    TAirLoSet=TAirLoLim,
    TWaLoSet=TempWaLoSet,
    TiCHW=TimeCHW,
    TiHea=TimHea,
    TiCoo=TimCoo)
    annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=43000)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=43000)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul2(period=43000)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(sin.y, allLoc.TRooAir) annotation (Line(points={{-58,-30},{-40,-30},{
          -40,5},{-22,5}}, color={0,0,127}));
  connect(sin1.y, allLoc.TChwRet) annotation (Line(points={{-58,-70},{-40,-70},
          {-40,1},{-22,1}}, color={0,0,127}));
  connect(booPul2.y, allLoc.clgSig) annotation (Line(points={{-58,10},{-40,10},
          {-40,9},{-22,9}}, color={255,0,255}));
  connect(booPul1.y, allLoc.htgSig) annotation (Line(points={{-58,50},{-40,50},
          {-40,13},{-22,13}}, color={255,0,255}));
  connect(booPul.y, allLoc.nitFluSig) annotation (Line(points={{-58,90},{-34,90},
          {-34,17},{-22,17}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model validates all lockouts. 
Heating is locked out if room air temperature is too hot, 
if night flush mode is on, 
or if cooling was on within a user-specified amount of time. 
Cooling is locked out if room air temperature is too cold, 
if chilled water return temperature is too cold, 
or if heating was on within a user-specified amount of time. 
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/Lockouts/Validation/AllLockout.mos"
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
end AllLockout;
