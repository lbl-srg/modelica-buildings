within Buildings.Electrical.DC.Sources;
model ConstantVoltage "Model of a constant DC voltage source"
  extends Buildings.Electrical.Interfaces.Source(
    redeclare package PhaseSystem = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_p terminal,
    final potentialReference=true,
    final definiteReference=false);
  parameter Modelica.Units.SI.Voltage V(start=1) "Value of constant voltage";
  Modelica.Electrical.Analog.Interfaces.NegativePin n "Negative pin"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
  terminal.v[1] = V;
  terminal.v[2] = n.v;
  sum(terminal.i) + n.i = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{-40,0},{40,0}},  color={0,0,0},
          origin={10,0},
          rotation=90),
        Line(points={{0,26},{0,-54}},     color={0,0,0},
          origin={36,0},
          rotation=90),
        Line(points={{0,46},{0,-34}}, color={0,0,0},
          origin={-44,0},
          rotation=90),
        Line(points={{-20,0},{20,0}},
                                    color={0,0,0},
          origin={-10,0},
          rotation=90),
        Text(
          extent={{50,70},{150,20}},
          textColor={0,0,0},
          textString="+"),
        Text(
          extent={{50,-12},{150,-62}},
          textColor={0,0,0},
          textString="-"),
        Text(
          extent={{-150,60},{150,100}},
          textColor={0,0,0},
          textString="V=%V")}),    Documentation(info="<html>
<p>
This model represents a simple DC voltage source with constant voltage.
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Michael Wetter:<br/>
Set <code>final potentialReference=true</code> and
<code>final definiteReference=false</code> as this
model is for a DC voltage.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end ConstantVoltage;
