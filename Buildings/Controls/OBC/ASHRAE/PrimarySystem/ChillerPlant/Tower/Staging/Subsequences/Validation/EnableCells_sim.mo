within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.Validation;
model EnableCells_sim
  "Validation sequence of enabling and disabling tower cells"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final startTime=300) "Water side economizer status"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells_sim
    enaTowCel1 annotation (Placement(transformation(extent={{60,60},{80,80}})));
  CDL.Continuous.Sources.Ramp chiStaGen(
    height=2,
    duration=3600,
    offset=2) "Generate chiller stage"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Conversions.RealToInteger chiStaSet "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Integers.Sources.Constant curChiSta(final k=1) "Current chiller stage"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  CDL.Logical.Sources.Pulse booPul2(width=0.75, period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  CDL.Logical.Not StaTow "Stage tower cells"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Logical.Sources.Constant leaConPum(final k=true)
    "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Continuous.Sources.Constant conWatPumSpe(k=0.5)
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation

  connect(chiStaGen.y, chiStaSet.u)
    annotation (Line(points={{-78,50},{-62,50}}, color={0,0,127}));
  connect(curChiSta.y, enaTowCel1.uChiSta) annotation (Line(points={{-38,90},{40,
          90},{40,79},{58,79}}, color={255,127,0}));
  connect(chiStaSet.y, enaTowCel1.uChiStaSet) annotation (Line(points={{-38,50},
          {-20,50},{-20,76},{58,76}}, color={255,127,0}));
  connect(booPul2.y, StaTow.u)
    annotation (Line(points={{-78,10},{-62,10}}, color={255,0,255}));
  connect(StaTow.y, enaTowCel1.uTowStaCha) annotation (Line(points={{-38,10},{-14,
          10},{-14,72},{58,72}}, color={255,0,255}));
  connect(wseSta.y, enaTowCel1.uWse) annotation (Line(points={{-38,-30},{-8,-30},
          {-8,68},{58,68}}, color={255,0,255}));
  connect(leaConPum.y, enaTowCel1.uLeaConWatPum) annotation (Line(points={{-78,-50},
          {0,-50},{0,64},{58,64}}, color={255,0,255}));
  connect(conWatPumSpe.y, enaTowCel1.uConWatPumSpe) annotation (Line(points={{-38,
          -70},{8,-70},{8,61},{58,61}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/Staging/Subsequences/Validation/EnableCells.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                   graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end EnableCells_sim;
