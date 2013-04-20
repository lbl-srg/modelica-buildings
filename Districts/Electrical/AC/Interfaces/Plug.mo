within Districts.Electrical.AC.Interfaces;
partial connector Plug
  "Generalized AC connector, it can be used for representing both single and three phases systems."
  parameter Integer N "Number of phases";
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin p[N]
    "phases pins"                       annotation (Placement(transformation(extent={{-10,40},
            {10,60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin n
    "neutral pin"                      annotation (Placement(transformation(extent={{-10,-60},
            {10,-40}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),
                      graphics), Icon(graphics));
end Plug;
