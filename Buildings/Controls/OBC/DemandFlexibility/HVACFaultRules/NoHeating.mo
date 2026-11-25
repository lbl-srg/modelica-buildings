within Buildings.Controls.OBC.DemandFlexibility.HVACFaultRules;
block NoHeating "Detection of no heating output of a VAV box"

  parameter Integer nZon(final min=1)
    "Number of zones";
  parameter Real dTApp(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=1
    "Threshold of the absolute difference between the VAV box discharge air temperature and the AHU supply air temperature, below which they are considered approximately equal";
  parameter Real dTHys(
    final min=0,
    final unit="K",
    final quantity="TemperatureDifference")=0.5
    "Hysteresis for the temperature difference comparison";
  parameter Real yValOpe(
    final min=0,
    final max=1,
    final unit="1")=0.9
    "Reheat valve position above which the valve is considered sufficiently open (90% open)";
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yNoHea[nZon]
    "True: no heating output although the reheat valve is open"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(final nout=
        nZon) "Replicate the AHU supply air temperature for all zones"
    annotation (Placement(transformation(extent={{-160,10},{-120,50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT[nZon]
    "VAV box discharge air temperature minus the AHU supply air temperature"
    annotation (Placement(transformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Abs absDT[nZon]
    "Absolute difference between the discharge air temperature and the AHU supply air temperature"
    annotation (Placement(transformation(extent={{-70,90},{-30,130}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesDTApp[nZon](
    final t=fill(dTApp, nZon),
    final h=fill(dTHys, nZon))
    "Check if the discharge air temperature is approximately equal to the AHU supply air temperature"
    annotation (Placement(transformation(extent={{0,90},{40,130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greValOpe[nZon](
    final t=fill(yValOpe, nZon),
    final h=fill(yValHys, nZon))
    "Check if the reheat valve is open at 90% or more"
    annotation (Placement(transformation(extent={{0,-110},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And andNoHea[nZon]
    "Check if both conditions for no heating are met"
    annotation (Placement(transformation(extent={{100,0},{140,40}})));

equation
  connect(TSupAir, reaScaRep.u)
    annotation (Line(points={{-178,30},{-162,30}}, color={0,0,127}));
  connect(TDisAir, dT.u1) annotation (Line(points={{-178,110},{-160,110},{
          -160,120},{-142,120}}, color={0,0,127}));
  connect(reaScaRep.y, dT.u2) annotation (Line(points={{-118,30},{-160,30},{
          -160,100},{-142,100}}, color={0,0,127}));
  connect(dT.y, absDT.u)
    annotation (Line(points={{-98,110},{-72,110}}, color={0,0,127}));
  connect(absDT.y, lesDTApp.u)
    annotation (Line(points={{-28,110},{-2,110}}, color={0,0,127}));
  connect(yVal, greValOpe.u) annotation (Line(points={{-178,-90},{-2,-90}},
        color={0,0,127}));
  connect(lesDTApp.y, andNoHea.u1) annotation (Line(points={{42,110},{70,110},
          {70,30},{98,30}}, color={255,0,255}));
  connect(greValOpe.y, andNoHea.u2) annotation (Line(points={{42,-90},{70,-90},
          {70,10},{98,10}}, color={255,0,255}));
  connect(andNoHea.y, yNoHea) annotation (Line(points={{142,20},{160,20},{160,
          0},{178,0}}, color={255,0,255}));
  annotation (defaultComponentName="noHea",
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
This block detects that a VAV box provides no heating although the reheat
valve is open. The fault is detected when both of the following conditions
are true:
</p>
<ul>
<li>
The VAV box discharge air temperature <code>TDisAir</code> is approximately
equal to the AHU supply air temperature <code>TSupAir</code>, i.e., the
absolute difference between the two temperatures is less than
<code>dTApp</code>, which defaults to <i>1 K</i>.
</li>
<li>
The reheat valve position <code>yVal</code> is <i>90%</i> or more open,
configured by the parameter <code>yValOpe</code>.
</li>
</ul>
<p>
If the reheat valve is open at <i>90%</i> or more, the discharge air
temperature should be noticeably higher than the AHU supply air temperature.
An approximately equal discharge air temperature indicates that the heating
coil provides no heating output.
</p>
</html>"));
end NoHeating;
