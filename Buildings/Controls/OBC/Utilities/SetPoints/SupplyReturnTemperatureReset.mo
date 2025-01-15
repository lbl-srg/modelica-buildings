within Buildings.Controls.OBC.Utilities.SetPoints;
block SupplyReturnTemperatureReset
  "Block to compute the supply and return set point"
  parameter Real m=1.3
    "Exponent for heat transfer";
  parameter Real TSup_nominal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real TRet_nominal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real TZon_nominal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")=293.15
    "Zone temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real TOut_nominal(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Outside temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real dTOutHeaBal(
    final quantity="TemperatureDifference",
    final unit="K",
    displayUnit="K")=8
    "Offset for heating curve";
  CDL.Interfaces.RealInput TSetZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200)
    "Zone setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealOutput TSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200)
    "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  CDL.Interfaces.RealOutput TRet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200)
    "Setpoint for return temperature"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  CDL.Reals.Sources.Constant dTOutHeaBal_nominal(
    final k=dTOutHeaBal,
    y(final quantity="TemperatureDifference",
      final unit="K"))
    "Offset of outdoor temperature to take into account heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  CDL.Reals.Sources.Constant TSup_nom(
    final k=TSup_nominal,
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Heating supply water temperature at nominal condition"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  CDL.Reals.Sources.Constant TZon_nom(
    final k=TZon_nominal,
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Zone temperature at design condition"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Reals.Sources.Constant zer(
    final k=1E-100)
    "Small positive constant to avoid log(0)"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  CDL.Reals.Sources.Constant TRet_nom(
    final k=TRet_nominal,
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Heating return water temperature at nominal condition"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  CDL.Reals.Sources.Constant TOut_nom(
    final k=TOut_nominal,
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Outside temperature at design condition"
    annotation (Placement(transformation(extent={{-80,38},{-60,58}})));
  CDL.Reals.Sources.Constant expM(
    final k=m)
    "Exponent of heat transfer"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  CDL.Reals.Sources.Constant one(
    final k=1)
    "Outputs 1"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  CDL.Reals.Add TOutOffSet(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Effective outside temperature for heat transfer (takes into account zone heat gains)"
    annotation (Placement(transformation(extent={{-80,-58},{-60,-38}})));
  CDL.Reals.Subtract qRelDen(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Denominator for relative heating load calculation"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  CDL.Reals.Subtract qRelNum(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Numerator for relative heating load calculation"
    annotation (Placement(transformation(extent={{-40,-52},{-20,-32}})));
  CDL.Reals.Divide qRel "Relative heating load = Q_flow/Q_flow_nominal"
    annotation (Placement(transformation(extent={{0,24},{20,44}})));
  CDL.Reals.Subtract dTFlu2_nom
    "Heating supply minus return water temperature at nominal condition"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  CDL.Reals.Average TFluAve_nominal(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Average heating water temperature at nominal condition"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  CDL.Reals.Subtract dTFluAve_nominal(
    y(final quantity="TemperatureDifference",
      final unit="K"))
    "Average heating water temperature minus room temperature at nominal condition"
    annotation (Placement(transformation(extent={{36,110},{56,130}})));
  CDL.Reals.Divide mInv "Inverse of heat transfer exponent, y = 1/m"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Reals.Add TAve(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Average of supply and return temperature"
    annotation (Placement(transformation(extent={{-40,276},{-20,296}})));
  CDL.Reals.Add TSupCur(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Current supply water temperature"
    annotation (Placement(transformation(extent={{42,270},{62,290}})));
  CDL.Reals.Subtract TRetCur(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Current return water temperature"
    annotation (Placement(transformation(extent={{40,238},{60,258}})));
  CDL.Reals.Max qRel0
    "Relative heating load, but always non-zero value"
    annotation (Placement(transformation(extent={{32,30},{52,50}})));
  CDL.Reals.Multiply pro "Product used to compute q^(1/m)"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  CDL.Reals.Exp qRaiInvM
    "Outputs qRel^(1/m)"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  CDL.Reals.Log log1
    "Logarithm used for evaluation of qRel^(1/m)"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  CDL.Reals.Multiply dTQ(y(
    final quantity="TemperatureDifference",
    final unit="K")) "Temperature contribution due to qRel^(1/m)"
    annotation (Placement(transformation(extent={{-80,220},{-60,240}})));
  CDL.Reals.Multiply dTFlu(y(
    final quantity="TemperatureDifference",
    final unit="K")) "Supply minus return water temperature"
    annotation (Placement(transformation(extent={{0,220},{20,240}})));
  CDL.Reals.Add TOutOffSet_nominal(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC"))
    "Effective outside temperature for heat transfer at nominal condition (takes into account zone heat gains)"
    annotation (Placement(transformation(extent={{-44,32},{-24,52}})));
  CDL.Reals.MultiplyByParameter gai(
    final k=0.5,
    y(final quantity="TemperatureDifference",
      final unit="K")) "Gain factor"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

equation
  connect(dTOutHeaBal_nominal.y,TOutOffSet.u1)
    annotation (Line(points={{-58,0},{-52,0},{-52,-28},{-86,-28},{-86,-42},{-82,-42}},color={0,0,127}));
  connect(TOut,TOutOffSet.u2)
    annotation (Line(points={{-120,60},{-90,60},{-90,-54},{-82,-54}},color={0,0,127}));
  connect(TZon_nom.y,qRelDen.u1)
    annotation (Line(points={{-58,90},{-42,90}},color={0,0,127}));
  connect(qRel.y,qRel0.u2)
    annotation (Line(points={{22,34},{30,34}},color={0,0,127}));
  connect(zer.y,qRel0.u1)
    annotation (Line(points={{22,70},{26,70},{26,46},{30,46}},color={0,0,127}));
  connect(dTFlu2_nom.u1,TSup_nom.y)
    annotation (Line(points={{-42,166},{-48,166},{-48,170},{-58,170}},color={0,0,127}));
  connect(dTFlu2_nom.u2,TRet_nom.y)
    annotation (Line(points={{-42,154},{-52,154},{-52,130},{-58,130}},color={0,0,127}));
  connect(TFluAve_nominal.u1,TSup_nom.y)
    annotation (Line(points={{-42,136},{-48,136},{-48,170},{-58,170}},color={0,0,127}));
  connect(TRet_nom.y,TFluAve_nominal.u2)
    annotation (Line(points={{-58,130},{-52,130},{-52,124},{-42,124}},color={0,0,127}));
  connect(dTFluAve_nominal.u2,TZon_nom.y)
    annotation (Line(points={{34,114},{-50,114},{-50,90},{-58,90}},color={0,0,127}));
  connect(qRel0.y,log1.u)
    annotation (Line(points={{54,40},{64,40},{64,-80},{-90,-80},{-90,-100},{-82,-100}},color={0,0,127}));
  connect(one.y,mInv.u1)
    annotation (Line(points={{-58,-130},{-50,-130},{-50,-144},{-42,-144}},color={0,0,127}));
  connect(expM.y,mInv.u2)
    annotation (Line(points={{-58,-170},{-50,-170},{-50,-156},{-42,-156}},color={0,0,127}));
  connect(log1.y,pro.u1)
    annotation (Line(points={{-58,-100},{-50,-100},{-50,-94},{-42,-94}},color={0,0,127}));
  connect(pro.u2,mInv.y)
    annotation (Line(points={{-42,-106},{-48,-106},{-48,-120},{-10,-120},{-10,-150},{-18,-150}},color={0,0,127}));
  connect(qRaiInvM.u,pro.y)
    annotation (Line(points={{-2,-100},{-18,-100}},color={0,0,127}));
  connect(dTQ.u1,dTFluAve_nominal.y)
    annotation (Line(points={{-82,236},{-92,236},{-92,204},{60,204},{60,120},{58,
          120}},                                                                       color={0,0,127}));
  connect(qRaiInvM.y,dTQ.u2)
    annotation (Line(points={{22,-100},{46,-100},{46,-98},{70,-98},{70,206},{-90,206},{-90,224},{-82,224}},color={0,0,127}));
  connect(TSetZon,TAve.u1)
    annotation (Line(points={{-120,-60},{-94,-60},{-94,292},{-42,292}},color={0,0,127}));
  connect(TAve.u2,dTQ.y)
    annotation (Line(points={{-42,280},{-52,280},{-52,230},{-58,230}},color={0,0,127}));
  connect(qRel0.y,dTFlu.u2)
    annotation (Line(points={{54,40},{64,40},{64,216},{-6,216},{-6,224},{-2,224}},color={0,0,127}));
  connect(TSupCur.u1,TAve.y)
    annotation (Line(points={{40,286},{-18,286}},color={0,0,127}));
  connect(dTFlu.y,TSupCur.u2)
    annotation (Line(points={{22,230},{32,230},{32,274},{40,274}},color={0,0,127}));
  connect(TSupCur.y,TSup)
    annotation (Line(points={{64,280},{88,280},{88,60},{120,60}},color={0,0,127}));
  connect(TRetCur.u1,TAve.y)
    annotation (Line(points={{38,254},{12,254},{12,286},{-18,286}},color={0,0,127}));
  connect(TRetCur.u2,dTFlu.y)
    annotation (Line(points={{38,242},{32,242},{32,230},{22,230}},color={0,0,127}));
  connect(TRetCur.y,TRet)
    annotation (Line(points={{62,248},{80,248},{80,-60},{120,-60}},color={0,0,127}));
  connect(qRel.u1,qRelNum.y)
    annotation (Line(points={{-2,40},{-12,40},{-12,-42},{-18,-42}},color={0,0,127}));
  connect(qRel.u2,qRelDen.y)
    annotation (Line(points={{-2,28},{-6,28},{-6,84},{-18,84}},color={0,0,127}));
  connect(TOutOffSet_nominal.u1,TOut_nom.y)
    annotation (Line(points={{-46,48},{-58,48}},color={0,0,127}));
  connect(dTOutHeaBal_nominal.y,TOutOffSet_nominal.u2)
    annotation (Line(points={{-58,0},{-52,0},{-52,36},{-46,36}},color={0,0,127}));
  connect(TOutOffSet_nominal.y,qRelDen.u2)
    annotation (Line(points={{-22,42},{-20,42},{-20,66},{-50,66},{-50,78},{-42,78}},color={0,0,127}));
  connect(TSetZon, qRelNum.u1) annotation (Line(points={{-120,-60},{-48,-60},{-48,
          -36},{-42,-36}}, color={0,0,127}));
  connect(TOutOffSet.y, qRelNum.u2)
    annotation (Line(points={{-58,-48},{-42,-48}}, color={0,0,127}));
  connect(dTFlu2_nom.y, gai.u)
    annotation (Line(points={{-18,160},{-2,160}}, color={0,0,127}));
  connect(gai.y, dTFlu.u1) annotation (Line(points={{22,160},{28,160},{28,180},{
          -10,180},{-10,236},{-2,236}}, color={0,0,127}));
  connect(TFluAve_nominal.y, dTFluAve_nominal.u1) annotation (Line(points={{-18,
          130},{10,130},{10,126},{34,126}}, color={0,0,127}));
  annotation (
    defaultComponentName="watRes",
    Documentation(
      info="<html>
<p>
This block computes the set point temperatures for the
supply and return water temperature.
The set point for the zone air temperature can be an input to the model.
It allows to use this model with systems that have night set back.
</p>
<p>
If used to reset the temperature in a heating system,
the parameter <code>dTOutHeaBal</code> can be used to shift the heating curve
to take into account that heat gains from solar, equipment and people
make up for some of the transmission losses.
For example, in energy efficient houses, the heating may not be switched on if
the outside air temperature is greater than
<i>12</i>&deg;C, even if a zone temperature of <i>20</i>&deg;C is required.
In such a situation, set <code>dTOutHeaBal=20-12=8</code> Kelvin to
shift the heating curve.
</p>
<h4>Typical usage</h4>
<p>
The figure below shows a typical usage for a hot water temperature reset
for a heating system.
The parameters of the block <code>heaCur</code>
are for a heating system with
<i>60</i>&deg;C supply water temperature and
<i>40</i>&deg;C return water temperature at
an outside temperature of
<i>-10</i>&deg;C and a room temperature of
<i>20</i>&deg;C. The offset for the temperature reset is
<i>8</i> Kelvin, i.e., above
<i>12</i>&deg;C outside temperature, there is no heating load.
The figure shows the computed supply and return water temperatures.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/Utilities/SetPoints/SupplyReturnTemperatureReset.png\"
border=\"1\"
alt=\"Supply and return water temperatures.\"/>
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 21, 2021, by Michael Wetter:<br/>
Corrected icon.
</li>
<li>
February 8, 2021, by Michael Wetter:<br/>
Renamed to <code>Buildings.Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset</code>
and reimplemented using elementary CDL blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2355\">Buildings, issue 2355</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">Buildings, issue 2243</a>.
</li>
<li>
January 3, 2020, by Jianjun Hu:<br/>
Changed name from <code>HotWaterTemperatureReset</code> to
<code>SupplyReturnTemperatureReset</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">Buildings, issue 860</a>.
</li>
<li>
January 10, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
February 13, 2013, by Michael Wetter:<br/>
Corrected error that led to wrong results if the zone air temperature is
different from its nominal value <code>TZon_nominal</code>.
See ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">Buildings, issue 74</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
February 5, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-82},{68,-74},{68,-90},{90,-82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-82},{82,-82}},
          color={192,192,192}),
        Line(
          points={{-80,76},{-80,-92}},
          color={192,192,192}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,86},{-80,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-82},{60,32}}),
        Line(
          points={{-80,-82},{-42,-38},{4,2},{60,32}},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-82},{-58,-42},{-4,8},{60,32}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-152,120},{-102,70}},
          textColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-152,-4},{-102,-54}},
          textColor={0,0,127},
          textString="TSetZon"),
        Text(
          extent={{40,86},{90,36}},
          textColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{42,-30},{92,-80}},
          textColor={0,0,127},
          textString="TRet"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-200},{100,340}}),
      graphics={
        Rectangle(
          extent={{-84,320},{76,212}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-34,318},{66,306}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Current fluid setpoint temperatures"),
        Rectangle(
          extent={{-84,-84},{76,-192}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-26,-178},{74,-190}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Computation of qRel^(1/m)"),
        Rectangle(
          extent={{-86,200},{-16,-22}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-84,198},{-36,190}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Nominal values"),
        Rectangle(
          extent={{-10,102},{58,-22}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-4,98},{56,90}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Guard against 0^(1/m)"),
        Rectangle(
          extent={{-84,-28},{58,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-6,-68},{60,-76}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Numerator for qRel")}));
end SupplyReturnTemperatureReset;
