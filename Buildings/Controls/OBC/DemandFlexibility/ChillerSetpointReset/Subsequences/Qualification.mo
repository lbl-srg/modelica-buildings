within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences;
block Qualification "Chiller plant qualification check"

  parameter Integer nChi(final min=1)
    "Number of chillers";
  parameter Real uCooCoiMax[nChi](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Cooling coil control signal threshold, set slightly below full signal (e.g., 0.95) so a fully open coil is detected";
  parameter Real fanSpeMax[nChi](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Fan speed threshold, set slightly below maximum speed (e.g., 0.95) so a fan at full speed is detected";
  parameter Real dTSupMax[nChi](
    each final unit="K",
    each final quantity="TemperatureDifference")
    "Threshold for the supply air temperature deviation above its setpoint";
  parameter Real uCooCoiHys(
    final unit="1",
    final min=0)
    "Cooling coil control signal hysteresis";
  parameter Real fanSpeHys(
    final unit="1",
    final min=0)
    "Fan speed hysteresis";
  parameter Real dTSupHys(
    final unit="K",
    final quantity="TemperatureDifference",
    final min=0)
    "Supply air temperature deviation hysteresis";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi[nChi](
    each final unit="1")
    "Cooling coil control signal, one per chiller"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpe[nChi](
    each final unit="1")
    "Supply fan speed, one per chiller"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dTSup[nChi](
    each final unit="K",
    each final quantity="TemperatureDifference")
    "Supply air temperature minus its setpoint, one per chiller, positive when supply air is warmer than setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yQua[nChi]
    "True if the chiller is qualified for chilled water setpoint reset"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greUCooCoiMax[nChi](
    final t=uCooCoiMax,
    final h=fill(uCooCoiHys, nChi))
    "Check if the cooling coil signal is greater than its threshold"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greFanSpeMax[nChi](
    final t=fanSpeMax,
    final h=fill(fanSpeHys, nChi))
    "Check if the fan speed is greater than its threshold"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greDTSupMax[nChi](
    final t=dTSupMax,
    final h=fill(dTSupHys, nChi))
    "Check if the supply air temperature deviation is greater than its threshold"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And andCooCoiFanSpe[nChi]
    "Check if both conditions for the cooling coil signal and the fan speed are met"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.And andAll[nChi]
    "Check if all 3 conditions are met, meaning the cooling load served by the chiller is at its limit"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCooLim[nChi]
    "Qualify the chiller if its cooling load is not at its limit"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

equation
  connect(uCooCoi, greUCooCoiMax.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={0,0,127}));
  connect(fanSpe, greFanSpeMax.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(dTSup, greDTSupMax.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));
  connect(greUCooCoiMax.y, andCooCoiFanSpe.u1)
    annotation (Line(points={{-58,60},{-50,60},{-50,30},{-42,30}}, color={255,0,255}));
  connect(greFanSpeMax.y, andCooCoiFanSpe.u2)
    annotation (Line(points={{-58,0},{-50,0},{-50,22},{-42,22}}, color={255,0,255}));
  connect(andCooCoiFanSpe.y, andAll.u1)
    annotation (Line(points={{-18,30},{-10,30},{-10,0},{-2,0}}, color={255,0,255}));
  connect(greDTSupMax.y, andAll.u2)
    annotation (Line(points={{-58,-60},{-10,-60},{-10,-8},{-2,-8}}, color={255,0,255}));
  connect(andAll.y, notCooLim.u)
    annotation (Line(points={{22,0},{48,0}}, color={255,0,255}));
  connect(notCooLim.y, yQua)
    annotation (Line(points={{72,0},{120,0}}, color={255,0,255}));

  annotation (defaultComponentName="qua",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
      grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
      textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
October 22, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Chiller load check for the chilled water temperature setpoint
reset demand flexibility strategy.
</p>
<p>
The check is performed separately for each of the
<code>nChi</code> chillers. The cooling load served by chiller
<code>i</code> is considered to be at its limit if all of the
following conditions are true:
</p>
<ul>
<li>
the cooling coil control signal <code>uCooCoi[i]</code> is
greater than <code>uCooCoiMax[i]</code>,
</li>
<li>
the supply air temperature deviation <code>dTSup[i]</code>
(supply air temperature minus its setpoint) is greater than
<code>dTSupMax[i]</code>, and
</li>
<li>
the fan speed <code>fanSpe[i]</code> is greater than
<code>fanSpeMax[i]</code>.
</li>
</ul>
<p>
If so, chiller <code>i</code> is disqualified and
<code>yQua[i] = false</code>. Otherwise, it is qualified and
<code>yQua[i] = true</code>.
</p>
<p>
The sequence specifies the fan speed condition as greater than
or equal to the maximum. Because the comparison is strictly
greater than, the thresholds <code>fanSpeMax</code> and
<code>uCooCoiMax</code> should be set slightly below full output
so that a fan or coil operating at 100% is detected.
</p>
<p>
The zone temperature and chilled water temperature conditions
of the sequence are not yet implemented.
</p>
</html>"));
end Qualification;
