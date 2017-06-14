within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.Validation;
model OnHold "Validation model for the OnHold block"
extends Modelica.Icons.Example;

  Sources.BooleanPulse booPul(period(displayUnit="s") = 9000, startTime=300)
                                                          "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Logical.Composite.OnHold onHold(holdDuration=3600)
                                  "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Sources.BooleanPulse booPul1(period=3600)               "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Logical.Composite.OnHold onHold1(holdDuration=600)
                                  "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(booPul.y, onHold.u)
    annotation (Line(points={{-19,50},{19,50}},     color={255,0,255}));
  connect(booPul1.y, onHold1.u)
    annotation (Line(points={{-19,0},{19,0}}, color={255,0,255}));
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
