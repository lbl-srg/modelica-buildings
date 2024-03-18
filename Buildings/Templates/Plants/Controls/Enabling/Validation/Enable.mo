within Buildings.Templates.Plants.Controls.Enabling.Validation;
model Enable
  "Validation model for system enabling logic"
  Buildings.Templates.Plants.Controls.Enabling.Enable enaHea(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    nReqIgn=1)
    "Enable heating system"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse req(
    amplitude=1,
    period=60 * 20,
    offset=1)
    "System request"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    y(
      displayUnit="degC",
      unit="K"),
    final amplitude=12,
    final freqHz=1 /(10000),
    final offset=285.15)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Templates.Plants.Controls.Enabling.Enable enaCoo(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    nReqIgn=1)
    "Enable cooling system"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Templates.Plants.Controls.Enabling.Enable enaCooSch(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    have_inpSch=true,
    nReqIgn=1)
    "Enable cooling system with input schedule"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse sch(
    width=0.4,
    period=120 * 60,
    shift=25 * 60)
    "Enable schedule"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(req.y, enaHea.nReq)
    annotation (Line(points={{-38,60},{18,60}},color={255,127,0}));
  connect(TOut.y, enaHea.TOut)
    annotation (Line(points={{-38,0},{-20,0},{-20,56},{18,56}},color={0,0,127}));
  connect(req.y, enaCoo.nReq)
    annotation (Line(points={{-38,60},{0,60},{0,0},{18,0}},color={255,127,0}));
  connect(TOut.y, enaCoo.TOut)
    annotation (Line(points={{-38,0},{-20,0},{-20,-4},{18,-4}},color={0,0,127}));
  connect(TOut.y, enaCooSch.TOut)
    annotation (Line(points={{-38,0},{-20,0},{-20,-64},{18,-64}},color={0,0,127}));
  connect(req.y, enaCooSch.nReq)
    annotation (Line(points={{-38,60},{0,60},{0,-60},{18,-60}},color={255,127,0}));
  connect(sch.y, enaCooSch.u1Sch)
    annotation (Line(points={{-38,-60},{-30,-60},{-30,-56},{18,-56}},color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Enabling/Validation/Enable.mos"
        "Simulate and plot"),
    experiment(
      StopTime=7200.0,
      Tolerance=1e-06),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Enabling.Enable\">
Buildings.Templates.Plants.Controls.Enable.Enable</a>
in a heating configuration, in a cooling configuration, and in
a cooling configuration with the enable schedule provided via
an input point.
All these configurations have the same setting for the minimum number
of ignored requests: <code>nReqIgn=1</code>.
</p>
</html>"));
end Enable;
