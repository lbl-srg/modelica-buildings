within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLead_headered
  "Sequence to enable or disable the lead pump of plants with headered primary chilled water pumps"
  parameter Integer nChi=2 "Total number of chiller CHW isolation valves";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch leaPumSta "Lead pump status"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4[nChi](
    final uLow=fill(0.925,nChi),
    final uHigh=fill(0.975, nChi))
    "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr2(final nin=nChi)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(con.y,leaPumSta. u1)
    annotation (Line(points={{-18,60},{30,60},{30,8},{38,8}},color={255,0,255}));
  connect(con1.y,leaPumSta. u3)
    annotation (Line(points={{-18,-60},{30,-60},{30,-8},{38,-8}},
      color={255,0,255}));
  connect(leaPumSta.y, yLea)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));
  connect(uChiWatIsoVal, hys4.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(hys4.y, mulOr2.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={255,0,255}));
  connect(mulOr2.y, leaPumSta.u2)
    annotation (Line(points={{-18,0},{38,0}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLeaChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,12},{-20,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{42,12},{96,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps and parallel chillers, 
according to ASHRAE Guideline36-2021, 
section 5.20.6 Primary chilled water pumps, part 1 and 2.
</p>
<ol>
<li>
Primary chilled water pumps shall be lead-lag. Note that the lead-lag control is
implemented in a separated sequence.
</li>
<li>
The lead primary chilled water pump shall be enabled when any chiller
CHW isolation valve <code>uChiIsoVal</code> is fully open, shall be disabled
when chiller CHW isolation valves are commanded closed.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 1, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_headered;
