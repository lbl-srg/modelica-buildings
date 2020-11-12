within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model SideCold1
  "Control block for cold side"
  extends BaseClasses.PartialSideHotCold(
    final reverseActing=true);
  parameter Modelica.SIunits.TemperatureDifference dTHys(
    min=0)=1
    "Temperature hysteresis (full width, absolute value)";
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Maximum tank temperature"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  LimPlaySequence conPlaSeq(
    have_enaSig=true,
    final nCon=nSouAmb,
    yThr=0.9,
    final hys=dTHys,
    final dea=dTDea,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=Modelica.Constants.eps,
    final h=0.5*Modelica.Constants.eps)
    "At least one signal is non zero"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert DO to AO signal"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    nin=nSouAmb)
    "Maximum of control signals for ambient sources"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRej
    "Enable signal for heat or cold rejection"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),iconTransformation(extent={{-140,20},{-100,60}})));
equation
  connect(max.u2,TBot)
    annotation (Line(points={{-92,-46},{-120,-46},{-120,-140},{-200,-140}},color={0,0,127}));
  connect(max.y,errDis.u2)
    annotation (Line(points={{-68,-40},{-60,-40},{-60,-12}},color={0,0,127}));
  connect(TBot,errEna.u2)
    annotation (Line(points={{-200,-140},{-120,-140},{-120,20},{-80,20},{-80,28}},color={0,0,127}));
  connect(TTop,max.u1)
    annotation (Line(points={{-200,-40},{-100,-40},{-100,-34},{-92,-34}},color={0,0,127}));
  connect(TTop,swi.u1)
    annotation (Line(points={{-200,-40},{-100,-40},{-100,-172},{-92,-172}},color={0,0,127}));
  connect(greThr.y,booToRea.u)
    annotation (Line(points={{102,-140},{118,-140}},color={255,0,255}));
  connect(booToRea.y,yValIso)
    annotation (Line(points={{142,-140},{160,-140},{160,-120},{200,-120}},color={0,0,127}));
  connect(TSet,conPlaSeq.u_s)
    annotation (Line(points={{-200,40},{-160,40},{-160,-140},{-72,-140}},color={0,0,127}));
  connect(mulMax.y,greThr.u)
    annotation (Line(points={{62,-140},{78,-140}},color={0,0,127}));
  connect(TSet,swi.u3)
    annotation (Line(points={{-200,40},{-160,40},{-160,-188},{-92,-188}},color={0,0,127}));
  connect(swi.y,conPlaSeq.u_m)
    annotation (Line(points={{-68,-180},{-60,-180},{-60,-152}},color={0,0,127}));
  connect(conPlaSeq.y,mulMax.u)
    annotation (Line(points={{-48,-140},{38,-140}},color={0,0,127}));
  connect(conPlaSeq.y,yAmb)
    annotation (Line(points={{-48,-140},{0,-140},{0,-80},{200,-80}},color={0,0,127}));
  connect(uRej,swi.u2)
    annotation (Line(points={{-200,140},{-140,140},{-140,-180},{-92,-180}},color={255,0,255}));
  connect(uRej,conPlaSeq.uEna)
    annotation (Line(points={{-200,140},{-140,140},{-140,-160},{-64,-160},{-64,-152}},color={255,0,255}));
  annotation (
    defaultComponentName="conCol",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p>
This block serves as the controller for the cold side of the ETS in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory1\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory1</a>.
See
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>
for the computation of the demand signal <code>yDem</code>.
The other control signals are computed as follows.
</p>
<ul>
<li>
Control signals for ambient sources <code>yAmb</code> (array)<br/>
The systems serving as ambient sources are
<ul>
<li>
enabled if the cold rejection mode signal is <code>true</code>, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.RejectionMode\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.RejectionMode</a>,
</li>
<li>
controlled in sequence with an instance of
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlaySequence</a>
limiting the decrease in the temperature measured at the top of the tank as
illustrated on the figure below.
</li>
</ul>
<li>
Control signal for the evaporator loop isolation valve <code>yIsoAmb</code><br/>

The valve is commanded to be fully open whenever the maximum of the
ambient source control signals is greater than zero.
</li>
</ul>
<p>
<img alt=\"Sequence chart for hot side\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Combined/Generation5/Controls/SideCold1.png\"/>
</p>
</html>"));
end SideCold1;
