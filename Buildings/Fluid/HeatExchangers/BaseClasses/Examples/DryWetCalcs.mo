within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model DryWetCalcs "Test the DryWetCalcs model"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325 "Atmospheric pressure";

  // -- water
  parameter Modelica.SIunits.ThermalConductance UAWat = 9495.5;
  parameter Modelica.SIunits.Temperature TWatIn=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.MassFlowRate mWat_flow = 3.78
    "Nominal mass flow rate medium 1 (water)";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat = 4199.3604;
  // -- air
  parameter Modelica.SIunits.ThermalConductance UAAir = 9495.5;
  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.MassFlowRate mAir_flow = 2.646
    "Nominal mass flow rate medium 2 (air)";
  parameter Modelica.SIunits.SpecificHeatCapacity cpAir = 1021.5792;
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn=
    Medium_A.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn, 1-wAirIn});
  parameter Modelica.SIunits.AbsolutePressure pAir = pAtm;
  parameter Real wAirIn(min=0,max=1,unit="1") = 0.0089757;

  Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs dryWetCalcs(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    TWatOut_init = TWatIn,
    cfg=
    Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowCMinUnmixedCMaxMixed)
    annotation (Placement(transformation(extent={{-40,-60},{60,60}})));

  Modelica.Blocks.Sources.RealExpression UAAirExp(y=UAAir)
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.RealExpression UAWatExp(y=UAWat)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.RealExpression mAir_flowExp(y=mAir_flow)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.RealExpression mWat_flowExp(y=mWat_flow)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.RealExpression cpWatExp(y=cpWat)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.RealExpression cpAirExp(y=cpAir)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.RealExpression TWatInExp(y=TWatIn)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.RealExpression TAirInExp(y=TAirIn)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.RealExpression hAirInExp(y=hAirIn)
    "enthaly of air at inlet"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.RealExpression pAirExp(y=pAir)
    "inlet air pressure"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.RealExpression wAirInExp(y=wAirIn)
    "inlet humidity ratio (kg of water/kg of moist air)"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

equation
  connect(UAWatExp.y, dryWetCalcs.UAWat) annotation (Line(points={{-79,90},{-44,
          90},{-44,55},{-36.4286,55}}, color={0,0,127}));
  connect(mWat_flowExp.y, dryWetCalcs.mWat_flow) annotation (Line(points={{-79,70},
          {-48,70},{-48,45},{-36.4286,45}}, color={0,0,127}));
  connect(cpWatExp.y, dryWetCalcs.cpWat) annotation (Line(points={{-79,50},{-52,
          50},{-52,35},{-36.4286,35}}, color={0,0,127}));
  connect(TWatInExp.y, dryWetCalcs.TWatIn) annotation (Line(points={{-79,30},{
          -58,30},{-58,25},{-36.4286,25}},
                                       color={0,0,127}));
  connect(wAirInExp.y, dryWetCalcs.wAirIn) annotation (Line(points={{-79,10},{
          -76,10},{-76,5},{-36.4286,5}},
                                     color={0,0,127}));
  connect(pAirExp.y, dryWetCalcs.pAir) annotation (Line(points={{-79,-10},{-74,
          -10},{-74,-5},{-36.4286,-5}}, color={0,0,127}));
  connect(hAirInExp.y, dryWetCalcs.hAirIn) annotation (Line(points={{-79,-30},{
          -70,-30},{-70,-15},{-36.4286,-15}},
                                          color={0,0,127}));
  connect(TAirInExp.y, dryWetCalcs.TAirIn) annotation (Line(points={{-79,-50},{
          -66,-50},{-66,-25},{-36.4286,-25}},
                                          color={0,0,127}));
  connect(cpAirExp.y, dryWetCalcs.cpAir) annotation (Line(points={{-79,-70},{
          -60,-70},{-60,-35},{-36.4286,-35}},
                                          color={0,0,127}));
  connect(mAir_flowExp.y, dryWetCalcs.mAir_flow) annotation (Line(points={{-79,-90},
          {-56,-90},{-56,-45},{-36.4286,-45}}, color={0,0,127}));
  connect(UAAirExp.y, dryWetCalcs.UAAir) annotation (Line(points={{-79,-110},{
          -52,-110},{-52,-55},{-36.4286,-55}},
                                           color={0,0,127}));
  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/DryWetCalcs.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-120},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-120},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This example duplicates example SM2-1 from Mitchell and Braun 2012. Because we
have the ability to directly specify fluid properties as inputs, we can use the
exact same numbers for specific heats, etc. as in the textbook example. The
only known differences are in the tolerance, the iterative solution method of
the solvers (Mitchell and Braun's example was calculed using Engineering
Equation Solver or EES), and in the unit system employed. In particular, the
authors performed their calculations in IP units while this problem is
conducted in SI units which may imply differences due to the conversion
factors used and precision of results. This example tests the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs</a>.
</p>

<p>
The example values calculated here corresponds closely with those of the text.
Note: to do a full comparison, you may want to choose to show values of
protected variables if you have that option in your Modelica compiler.
</p>

<p>
Because the full data corresponding to SM2-1 is somewhat difficult to obtain
(it requires downloading an EES file and running it and converting the units to
SI), we present it below in tabular form. Note in particular that the SM2-1 data
uses a different zero-point for calculation of specific enthalpy -- therefore, only
differences in specific enthalpy should be compared:
</p>

<p>
Note also that the entries for Q<sub>sensible, wet</sub> and
SHR<sub>wet</sub> are values for the 100% wet coil case
derived using a Psychrometrics calculator that had less
precision than calculations in Modelica.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
  <th>Ex. SM2-1 Parameter</th>
  <th>Ex. SM2-1 Value</th>
  <th>Compare With</th>
</tr>
<tr>
  <td>Configuration</td>
  <td>Cross-flow</td>
  <td><code>cfg</code></td>
</tr>
<tr>
  <td>A<sub>a</sub></td>
  <td>33.4450944 m<sup>2</sup></td>
  <td>NA</td>
</tr>
<tr>
  <td>A<sub>w</sub></td>
  <td>1.67225472 m<sup>2</sup></td>
  <td>NA</td>
</tr>
<tr>
  <td>cp<sub>a</sub></td>
  <td>1021.5792 J/kg/K</td>
  <td><code>cpAir</code></td>
</tr>
<tr>
  <td>cp<sub>w</sub></td>
  <td>4199.3604 J/kg/K</td>
  <td><code>cpWat</code></td>
</tr>
<tr>
  <td>C<sub>a</sub></td>
  <td>2703.05 W/K</td>
  <td><code>dryWetCalcs.dry.CAir</code></td>
</tr>
<tr>
  <td>C<sub>min</sub></td>
  <td>2703.05 W/K</td>
  <td><code>dryWetCalcs.dry.CMin</code></td>
</tr>
<tr>
  <td>c<sub>s</sub></td>
  <td>2104.70 J/kg/K</td>
  <td><code>dryWetCalcs.wet.cpEff</code></td>
</tr>
<tr>
  <td>C<sup>*</sup></td>
  <td>0.1704</td>
  <td><code>dryWetCalcs.dry.Z</code></td>
</tr>
<tr>
  <td>C<sub>w</sub></td>
  <td>15866.98 W/K</td>
  <td><code>dryWetCalcs.dry.CWat</code></td>
</tr>
<tr>
  <td>eff<sub>dry</sub></td>
  <td>0.7717</td>
  <td><code>dryWetCalcs.dry.eff</code></td>
</tr>
<tr>
  <td>eff<sub>p,dry</sub></td>
  <td>0.4525</td>
  <td><code>dryWetCalcs.parDry.eff</code></td>
</tr>
<tr>
  <td>eff<sub>p,wet</sub></td>
  <td>0.4745</td>
  <td><code>dryWetCalcs.parWet.effSta</code></td>
</tr>
<tr>
  <td>eff<sup>*</sup></td>
  <td>0.6071</td>
  <td><code>dryWetCalcs.wet.effSta</code></td>
</tr>
<tr>
  <td>h<sub>a,in</sub></td>
  <td>67709.86 J/kg</td>
  <td><code>hAirIn</code></td>
</tr>
<tr>
  <td>h<sub>a,out,p</sub></td>
  <td>48659.92 J/kg</td>
  <td><code>dryWetCalcs.parWet.hAirOut</code></td>
</tr>
<tr>
  <td>h<sub>a,out,wet</sub></td>
  <td>49380.98 J/kg</td>
  <td><code>dryWetCalcs.wet.hAirOut</code></td>
</tr>
<tr>
  <td>h<sub>a,x</sub></td>
  <td>58731.50 J/kg</td>
  <td><code>dryWetCalcs.wet.hAirIn</code></td>
</tr>
<tr>
  <td>h<sub>s,eff</sub></td>
  <td>48822.74 J/kg</td>
  <td><code>dryWetCalcs.wet.hSurEff</code></td>
</tr>
<tr>
  <td>h<sub>w,in</sub></td>
  <td>37518.38 J/kg</td>
  <td><code>dryWetCalcs.hAirSatSurIn</code></td>
</tr>
<tr>
  <td>h<sub>w,out,wet</sub></td>
  <td>43938.14 J/kg</td>
  <td><code>dryWetCalcs.wet.hAirSatSurOut</code></td>
</tr>
<tr>
  <td>m<sub>dot,a</sub></td>
  <td>2.646 kg/s</td>
  <td><code>mAir_flow</code></td>
</tr>
<tr>
  <td>m<sub>dot,cond,wet</sub></td>
  <td>0.002087 kg/s</td>
  <td><code>dryWetCalcs.wet.mCon_flow</code></td>
</tr>
<tr>
  <td>m<sub>dot,w</sub></td>
  <td>3.78 kg/s</td>
  <td><code>mWat_flow</code></td>
</tr>
<tr>
  <td>m<sup>*</sup></td>
  <td>0.351</td>
  <td><code>dryWetCalcs.wet.mSta</code></td>
</tr>
<tr>
  <td>NTU<sub>a,star</sub></td>
  <td>3.513</td>
  <td><code>dryWetCalcs.wet.NTUAirSta</code></td>
</tr>
<tr>
  <td>NTU<sub>dry</sub></td>
  <td>1.756</td>
  <td><code>dryWetCalcs.dry.Ntu</code></td>
</tr>
<tr>
  <td>NTU<sub>p,dry</sub></td>
  <td>0.6366</td>
  <td><code>dryWetCalcs.parDry.Ntu</code></td>
</tr>
<tr>
  <td>NTU<sub>p,wet</sub></td>
  <td>0.7319</td>
  <td><code>dryWetCalcs.parWet.NTUSta</code></td>
</tr>
<tr>
  <td>NTU<sup>*</sup></td>
  <td>1.148</td>
  <td><code>dryWetCalcs.wet.NTUSta</code></td>
</tr>
<tr>
  <td>p<sub>atm</sub></td>
  <td>101352.93 Pa</td>
  <td><code>pAtm</code></td>
</tr>
<tr>
  <td>Q<sub>dry</sub></td>
  <td>44035.97 W</td>
  <td><code>-dryWetCalcs.dry.Q</code></td>
</tr>
<tr>
  <td>Q<sub>p,dry</sub></td>
  <td>23769.24 W</td>
  <td><code>-dryWetCalcs.parDry.Q</code></td>
</tr>
<tr>
  <td>Q<sub>p,total</sub></td>
  <td>50404.71 W</td>
  <td><code>-dryWetCalcs.QTot</code></td>
</tr>
<tr>
  <td>Q<sub>p,wet</sub></td>
  <td>26626.97 W</td>
  <td><code>-dryWetCalcs.QParTotWet_flow</code></td>
</tr>
<tr>
  <td>Q<sub>wet</sub></td>
  <td>48505.90 W</td>
  <td><code>-dryWetCalcs.QTotWet_flow</code></td>
</tr>
<tr>
  <td>R<sub>a</sub></td>
  <td>0.000105 K/W</td>
  <td><code>dryWetCalcs.dry.ResAir</code></td>
</tr>
<tr>
  <td>R<sub>dry</sub></td>
  <td>0.000210 K/W</td>
  <td><code>dryWetCalcs.dry.ResTot</code></td>
</tr>
<tr>
  <td>R<sub>w</sub></td>
  <td>0.000105 K/W</td>
  <td><code>dryWetCalcs.dry.ResWat</code></td>
</tr>
<tr>
  <td>T<sub>a,in</sub></td>
  <td>26.67 C</td>
  <td><code>TAirIn</code></td>
</tr>
<tr>
  <td>T<sub>a,out,dry</sub></td>
  <td>10.38 C</td>
  <td><code>dryWetCalcs.dry.TAirOut</code></td>
</tr>
<tr>
  <td>T<sub>a,out,wet</sub></td>
  <td>11.21 C</td>
  <td><code>dryWetCalcs.wet.TAirOut</code></td>
</tr>
<tr>
  <td>T<sub>a,x</sub></td>
  <td>17.87 C</td>
  <td><code>dryWetCalcs.TAirX</code></td>
</tr>
<tr>
  <td>T<sub>s,x</sub></td>
  <td>12.56 C</td>
  <td><code>dryWetCalcs.TAirInDewPoi</code></td>
</tr>
<tr>
  <td>T<sub>wb,in</sub></td>
  <td>17.78 C</td>
  <td>NA</td>
</tr>
<tr>
  <td>T<sub>w,in</sub></td>
  <td>5.56 C</td>
  <td><code>TWatIn</code></td>
</tr>
<tr>
  <td>T<sub>w,out,dry</sub></td>
  <td>8.33 C</td>
  <td><code>dryWetCalcs.dry.TWatOut</code></td>
</tr>
<tr>
  <td>T<sub>w,out,p</sub></td>
  <td>8.73 C</td>
  <td><code>dryWetCalcs.parDry.TWatOut</code></td>
</tr>
<tr>
  <td>T<sub>w,out,wet</sub></td>
  <td>8.61 C</td>
  <td><code>dryWetCalcs.wet.TWatOut</code></td>
</tr>
<tr>
  <td>T<sub>w,x</sub></td>
  <td>7.23 C</td>
  <td><code>dryWetCalcs.TWatX</code></td>
</tr>
<tr>
  <td>UA<sub>dry</sub></td>
  <td>4747.75 W/K</td>
  <td><code>dryWetCalcs.dry.UA</code></td>
</tr>
<tr>
  <td>UA<sub>wet</sub></td>
  <td>3.037 kg/s</td>
  <td><code>dryWetCalcs.wet.UASta</code></td>
</tr>
<tr>
  <td>UA<sub>a</sub></td>
  <td>283.913 W/m<sup>2</sup>/K</td>
  <td>NA</td>
</tr>
<tr>
  <td>UA<sub>a,dry</sub></td>
  <td>141.96 W/m<sup>2</sup>/K</td>
  <td>NA</td>
</tr>
<tr>
  <td>UA<sup>*</sup></td>
  <td>0.0908 kg/s/m<sup>2</sup></td>
  <td>NA</td>
</tr>
<tr>
  <td>U<sub>w</sub></td>
  <td>5678.26 W/m<sup>2</sup>/K</td>
  <td>NA</td>
</tr>
<tr>
  <td>w<sub>in</sub></td>
  <td>0.0089757 kg water/kg moist air</td>
  <td><code>wAirIn</code></td>
</tr>
<tr>
  <td>w<sub>out,wet</sub></td>
  <td>0.0082002 kg water/kg moist air</td>
  <td><code>dryWetCalcs.wet.wAirOut</code></td>
</tr>
<tr>
  <td>X</td>
  <td>0.3624</td>
  <td><code>dryWetCalcs.dryFra</code></td>
</tr>
<tr>
  <td>SHR<sub>wet</sub> (calculated, approx.)</td>
  <td>0.8876</td>
  <td>NA</td>
</tr>
<tr>
  <td>Q<sub>sensible, wet</sub> (calculated, approx.)</td>
  <td>41807 W</td>
  <td><code>-dryWetCalcs.wet.QSen</code></td>
</tr>
</table>

<h4>References</h4>

<p>
Mitchell, John W., and James E. Braun. 2012.
\"Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications\".
Excerpt from <i>Principles of heating, ventilation, and air conditioning in buildings</i>.
Hoboken, N.J.: Wiley. Available online:
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185</a>
</p>
</html>"));
end DryWetCalcs;
