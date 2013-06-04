within Districts.Electrical.DC.Interfaces;
partial model TwoPort
  "Component with two DC connectors ('positive' and 'negative')"

  TwoPin_n term_n annotation (Placement(transformation(extent={{-120,-20},{-100,
            0}}), iconTransformation(extent={{-120,-20},{-80,20}})));
  TwoPin_p term_p annotation (Placement(transformation(extent={{80,-20},{100,0}}),
        iconTransformation(extent={{80,-20},{120,20}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end TwoPort;
