within Districts.Electrical.DC.Sources;
model ConstantVoltage
  extends Districts.Electrical.DC.Interfaces.TwoPinComponent_p;
  parameter Modelica.SIunits.Voltage V(start=1) "Value of constant voltage";
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative pin"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  v = V;
  term.v[2] = n.v;
  sum(term.i) + n.i = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{-40,0},{40,0}},  color={0,0,0},
          origin={-10,0},
          rotation=90),
        Line(points={{0,26},{8.4637e-16,-54}},
                                          color={0,0,0},
          origin={36,0},
          rotation=90),
        Line(points={{0,30},{4.28612e-15,-34}},
                                      color={0,0,0},
          origin={-44,0},
          rotation=90),
        Line(points={{-20,0},{20,0}},
                                    color={0,0,0},
          origin={10,0},
          rotation=90),
        Text(
          extent={{-150,70},{-50,20}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{-150,-12},{-50,-62}},
          lineColor={0,0,255},
          textString="-"),
        Text(
          extent={{-150,60},{150,100}},
          textString="%name=%V",
          lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end ConstantVoltage;
