within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.Validation;
model DisableChillers
  "Validation sequence for disabling chillers and the associated devices"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.DisableChillers
    disPlaFroChi(have_WSE=false)
    "Disable plant from chiller mode"
    annotation (Placement(transformation(extent={{60,0},{80,32}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staPro(
    final k=false) "Staging change process"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiIsoVal[2](
    final k={true,false})
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conIsoVal1[2](
    final k={1,0})
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumSpe(final k=0.75)
    "Pumps speed"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta[2](
    final width={0.5,0.01},
    final period={3600,7200},
    shift={0,-100})
    "Chiller status"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conIsoValSta[2](
    final k={true,false}) "Condenser water isolation valve commanded setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant watPum[2](
    final k={true,false}) "Water pump commanded setpoint"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(chiSta.y, disPlaFroChi.uChi) annotation (Line(points={{-18,80},{40,80},
          {40,30},{58,30}},   color={255,0,255}));
  connect(chiSta.y, disPlaFroChi.uChiWatReq) annotation (Line(points={{-18,80},
          {40,80},{40,28},{58,28}},color={255,0,255}));
  connect(chiSta.y, disPlaFroChi.uConWatReq) annotation (Line(points={{-18,80},
          {40,80},{40,23},{58,23}},  color={255,0,255}));
  connect(staPro.y, disPlaFroChi.chaPro) annotation (Line(points={{-58,-60},{30,
          -60},{30,10},{58,10}}, color={255,0,255}));
  connect(watPum.y, disPlaFroChi.uConWatPum) annotation (Line(points={{-18,-80},
          {40,-80},{40,5},{58,5}}, color={255,0,255}));
  connect(pumSpe.y, disPlaFroChi.uChiWatPumSpe) annotation (Line(points={{-18,
          -30},{20,-30},{20,13},{58,13}}, color={0,0,127}));
  connect(pumSpe.y, disPlaFroChi.uConWatPumSpe) annotation (Line(points={{-18,
          -30},{20,-30},{20,7},{58,7}}, color={0,0,127}));
  connect(watPum.y, disPlaFroChi.uChiWatPum) annotation (Line(points={{-18,-80},
          {40,-80},{40,15},{58,15}}, color={255,0,255}));
  connect(conIsoValSta.y, disPlaFroChi.u1ConWatIsoVal) annotation (Line(points=
          {{-58,0},{10,0},{10,19},{58,19}}, color={255,0,255}));
  connect(conIsoVal1.y, disPlaFroChi.uConWatIsoVal) annotation (Line(points={{
          -18,30},{0,30},{0,21},{58,21}}, color={0,0,127}));
  connect(chiIsoVal.y, disPlaFroChi.u1ChiWatIsoVal) annotation (Line(points={{-58,
          50},{30,50},{30,26},{58,26}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Generic/PlantEnable/Validation/DisableChillers.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.DisableChillers\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.PlantEnable.DisableChillers</a>.
It demonstrates the control of disabling plants from chiller mode (<code>disPlaFroChi</code>).
</p>
<ul>
<li>
Before 1800 seconds, the chiller 1 is enabled and the chiller 2 is disabled.
The chilled water isolation valve is fully open, and the chiller water pump
speed equals the input speed setpoint.
</li>
<li>
After 1800 seconds, the chillers are disabled. Thus, both the chilled and condenser
water isolation valves are closed, the chilled and condenser water pump speed
setpoints become 0, and all the tower cells are disabled.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DisableChillers;
