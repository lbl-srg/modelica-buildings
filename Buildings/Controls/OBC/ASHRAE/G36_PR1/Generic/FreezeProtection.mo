within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic;
model FreezeProtection
  "Freeze protection sequence according to G36 PART5.N.12 and PART5.O.9"

  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
     iconTransformation(extent={{-220,-80},{-180,-40}})));
  CDL.Interfaces.RealInput TSup(unit="K", quantity="ThermodynamicTemperature")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-220,-16},{-180,24}}),
    iconTransformation(extent={{-220,-20},{-180,20}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Continuous.LessThreshold TSupThreshold(threshold=273.15 + 3.3)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Continuous.Greater greater
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant TSupTimeLimit(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  CDL.Continuous.LessThreshold TSupThreshold1(threshold=273.15 + 4.4)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  CDL.Continuous.Greater greater1
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  CDL.Logical.Timer timer2
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant TSupTimeLimit1(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Continuous.LessThreshold TSupThreshold2(threshold=273.15 + 1.1)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  CDL.Logical.Timer timer3
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant TSupTimeLimit2(
                                        k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  CDL.Continuous.Greater greater2
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  CDL.Continuous.LessThreshold TSupThreshold3(threshold=273.15 + 3.3)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Logical.Timer timer4
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant TSupTimeLimit3(k=900)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Continuous.Greater greater3
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  CDL.Logical.Or3 or1
    annotation (Placement(transformation(extent={{78,-38},{98,-18}})));

protected
  CDL.Conversions.BooleanToInteger                        booToInt(integerTrue=
        Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage1,
      integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage0)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  CDL.Conversions.BooleanToInteger                        booToInt1(
      integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage0,
      integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage2)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{32,50},{52,70}})));
  CDL.Conversions.BooleanToInteger                        booToInt2(
      integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage0,
      integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.FreezeProtectionStages.stage3)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{110,-100},{130,-80}})));
public
  CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  CDL.Integers.Max maxInt1
    annotation (Placement(transformation(extent={{110,20},{130,40}})));
protected
  CDL.Logical.TrueDelay fixme(final delayTime=stage1disDel) "fixme"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  CDL.Logical.TrueDelay                        delOutDamOsc1(final delayTime=
        disDel)
    "Small delay before closing the outdoor air damper to avoid pressure fluctuations"
    annotation (Placement(transformation(extent={{-40,-48},{-20,-28}})));
  CDL.Continuous.Sources.Constant                        oneBoiPlaReq(final k=1) if
                  (have_heaWatCoi and have_heaPla)
    "Constant 1"
    annotation (Placement(transformation(extent={{86,-196},{106,-176}})));
  CDL.Continuous.Sources.Constant                        zerBoiPlaReq(final k=0) if
                  (have_heaWatCoi
     and have_heaPla)
    "Constant 0"
    annotation (Placement(transformation(extent={{86,-236},{106,-216}})));
  CDL.Conversions.RealToInteger                        reaToInt3 if (have_heaWatCoi and
    have_heaPla)
    "Convert real to integer value"
    annotation (Placement(transformation(extent={{186,-216},{206,-196}})));
  CDL.Logical.Switch                        swi10 if (have_heaWatCoi and
    have_heaPla)
    "Output 0 or 1 request "
    annotation (Placement(transformation(extent={{146,-216},{166,-196}})));
public
  CDL.Interfaces.IntegerOutput yHeaPlaReq if (have_heaWatCoi and have_heaPla)
    "Heating plant request"
    annotation (Placement(transformation(extent={{260,-210},{280,-190}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
equation
  connect(TSupThreshold.y, timer1.u) annotation (Line(points={{-119,70},{-119,
          70},{-102,70}},            color={255,0,255}));
  connect(TSupTimeLimit.y, greater.u2) annotation (Line(points={{-79,40},{-70,
          40},{-70,52},{-62,52}}, color={0,0,127}));
  connect(timer1.y, greater.u1) annotation (Line(points={{-79,70},{-70,70},{-70,
          60},{-62,60}},   color={0,0,127}));
  connect(TSup, TSupThreshold.u) annotation (Line(points={{-200,4},{-200,4},{
          -158,4},{-158,70},{-142,70}},
                              color={0,0,127}));
  connect(TSupTimeLimit1.y, greater1.u2) annotation (Line(points={{-79,140},{
          -70,140},{-70,152},{-62,152}}, color={0,0,127}));
  connect(timer2.y, greater1.u1) annotation (Line(points={{-79,170},{-70,170},{
          -70,160},{-62,160}}, color={0,0,127}));
  connect(TSupThreshold1.y, timer2.u) annotation (Line(points={{-119,170},{-119,
          170},{-102,170}}, color={255,0,255}));
  connect(timer3.y, greater2.u1) annotation (Line(points={{1,-130},{10,-130},{
          10,-140},{18,-140}}, color={0,0,127}));
  connect(TSupThreshold2.y, timer3.u) annotation (Line(points={{-39,-130},{-39,
          -130},{-22,-130}},color={255,0,255}));
  connect(TSupTimeLimit2.y, greater2.u2) annotation (Line(points={{1,-160},{10,
          -160},{10,-148},{18,-148}},    color={0,0,127}));
  connect(timer4.y, greater3.u1) annotation (Line(points={{-79,-80},{-70,-80},{
          -70,-90},{-62,-90}},    color={0,0,127}));
  connect(TSupThreshold3.y, timer4.u) annotation (Line(points={{-119,-80},{-119,
          -80},{-102,-80}},        color={255,0,255}));
  connect(TSupTimeLimit3.y, greater3.u2) annotation (Line(points={{-79,-110},{
          -70,-110},{-70,-98},{-62,-98}},   color={0,0,127}));
  connect(uFre, or1.u1) annotation (Line(points={{-200,-60},{-72,-60},{-72,-20},
          {76,-20}}, color={255,0,255}));
  connect(greater3.y, or1.u2) annotation (Line(points={{-39,-90},{20,-90},{20,-28},
          {76,-28}},      color={255,0,255}));
  connect(greater2.y, or1.u3) annotation (Line(points={{41,-140},{60,-140},{60,-36},
          {76,-36}},      color={255,0,255}));
  connect(TSup, TSupThreshold1.u) annotation (Line(points={{-200,4},{-180,4},{
          -158,4},{-158,170},{-142,170}}, color={0,0,127}));
  connect(TSup, TSupThreshold3.u) annotation (Line(points={{-200,4},{-158,4},{
          -158,-80},{-142,-80}}, color={0,0,127}));
  connect(TSup, TSupThreshold2.u) annotation (Line(points={{-200,4},{-180,4},{
          -158,4},{-158,-130},{-62,-130}}, color={0,0,127}));
  connect(maxInt1.y, maxInt.u1) annotation (Line(points={{131,30},{134,30},{134,
          6},{138,6}}, color={255,127,0}));
  connect(yFreProSta, maxInt.y)
    annotation (Line(points={{190,0},{161,0}}, color={255,127,0}));
  connect(maxInt1.u2, booToInt1.y) annotation (Line(points={{108,24},{80,24},{80,
          60},{53,60}}, color={255,127,0}));
  connect(maxInt1.u1, booToInt.y) annotation (Line(points={{108,36},{104,36},{104,
          160},{101,160}}, color={255,127,0}));
  connect(maxInt.u2, booToInt2.y) annotation (Line(points={{138,-6},{134,-6},{134,
          -90},{131,-90}}, color={255,127,0}));
  connect(or1.y, booToInt2.u) annotation (Line(points={{99,-28},{104,-28},{104,-90},
          {108,-90}}, color={255,0,255}));
  connect(oneBoiPlaReq.y,swi10. u1)
    annotation (Line(points={{107,-186},{126,-186},{126,-198},{144,-198}},
      color={0,0,127}));
  connect(zerBoiPlaReq.y,swi10. u3)
    annotation (Line(points={{107,-226},{126,-226},{126,-214},{144,-214}},
      color={0,0,127}));
  connect(swi10.y,reaToInt3. u)
    annotation (Line(points={{167,-206},{184,-206}}, color={0,0,127}));
  connect(reaToInt3.y, yHeaPlaReq) annotation (Line(points={{207,-206},{214,-206},
          {214,-200},{270,-200}}, color={255,127,0}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-180,-200},{180,200}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-38,-140},{-38,126},{66,126}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-38,18},{42,18}},
          color={28,108,200},
          thickness=0.5)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-280},{260,280}},
        initialScale=0.1), graphics={
        Rectangle(extent={{-254,274},{256,94}}, lineColor={0,0,255}),
        Rectangle(extent={{-254,90},{256,-90}}, lineColor={0,0,255}),
        Rectangle(extent={{-254,-94},{256,-276}}, lineColor={0,0,255}),
        Text(
          extent={{214,268},{250,264}},
          lineColor={0,0,255},
          textString="Stage 1"),
        Text(
          extent={{208,76},{244,72}},
          lineColor={0,0,255},
          textString="Stage 2"),
        Text(
          extent={{212,-254},{248,-258}},
          lineColor={0,0,255},
          textString="Stage 3")}),
    Documentation(info="<html>      
    <p>
This sequence implements the Freeze Protection according to G36 PART5.N.12 and O.9.
Inputs to the sequence are outdoor air temperature, supply air temperature, and 
freezestat status (if installed).
</p>   
<p>
Usage
</p>
<p>
The sequence is designed to output the Freeze Protection Stage. This signal should
get passed to any sequence influenced by the freeze protection stage as perscribed in ASHRAE G36, 
through a request block or directly. The initial output value is Freeze Protection Stage 0, which enumerates
a status where all relevant conditions are satisfying and freeze protection is not activated. 
The conditions for stages 1 through 3 are as follows:
</p>
<p>
Freeze Protection Stage 1:
</p>
<p>
Enable: TSup below 4.5℃ [40°F] for 5 minutes<br/>
Disable: TSup above 7℃ [45°F] for 5 minutes
</p>
<p>
Freeze Protection Stage 2:
</p>
<p>
Enable: TSup below 3.5℃ [38°F] for 5 minutes<br/>
Disable: After 1 hour set to Stage 1
</p>
<p>
Freeze Protection Stage 3:
</p>
<p>
Enable: TSup below 4.5℃ [40°F] for 15 minutes or 
TOut below 1.1℃ [34°F] for 5 minutes or Freezestat Status is ON (if installed) <br/>
Disable: Manual reset
</p>
<p>
Values in other sequences that react to the Freeze Protection Stage output:
</p>
<p>
Freeze Protection Stage 1 activated:
</p>
<p>
Make sure to affect: <br/>
EconomizerControl: set outDamPos to outDamPosMin <br/>
***TSupSet sequences: maintain TSup above 5.5℃ [42°F] <br/>
Send 2 or more BoilerPlantRequests [fixme: what are these supposed to do exactly,
which sequence do they influence?]
</p>
<p>
Freeze Protection Stage 2 activated:
</p>
<p>
Make sure to affect: <br/>
EconomizerControl: set outDamPos to outDamPhyPosMin <br/>
set Level 3 alarm [fixme: how are alarms implemented]
</p>
<p>
Freeze Protection Stage 3:
</p>
<p>
Make sure to affect: [fixme: most of these conditions are still not implemented in other sequences, go throught them and 
make sure that all variables are affected as desired]
EconomizerControl: set outDamPos to outDamPhyPosMin <br/>
Supply fan OFF<br/>
Relief fan OFF<br/>
Open cooling coil valve to 100%<br/>
Send Boiler Plant Requests (2 or more) to maintain max(TSup, TMix)>=80°F<br/>
Set Level 2 alarm [fixme - make Alarm sequence that takes freeze status as output, 
among other inputs req by G36, and output alarm level type output]
</p>
<p align=\"center\">
<img alt=\"Image of fixme\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtection;
