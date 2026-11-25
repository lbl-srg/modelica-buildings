within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules;
block LeakyReheatValve "Detection of a leaky reheat valve of a VAV box"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real dTLik(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=2.77778
    "Threshold of the VAV box discharge air temperature above the AHU supply air temperature, above which the reheat valve is considered to leak (5 degF = 2.77778 K)";
  parameter Real dTHys(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=0.5
    "Hysteresis for the temperature difference comparison";
  parameter Real yValClo(
    final min=0,
    final max=1,
    final unit="1")=0.05
    "Reheat valve position below which the valve is considered closed";
  parameter Real yValHys(
    final min=0,
    final max=0.5,
    final unit="1")=0.01
    "Hysteresis for the reheat valve position comparison";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisAir[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "VAV box discharge air temperature"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupAir(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal[nZon](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Reheat valve position"
    annotation (Placement(transformation(extent={{-220,-110},{-180,-70}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaVal[nZon]
    "True: the reheat valve leaks"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(final nout=
        nZon) "Replicate the AHU supply air temperature for all zones"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT[nZon]
    "VAV box discharge air temperature minus the AHU supply air temperature"
    annotation (Placement(transformation(extent={{-110,90},{-70,130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greDT[nZon](
    final t=fill(dTLik, nZon),
    final h=fill(dTHys, nZon))
    "Check if the discharge air temperature is sufficiently higher than the AHU supply air temperature"
    annotation (Placement(transformation(extent={{-40,90},{0,130}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesValClo[nZon](
    final t=fill(yValClo, nZon),
    final h=fill(yValHys, nZon))
    "Check if the reheat valve is closed"
    annotation (Placement(transformation(extent={{-40,-110},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And andLea[nZon]
    "Check if both conditions for a leaky reheat valve are met"
    annotation (Placement(transformation(extent={{60,0},{100,40}})));

equation
  connect(TSupAir, reaScaRep.u)
    annotation (Line(points={{-178,30},{-162,30}}, color={0,0,127}));
  connect(TDisAir, dT.u1) annotation (Line(points={{-178,110},{-140,110},{-140,
          120},{-112,120}}, color={0,0,127}));
  connect(reaScaRep.y, dT.u2) annotation (Line(points={{-118,30},{-130,30},{
          -130,100},{-112,100}}, color={0,0,127}));
  connect(dT.y, greDT.u)
    annotation (Line(points={{-68,110},{-42,110}}, color={0,0,127}));
  connect(yVal, lesValClo.u) annotation (Line(points={{-178,-90},{-60,-90},{
          -60,-90},{-42,-90}}, color={0,0,127}));
  connect(greDT.y, andLea.u1) annotation (Line(points={{2,110},{30,110},{30,30},
          {58,30}}, color={255,0,255}));
  connect(lesValClo.y, andLea.u2) annotation (Line(points={{2,-90},{30,-90},{
          30,10},{58,10}}, color={255,0,255}));
  connect(andLea.y, yLeaVal) annotation (Line(points={{102,20},{140,20},{140,0},
          {178,0}}, color={255,0,255}));
  annotation (defaultComponentName="leaReaVal",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-140},{
            220,140}})),
    Documentation(revisions="<html>
<ul>
<li>
November 25, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block detects a leaky reheat valve of a VAV box.
The fault is detected when both of the following conditions are true:
</p>
<ul>
<li>
The VAV box discharge air temperature <code>TDisAir</code> is higher than the
AHU supply air temperature <code>TSupAir</code> by more than
<code>dTLik</code>, which defaults to <i>5 &deg;F = 2.77778 K</i>.
</li>
<li>
The reheat valve position <code>yVal</code> is lower than <code>yValClo</code>,
which indicates that the reheat valve is closed.
</li>
</ul>
<p>
If the reheat valve is closed, the discharge air temperature should not be much
higher than the AHU supply air temperature. A persistently higher discharge air
temperature indicates that hot air leaks through the reheat valve.
</p>
<h4>Unit conversion</h4>
<p>
The threshold of <i>5 &deg;F</i> is converted to Kelvin as
<i>5 &deg;F &times; 5&#8260;9 = 2.77778 K</i>.
</p>
</html>"));
end LeakyReheatValve;
