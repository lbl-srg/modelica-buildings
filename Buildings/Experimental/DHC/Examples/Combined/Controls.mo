within Buildings.Experimental.DHC.Examples.Combined;
package Controls "Package of control blocks for distribution systems"

  model MainPump "Main pump controller"
    extends Modelica.Blocks.Icons.Block;
    parameter Integer nMix(min=1) "Number of mixing points after the substations";
    parameter Integer nSou(min=1) "Number of heat sources (and heat sinks)";
    parameter Integer nBui(min=1) "Number of heat sources (and heat sinks)";
    parameter Real yPumMin(min=0.01, max=1, final unit="1") = 0.05
      "Minimum pump speed";
    parameter Modelica.Units.SI.Temperature TMin(displayUnit="degC") = 281.15
      "Minimum loop temperature";
    parameter Modelica.Units.SI.Temperature TMax(displayUnit="degC") = 291.15
      "Maximum loop temperature";
    parameter Modelica.Units.SI.TemperatureDifference dTSlo(min=1) = 2
      "Temperature difference for slope";
    parameter Boolean use_temperatureShift = true
      "Set to false to disable temperature shift of slopes";
    final parameter Modelica.Units.SI.TemperatureDifference delta=if
        use_temperatureShift then TMax - TMin - 3*dTSlo else 0
      "Maximum shift of slopes";
    parameter Modelica.Units.SI.TemperatureDifference dTSou_nominal[nSou](
      each min=0) = fill(4, nSou)
      "Nominal temperature difference over source";
    parameter Real k=0.01
      "Gain of controller that shifts upper and lower temperature setpoints";
    parameter Modelica.Units.SI.Time Ti(displayUnit="min") = 300
      "Time constant of integrator block that shifts upper and lower temperature setpoints";
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix[nMix](
      each final unit="K",
      each displayUnit="degC")
      "Temperatures at the mixing points"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn[nSou](
      each final unit="K",
      each displayUnit="degC") "Temperatures at the inlets of the sources"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouOut[nSou](
      each final unit="K",
      each displayUnit="degC") "Temperatures at the outlets of the sources"
      annotation (Placement(transformation(extent={{-156,-80},{-116,-40}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=0, max=1, unit="1")
      "Pump control signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiMin TMixMin(
      final nin=nMix,
      y(final unit="K",
        displayUnit="degC"))
      "Minimum temperature at mixing points"
      annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiMax TMixMax(
      final nin=nMix,
      y(final unit="K", displayUnit="degC"))
      "Maximum temperature at mixing points"
      annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
      k=fill(1, nSou), nin=nSou)
      annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
    Buildings.Controls.OBC.CDL.Continuous.Subtract dTSou[nSou]
      "Temperature differences over source"
      annotation (Placement(transformation(extent={{-92,-130},{-72,-110}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter dTSou_nor(k=1/(
          sum(dTSou_nominal)))
      "Normalization of temperature difference over source"
      annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
    Buildings.Controls.OBC.CDL.Continuous.PID conShi(
      controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
      final k=k,
      Ti(displayUnit="min") = Ti,
      final yMax=1,
      final yMin=-1)
      "Controller to shift the min/max slopes"
      annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0)
      "Set point for source dT"
      annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
    Buildings.Controls.OBC.CDL.Continuous.Line uppCur "Upper curve"
      annotation (Placement(transformation(extent={{30,10},{50,30}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Constant 1"
      annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yMin(k=yPumMin)
      "Minimum pump speed"
      annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMax_nominal(k=TMax)
      "Maximum temperature"
      annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
    Buildings.Controls.OBC.CDL.Continuous.Add TMax_upper(
      y(final unit="K", displayUnit="degC"))
      "Upper value of upper slope after shifting it"
      annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
    Buildings.Controls.OBC.CDL.Continuous.Max sPos "Positive shift"
      annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
    Buildings.Controls.OBC.CDL.Continuous.Min sNeg "Negative shift"
      annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
    Buildings.Controls.OBC.CDL.Continuous.AddParameter TMax_lower(
      final p=-dTSlo,
      y(final unit="K", displayUnit="degC"))
      "Minimum temperatuer value of upper slope after shifting it"
      annotation (Placement(transformation(extent={{10,149},{30,171}})));
    Buildings.Controls.OBC.CDL.Continuous.Line lowCur "Lower curve"
      annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TMin_nominal(k=TMin)
      "Minimum temperature"
      annotation (Placement(transformation(extent={{-70,110},{-50,130}})));
    Buildings.Controls.OBC.CDL.Continuous.Add TMin_lower(
      y(unit="K", displayUnit="degC"))
      "Lower value of lower slope after shifting it"
      annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
    Buildings.Controls.OBC.CDL.Continuous.AddParameter TMin_upper(
      final p=dTSlo,
      y(final unit="K", displayUnit="degC"))
      "Maximum temperatuer value of lower slope after shifting it"
      annotation (Placement(transformation(extent={{10,110},{30,130}})));
    Buildings.Controls.OBC.CDL.Continuous.Max ySetPum "Change in pump signal"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=0)
      "Gain factor"
      annotation (Placement(transformation(extent={{60,70},{80,90}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(final k=2)
      "Gain factor"
      annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
    Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(h=0.05)
      annotation (Placement(transformation(extent={{6,-176},{26,-156}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi
      annotation (Placement(transformation(extent={{44,-176},{64,-156}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi1
      annotation (Placement(transformation(extent={{44,-204},{64,-184}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi2
      annotation (Placement(transformation(extent={{126,-128},{146,-108}})));
    Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=
          use_temperatureShift)
      annotation (Placement(transformation(extent={{112,-162},{132,-142}})));
    Modelica.Blocks.Interfaces.RealInput m_flow_coo[nBui](final unit="kg/s")
      "Prescribed mass flow rate" annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-124,-154}), iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-124,-104})));

    Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=0.001, h=0.01)
      annotation (Placement(transformation(extent={{-74,-170},{-54,-150}})));
    Buildings.Controls.OBC.CDL.Logical.And and2
      annotation (Placement(transformation(extent={{92,-198},{112,-178}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nBui, k=fill(1,
          nBui))
      annotation (Placement(transformation(extent={{-104,-188},{-84,-168}})));
  equation
    connect(TMix, TMixMin.u) annotation (Line(points={{-120,60},{-80,60},{-80,-20},
            {-72,-20}}, color={0,0,127}));
    connect(TMix, TMixMax.u) annotation (Line(points={{-120,60},{-80,60},{-80,20},
            {-72,20}}, color={0,0,127}));
    connect(mulSum.y, dTSou_nor.u)
      annotation (Line(points={{-28,-120},{-22,-120}}, color={0,0,127}));
    connect(dTSou_nor.y, conShi.u_m)
      annotation (Line(points={{2,-120},{20,-120},{20,-112}},  color={0,0,127}));
    connect(conShi.u_s, zer.y) annotation (Line(points={{8,-100},{0,-100},{0,
            -80},{-28,-80}},
                   color={0,0,127}));
    connect(uppCur.u, TMixMax.y)
      annotation (Line(points={{28,20},{-48,20}}, color={0,0,127}));
    connect(uppCur.f1, yMin.y) annotation (Line(points={{28,24},{-30,24},{-30,50},
            {-50,50}}, color={0,0,127}));
    connect(uppCur.f2, one.y) annotation (Line(points={{28,12},{-26,12},{-26,80},{
            -48,80}}, color={0,0,127}));
    connect(TMax_nominal.y, TMax_upper.u1)
      annotation (Line(points={{-48,160},{-40,160},{-40,166},{-32,166}},
                                                     color={0,0,127}));
    connect(zer.y, sPos.u1) annotation (Line(points={{-28,-80},{46,-80},{46,-54},
            {58,-54}},
                   color={0,0,127}));
    connect(zer.y, sNeg.u1) annotation (Line(points={{-28,-80},{46,-80},{46,
            -134},{58,-134}},
                   color={0,0,127}));
    connect(conShi.y, sPos.u2) annotation (Line(points={{32,-100},{50,-100},{50,-66},
            {58,-66}}, color={0,0,127}));
    connect(conShi.y, sNeg.u2) annotation (Line(points={{32,-100},{50,-100},{50,-146},
            {58,-146}},color={0,0,127}));
    connect(TMax_lower.u, TMax_upper.y)
      annotation (Line(points={{8,160},{-8,160}},   color={0,0,127}));
    connect(uppCur.x1, TMax_lower.y) annotation (Line(points={{28,28},{20,28},{
            20,80},{40,80},{40,160},{32,160}},
                                            color={0,0,127}));
    connect(TMax_upper.y, uppCur.x2) annotation (Line(points={{-8,160},{0,160},
            {0,16},{28,16}},
                          color={0,0,127}));
    connect(TMixMin.y, lowCur.u)
      annotation (Line(points={{-48,-20},{28,-20}}, color={0,0,127}));
    connect(TMin_nominal.y, TMin_lower.u1) annotation (Line(points={{-48,120},{
            -40,120},{-40,126},{-32,126}},
                                       color={0,0,127}));
    connect(TMin_lower.y, TMin_upper.u)
      annotation (Line(points={{-8,120},{8,120}}, color={0,0,127}));
    connect(TMin_upper.y, lowCur.x2) annotation (Line(points={{32,120},{36,120},
            {36,84},{16,84},{16,-24},{28,-24}},
                                            color={0,0,127}));
    connect(TMin_lower.y, lowCur.x1) annotation (Line(points={{-8,120},{-4,120},
            {-4,-12},{28,-12}},
                          color={0,0,127}));
    connect(lowCur.f1, one.y) annotation (Line(points={{28,-16},{-26,-16},{-26,80},
            {-48,80}},color={0,0,127}));
    connect(lowCur.f2, yMin.y) annotation (Line(points={{28,-28},{-30,-28},{-30,
            50},{-50,50}},
                       color={0,0,127}));
    connect(uppCur.y, ySetPum.u1)
      annotation (Line(points={{52,20},{56,20},{56,6},{58,6}}, color={0,0,127}));
    connect(lowCur.y, ySetPum.u2) annotation (Line(points={{52,-20},{56,-20},{56,-6},
            {58,-6}}, color={0,0,127}));
    connect(ySetPum.y, y)
      annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
    connect(TSouOut, dTSou.u1) annotation (Line(points={{-136,-60},{-94,-60},{-94,
            -104},{-102,-104},{-102,-114},{-94,-114}},
                               color={0,0,127}));
    connect(TSouIn, dTSou.u2) annotation (Line(points={{-120,0},{-90,0},{-90,-86},
            {-104,-86},{-104,-126},{-94,-126}},
                         color={0,0,127}));
    connect(gai.y, TMin_lower.u2) annotation (Line(points={{82,80},{84,80},{84,
            102},{-42,102},{-42,114},{-32,114}}, color={0,0,127}));
    connect(dTSou_nor.y, lesThr.u) annotation (Line(points={{2,-120},{8,-120},{8,
            -144},{-2,-144},{-2,-166},{4,-166}}, color={0,0,127}));
    connect(zer.y, swi.u1) annotation (Line(points={{-28,-80},{46,-80},{46,-150},
            {36,-150},{36,-158},{42,-158}}, color={0,0,127}));
    connect(one.y, swi.u3) annotation (Line(points={{-48,80},{-10,80},{-10,-76},{
            34,-76},{34,-174},{42,-174}}, color={0,0,127}));
    connect(zer.y, swi1.u3) annotation (Line(points={{-28,-80},{-26,-80},{-26,
            -202},{42,-202}}, color={0,0,127}));
    connect(one.y, swi1.u1) annotation (Line(points={{-48,80},{-48,-4},{-16,-4},{
            -16,-186},{42,-186}}, color={0,0,127}));
    connect(lesThr.y, swi.u2)
      annotation (Line(points={{28,-166},{42,-166}}, color={255,0,255}));
    connect(lesThr.y, swi1.u2) annotation (Line(points={{28,-166},{28,-194},{42,
            -194}}, color={255,0,255}));
    connect(swi.y, gai1.u) annotation (Line(points={{66,-166},{86,-166},{86,-164},
            {96,-164},{96,-116},{54,-116},{54,-100},{58,-100}}, color={0,0,127}));
    connect(swi1.y, gai.u) annotation (Line(points={{66,-194},{84,-194},{84,64},{
            48,64},{48,80},{58,80}}, color={0,0,127}));
    connect(gai1.y, swi2.u1) annotation (Line(points={{82,-100},{118,-100},{118,
            -110},{124,-110}}, color={0,0,127}));
    connect(zer.y, swi2.u3) annotation (Line(points={{-28,-80},{36,-80},{36,-76},
            {114,-76},{114,-126},{124,-126}}, color={0,0,127}));
    connect(swi2.y, TMax_upper.u2) annotation (Line(points={{148,-118},{140,-118},
            {140,146},{-40,146},{-40,154},{-32,154}}, color={0,0,127}));
    connect(booleanExpression.y, and2.u2) annotation (Line(points={{133,-152},{132,
            -152},{132,-222},{90,-222},{90,-196}}, color={255,0,255}));
    connect(and2.y, swi2.u2) annotation (Line(points={{114,-188},{112,-188},{112,-118},
            {124,-118}}, color={255,0,255}));
    connect(dTSou.y, mulSum.u)
      annotation (Line(points={{-70,-120},{-52,-120}}, color={0,0,127}));
    connect(greThr.y, and2.u1) annotation (Line(points={{-52,-160},{-46,-160},{-46,
            -188},{90,-188}}, color={255,0,255}));
    connect(mulSum1.y, greThr.u) annotation (Line(points={{-82,-178},{-76,-178},{-76,
            -160}}, color={0,0,127}));
    connect(mulSum1.u[:], m_flow_coo[:]) annotation (Line(points={{-106,-178},{-124,
            -178},{-124,-154}},
                    color={0,0,127}));
    annotation (
      defaultComponentName="conPum",
      Diagram(coordinateSystem(extent={{-100,-180},{100,180}})), Icon(
          coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
          Ellipse(
            extent={{-52,52},{54,-52}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-94,68},{-76,54}},
            textColor={0,0,127},
            textString="TMix"),
          Text(
            extent={{-94,12},{-66,-12}},
            textColor={0,0,127},
            textString="TSouIn"),
          Text(
            extent={{-94,-44},{-62,-78}},
            textColor={0,0,127},
            textString="TSouOut"),
          Text(
            extent={{80,8},{96,-4}},
            textColor={0,0,127},
            textString="y"),
          Ellipse(
            extent={{-50,50},{52,-50}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{0,50},{0,-50},{52,0},{0,50}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}),
      Documentation(revisions="<html>
<ul>
<li>
September 12, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>",
    info="<html>
<p>
Controller for the main circulation pump.
</p>
<p>
This controller adjusts the pump speed in order to reduce it, unless
the water temperature at the mixing points after the agents in the district is too high
or too low, as measured by the difference to <code>TMin</code> and <code>TMax</code>.
In that case, the pump speed is increased to prevent the loop getting too cold or too warm.
The control is as follows:
Let <code>TMixMin</code> and <code>TMixMax</code> be the
minimum and maximum mixing temperatures.
If <code>TMax-TMixMax</code> or <code>TMixMin-TMin</code> is too small,
the pump speed is increased.
If the difference is larger than <code>dTSlo</code>, then the pump speed
is set to the minimum speed <code>yPumMin</code>.
This calculation is done for both, <code>TMixMin</code> and <code>TMixMax</code>.
The actual pump speed is then the larger of the two pump signals.
Therefore, the pump speeds are calculated as shown in the figure below.
</p>
<p>
<br/>
<img alt=\"Image of the control that adjusts the pump speed\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Networks/Controls/MainPump.png\"/>
<br/>
</p>
<p>
Moreover, if the parameter <code>use_temperatureShift</code> is set to <code>true</code>,
then the district loop temperature is adjusted by changing the mass
flow rate of the pump to increase the overall efficiency if there is net
cooling or net heating on the loop. Specifically,
if the district heating or cooling loop is in net heating (cooling) mode,
it may be favorable to increase (decrease) the loop temperature, which can
be done by increasing the pump speed. Whether the loop
is in heating or cooling mode is determined based on the temperature differences
across the loop sources, which are the inputs <code>TSouIn</code> and <code>TSouOut</code>.
Each heat source or sink needs to be connected to one element of these
vectorized input signals.
This net difference is then used with a PI-controller to determine how much the slopes
should be shifted in order to increase the pump speed.
The shift of these slopes is indicated by the arrows
in the figure.
Note that this controller must be configured to be slow reacting, as it requires the
feedback from the district heating and cooling loop.
</p>
<p>
For a typical usage of this controller, see
<a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesVariableFlow\">
Buildings.Experimental.DHC.Examples.Combined.SeriesVariableFlow</a>.
</p>
</html>"));
  end MainPump;

  block AgentPump "Ambient network storage and plants agent controls"
     extends Modelica.Blocks.Icons.Block;
     parameter Real yPumMin(min=0, max=1, final unit="1") = 0.05
      "Minimum pump speed";
     parameter Modelica.Units.SI.TemperatureDifference dTnom(min=0.1) = 1
      "Nominal temperature abs(DT) between supply and return for each load";
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TsupDis(each final unit="K",
        each displayUnit="degC") "Plant supply temperature"
      annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TSouIn(each final unit="K",
        each displayUnit="degC") "Temperatures at the inlet of the source"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TretDis(each final unit="K",
        each displayUnit="degC") "District return temperature"
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TSou(each final unit="K",
        each displayUnit="degC") "Average temperature available at source"
      annotation (Placement(transformation(extent={{-140,32},{-100,72}})));
    Buildings.Controls.OBC.CDL.Continuous.Less les1(h=h)
      annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi
      annotation (Placement(transformation(extent={{74,-2},{94,18}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
      min=0,
      max=1,
      unit="1")
      "Pump control signal"
      annotation (Placement(transformation(extent={{100,-20},{140,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));
    Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
      controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      k=khea,
      Ti=Ti,
      yMin=yPumMin)
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    parameter Real k=1 "Gain of controller";
    parameter Real khea=k "Gain of controller";
    parameter Real kcoo=k "Gain of controller";
    parameter Real Ti=0.5 "Time constant of integrator block";
    Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
      controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      k=kcoo,
      Ti=Ti,
      yMin=yPumMin,
      reverseActing=false)
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput TsupPla(each final unit="K",
        each displayUnit="degC") "Plant supply temperature"
      annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=uLowCoo, uHigh=
          uHighCoo)
      annotation (Placement(transformation(extent={{18,-98},{38,-78}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi1
      annotation (Placement(transformation(extent={{46,-20},{66,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    parameter Real uLowHea=1 "if y=true and u<uLow, switch to y=false";
    parameter Real uHighHea=2 "if y=false and u>uHigh, switch to y=true";
    parameter Real uLowCoo=1 "if y=true and u<uLow, switch to y=false";
    parameter Real uHighCoo=2 "if y=false and u>uHigh, switch to y=true";
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=uLowHea, uHigh=
          uHighHea)
      annotation (Placement(transformation(extent={{22,70},{42,90}})));
    Buildings.Controls.OBC.CDL.Continuous.Switch swi2
      annotation (Placement(transformation(extent={{40,38},{60,58}})));
    Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=-1)
      annotation (Placement(transformation(extent={{-14,-98},{6,-78}})));
    parameter Real h=0.15 "Hysteresis";
    Buildings.Controls.OBC.CDL.Continuous.AddParameter Tsou_negshift(final p=-
          dTnom, y(final unit="K", displayUnit="degC"))
      "Source temperature after negative shift"
      annotation (Placement(transformation(extent={{-40,39},{-20,61}})));
    Buildings.Controls.OBC.CDL.Continuous.AddParameter Tsou_posshift(final p=
          dTnom, y(final unit="K", displayUnit="degC"))
      "Source temperature after positive shift"
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    Buildings.Controls.OBC.CDL.Continuous.Subtract dTLoads3
      "Temperature differences over loads"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Buildings.Controls.OBC.CDL.Continuous.AddParameter TMax_lower2(final p=-dTnom,
                                                                               y(
          final unit="K", displayUnit="degC"))
      "Minimum temperatuer value of upper slope after shifting it"
      annotation (Placement(transformation(extent={{-26,69},{-6,91}})));
    Buildings.Controls.OBC.CDL.Continuous.AddParameter TMax_lower3(final p=dTnom,
                                                                              y(
          final unit="K", displayUnit="degC"))
      "Minimum temperatuer value of upper slope after shifting it"
      annotation (Placement(transformation(extent={{-42,-99},{-22,-77}})));
  equation
    connect(les1.y, swi.u2) annotation (Line(points={{-58,-50},{70,-50},{70,8},{
            72,8}}, color={255,0,255}));
    connect(TretDis, les1.u1) annotation (Line(points={{-120,-50},{-82,-50}},
                        color={0,0,127}));
    connect(TsupDis, les1.u2) annotation (Line(points={{-120,-90},{-90,-90},{-90,
            -58},{-82,-58}},
                        color={0,0,127}));
    connect(hys.y, swi1.u2) annotation (Line(points={{40,-88},{40,-32},{44,-32},{
            44,-30}},
                   color={255,0,255}));
    connect(con.y, swi1.u3) annotation (Line(points={{22,10},{30,10},{30,-22},{44,
            -22}},      color={0,0,127}));
    connect(swi.y, y) annotation (Line(points={{96,8},{98,8},{98,0},{120,0}},
          color={0,0,127}));
    connect(conPIDCoo.y, swi1.u1) annotation (Line(points={{22,-30},{32,-30},{32,
            -38},{44,-38}},
                        color={0,0,127}));
    connect(swi1.y, swi.u3) annotation (Line(points={{68,-30},{72,-30},{72,0}},
                                     color={0,0,127}));
    connect(hys1.y, swi2.u2) annotation (Line(points={{44,80},{50,80},{50,62},{32,
            62},{32,48},{38,48}},
                      color={255,0,255}));
    connect(conPIDHea.y, swi2.u1) annotation (Line(points={{22,50},{30,50},{30,56},
            {38,56}},  color={0,0,127}));
    connect(con.y, swi2.u3) annotation (Line(points={{22,10},{30,10},{30,40},{38,
            40}},                        color={0,0,127}));
    connect(swi2.y, swi.u1) annotation (Line(points={{62,48},{72,48},{72,16}},
                                  color={0,0,127}));
    connect(TSou, Tsou_negshift.u) annotation (Line(points={{-120,52},{-40,52},{
            -40,50},{-42,50}}, color={0,0,127}));
    connect(Tsou_negshift.y, conPIDHea.u_s)
      annotation (Line(points={{-18,50},{-2,50}}, color={0,0,127}));
    connect(TSou, Tsou_posshift.u) annotation (Line(points={{-120,52},{-92,52},{
            -92,-30},{-42,-30}}, color={0,0,127}));
    connect(Tsou_posshift.y, conPIDCoo.u_s)
      annotation (Line(points={{-18,-30},{-2,-30}}, color={0,0,127}));
    connect(TsupPla, conPIDCoo.u_m) annotation (Line(points={{-120,-10},{-10,-10},
            {-10,-48},{10,-48},{10,-42}}, color={0,0,127}));
    connect(TsupPla, conPIDHea.u_m) annotation (Line(points={{-120,-10},{-10,-10},
            {-10,30},{10,30},{10,38}}, color={0,0,127}));
    connect(gai1.y, hys.u) annotation (Line(points={{8,-88},{16,-88}},
                                        color={0,0,127}));
    connect(dTLoads3.y, TMax_lower2.u)
      annotation (Line(points={{-58,10},{-54,10},{-54,80},{-28,80}},
                                                            color={0,0,127}));
    connect(TSou, dTLoads3.u1) annotation (Line(points={{-120,52},{-92,52},{-92,
            16},{-82,16}}, color={0,0,127}));
    connect(TMax_lower2.y, hys1.u) annotation (Line(points={{-4,80},{20,80}},
                                          color={0,0,127}));
    connect(dTLoads3.y, TMax_lower3.u) annotation (Line(points={{-58,10},{-48,10},
            {-48,-88},{-44,-88}}, color={0,0,127}));
    connect(TMax_lower3.y, gai1.u) annotation (Line(points={{-20,-88},{-16,-88}},
                                        color={0,0,127}));
    connect(TSouIn, dTLoads3.u2) annotation (Line(points={{-120,20},{-94,20},{-94,
            4},{-82,4}},                     color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
              -120},{140,120}}),                                  graphics={
          Ellipse(
            extent={{-54,64},{48,-36}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-4,64},{-4,-36},{48,14},{-4,64}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-62,-46},{68,-84}},
            textColor={0,0,0},
            textString="Plant")}),                                 Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
              120}})));
  end AgentPump;
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains models for control of distribution networks.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
      Rectangle(
        origin={0,35.1488},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Rectangle(
        origin={0,-34.8512},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Line(
        origin={-51.25,0},
        points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
      Polygon(
        origin={-40,35},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
      Line(
        origin={51.25,0},
        points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}}),
      Polygon(
        origin={40,-35},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}})}));
end Controls;
