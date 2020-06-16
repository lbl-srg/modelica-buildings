within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Reset "Supply temperature reset"
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
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
equation
  connect(TChiWatSupPreSet, swiCoo.u1) annotation (Line(points={{-120,-80},{-40,
          -80},{-40,-52},{38,-52}}, color={0,0,127}));
  connect(uCoo, swiCoo.u2) annotation (Line(points={{-120,40},{-20,40},{-20,-60},
          {38,-60}}, color={255,0,255}));
  connect(THeaWatSupPreSet, swiHea.u1) annotation (Line(points={{-120,-40},{-60,
          -40},{-60,68},{38,68}}, color={0,0,127}));
  connect(uHea, swiHea.u2) annotation (Line(points={{-120,80},{-20,80},{-20,60},
          {38,60}}, color={255,0,255}));
  connect(minSet.y, swiHea.u3) annotation (Line(points={{12,40},{20,40},{20,52},
          {38,52}}, color={0,0,127}));
  connect(maxSet.y, swiCoo.u3) annotation (Line(points={{10,-80},{20,-80},{20,-68},
          {38,-68}}, color={0,0,127}));
  connect(swiCoo.y, TChiWatSupSet)
    annotation (Line(points={{62,-60},{120,-60}}, color={0,0,127}));
  connect(swiHea.y, THeaWatSupSet)
    annotation (Line(points={{62,60},{120,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Reset;
