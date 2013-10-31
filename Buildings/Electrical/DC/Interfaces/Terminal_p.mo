within Buildings.Electrical.DC.Interfaces;
connector Terminal_p "Terminal p for DC electrical systems"
  extends Buildings.Electrical.Interfaces.Terminal;
  annotation (Icon(graphics={  Polygon(
          points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({0,0,255}, if PhaseSystem.phaseSystemName=="TwoConductor" then {255,0,255} else {255,255,255}),
          fillPattern=FillPattern.Solid)}));
end Terminal_p;
