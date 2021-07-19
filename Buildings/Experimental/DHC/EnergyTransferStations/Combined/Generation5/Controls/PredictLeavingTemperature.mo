within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model PredictLeavingTemperature
  "Block that predicts heat exchanger leaving water temperature"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal
    "Heat exchanger approach"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Heat exchanger secondary mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1WatEnt(
    final unit="K",
    displayUnit="degC")
    "Heat exchanger primary water entering temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput T2WatLvg(
    final unit="K",
    displayUnit="degC")
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m2_flow(
    final unit="kg/s")
    "Heat exchanger secondary mass flow rate" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent=
           {{-140,30},{-100,70}})));
protected
  Real ratLoa "Part load ratio";
equation
  ratLoa = min(1, abs(m2_flow / m2_flow_nominal));
  T2WatLvg = T1WatEnt + dTApp_nominal * ratLoa;
annotation (
  defaultComponentName="calTemLvg",
  Documentation(
    revisions="<html>
<ul>
<li>
July 14, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block computes the predicted heat exchanger leaving water temperature
as used in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.WatersideEconomizer\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.WatersideEconomizer</a>.
</p>
<p>
The predicted heat exchanger approach is computed as
</p>
<p>
<i>dTApp = dTApp_nominal * m2_flow / m2_flow_nominal</i>.
</p>
<p>
Which gives the predicted heat exchanger leaving water temperature as
</p>
<p>
<i>T2WatLvg = T1WatEnt + dTApp</i>.
</p>
</html>"));
end PredictLeavingTemperature;
