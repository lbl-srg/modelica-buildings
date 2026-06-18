within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SelectSmallestValues "Select smallest values"

  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues selSmaVal(
    nVal=5)
    "Block to select smallest values"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[4](k={13,7,2,3})
    "A vector of four real constants"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[4](
    k={false,false,false,false})
    "A vector of four false boolean constants"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nSel(k=3)
    "Number of smallest values to select"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=1)
    "True for half a second, false for the other half second"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable sawSig(
    table=[0,-15; 0.5,15; 0.5, -15; 1,15]) "Sawtooth signal"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(nSel.y, selSmaVal.nSel)
    annotation (Line(points={{22,-70},{40,-70},{40,4},{58,4}}, color={255,127,0}));
  connect(con1.y, selSmaVal.disFla[2:5])
    annotation (Line(points={{-58,50},{20,50}, {20,16.8},{58,16.8}},
      color={255,0,255}));
  connect(booPul.y, selSmaVal.disFla[1])
    annotation (Line(points={{-18,70},{20,70},{20,15.2},{58,15.2}},
      color={255,0,255}));
  connect(con2.y, selSmaVal.u[2:5])
    annotation (Line(points={{-18,-30},{20,-30},{20,10.8},{58,10.8}},
      color={0,0,127}));
  connect(sawSig.y[1], selSmaVal.u[1])
    annotation (Line(points={{-58,10},{20,10},{20,9.2},{58,9.2}}, color={0,0,127}));
annotation (experiment(StopTime=1, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SelectSmallestValues.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end SelectSmallestValues;
