within Buildings.HeatTransfer.Windows.BaseClasses;
block WindowRadiation "Calculation radiation for window"

  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;

  Modelica.Blocks.Interfaces.RealInput HRoo(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Diffussive radiation from room " annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-130,-91},{-100,-61}})));
  Modelica.Blocks.Interfaces.RealOutput QTra_flow(final quantity="Power",
      final unit="W")
    "Transmitted exterior radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QAbsExtSha_flow(final quantity="Power",
      final unit="W")
    "Absorbed interior and exterior radiation by exterior shading device"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsIntSha_flow(final quantity="Power",
      final unit="W")
    "Absorbed interior and exterior radiation by interior shading device"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaUns_flow[N](each quantity=
        "Power", each final unit="W")
    "Absorbed interior and exterior radiation by unshaded part of glass"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput QAbsGlaSha_flow[N](each quantity=
        "Power", each final unit="W")
    "Absorbed interior and exterior radiation by shaded part of glass"
    annotation (Placement(transformation(extent={{100,0},{120,20}}),
        iconTransformation(extent={{100,0},{120,20}})));

  Buildings.HeatTransfer.Windows.BaseClasses.TransmittedRadiation tra(
    final N=N,
    final tauGlaSol=tauGlaSol,
    final rhoGlaSol_a=rhoGlaSol_a,
    final rhoGlaSol_b=rhoGlaSol_b,
    final xGla=xGla,
    final tauShaSol_a=tauShaSol_a,
    final rhoShaSol_a=rhoShaSol_a,
    final rhoShaSol_b=rhoShaSol_b,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade,
    final AWin=AWin,
    final tauShaSol_b=tauShaSol_b)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.HeatTransfer.Windows.BaseClasses.AbsorbedRadiation abs(
    final N=N,
    final tauGlaSol=tauGlaSol,
    final rhoGlaSol_a=rhoGlaSol_a,
    final rhoGlaSol_b=rhoGlaSol_b,
    final xGla=xGla,
    final tauShaSol_a=tauShaSol_a,
    final tauShaSol_b=tauShaSol_b,
    final rhoShaSol_a=rhoShaSol_a,
    final rhoShaSol_b=rhoShaSol_b,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade,
    final AWin=AWin)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
protected
  final parameter Boolean noShade=not (haveExteriorShade or haveInteriorShade)
    "Flag, true if the window has a shade";
equation
  if noShade then
    assert(uSha_internal < 1E-6,
      "Window has no shade, but control signal is non-zero.\n" +
      "  Received uSha_internal = " + String(uSha_internal));
  end if;
  connect(HDif, tra.HDif) annotation (Line(
      points={{-120,80},{-80,80},{-80,58},{-41.5,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDif, abs.HDif) annotation (Line(
      points={{-120,80},{-80,80},{-80,-22},{-41.5,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDir, tra.HDir) annotation (Line(
      points={{-120,40},{-74,40},{-74,54},{-41.5,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDir, abs.HDir) annotation (Line(
      points={{-120,40},{-74,40},{-74,-26},{-41.5,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng, tra.incAng) annotation (Line(
      points={{-120,1.11022e-15},{-68,1.11022e-15},{-68,49},{-41.5,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng, abs.incAng) annotation (Line(
      points={{-120,1.11022e-15},{-68,1.11022e-15},{-68,-31},{-41.5,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HRoo, abs.HRoo) annotation (Line(
      points={{-120,-80},{-54,-80},{-54,-37.6},{-41.5,-37.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tra.uSha, uSha) annotation (Line(
      points={{-30.2,38.4},{-30.2,24},{1.11022e-15,24},{1.11022e-15,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.uSha, uSha) annotation (Line(
      points={{-30.2,-41.6},{-30.2,-48},{1.11022e-15,-48},{1.11022e-15,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tra.QTra_flow, QTra_flow) annotation (Line(
      points={{-19,50},{12,50},{12,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.QAbsIntSha_flow, QAbsIntSha_flow) annotation (Line(
      points={{-19,-38},{80,-38},{80,-30},{110,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.QAbsGlaSha_flow, QAbsGlaSha_flow) annotation (Line(
      points={{-19,-34},{72,-34},{72,10},{110,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.QAbsGlaUns_flow, QAbsGlaUns_flow) annotation (Line(
      points={{-19,-26},{52,-26},{52,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.QAbsExtSha_flow, QAbsExtSha_flow) annotation (Line(
      points={{-19,-22},{36,-22},{36,90},{110,90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
The model calculates solar radiation through the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.
</p>
<p>
The absorbed radiation by exterior shades includes:
</p>
<ol>
<li>
the directly absorbed exterior radiation: <code>AWin*uSha*(HDir+HDif)*(1-tau-rho)</code>
</li>
<li>
the indirectly absorbed exterior radiantion from reflection (angular part): <code>AWin*uSha*HDir*tau*rho(IncAng)*(1-tau-rho)</code>
</li>
<li>
the indirectly absorbed of exterior irradiantion from reflection (diffusive part): <code>AWin*uSha*HDif*tau*rho(HEM)*(1-tau-rho)</code>
</li>
<li>
the absorbed interior radiation is neglected.
</li>
</ol>
<p>
The output is <code>absRad[2, 1]</code>
</p>

<p>
The absorbed radiation by interior shades includes:</p>
<ol>
<li>
the absorbed exterior radiation (angular part): <code>AWin*uSha*HDir*alpha(IncAng)</code>
</li>
<li>
the absorbed exterior radiation (diffusive part): <code>AWin*uSha*HDif*alpha(HEM)</code>
</li>
<li>
the absorbed interior radiation (diffusive part): <code>AWin*uSha*HRoo*(1-tau-rho)</code>
</li>
</ol>
<p>
The output is <code>absRad[2, N+2]</code></p>

<p>
The absorbed radiation by glass includes:</p>
<ol>
<li>
the absorbed radiation by unshaded part (diffusive part): <code>AWin*(1-uSha)*(HDif*alphaEx(HEM)+HRoo*alphaIn(HEM))</code>
</li>
<li>
the absorbed radiation by unshaded part (angualr part from exterior source): <code>AWin*(1-uSha)*HDir*alphaEx(IncAng)</code>
</li>
<li>
the absorbed radiaiton by shaded part (diffusive part): <code>AWin*uSha*(HDif*alphaExSha(HEM)+HRoo*alphaInSha(HEM))</code>
</li>
<li>
the absorbed radiation by shaded part (angular part from exterior source): <code>AWin*uSha*HDir*alphaExSha(IncAng)</code>
</li>
</ol>
<p>
The output is <code>absRad[1, 2:N+1] = Part1 + Part2; absRad[2, 2:N+1] = Part3 + Part4</code></p>

<p>
The transmitted exterior radiation for window system includes:</p>
<ol>
<li>
the transmitted diffusive radiation on unshaded part: <code>AWin*(1-uSha)*HDif*tau(HEM)</code>
</li>
<li>
the transmitted direct radiation on no shade part: <code>AWin*(1-uSha)*HDir*tau(IncAng)</code>
</li>
<li>
the transmitted diffusive radiation on shaded part: <code>AWin*uSha*HDif*tauSha(HEM)</code>
</li>
<li>
the transmitted direct radiation on shaded part: <code>AWin*uSha*HDir*tauSha(IncAng);</code>
</li>
</ol>
<p>The output is <code>QTra_flow = Part1 + Part2 + Part3 + Part4</code></p>

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br/>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Removed duplicate text annotation.
</li>
<li>
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for tra and abs. It is needed by the claculation of property for uncoated glass.
</li>
<li>
February 2, 2010, by Michael Wetter:<br/>
Made connector <code>uSha</code> a conditional connector.
</li>
<li>
January 4, 2011, by Michael Wetter:<br/>
Added assert statement to check that <code>uSha=0</code> if no shade is present.
This is needed to avoid wrong results in the room model.
</li>
<li>
December 15, 2010, by Wangda Zuo:<br/>
Revise the model by separating transmittance and absorbance.
</li>
<li>
December 12, 2010, by Michael Wetter:<br/>
Replaced record
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> with the
parameters used by this model.
This was needed to integrate the radiation model into the room model.
</li>
<li>
December 10, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{0,86},{90,72}},
          lineColor={0,0,127},
          textString="QAbsExtSha"),
        Text(
          extent={{-4,-22},{92,-36}},
          lineColor={0,0,127},
          textString="QAbsIntSha"),
        Text(
          extent={{2,58},{94,44}},
          lineColor={0,0,127},
          textString="QAbsGlaUns"),
        Text(
          extent={{-2,20},{92,6}},
          lineColor={0,0,127},
          textString="QAbsGlaSha"),
        Text(
          extent={{18,-78},{92,-94}},
          lineColor={0,0,127},
          textString="QTra"),
        Text(
          extent={{-110,-64},{-26,-86}},
          lineColor={0,0,127},
          textString="HRoo")}));
end WindowRadiation;
