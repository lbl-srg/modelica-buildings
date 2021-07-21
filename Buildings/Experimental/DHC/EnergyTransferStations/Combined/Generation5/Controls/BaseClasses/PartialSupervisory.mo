within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses;
partial block PartialSupervisory
  "Partial model for supervisory controller"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
    iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
    iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
    iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",
    displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
    iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",
    displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
    iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
    iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point after reset"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
    iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point after reset"
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
    iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValIsoEva(
    final unit="1")
    "Evaporator to ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
    iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValIsoCon(
    final unit="1")
    "Condenser to ambient loop isolation valve control signal"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
    iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1")
    "Control output for ambient sources"
    annotation (Placement(transformation(extent={{120,-40},{160,0}}),
    iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Tank in heating demand"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
    iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Tank in cooling demand"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
    iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold uHeaHol(
    trueHoldDuration=900)
    "Hold heating enable signal"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold uCooHol(
    trueHoldDuration=900)
    "Hold cooling enable signal"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
equation
  connect(uHea,uHeaHol.u)
    annotation (Line(points={{-140,100},{-112,100}},color={255,0,255}));
  connect(uCoo,uCooHol.u)
    annotation (Line(points={{-140,60},{-112,60}},color={255,0,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    defaultComponentName="conSup",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a base class for the ETS supervisory controller.
</p>
</html>"));
end PartialSupervisory;
