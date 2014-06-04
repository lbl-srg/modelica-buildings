within Buildings.Electrical.DC.Lines;
model TwoPortRCLine "Model of a two port DC resistance and capacity (T-model)"
  extends Buildings.Electrical.Transmission.Base.PartialTwoPortRLC(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n(
      redeclare package PhaseSystem = PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(
      redeclare package PhaseSystem = PhaseSystem_p),
    final L=0);
  parameter Boolean use_C = false
    "Set to true to add a capacitance in the center of the line"
    annotation(Dialog(tab="Model", group="Assumptions"));
  Modelica.SIunits.Voltage Vc(start = V_nominal) "Voltage of the capacitor";
equation
  terminal_p.v[1] - (Vc+terminal_p.v[2]) = terminal_p.i[1]*R_actual/2;
  terminal_n.v[1] - (Vc+terminal_p.v[2]) = terminal_n.i[1]*R_actual/2;

  if C>0 and use_C then
    C*der(Vc) = terminal_p.i[1] + terminal_n.i[1];
  else
    Vc = 0.5*(terminal_p.v[1] - terminal_p.v[2] + terminal_n.v[1] - terminal_n.v[2]);
  end if;

  terminal_p.v[2] = terminal_n.v[2];
  terminal_p.i[2] + terminal_n.i[2] = 0;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            textString="%name",
            lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255}),
        Rectangle(
          extent={{-70,32},{70,-28}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model represents a series of two resistances and a capacitance that connect two DC interfaces.
This model can be used to represent a cable in a DC grid.
</p>
<p>
The model represents the lumped resistances and capacity (T-model) as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/DC/Lines/twoPortRC.png\"/>
</p>
<p>
As can be seen in the figure, the resistance <i>R</i> is split in two halves
and the capacitance is located in the center.
The capacitance in the center is optional and can be selected using the
boolean flag <code>use_C = true</code>. The model is either dynamic or static depending on the
presence of the capacitive effect.
</p>
</html>", revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
revised documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoPortRCLine;
