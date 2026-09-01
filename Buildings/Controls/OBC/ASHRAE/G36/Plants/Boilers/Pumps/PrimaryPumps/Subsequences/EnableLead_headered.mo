within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.PrimaryPumps.Subsequences;
block EnableLead_headered
    "Sequence to enable or disable the lead primary pump of plants with headered
    primary hot water pumps"

  parameter Integer nBoi=3
    "Total number of hot water isolation valves (same as number of boilers)";

  CDL.Interfaces.BooleanInput                     uHotWatIsoVal[nBoi]
    "Hot water isolation valve status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch leaPumSta
    "Lead pump status"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=nBoi)
    "Check if there are any hot water isolation valves opened"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(con.y,leaPumSta. u1)
    annotation (Line(points={{-18,40},{30,40},{30,8},{38,8}},color={255,0,255}));

  connect(con1.y,leaPumSta. u3)
    annotation (Line(points={{-18,-40},{30,-40},{30,-8},{38,-8}},
      color={255,0,255}));

  connect(leaPumSta.y, yLea)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));

  connect(mulOr.y, leaPumSta.u2)
    annotation (Line(points={{-18,0},{38,0}}, color={255,0,255}));

  connect(uHotWatIsoVal, mulOr.u)
    annotation (Line(points={{-120,0},{-42,0}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLeaPriPum_headered",
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
          extent={{-94,12},{-40,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHotIsoVal"),
        Text(
          extent={{42,12},{96,-10}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLeaPum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enables and disables lead primary hot water pump, for plants
with headered primary hot water pumps, according to ASHRAE Guideline 36, 2021, 
section 5.21.6.2.
</p>
<ul>
<li>
The lead primary hot water pump shall be enabled when any boilers
hot water isolation valve is commanded open <code>uHotWatIsoVal &gt; 0.975</code>,
and shall be disabled when all boilers' hot water isolation valves are commanded closed
<code>uHotWatIsoVal &le; 0.975</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_headered;
