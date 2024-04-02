within Buildings.Controls.DemandResponse.BaseClasses;
partial block PartialDemandResponse
  "Partial block that declares common data for demand response models"
  extends Modelica.StateGraph.Step(nIn=1, nOut=1);
  parameter Integer nSam
    "Number of intervals in a day for which baseline is computed";

  parameter Integer nPre(min=1)
    "Number of intervals for which future load need to be predicted (set to one to only predict current time, or to nSam to predict one day)";

  parameter Buildings.Controls.Predictors.Types.PredictionModel predictionModel
    "Load prediction model";

  Modelica.Blocks.Interfaces.RealInput ECon(unit="J")
    "Consumed electrical energy"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealOutput PPre[nPre](each unit="W")
    "Predicted power consumption for the current time interval"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealInput TOutFut[nPre-1](each unit="K")
    if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Future outside air temperatures"
    annotation (Placement(
      transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  annotation ( Documentation(info="<html>
<p>
This is a partial block that declares parameters, inputs and outputs that are
used by the blocks that compute the demand reponse client.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 29, 2024, by Michael Wetter:<br/>
Due to the refactoring for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3754\">3754</a>,
this model is no longer used. It is left in the library for backward compatibility,
and will be removed for release 11.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDemandResponse;
