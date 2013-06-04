within Districts.Electrical.PhaseSystems;
package OnePhase "Single phase two connectors AC system"
  extends PartialPhaseSystem(phaseSystemName="OnePhase", n=2, m=1);


  annotation (Icon(graphics={
        Line(
          points={{-70,-10},{-58,10},{-38,30},{-22,10},{-10,-10},{2,-30},{22,-50},
              {40,-30},{50,-10}},
          color={95,95,95},
          smooth=Smooth.Bezier)}));
end OnePhase;
