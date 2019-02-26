within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging;
block Controller
  "Chiller stage for fixed speed chillers (positive displacement and centrifugal),try to have optional WSE"

  parameter Integer numSta=2 "Number of stages";

  parameter Real minPlrSta1=0.1 "Minimal part load ratio of the first stage";

  parameter Real small=0.00000001 "Small number to avoid division with zero";

  parameter Modelica.SIunits.Time minStaRun=15*60 "Minimum stage runtime";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1]={small,3.517*1000*310,2
      *3.517*1000*310} "Array of nominal stage capacities starting at stage 0";

  parameter Real staUpPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Minimum operating part load ratio of the next lower stage before staging down";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=0,
    final max=numSta) "Chiller stage"
    annotation (Placement(transformation(extent={{
    140,-10},{160,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Subsequences.Change staChaPosDis
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  CDL.Interfaces.BooleanInput                        uWseSta "Waterside economizer status" annotation (
     Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-120,-110},{-100,-90}})));
  CDL.Interfaces.RealInput                        uTowFanSpeMax "Maximum cooling tower fan speed"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  CDL.Interfaces.RealInput                        TWsePre(final unit="1")
    "Predicted waterside economizer outlet temperature" annotation (Placement(
        transformation(extent={{-180,-90},{-140,-50}}), iconTransformation(
          extent={{-120,-70},{-100,-50}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity=
        "ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-180,-60},{-140,-20}}),   iconTransformation(extent={{-120,10},
            {-100,30}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity=
        "PressureDifference")
    "Chilled water pump differential static pressure" annotation (Placement(
        transformation(extent={{-180,-30},{-140,10}}),    iconTransformation(
          extent={{-120,-40},{-100,-20}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity=
        "PressureDifference")
    "Chilled water pump differential static pressure setpoint" annotation (
      Placement(transformation(extent={{-180,0},{-140,40}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));
  CDL.Interfaces.RealInput                        VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
                       "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.RealInput                        TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity=
        "ThermodynamicTemperature")
    "Chilled water supply temperature setpoint" annotation (Placement(
        transformation(extent={{-180,100},{-140,140}}), iconTransformation(
          extent={{-120,80},{-100,100}})));
  annotation (
    defaultComponentName="chiSta",
    Icon(graphics={
    Rectangle(
    extent={{-100,-100},{100,100}},
    lineColor={0,0,127},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
    Text(
      extent={{-120,146},{100,108}},
      lineColor={0,0,255},
      textString="%name")}),         Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,140}})),
    Documentation(info=
               "<html>
<p>
Fixme
</p>
</html>", revisions=
      "<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
