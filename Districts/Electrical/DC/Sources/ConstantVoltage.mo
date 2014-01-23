within Districts.Electrical.DC.Sources;
model ConstantVoltage
  extends Districts.Electrical.Interfaces.PartialSource(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor,  redeclare
      Districts.Electrical.DC.Interfaces.Terminal_p
                                                 terminal);
  parameter Modelica.SIunits.Voltage V(start=1) "Value of constant voltage";
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
        Line(points={{0,26},{8.4637e-16,-54}},
                                          color={0,0,0},
          origin={36,0},
          rotation=90),
        Line(points={{-5.66278e-15,46},{4.28612e-15,-34}},
                                      color={0,0,0},
          origin={-44,0},
          rotation=90),
        Line(points={{-20,0},{20,0}},
                                    color={0,0,0},
          origin={-10,0},
          rotation=90),
        Text(
          extent={{50,70},{150,20}},
          lineColor={0,0,255},
          textString="+"),
        Text(
          extent={{50,-12},{150,-62}},
          lineColor={0,0,255},
          textString="-"),
        Text(
          extent={{-150,60},{150,100}},
          lineColor={0,0,255},
          textString="V=%V")}),   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end ConstantVoltage;
