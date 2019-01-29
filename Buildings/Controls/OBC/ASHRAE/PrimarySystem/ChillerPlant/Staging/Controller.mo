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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
    iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
    iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=0,
    final max=numSta) "Chiller stage"
    annotation (Placement(transformation(extent={{
    140,-10},{160,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
"Chilled water return temperature" annotation (Placement(transformation(
      extent={{-180,10},{-140,50}}),     iconTransformation(extent={{-120,0},
        {-100,20}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump differential static pressure setpoint"
annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
  iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump differential static pressure"
annotation (Placement(
    transformation(extent={{-180,-170},{-140,-130}}), iconTransformation(
      extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput chiWatPumSpe(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump speed"
annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
                             iconTransformation(extent={{-140,-100},{-100,-60}})));
  Subsequences.Capacities staCap
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Subsequences.CapacityRequirement capReq
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Subsequences.PartLoadRatios PLRs
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Subsequences.Up staUp
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Subsequences.Down staDow
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(capReq.y, PLRs.uCapReq) annotation (Line(points={{-79,10},{-70,10},{
          -70,-3},{-61,-3}}, color={0,0,127}));
  connect(staCap.yStaNom, PLRs.uStaCapNom) annotation (Line(points={{-79,-23},{
          -74,-23},{-74,-5},{-61,-5}}, color={0,0,127}));
  connect(staCap.yStaUpNom, PLRs.uStaUpCapNom) annotation (Line(points={{-79,
          -27},{-72,-27},{-72,-7},{-61,-7}}, color={0,0,127}));
  connect(staCap.yStaDowNom, PLRs.uStaDowCapNom) annotation (Line(points={{-79,
          -31},{-70,-31},{-70,-9},{-61,-9}}, color={0,0,127}));
  connect(staCap.yStaUpMin, PLRs.uStaUpCapMin) annotation (Line(points={{-79,
          -36},{-66,-36},{-66,-11},{-61,-11}}, color={0,0,127}));
  connect(staCap.yStaMin, PLRs.uStaCapMin) annotation (Line(points={{-79,-38},{
          -64,-38},{-64,-13},{-61,-13}}, color={0,0,127}));
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
