within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Reset "Supervisory supply temperature reset"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Temperature THeaWatSupSetMin(
    displayUnit="degC")
    "Minimum value of heating water supply temperature set-point";
  parameter Modelica.SIunits.Temperature TChiWatSupSetMax(
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set-point";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={{-140,60},
            {-100,100}}),           iconTransformation(extent={{-140,60},{-100,
            100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={
            {-140,20},{-100,60}}), iconTransformation(extent={{-140,10},{-100,
            50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(final unit="K",
      displayUnit="degC")
    "Heating water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(
          extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(final unit="K",
      displayUnit="degC")
    "Chilled water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiCoo "Switch"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSet(k=
        THeaWatSupSetMin) "Minimum value of HW set-point"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiHea "Switch"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSet(k=
        TChiWatSupSetMax) "Maximum value of CHW set-point"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
equation
  connect(TChiWatSupPreSet, swiCoo.u1) annotation (Line(points={{-120,-80},{-40,
          -80},{-40,-52},{38,-52}}, color={0,0,127}));
  connect(THeaWatSupPreSet, swiHea.u1) annotation (Line(points={{-120,-40},{-60,
          -40},{-60,68},{38,68}}, color={0,0,127}));
  connect(minSet.y, swiHea.u3) annotation (Line(points={{12,40},{20,40},{20,52},
          {38,52}}, color={0,0,127}));
  connect(maxSet.y, swiCoo.u3) annotation (Line(points={{12,-80},{20,-80},{20,-68},
          {38,-68}}, color={0,0,127}));
  connect(swiCoo.y, TChiWatSupSet)
    annotation (Line(points={{62,-60},{120,-60}}, color={0,0,127}));
  connect(swiHea.y, THeaWatSupSet)
    annotation (Line(points={{62,60},{120,60}}, color={0,0,127}));
  connect(uHea, swiHea.u2) annotation (Line(points={{-120,80},{-20,80},{-20,60},
          {38,60}}, color={255,0,255}));
  connect(uCoo, swiCoo.u2) annotation (Line(points={{-120,40},{-20,40},{-20,-60},
          {38,-60}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block implement the supervisory reset of the heating water 
and chilled water supply temperature.
The heating water (resp. chilled water) supply temperature is 
reset down (resp. up) whenever the heating (resp. cooling) demand signal  
yielded by the building automation system is false.
</p>
</html>"));
end Reset;
