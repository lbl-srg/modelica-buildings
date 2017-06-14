within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.Validation;
model OnHold "Validation model for the OnHold block"
  extends Modelica.Icons.Example;

  Sources.BooleanPulse booPul(period(displayUnit="s") = 9000, startTime=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Logical.Composite.OnHold onHold(holdDuration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Sources.BooleanPulse booPul1(period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Logical.Composite.OnHold onHold1(holdDuration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Sources.BooleanPulse booPul2(
                              period(displayUnit="s") = 9000, startTime=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Logical.Composite.OnHold onHold2(
                                  holdDuration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Sources.BooleanPulse booPul3(period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Logical.Composite.OnHold onHold3(holdDuration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Not not2 "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Not not3 "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(booPul.y, onHold.u)
    annotation (Line(points={{-19,80},{19,80}},     color={255,0,255}));
  connect(booPul1.y, onHold1.u)
    annotation (Line(points={{-19,30},{19,30}},
                                              color={255,0,255}));
  connect(booPul2.y, not2.u)
    annotation (Line(points={{-19,-10},{-12,-10}}, color={255,0,255}));
  connect(not2.y, onHold2.u)
    annotation (Line(points={{11,-10},{19,-10}}, color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-19,-60},{-12,-60}}, color={255,0,255}));
  connect(not3.y, onHold3.u)
    annotation (Line(points={{11,-60},{19,-60}}, color={255,0,255}));
  annotation (
  experiment(StopTime=15000.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Composite/Validation/OnHold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnHold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnHold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end OnHold;
