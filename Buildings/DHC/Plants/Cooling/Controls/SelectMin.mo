within Buildings.DHC.Plants.Cooling.Controls;
block SelectMin
  "Block that includes or excludes storage plant pressure signal for min"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nin
    "Number of input connections"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpUse[nin]
    "Connector of Real input signals" annotation (Placement(transformation(
          extent={{-120,60},{-100,40}}), iconTransformation(extent={{-140,80},{-100,
            40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpStoPla
    "Connector of Real input signals" annotation (Placement(transformation(
          extent={{-120,10},{-100,-10}}), iconTransformation(extent={{-140,20},{
            -100,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput isChaRem
    "The storage plant is in remote charging mode" annotation (Placement(
        transformation(extent={{-120,-60},{-100,-40}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));
equation
  y = if isChaRem then
        min(min(dpUse),dpStoPla)
      else
        min(dpUse);
annotation(defaultComponentName="selMin",
    Icon(graphics={Line(
          points={{-80,60},{-60,40},{-20,80}},
          color={0,140,72},
          thickness=5), Text(
          extent={{-78,2},{-20,-78}},
          textColor={28,108,200},
          textString="?")}),
    Documentation(info="<html>
<p>
This block finds the minimum value from pressure head signals.
The signal from the storage plant is included
only when the plant is in remote charging mode.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 23, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SelectMin;
