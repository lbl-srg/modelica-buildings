within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model InterpolateStates "Interpolate states of a working fluid"

  // Input properties
  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(Dialog(group="ORC inputs"),choicesAllMatching = true);

  input Modelica.Units.SI.ThermodynamicTemperature TEva
    "Evaporating temperature";
  input Modelica.Units.SI.ThermodynamicTemperature TCon
    "Condensing temperature";

  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature"
    annotation(Dialog(group="ORC inputs"));
  parameter Modelica.Units.SI.Efficiency etaExp "Expander efficiency"
    annotation(Dialog(group="ORC inputs"));

  // Computed properties
  Modelica.Units.SI.AbsolutePressure pEva(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TEva,
      xSup = pro.T,
      ySup = pro.p)
    "Evaporating pressure";
  Modelica.Units.SI.AbsolutePressure pCon(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.p)
    "Condensing pressure";
  Modelica.Units.SI.SpecificEntropy sExpInl
    "Specific entropy at expander inlet";
  Modelica.Units.SI.SpecificEntropy sPum =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.sSatLiq)
    "Specific entropy at pump, neglecting difference between inlet and outlet";
  Modelica.Units.SI.SpecificEnthalpy hExpInl(displayUnit = "kJ/kg")
    "Specific enthalpy at expander inlet";
  Modelica.Units.SI.SpecificEnthalpy hPum(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.hSatLiq)
    "Specific enthalpy at pump, neglecting difference between inlet and outlet";
  Modelica.Units.SI.SpecificEnthalpy hExpOut_i(displayUnit = "kJ/kg", start = (max(pro.hSatVap)+min(pro.hSatVap))/2)
    "Estimated specific enthalpy at expander outlet assuming isentropic";

  Modelica.Units.SI.SpecificEnthalpy hExpOut(
    displayUnit = "kJ/kg") = hExpInl - (hExpInl - hExpOut_i) * etaExp
    "Specific enthalpy at expander outlet";
  Modelica.Units.SI.ThermodynamicTemperature TExpOut
    "Temperature at expander outlet";

  Modelica.Units.SI.SpecificEnthalpy hPinEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.hSatLiq)
    "Specific enthalpy on evaporator-side pinch point";
  Modelica.Units.SI.SpecificEnthalpy hPinCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.hSatVap)
    "Specific enthalpy on condenser-side pinch point";

  Real etaExpLim =
    (hExpInl - hSatVapCon)/(hExpInl - hExpOut_i)
    "Upper limit of expander efficiency to prevent condensation, dry fluids have >1";

  // Enthalpy differentials,
  //   taking positive sign when flowing into the cycle
  Modelica.Units.SI.SpecificEnthalpy dhEva = hExpInl - hPum
    "Enthalpy differential at the evaporator (positive)";
  Modelica.Units.SI.SpecificEnthalpy dhExp =
    (hExpOut_i - hExpInl) * etaExp
    "Enthalpy differential at the expander (negative)";
  Modelica.Units.SI.SpecificEnthalpy dhCon = -dhEva - dhExp
    "Enthalpy differential at the condenser (negative)";

  Modelica.Units.SI.Efficiency etaThe(min=0) = -dhExp/dhEva
    "Thermal efficiency";

protected
  Modelica.Units.SI.SpecificEntropy sSatVapCon =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.sSatVap)
    "Specific entropy of saturated vapour at the condenser";
  Modelica.Units.SI.SpecificEntropy sSupVapCon =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.sSupVap)
    "Specific entropy of superheated vapour on condenser side";
  Modelica.Units.SI.SpecificEntropy sSatVapEva =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.sSatVap)
    "Specific entropy of saturated vapour in evaporator";
  Modelica.Units.SI.SpecificEntropy sSupVapEva =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.sSupVap)
    "Specific entropy of superheated vapour on evaporator side";
  Modelica.Units.SI.SpecificEnthalpy hSatVapCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.hSatVap)
    "Specific enthalpy of saturated vapour at the condenser as reference point";
  Modelica.Units.SI.SpecificEnthalpy hSupVapCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.hSupVap)
    "Specific enthalpy of superheated vapour on condenser side";
  Modelica.Units.SI.SpecificEnthalpy hSatVapEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.hSatVap)
    "Specific enthalpy of saturated vapour in evaporator";
  Modelica.Units.SI.SpecificEnthalpy hSupVapEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.hSupVap)
    "Specific enthalpy of superheated vapour on evaporator side";

initial equation
  assert(etaExp < etaExpLim,
"Expander outlet state is under the dome! Based on the input parameters,
the expander effciency can be assumed at maximum to be " + String(etaExpLim) + ".
Or use a higher superheating differential temperature.");

equation
  // Estimate the overheated expander inlet state
  if dTSup > 0.1 then
    (sExpInl - sSatVapEva) / dTSup = (sSupVapEva - sSatVapEva) / pro.dTSup;
    (hExpInl - hSatVapEva) / dTSup = (hSupVapEva - hSatVapEva) / pro.dTSup;
  else
    sExpInl = sSatVapEva;
    hExpInl = hSatVapEva;
  end if;

  // Estimate the isentropic expander outlet state
  if sExpInl > sSatVapCon then
    (hExpOut_i - hSatVapCon) / (sExpInl - sSatVapCon)
      =  (hSupVapCon - hSatVapCon) / (sSupVapCon - sSatVapCon);
  else
    (hExpOut_i - hPum) / (sExpInl - sPum)
      = (hSatVapCon - hPum) / (sSatVapCon - sPum);
  end if;

  // Estimate temperature at expander outlet
  (TExpOut - TCon) / pro.dTSup
    = (hExpOut - hSatVapCon) / (hSupVapCon - hSatVapCon);

  annotation (defaultComponentName="intSta",
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
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18}},
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
