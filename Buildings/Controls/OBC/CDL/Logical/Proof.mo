within Buildings.Controls.OBC.CDL.Logical;
block Proof "Verify two boolean inputs"
  Interfaces.BooleanInput u1 "Connector of Boolean input signal" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.BooleanOutput y1 "Connector of Boolean output signal" annotation (
      Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(
          extent={{100,40},{140,80}})));

  Interfaces.BooleanInput u2 "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.BooleanOutput y2 "Connector of Boolean output signal" annotation (
      Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
end Proof;
