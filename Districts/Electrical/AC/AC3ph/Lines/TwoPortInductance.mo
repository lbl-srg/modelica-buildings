within Districts.Electrical.AC.AC3ph.Lines;
model TwoPortInductance
  extends Districts.Electrical.Transmission.Base.PartialTwoPortInductance(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);

  Modelica.SIunits.AngularVelocity omega;
  parameter Districts.Electrical.Types.Assumption
                       mode(min=1,max=4) = Districts.Electrical.Types.Assumption.FixedZ_steady_state annotation(evaluate=true,Dialog(group="Modelling assumption"));
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  omega = der(PhaseSystem_p.thetaRef(terminal_p.theta));

  if mode==2 then
    // Dynamic of the system
    der(L*terminal_p.i) + L*omega*PhaseSystem_p.j(terminal_p.i) = terminal_p.v - terminal_n.v;

  else
    // steady state relationship
    L*omega*PhaseSystem_p.j(terminal_p.i) = terminal_p.v - terminal_n.v;

  end if;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            textString="%name",
            lineColor={0,0,255})}));
end TwoPortInductance;
