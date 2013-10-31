within Buildings.Electrical.DC.Lines;
model TwoPortRCLine "Model of a RC system"
  extends Buildings.Electrical.Transmission.Base.PartialTwoPortRLC(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    final L=0);
  parameter Boolean useC = false
    "Select if choosing the capacitive effect of the cable or not"
    annotation(Dialog(tab="Model", group="Assumptions"));
  Modelica.SIunits.Voltage Vc(start = V_nominal) "Voltage of the capacitor";
equation
  terminal_p.v[1] - (Vc+terminal_p.v[2]) = terminal_p.i[1]*R_actual/2;
  terminal_n.v[1] - (Vc+terminal_p.v[2]) = terminal_n.i[1]*R_actual/2;

  if C>0 and useC then
    C*der(Vc) = terminal_p.i[1] + terminal_n.i[1];
  else
    Vc = 0.5*(terminal_p.v[1] - terminal_p.v[2]) + 0.5*(terminal_n.v[1] - terminal_n.v[2]);
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
          extent={{-70,30},{70,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end TwoPortRCLine;
