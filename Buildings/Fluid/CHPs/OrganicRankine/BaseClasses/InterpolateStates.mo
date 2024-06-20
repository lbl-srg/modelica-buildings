within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model InterpolateStates "Interpolate states of a working fluid"

  // Input properties
  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(Dialog(group="ORC inputs"), choicesAllMatching = true);
  parameter Modelica.Units.SI.SpecificEnthalpy h_small =
    (max(pro.hSatVap) - min(pro.hSatLiq)) * 1E-4
    "A small value for specific enthalpy regularisation"
    annotation(Dialog(tab="Advanced"));

  input Modelica.Units.SI.ThermodynamicTemperature TEva
    "Evaporating temperature";
  input Modelica.Units.SI.ThermodynamicTemperature TCon
    "Condensing temperature";
  input Modelica.Units.SI.Efficiency etaExp
    "Expander efficiency";
  input Modelica.Units.SI.Efficiency etaPum
    "Pump efficiency";

  // Once-interpolated properties
  Modelica.Units.SI.AbsolutePressure pEva(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TEva,
      xd = pro.T,
      yd = pro.p,
      d = pDer_T)
    "Evaporating pressure";
  Modelica.Units.SI.AbsolutePressure pCon(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.p,
      d = pDer_T)
    "Condensing pressure";
  Modelica.Units.SI.Density rhoLiq =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.rhoLiq,
      d = rhoLiqDer_T)
    "Saturated liquid density";
  Modelica.Units.SI.SpecificEntropy sPumInl =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.sSatLiq,
      d = sSatLiqDer_T)
    "Specific entropy at pump inlet";
  Modelica.Units.SI.SpecificEnthalpy hPumInl(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.hSatLiq,
      d = hSatLiqDer_T)
    "Specific enthalpy at pump inlet";
  Modelica.Units.SI.SpecificEnthalpy hPinEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TEva,
      xd = pro.T,
      yd = pro.hSatLiq,
      d = hSatLiqDer_T)
    "Specific enthalpy at evaporator-side pinch point";
  Modelica.Units.SI.SpecificEnthalpy hPinCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.hSatVap,
      d = hSatVapDer_T)
    "Specific enthalpy at condenser-side pinch point";
  Modelica.Units.SI.SpecificEntropy sSatVapCon(
    start = max(pro.sSatVap) * 0.1 + min(pro.sSatVap) * 0.9) =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.sSatVap,
      d = sSatVapDer_T)
    "Specific entropy of saturated vapor at the condenser";
  Modelica.Units.SI.SpecificEntropy sRefCon =
    Buildings.Utilities.Math.Functions.interpolate(
      u = pCon,
      xd = pro.p,
      yd = pro.sRef,
      d = sRefDer_p)
    "Specific entropy on reference line at condensing pressure";
  Modelica.Units.SI.SpecificEntropy sSatVapEva =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TEva,
      xd = pro.T,
      yd = pro.sSatVap,
      d = sSatVapDer_T)
    "Specific entropy of saturated vapor at evaporating temperature";
  Modelica.Units.SI.SpecificEnthalpy hSatVapEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TEva,
      xd = pro.T,
      yd = pro.hSatVap,
      d = hSatVapDer_T)
    "Specific enthalpy of saturated vapor at evaporating temperature";
  Modelica.Units.SI.SpecificEntropy sRefEva =
    Buildings.Utilities.Math.Functions.interpolate(
      u = pEva,
      xd = pro.p,
      yd = pro.sRef,
      d = sRefDer_p)
    "Specific entropy on reference line at evaporating pressure";
  Modelica.Units.SI.SpecificEnthalpy hSatVapCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = TCon,
      xd = pro.T,
      yd = pro.hSatVap,
      d = hSatVapDer_T)
    "Specific enthalpy of saturated vapor at the condensing temperature";
  Modelica.Units.SI.SpecificEnthalpy hRefCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = pCon,
      xd = pro.p,
      yd = pro.hRef,
      d = hRefDer_p)
    "Specific enthalpy on reference line at condensing pressure";
  Modelica.Units.SI.SpecificEnthalpy hRefEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.interpolate(
      u = pEva,
      xd = pro.p,
      yd = pro.hRef,
      d = hRefDer_p)
    "Specific enthalpy on reference line at evaporating pressure";

  // Computed properties not interpolated
  Modelica.Units.SI.SpecificEnthalpy hPumOut(displayUnit = "kJ/kg") =
    hPumInl + wPum
    "Specific enthalpy at pump outlet";
  Modelica.Units.SI.SpecificEnthalpy hExpInl(displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.regStep(
      x = h_reg,
      y1 = hSatVapEva,
      y2 = hExpInlWet,
      x_small = h_small)
    "Specific enthalpy at expander inlet";
  Modelica.Units.SI.SpecificEnthalpy hExpOut(displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.regStep(
      x = h_reg,
      y1 = hExpOutDry,
      y2 = hSatVapCon,
      x_small = h_small)
    "Specific enthalpy at expander inlet";
  Modelica.Units.SI.TemperatureDifference dTSup = max(0, dTSupWet)
    "Superheating temperature differential";

  // Energy transfer
  Modelica.Units.SI.SpecificEnergy qEva = hPumOut - hExpInl
    "Evaporator specific energy transfer into the cycle";
  Modelica.Units.SI.SpecificEnergy qCon = hExpOut - hPumInl
    "Condenser specific energy transfer out of the cycle";
  Modelica.Units.SI.SpecificEnergy wExp = hExpOut - hExpInl
    "Expander specific work";
  Modelica.Units.SI.SpecificEnergy wPum = (pEva - pCon) / (rhoLiq * etaPum)
    "Pump specific work";
  Modelica.Units.SI.Efficiency etaThe(min=0) =
    (wExp + wPum) / qEva "Thermal efficiency";

protected
  Modelica.Units.SI.SpecificEnthalpy h_reg = hExpOutDry - hSatVapCon
    "For regularisation; if > 0, dry cycle";

  // Intermediate property computation
  // 1. Dry cycle
  //      expander inlet = saturated vapor at evaporating pressure (known),
  //      expander outlet = superheated vapor at condensing pressure (solved).
  Modelica.Units.SI.SpecificEntropy sExpOutDryIse = sSatVapEva
    "Specific entropy at isentropic expander outlet, assuming dry cycle";
  Modelica.Units.SI.SpecificEnthalpy hExpOutDryIse(
    displayUnit = "kJ/kg") =
    if sExpOutDryIse > sSatVapCon
    then (hRefCon - hSatVapCon) * (sExpOutDryIse - sSatVapCon)
         / (sRefCon - sSatVapCon) + hSatVapCon
    else (hSatVapCon - hPumInl) * (sExpOutDryIse - sPumInl)
         / (sSatVapCon - sPumInl) + hPumInl
    "Specific enthalpy at expander outlet, assuming dry cycle";
  Modelica.Units.SI.SpecificEnthalpy hExpOutDry(
    displayUnit = "kJ/kg") =
    hSatVapEva - (hSatVapEva - hExpOutDryIse) * etaExp
    "Specific enthalpy at expander outlet, assuming dry cycle";
  // 2. Wet cycle
  //      expander inlet = superheated vapor at evaporating pressure (solved),
  //      expander outlet = saturated vapor at condensing pressure (known).
  Modelica.Units.SI.SpecificEntropy sExpInlWetIse = sSatVapCon
    "Specific entropy at isentropic expander inlet, assuming wet cycle";
  Modelica.Units.SI.SpecificEnthalpy hExpInlWetIse(
    displayUnit = "kJ/kg") =
    (hRefEva - hSatVapEva) * (sExpInlWetIse - sSatVapEva)
    / (sRefEva - sSatVapEva) + hSatVapEva
    "Specific enthalpy at expander inlet, assuming wet cycle";
  Modelica.Units.SI.SpecificEnthalpy hExpInlWet(
    displayUnit = "kJ/kg") =
    (hExpInlWetIse - hSatVapCon) * etaExp + hSatVapCon
    "Specific enthalpy at expander inlet, assuming wet cycle";
  Modelica.Units.SI.TemperatureDifference dTSupWet(
    displayUnit = "K") =
    (hExpInlWet - hSatVapEva) * pro.dTRef / (hRefEva - hSatVapEva)
    "Superheating temperature differential, assuming wet cycle";

  // Derivatives
  final parameter Real pDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.p,
      ensureMonotonicity = true)
  "Derivative of saturation pressure vs. saturation temperature for cubic spline";
  final parameter Real rhoLiqDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.rhoLiq,
      ensureMonotonicity = true)
  "Derivative of saturated liquid density vs. temperature for cubic spline";
  final parameter Real sSatLiqDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.sSatLiq,
      ensureMonotonicity = true)
  "Derivative of saturated liquid entropy vs. temperature for cubic spline";
  final parameter Real sSatVapDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.sSatVap,
      ensureMonotonicity = false)
  "Derivative of saturated vapor entropy vs. temperature for cubic spline";
  final parameter Real sRefDer_p[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.p,
      y = pro.sRef,
      ensureMonotonicity = false)
  "Derivative of reference entropy vs. pressure for cubic spline";
  final parameter Real hSatLiqDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.hSatLiq,
      ensureMonotonicity = true)
  "Derivative of saturated liquid enthalpy vs. temperature for cubic spline";
  final parameter Real hSatVapDer_T[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.T,
      y = pro.hSatVap,
      ensureMonotonicity = false)
  "Derivative of saturated vapor enthalpy vs. temperature for cubic spline";
  final parameter Real hRefDer_p[pro.n]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x = pro.p,
      y = pro.hRef,
      ensureMonotonicity = false)
  "Derivative of reference enthaly vs. pressure for cubic spline";

  annotation (defaultComponentName="cyc",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-60,-60},{-28,-20},{16,32},{40,60},{52,60},{54,30},{48,2},{52,
              -38},{58,-58}},
          color={255,255,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18},{-24,-6},{6,20}},
          color={255,255,255},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(points={{-66,61},{-66,-78}}, color={255,255,255}),
        Polygon(
          points={{-66,73},{-74,51},{-58,51},{-66,73}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{63,-67},{41,-59},{41,-75},{63,-67}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-67},{57,-67}}, color={255,255,255}),
        Text(
          extent={{-100,100},{-64,58}},
          textColor={255,255,255},
          textString="T"),
        Text(
          extent={{64,-58},{100,-100}},
          textColor={255,255,255},
          textString="s"),
        Text(
          extent={{-151,-100},{149,-140}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model performs the property interpolations of a given working fluid.
See the documentation of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Cycle\">
Buildings.Fluid.CHPs.OrganicRankine.Cycle</a>
for more details.
</html>", revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end InterpolateStates;
