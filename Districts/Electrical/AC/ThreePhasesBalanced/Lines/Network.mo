within Districts.Electrical.AC.ThreePhasesBalanced.Lines;
model Network "Three phases balanced AC network"
  extends Districts.Electrical.Transmission.Base.PartialNetwork(
  redeclare Interfaces.Terminal_p terminal,
  redeclare Districts.Electrical.Transmission.Grids.TestGrid2Nodes grid,
  redeclare Lines.Line lines);
  annotation (Icon(graphics={             Line(
          points={{-98,-60},{-78,-20},{-58,-60},{-38,-100},{-18,-60}},
          color={0,0,0},
          smooth=Smooth.Bezier),          Line(
          points={{-88,-60},{-68,-20},{-48,-60},{-28,-100},{-8,-60}},
          color={120,120,120},
          smooth=Smooth.Bezier),          Line(
          points={{-78,-60},{-58,-20},{-38,-60},{-18,-100},{2,-60}},
          color={215,215,215},
          smooth=Smooth.Bezier)}));
end Network;
