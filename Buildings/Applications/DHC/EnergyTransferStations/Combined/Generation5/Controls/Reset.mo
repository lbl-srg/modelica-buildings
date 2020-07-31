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
    annotation (Placement(transformation(extent={{-138,-20},{-98,20}}),
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
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSet(k=
        THeaWatSupSetMin) "Minimum value of HW set-point"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiHea "Switch"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSet(k=
        TChiWatSupSetMax) "Maximum value of CHW set-point"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter ramLimHea(
      raisingSlewRate=0.1) "Limit the rate of change"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter ramLimCoo(
      raisingSlewRate=0.1) "Limit the rate of change"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
equation
  connect(TChiWatSupPreSet, swiCoo.u1) annotation (Line(points={{-120,-80},{-80,
          -80},{-80,-52},{-2,-52}}, color={0,0,127}));
  connect(THeaWatSupPreSet, swiHea.u1) annotation (Line(points={{-118,0},{-80,0},
          {-80,68},{-2,68}},      color={0,0,127}));
  connect(minSet.y, swiHea.u3) annotation (Line(points={{-28,40},{-20,40},{-20,
          52},{-2,52}},
                    color={0,0,127}));
  connect(maxSet.y, swiCoo.u3) annotation (Line(points={{-28,-80},{-20,-80},{
          -20,-68},{-2,-68}},
                     color={0,0,127}));
  connect(uHea, swiHea.u2) annotation (Line(points={{-120,80},{-60,80},{-60,60},
          {-2,60}}, color={255,0,255}));
  connect(uCoo, swiCoo.u2) annotation (Line(points={{-120,40},{-60,40},{-60,-60},
          {-2,-60}}, color={255,0,255}));
  connect(swiHea.y, ramLimHea.u)
    annotation (Line(points={{22,60},{48,60}}, color={0,0,127}));
  connect(ramLimHea.y, THeaWatSupSet)
    annotation (Line(points={{72,60},{120,60}}, color={0,0,127}));
  connect(swiCoo.y, ramLimCoo.u)
    annotation (Line(points={{22,-60},{48,-60}}, color={0,0,127}));
  connect(ramLimCoo.y, TChiWatSupSet)
    annotation (Line(points={{72,-60},{120,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
Documentation(
revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block implements the supervisory reset of the heating water
and chilled water supply temperature.
The heating water (resp. chilled water) supply temperature is
reset down (resp. up) whenever the heating (resp. cooling) demand signal
yielded by the building automation system is <code>false</code>.
This enables operating the chiller at a reduced lift whenever
there is no requirement on the water temperature supplied to the
building system.
</p>
</html>"));
end Reset;
