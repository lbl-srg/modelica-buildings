within Districts.Electrical.DC.Sources;
model ConstantVoltage
  extends Districts.Electrical.DC.Interfaces.TwoPin;
  parameter Modelica.SIunits.Voltage V(start=1) "Value of constant voltage";
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative pin"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  v = V;
  connect(dcPlug.n, n) annotation (Line(
      points={{-100,-2},{100,-2},{100,4.44089e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{-40,0},{40,0}},  color={0,0,0}),
        Line(points={{0,-8},{0,-60}},     color={0,0,0}),
        Line(points={{0,60},{0,0}},   color={0,0,0}),
        Line(points={{-20,-8},{20,-8}},
                                    color={0,0,0}),
        Text(
          extent={{-130,84},{-30,34}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{-128,-10},{-28,-60}},
          lineColor={0,0,255},
          textString="-"),
        Text(
          extent={{-140,-100},{160,-60}},
          textString="%name=%V",
          lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end ConstantVoltage;
