within Buildings.Fluid.CHPs.Rankine;
model Cycle "Model for the Rankine cycle"

  parameter Buildings.Fluid.CHPs.Rankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);

  Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate of the working fluid";

  // Input properties
  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature";
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature ";
  parameter Real etaExp "Expander efficiency";

  // Computed properties
  final parameter Modelica.Units.SI.AbsolutePressure pEva(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TEva,
      xSup = pro.T,
      ySup = pro.p)
    "Evaporator pressure";
  final parameter Modelica.Units.SI.AbsolutePressure pCon(
    displayUnit = "kPa") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.p)
    "Condenser pressure";
  Modelica.Units.SI.SpecificEntropy sExpInl
    "Specific entropy at expander inlet";
  final parameter Modelica.Units.SI.SpecificEntropy sPum =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.sSatLiq)
    "Specific entropy at pump, neglecting difference between inlet and outlet";
  Modelica.Units.SI.SpecificEnthalpy hExpInl(displayUnit = "kJ/kg")
    "Specific enthalpy at expander inlet";
  final parameter Modelica.Units.SI.SpecificEnthalpy hPum(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = TCon,
      xSup = pro.T,
      ySup = pro.hSatLiq)
    "Specific enthalpy at pump, neglecting difference between inlet and outlet";
  Modelica.Units.SI.SpecificEnthalpy hExpOut_i(displayUnit = "kJ/kg")
    "Estimated specific enthalpy at expander outlet assuming isentropic";

  final Real etaExpLim =
    (hExpInl - hSatVapCon)/(hExpInl - hExpOut_i)
    "Upper limit of expander efficiency to prevent condensation, dry fluids have >1";

  // Enthalpy differentials,
  //   taking positive sign when flowing into the cycle
  final Modelica.Units.SI.SpecificEnergy dhEva = hExpInl - hPum
    "Enthalpy differential at the evaporator (positive)";
  final Modelica.Units.SI.SpecificEnergy dhExp =
    (hExpOut_i - hExpInl) * etaExp
    "Enthalpy differential at the expander (negative)";
  final Modelica.Units.SI.SpecificEnergy dhCon = - dhEva - dhExp
    "Enthalpy differential at the condenser (negative)";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(
    T = TEva,
    Q_flow = m_flow * dhEva)
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(
    T = TCon,
    Q_flow = m_flow * dhCon)
    "Working fluid connector b (corresponding to the condenser)"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}}),
      iconTransformation(extent={{10,-110},{-10,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W")
    = - m_flow * dhExp
    "Power output of the expander" annotation (Placement(transformation(extent={
            {100,-50},{120,-30}}), iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") = - dhExp / dhEva "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-90},{120,-70}}), iconTransformation(extent
          ={{100,-90},{120,-70}})));
protected
  final parameter Modelica.Units.SI.SpecificEntropy sSatVapCon =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.sSatVap)
    "Specific entropy of saturated vapour at the condenser";
  final parameter Modelica.Units.SI.SpecificEntropy sSupVapCon =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.sSupVap)
    "Specific entropy of superheated vapour on condenser side";
  final parameter Modelica.Units.SI.SpecificEntropy sSatVapEva =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.sSatVap)
    "Specific entropy of saturated vapour in evaporator";
  final parameter Modelica.Units.SI.SpecificEntropy sSupVapEva =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.sSupVap)
    "Specific entropy of superheated vapour on evaporator side";
  final parameter Modelica.Units.SI.SpecificEnthalpy hSatVapCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.hSatVap)
    "Specific enthalpy of saturated vapour at the condenser as reference point";
  final parameter Modelica.Units.SI.SpecificEnthalpy hSupVapCon(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pCon,
      xSup = pro.p,
      ySup = pro.hSupVap)
    "Specific enthalpy of superheated vapour on condenser side";
  final parameter Modelica.Units.SI.SpecificEnthalpy hSatVapEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.hSatVap)
    "Specific enthalpy of saturated vapour in evaporator";
  final parameter Modelica.Units.SI.SpecificEnthalpy hSupVapEva(
    displayUnit = "kJ/kg") =
    Buildings.Utilities.Math.Functions.smoothInterpolation(
      x = pEva,
      xSup = pro.p,
      ySup = pro.hSupVap)
    "Specific enthalpy of superheated vapour on evaporator side";

initial equation
/*  assert(etaExp < etaExpLim,
"Expander outlet state is under the dome!
Based on the input parameters, the maximum expander effciency can be assumed
to be " + String(etaExpLim) + ".
Or use a higher superheating differential temperature.");*/

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
    (hExpOut_i - hSatVapCon) / (hSupVapCon - hSatVapCon)
      = (sExpInl - sSatVapCon) / (sSupVapCon - sSatVapCon);
  else
    (hExpOut_i - hPum) / (sExpInl - sPum)
      = (hSatVapCon - hPum) / (sSatVapCon - sPum);
  end if;

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          textString="s")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cycle;
