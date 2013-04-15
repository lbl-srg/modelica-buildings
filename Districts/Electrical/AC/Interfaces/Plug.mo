within Districts.Electrical.AC.Interfaces;
partial connector Plug
  "Generalized AC connector, it can be used for representing boh single and three phases systems."
  parameter Integer n "number of phases";
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
      phase[n] "phases pins"            annotation (Placement(transformation(extent={{-10,40},
            {10,60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin
      neutral "neutral pin"            annotation (Placement(transformation(extent={{-10,-60},
            {10,-40}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics));
end Plug;
