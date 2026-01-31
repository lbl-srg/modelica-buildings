within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.Validation;
model HWIsoVal
    "Validate isolation valve disable sequence"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.HWIsoVal
    cloHotIsoVal                "Close isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  CDL.Logical.Pre pre1(pre_u_start=true) "Unit delay"
    annotation (Placement(transformation(extent={{30,-20},{50,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not staCha
    "Stage change command"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta
    "Upstream device status"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-88,-20},{-62,-20}},   color={255,0,255}));

  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-88,20},{-62,20}},     color={255,0,255}));

  connect(upsDevSta.y,cloHotIsoVal. uUpsDevSta) annotation (Line(points={{-38,20},
          {-22,20},{-22,0},{-12,0}},          color={255,0,255}));

  connect(staCha.y,cloHotIsoVal. chaPro) annotation (Line(points={{-38,-20},{
          -22,-20},{-22,-6},{-12,-6}},  color={255,0,255}));

  connect(cloHotIsoVal.yHotWatIsoVal, pre1.u) annotation (Line(points={{12,-6},
          {20,-6},{20,-10},{28,-10}}, color={255,0,255}));
  connect(pre1.y, cloHotIsoVal.uHotWatIsoVal) annotation (Line(points={{52,-10},
          {60,-10},{60,18},{-20,18},{-20,6},{-12,6}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Generic/Subsequences/Validation/HWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This example validates
  <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.HWIsoVal\">
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences.HWIsoVal</a>.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  September 30, 2020 by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
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
      extent={{-220,-120},{220,120}})));
end HWIsoVal;
