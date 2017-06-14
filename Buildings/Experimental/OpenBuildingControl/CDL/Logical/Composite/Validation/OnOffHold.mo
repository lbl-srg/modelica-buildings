within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.Validation;
model OnOffHold "Validation model for the OnOffHold block"
extends Modelica.Icons.Example;

  Sources.BooleanPulse booPul(period=1600, startTime=0) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Logical.Composite.OnOffHold onOffHold(holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Sources.BooleanPulse booPul1(            startTime=0, period=900)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Logical.Composite.OnOffHold onOffHold1(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Sources.BooleanPulse booPul2(
                              period=1600, startTime=0) "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Logical.Composite.OnOffHold onOffHold2(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Sources.BooleanPulse booPul3(            startTime=0, period=900)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Logical.Composite.OnOffHold onOffHold3(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Not not1 "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Not not3 "Negation of input signal"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Sources.BooleanPulse booPul4(
                              period=1600, startTime=100)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Logical.Composite.OnOffHold onOffHold4(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Sources.BooleanPulse booPul5(period=900, startTime=100)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Logical.Composite.OnOffHold onOffHold5(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Sources.BooleanPulse booPul6(
                              period=1600, startTime=100)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Logical.Composite.OnOffHold onOffHold6(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Sources.BooleanPulse booPul7(period=900, startTime=100)
                                                        "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Logical.Composite.OnOffHold onOffHold7(
                                        holdDuration=900)
                                        "The block introduces a minimal offset between the input signal rising and falling edge"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Not not2 "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  Not not4 "Negation of input signal"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));
equation
  connect(booPul.y, onOffHold.u)
    annotation (Line(points={{-119,70},{-41.2,70}},   color={255,0,255}));
  connect(booPul1.y, onOffHold1.u)
    annotation (Line(points={{-119,30},{-41.2,30}}, color={255,0,255}));
  connect(booPul2.y, not1.u)
    annotation (Line(points={{-119,-10},{-92,-10}}, color={255,0,255}));
  connect(not1.y, onOffHold2.u)
    annotation (Line(points={{-69,-10},{-41.2,-10}}, color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-119,-50},{-92,-50}}, color={255,0,255}));
  connect(not3.y, onOffHold3.u)
    annotation (Line(points={{-69,-50},{-41.2,-50}}, color={255,0,255}));
  connect(booPul4.y, onOffHold4.u)
    annotation (Line(points={{41,70},{118.8,70}}, color={255,0,255}));
  connect(booPul5.y, onOffHold5.u)
    annotation (Line(points={{41,30},{118.8,30}}, color={255,0,255}));
  connect(booPul6.y, not2.u)
    annotation (Line(points={{41,-10},{68,-10}}, color={255,0,255}));
  connect(not2.y, onOffHold6.u)
    annotation (Line(points={{91,-10},{118.8,-10}}, color={255,0,255}));
  connect(booPul7.y, not4.u)
    annotation (Line(points={{41,-50},{68,-50}}, color={255,0,255}));
  connect(not4.y, onOffHold7.u)
    annotation (Line(points={{91,-50},{118.8,-50}}, color={255,0,255}));
  annotation (
  experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Composite/Validation/OnOffHold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnOffHold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnOffHold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{160,100}})));
end OnOffHold;
