within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion;
model ACDCConverter
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses.PartialConverter(
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter conv1(
      conversionFactor=conversionFactor,
      eta=eta,
      ground_AC=ground_AC,
      ground_DC=ground_DC),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter conv2(
      conversionFactor=conversionFactor,
      eta=eta,
      ground_AC=ground_AC,
      ground_DC=ground_DC),
    redeclare Buildings.Electrical.AC.OnePhase.Conversion.ACDCConverter conv3(
      conversionFactor=conversionFactor,
      eta=eta,
      ground_AC=ground_AC,
      ground_DC=ground_DC));
  parameter Real conversionFactor
    "Ratio of QS rms voltage on side 2 / QS rms voltage on side 1";
  parameter Real eta(min=0, max=1)
    "Converter efficiency, pLoss = (1-eta) * 'abs'(v2QS)";
  parameter Boolean ground_AC = false "Connect AC side of converter to ground" annotation(Dialog(tab = "Ground", group="AC side"));
  parameter Boolean ground_DC = true "Connect DC side of converter to ground" annotation(Dialog(tab = "Ground", group="DC side"));
equation

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Line(
          points={{2,60},{2,60},{82,60},{2,60},{82,-60},{2,-60},{2,60},{2,-60}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{36,54},{96,14}},
          lineColor={0,0,255},
          textString="DC"),
        Line(
          points={{-2,60},{-2,60},{-82,60},{-2,60},{-82,-60},{-2,-60},{-2,60},{
              -2,-60}},
          color={0,120,120},
          smooth=Smooth.None),
        Text(
          extent={{-100,52},{-40,12}},
          lineColor={0,120,120},
          textString="AC"),
        Text(
          extent={{-100,92},{100,60}},
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{-100,-60},{100,-92}},
          lineColor={0,0,255},
          textString="%conversionFactor"),
        Line(
          points={{100,-100},{100,-12}},
          color=DynamicSelect({0,0,255}, if ground_DC then {0,0,255} else {
              255,255,255}),
          smooth=Smooth.None),
        Line(
          points={{-80,-40},{-120,-40}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-80,-40},{-106,-14}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-102,-16},{-114,-24},{-118,-42}},
          color=DynamicSelect({0,120,120}, if ground_AC then {0,120,120} else {
              255,255,255}),
          smooth=Smooth.Bezier)}));
end ACDCConverter;
