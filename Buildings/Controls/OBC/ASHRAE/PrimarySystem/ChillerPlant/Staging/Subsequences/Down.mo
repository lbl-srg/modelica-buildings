within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Down "Conditions to enable stage down"

  // fixme: pull OPRLup and OPRLdown out into chiller type staging packages
  parameter Integer numSta = 2
  "Number of stages";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
  "Minimum chiller load time below or above current stage before a change is enabled";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

  CDL.Interfaces.RealInput uOplrUp(final unit="1")
    "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{-220,-90},{-180,-50}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uOplrUpMin(final unit="1")
    "Minimum operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(
    transformation(extent={{-220,-300},{-180,-260}}), iconTransformation(
     extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
    iconTransformation(extent={{-120,-20},{-100,0}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(
      extent={{-220,-220},{-180,-180}}), iconTransformation(extent={{-120,-40},{
            -100,-20}})));
  CDL.Interfaces.RealInput uOplr(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-220,120},{-180,160}}),iconTransformation(
          extent={{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uSplrUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-220,90},{-180,130}}),iconTransformation(extent=
           {{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uOplrDow(final unit="1")
    "Operating part load ratio of the next stage down" annotation (Placement(
        transformation(extent={{-220,0},{-180,40}}),  iconTransformation(extent=
           {{-120,70},{-100,90}})));
  CDL.Interfaces.RealInput uSplrDow(final unit="1")
    "Staging part load ratio of the next stage down"
                                                   annotation (Placement(
        transformation(extent={{-220,-40},{-180,0}}), iconTransformation(extent=
           {{-120,70},{-100,90}})));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-280},{180,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

add WSE enable at plant enable part (input, output, predicted temperature) and at staging down from 1.
</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Down;
