within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Validation;
model MultipleChillerVariant1And2
  "Validation model for the chilled water temperature setpoint reset controller with multiple chillers in Variant 1 and Variant 2"

  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Controller conVar1(
    final nChi=2,
    final zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
    final setChaWaiTim=900,
    final dTChiSetShe=0.278,
    final dTChiSetReb=0.278)
    "Controller in Variant 1 (single-step setpoint change)"
    annotation (Placement(transformation(extent={{40,40},{60,68}})));
  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Controller conVar2(
    final nChi=2,
    final zonConVar=Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_2,
    final setChaWaiTim=900,
    final dTChiSetShe=0.278,
    final dTChiSetReb=0.278)
    "Controller in Variant 2 (multiple-step setpoint change)"
    annotation (Placement(transformation(extent={{40,-68},{60,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification qua(
    final nChi=2,
    final uCooCoiMax={0.95,0.95},
    final fanSpeMax={0.95,0.95},
    final dTSupMax={1,1},
    final uCooCoiHys=0.01,
    final fanSpeHys=0.01,
    final dTSupHys=0.1)
    "Chiller qualification check"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable uCooCoi(
    final table=[0,0.5,0.5; 136000,0.5,1; 144300,0.5,0.5; 172800,0.5,0.5],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Cooling coil control signal of the two chillers"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable fanSpe(
    final table=[0,0.5,0.5; 136000,0.5,1; 144300,0.5,0.5; 172800,0.5,0.5],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Fan speed of the two chillers"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable dTSup(
    final table=[0,0,0; 136000,0,5; 144300,0,0; 172800,0,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Supply air temperature minus its setpoint of the two chillers"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable demFleMod(
    final table=[0,1; 50700,2; 65100,3; 72300,1],
    final period=86400)
    "Demand flexibility mode"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetDef[2](
    each final k=279.82)
    "Default chilled water temperature setpoint (44 degF)"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiSetTarShe[2](
    final k={281.48,280.93})
    "Target chilled water temperature setpoint for the load-shed mode (47 degF and 46 degF)"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelVar1[2](
    each final samplePeriod=10,
    each final y_start=279.82)
    "Emulates external chilled water setpoint controllers for Variant 1"
    annotation (Placement(transformation(extent={{90,44},{110,64}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDelVar2[2](
    each final samplePeriod=10,
    each final y_start=279.82)
    "Emulates external chilled water setpoint controllers for Variant 2"
    annotation (Placement(transformation(extent={{90,-64},{110,-44}})));

equation
  connect(uCooCoi.y, qua.uCooCoi) annotation (Line(points={{-138,120},{-120,120},
          {-120,86},{-102,86}}, color={0,0,127}));
  connect(fanSpe.y, qua.fanSpe)
    annotation (Line(points={{-138,80},{-102,80}}, color={0,0,127}));
  connect(dTSup.y, qua.dTSup) annotation (Line(points={{-138,40},{-120,40},
          {-120,74},{-102,74}}, color={0,0,127}));
  connect(qua.yQua, conVar1.uQua) annotation (Line(points={{-78,80},{-60,80},
          {-60,66},{38,66}}, color={255,0,255}));
  connect(qua.yQua, conVar2.uQua) annotation (Line(points={{-78,80},{-60,80},
          {-60,-42},{38,-42}}, color={255,0,255}));
  connect(demFleMod.y[1], conVar1.demFleMod) annotation (Line(points={{-138,0},
          {-40,0},{-40,53.8},{38,53.8}}, color={255,127,0}));
  connect(demFleMod.y[1], conVar2.demFleMod) annotation (Line(points={{-138,0},
          {-40,0},{-40,-54.2},{38,-54.2}}, color={255,127,0}));
  connect(TChiSetDef.y, conVar1.TChiSetDef) annotation (Line(points={{-138,-50},
          {-20,-50},{-20,46},{38,46}}, color={0,0,127}));
  connect(TChiSetDef.y, conVar2.TChiSetDef) annotation (Line(points={{-138,-50},
          {-20,-50},{-20,-62},{38,-62}}, color={0,0,127}));
  connect(TChiSetTarShe.y, conVar1.TChiSetTarShe) annotation (Line(points={{-138,-100},
          {0,-100},{0,42},{38,42}}, color={0,0,127}));
  connect(TChiSetTarShe.y, conVar2.TChiSetTarShe) annotation (Line(points={{-138,-100},
          {0,-100},{0,-66},{38,-66}}, color={0,0,127}));
  connect(conVar1.TChiSetCom, uniDelVar1.u)
    annotation (Line(points={{62,54},{88,54}}, color={0,0,127}));
  connect(uniDelVar1.y, conVar1.TChiSetCur) annotation (Line(points={{112,54},
          {130,54},{130,30},{30,30},{30,50},{38,50}}, color={0,0,127}));
  connect(conVar2.TChiSetCom, uniDelVar2.u)
    annotation (Line(points={{62,-54},{88,-54}}, color={0,0,127}));
  connect(uniDelVar2.y, conVar2.TChiSetCur) annotation (Line(points={{112,-54},
          {130,-54},{130,-80},{30,-80},{30,-58},{38,-58}}, color={0,0,127}));

annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ChillerSetpointReset/Validation/MultipleChillerVariant1And2.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Controller\">
ChillerSetpointReset.Controller</a>
for two chillers under Variant <i>1</i> (<code>conVar1</code>,
single-step setpoint change) and Variant <i>2</i>
(<code>conVar2</code>, multiple-step setpoint change of
<i>0.278</i> K, or <i>0.5</i> &deg;F). The setpoint change
waiting time is <i>900</i> s.
</p>
<p>
The default setpoint of both chillers is <i>279.82</i> K
(<i>44</i> &deg;F). The load-shed target is <i>281.48</i> K
(<i>47</i> &deg;F) for chiller <i>1</i> and <i>280.93</i> K
(<i>46</i> &deg;F) for chiller <i>2</i>. Each day, the demand
flexibility mode is load-shed from <i>50700</i> s to
<i>65100</i> s, load-rebound until <i>72300</i> s, and default
otherwise. The output of the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences.Qualification\">
ChillerSetpointReset.Subsequences.Qualification</a>
is connected to the input <code>uQua</code>. Chiller <i>2</i>
is disqualified from <i>136000</i> s to <i>144300</i> s.
A <code>UnitDelay</code> for each chiller emulates an external
setpoint controller that passes the commanded setpoint back to
<code>TChiSetCur</code> after <i>10</i> s.
</p>
<p>
Expected results for Variant <i>2</i> (<code>uniDelVar2.y</code>):
on day <i>1</i>, chiller <i>1</i> increases by one step at
<i>51310</i>, <i>52210</i>, <i>53110</i>, <i>54010</i>, and
<i>54910</i> s, and reaches its target at <i>55810</i> s.
During rebound, it decreases at <i>65710</i>, <i>66610</i>,
<i>67510</i>, <i>68410</i>, and <i>69310</i> s, and reaches the
default at <i>70210</i> s. Chiller <i>2</i> increases at
<i>51310</i>, <i>52210</i>, and <i>53110</i> s, reaches its
target at <i>54010</i> s, decreases at <i>65710</i>,
<i>66610</i>, and <i>67510</i> s, and reaches the default at
<i>68410</i> s. On day <i>2</i>, chiller <i>1</i> repeats day
<i>1</i> shifted by <i>86400</i> s. Chiller <i>2</i> stays at
the default while disqualified, increases at <i>144910</i>,
<i>145810</i>, and <i>146710</i> s, reaches its target at
<i>147610</i> s, decreases at <i>152110</i>, <i>153010</i>, and
<i>153910</i> s, and reaches the default at <i>154810</i> s.
</p>
<p>
Expected results for Variant <i>1</i> (<code>uniDelVar1.y</code>):
on day <i>1</i>, both chillers change to their targets at
<i>51310</i> s and back to the default at <i>65710</i> s. On
day <i>2</i>, chiller <i>1</i> changes to its target at
<i>137710</i> s and chiller <i>2</i> at <i>144910</i> s, and
both return to the default at <i>152110</i> s.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}),
    graphics={
      Ellipse(lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
      Polygon(lineColor={0,0,255},
              fillColor={75,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, grid={2,2},
    extent={{-180,-140},{180,140}})));
end MultipleChillerVariant1And2;
