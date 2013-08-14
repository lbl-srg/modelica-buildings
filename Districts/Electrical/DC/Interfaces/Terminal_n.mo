within Districts.Electrical.DC.Interfaces;
connector Terminal_n
  extends Districts.Electrical.Interfaces.Terminal;
  annotation (Icon(graphics={  Polygon(
          points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Terminal_n;
