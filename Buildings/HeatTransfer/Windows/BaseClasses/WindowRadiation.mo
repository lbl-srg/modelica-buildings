within Buildings.HeatTransfer.Windows.BaseClasses;
block WindowRadiation "Calculation radiation for window"

  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialRadiation;

  Modelica.Blocks.Interfaces.RealInput uSta(min=0, max=1, unit="1") if
       NSta > 1 "Control signal for window state"
                                      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}},   rotation=90,
        origin={40,-120}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={48,-116})));

  Modelica.Blocks.Interfaces.RealInput HRoo(quantity="RadiantEnergyFluenceRate",
      unit="W/m2") "Diffussive radiation from room " annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(
          extent={{-130,-91},{-100,-61}})));
  Modelica.Blocks.Interfaces.RealOutput QTraDif_flow(
    final quantity="Power",
    final unit="W")
    "Transmitted diffuse exterior radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
        iconTransformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput QTraDir_flow(
    final quantity="Power",
    final unit="W")
    "Transmitted direct exterior radiation through the window. (1: no shade; 2: shade)"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

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

  StateInterpolator staIntQAbsExtSha_flow(
    final NSta=NSta) "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  StateInterpolator staIntQAbsGlaUns_flow[N](each final NSta=NSta)
    "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  StateInterpolator staIntQAbsGlaSha_flow[N](each final NSta=NSta)
    "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  StateInterpolator staIntQAbsIntSha_flow(
    final NSta=NSta) "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  StateInterpolator staIntQTraDif_flow(final NSta=NSta)
    "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  StateInterpolator staIntQTraDir_flow(final NSta=NSta)
    "Interpolator for the window state"
    annotation (Placement(transformation(extent={{60,-98},{80,-78}})));

  Modelica.Blocks.Routing.Replicator replicator(final nout=N) if
     NSta > 1
    "Signal replicator for signals that have an element for each glass pane"
    annotation (Placement(transformation(extent={{16,-68},{36,-48}})));
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
  connect(abs.QAbsExtSha_flow, staIntQAbsExtSha_flow.HSta) annotation (Line(
        points={{-19,-22},{8,-22},{36,-22},{36,74},{58,74}},         color={0,0,
          127}));
  connect(staIntQAbsExtSha_flow.H, QAbsExtSha_flow) annotation (Line(points={{81,
          80},{92,80},{92,90},{110,90}}, color={0,0,127}));
  connect(abs.QAbsGlaUns_flow, staIntQAbsGlaUns_flow.HSta) annotation (Line(
        points={{-19,-26},{14,-26},{40,-26},{40,44},{58,44}}, color={0,0,127}));
  connect(staIntQAbsGlaUns_flow.H, QAbsGlaUns_flow)
    annotation (Line(points={{81,50},{110,50}},          color={0,0,127}));
  connect(staIntQAbsGlaSha_flow.HSta, abs.QAbsGlaSha_flow) annotation (Line(
        points={{58,-6},{44,-6},{44,-34},{-19,-34}}, color={0,0,127}));
  connect(staIntQAbsGlaSha_flow.H, QAbsGlaSha_flow) annotation (Line(points={{81,
          0},{92,0},{92,10},{110,10}}, color={0,0,127}));
  connect(abs.QAbsIntSha_flow, staIntQAbsIntSha_flow.HSta) annotation (Line(
        points={{-19,-38},{18,-38},{18,-36},{58,-36}}, color={0,0,127}));
  connect(staIntQAbsIntSha_flow.H, QAbsIntSha_flow)
    annotation (Line(points={{81,-30},{110,-30}},           color={0,0,127}));
  connect(staIntQTraDif_flow.H, QTraDif_flow)
    annotation (Line(points={{81,-60},{96,-60},{110,-60}},
                                                  color={0,0,127}));
  connect(uSta, staIntQAbsExtSha_flow.uSta) annotation (Line(points={{40,-120},{
          40,-120},{40,-96},{40,86},{58,86}},          color={0,0,127}));
  connect(staIntQTraDif_flow.uSta, uSta) annotation (Line(points={{58,-54},{58,-54},
          {40,-54},{40,-120}}, color={0,0,127}));
  connect(staIntQAbsIntSha_flow.uSta, uSta)
    annotation (Line(points={{58,-24},{40,-24},{40,-120}}, color={0,0,127}));

  connect(uSta, replicator.u) annotation (Line(points={{40,-120},{40,-74},{8,-74},
          {8,-58},{14,-58}}, color={0,0,127}));
  connect(replicator.y, staIntQAbsGlaUns_flow.uSta) annotation (Line(points={{37,
          -58},{48,-58},{48,56},{58,56}}, color={0,0,127}));
  connect(replicator.y, staIntQAbsGlaSha_flow.uSta) annotation (Line(points={{37,
          -58},{44,-58},{48,-58},{48,6},{58,6}}, color={0,0,127}));
  connect(uSta, staIntQTraDir_flow.uSta)
    annotation (Line(points={{40,-120},{40,-82},{58,-82}}, color={0,0,127}));
  connect(tra.QTraDif_flow, staIntQTraDif_flow.HSta) annotation (Line(points={{-19,
          52},{6,52},{6,-76},{48,-76},{48,-66},{58,-66}}, color={0,0,127}));
  connect(tra.QTraDir_flow, staIntQTraDir_flow.HSta) annotation (Line(points={{-19,
          48},{-10,48},{4,48},{4,-94},{58,-94}}, color={0,0,127}));
  connect(staIntQTraDir_flow.H, QTraDir_flow) annotation (Line(points={{81,-88},
          {88,-88},{88,-90},{110,-90}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
The model calculates solar radiation through the window.
The calculations follow the description in Wetter (2004), Appendix A.4.3.
with the difference that this implementation allows a window to have
multiple states, thereby allowing to model electrochromic windows.
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
<p>
The outputs are <code>QTraDif_flow = Part1 + Part3</code> and
<code>QTraDir_flow = Part2 + Part4</code>.
</p>

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
June 7, 2016, by Michael Wetter:<br/>
Removed output <code>QTra_flow</code> and introduced instead
<code>QTraDif_flow</code> and <code>QTraDir_flow</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
</li>
<li>
August 7, 2015, by Michael Wetter:<br/>
Revised model to allow modeling of electrochromic windows.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/445\">issue 445</a>.
</li>
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
          extent={{42,-52},{106,-66}},
          lineColor={0,0,127},
          textString="QTraDif"),
        Text(
          extent={{-104,-70},{-50,-84}},
          lineColor={0,0,127},
          textString="HRoo"),
        Text(
          extent={{8,-82},{62,-94}},
          lineColor={0,0,127},
          textString="uSta"),
        Text(
          extent={{44,-80},{108,-94}},
          lineColor={0,0,127},
          textString="QTraDir")}));
end WindowRadiation;
