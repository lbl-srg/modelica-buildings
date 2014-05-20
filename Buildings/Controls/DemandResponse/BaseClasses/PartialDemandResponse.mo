within Buildings.Controls.DemandResponse.BaseClasses;
block PartialDemandResponse
  "Partial block that declares common data for demand response models"
  extends Modelica.StateGraph.Step;
  parameter Integer nSam = 24
    "Number of intervals in a day for which baseline is computed";

  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Currently consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for the current time interval"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>
This is a partial block that declares parameters, inputs and outputs that are
used by the blocks that compute the demand reponse client.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDemandResponse;
