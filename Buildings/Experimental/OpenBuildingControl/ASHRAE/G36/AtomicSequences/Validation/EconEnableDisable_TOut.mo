within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model EconEnableDisable_TOut
  "Validation model for econ high limit lockout based on the 
  outdoor air temperature_fixm   e"
  extends Modelica.Icons.Example;

  EconEnableDisable econEnableDisable
    annotation (Placement(transformation(extent={{-20,-6},{0,24}})));
  CDL.Logical.Constant FreezestatStatus(k=false)
    "Keep freezestat alarm off for this validation test"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Continuous.Constant EcoDamPosMax(k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-52},{-60,-32}})));
  CDL.Continuous.Constant EcoDamPosMin(k=0.1)
    "Minimum allowed economizer damper position"
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
  CDL.Interfaces.RealOutput yEcoDamPosMax
    annotation (Placement(transformation(extent={{38,0},{58,20}})));
  CDL.Continuous.Constant TSup(k=277.594)
    "Set TSup to a constant value above 38F"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp TOut(
    duration=1200,
    height=10,
    offset=293.15)      "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(FreezestatStatus.y, econEnableDisable.uFre) annotation (Line(
        points={{-59,-10},{-40,-10},{-40,9.8},{-22,9.8}}, color={255,0,255}));
  connect(EcoDamPosMax.y, econEnableDisable.uEcoDamPosMin) annotation (Line(
        points={{-59,-42},{-36,-42},{-36,5.4},{-22,5.4}}, color={0,0,127}));
  connect(EcoDamPosMin.y, econEnableDisable.uEcoDamPosMax) annotation (Line(
        points={{-59,-76},{-32,-76},{-32,0.6},{-22,0.6}}, color={0,0,127}));
  connect(econEnableDisable.yEcoDamPosMax, yEcoDamPosMax) annotation (Line(
        points={{1.9,10.3},{26.95,10.3},{26.95,10},{48,10}}, color={0,0,127}));
  connect(TSup.y, econEnableDisable.TSup) annotation (Line(points={{-59,30},
          {-46,30},{-46,14.4},{-22,14.4}}, color={0,0,127}));
  connect(TOut.y, econEnableDisable.TOut) annotation (Line(points={{-59,70},
          {-42,70},{-42,19.4},{-22,19.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EconEnableDisable_TOut;
