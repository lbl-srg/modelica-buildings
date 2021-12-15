within IceStorage.BaseClasses;
model IsolationValveControl "Controller for isolation valve"

  Modelica.Blocks.Interfaces.RealOutput y(final quantity="1") "Valve position"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.IntegerInput u "Storage mode"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.IntegerExpression dorMod(y=Integer(IceStorage.Types.IceThermalStorageMode.Dormant))
    "Dormant mode"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isDor "Is dormant"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.BooleanToReal boo2Rea "Boolean to real"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(dorMod.y, isDor.u2) annotation (Line(points={{-59,-30},{-40,-30},{-40,
          -8},{-22,-8}}, color={255,127,0}));
  connect(u, isDor.u1)
    annotation (Line(points={{-120,0},{-22,0}}, color={255,127,0}));
  connect(boo2Rea.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(isDor.y, not1.u)
    annotation (Line(points={{2,0},{18,0}}, color={255,0,255}));
  connect(not1.y, boo2Rea.u)
    annotation (Line(points={{41,0},{58,0}}, color={255,0,255}));
  annotation (defaultComponentName="isoValCon",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block controls the on/off status of an isolation valve in the ice tank. 
If the ice tank is in Dormant mode, the isolation valve is fully closed. 
Otherwise, the isolation valve is fully open.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IsolationValveControl;
