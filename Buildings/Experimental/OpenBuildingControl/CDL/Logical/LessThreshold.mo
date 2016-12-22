within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block LessThreshold "Output y is true, if input u is less than threshold"

  parameter Real threshold=0 "Comparison with respect to threshold";

  Modelica.Blocks.Interfaces.RealInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u < threshold;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%threshold"),Text(
          extent={{-90,-40},{60,40}},
          lineColor={0,0,0},
          textString="<")}), Documentation(info="<html>
<p>
The output is <code>true</code> if the Real input is less than
parameter <code>threshold</code>, otherwise
the output is <code>false</code>.
</p>
</html>"));
end LessThreshold;
