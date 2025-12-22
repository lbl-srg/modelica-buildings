within Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses;
block CaseTemperature "Block to compute the case temperature"
  extends Modelica.Blocks.Icons.Block;

  constant Real delta = 1E-4 "Small value for regularization";

  parameter Data.Generic_R_m_flow datRes
    "Case-to-inlet thermal resistance as a function of the mass flow rate"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal
    "Nominal volume flow rate for one racks" annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput V_flow(
     final unit="m3/s")
     "Volume flow rate" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.Blocks.Interfaces.RealInput TIn(
     final unit="K",
     displayUnit="degC") "Fluid inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow(
    final unit="W")
    "Heat flow rate" annotation (Placement(transformation(extent={{-140,-80},{-100,
            -40}}), iconTransformation(extent={{-120,-70},{-100,-50}})));

  Modelica.Blocks.Interfaces.RealOutput dT(
    final unit="K") "Temperature rise (case to inlet)"
                                       annotation (Placement(transformation(
          extent={{100,30},{120,50}}),  iconTransformation(extent={{100,-10},{120,
            10}})));

  Modelica.Blocks.Interfaces.RealOutput TCas(
    final unit="K",
    displayUnit="degC") "Case temperature"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Units.SI.ThermalResistance R
    "Case-to-inlet thermal resistance";
  final parameter Real relErrR[:] = {RFit[i] / datRes.R[i] for i in 1:nSup}
    "Relative error of resistance based on data fit at each support point datRes.V_flow";
protected
  final parameter Integer nSup = size(datRes.V_flow,1)
    "Number of support points";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_small = delta * V_flow_nominal
    "Nominal volume flow rate for one rack" annotation (Dialog(group="Nominal condition"));
  parameter Real RV[nSup](each min=0) =
    {datRes.R[i]*datRes.V_flow[i] for i in 1:nSup}
    "Resistance multipled by volume flow rate";
  final parameter Real p[:] = Modelica.Math.Polynomials.fitting(
    u = datRes.V_flow,
    y = RV,
    n = datRes.n)
    "Polynomial coefficients";
  final parameter Modelica.Units.SI.ThermalResistance RFit[nSup] =
    {Modelica.Math.Polynomials.evaluateWithRange(
      p=p,
      uMin=datRes.V_flow[1],
      uMax=datRes.V_flow[end],
      u = datRes.V_flow[i]) /
      Buildings.Utilities.Math.Functions.smoothMax(
        x1=datRes.V_flow[i],
        x2=V_flow_small,
        deltaX=delta/4) for i in 1:nSup}
     "Resistance based on data fit (used to show error)";

equation
  R = Modelica.Math.Polynomials.evaluateWithRange(
    p=p,
    uMin=datRes.V_flow[1],
    uMax=datRes.V_flow[end],
    u = V_flow) /
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=V_flow,
      x2=V_flow_small,
      deltaX=delta/4);
  dT = R * Q_flow;
  TCas = TIn + dT;

  annotation (
  defaultComponentName="casTemp",
  Documentation(info="<html>
<p>
This block computes the case temperature for use in
<a href=\"modelica://Buildings.Applications.DataCenters.LiquidCooled.Racks.ColdPlateR_P\">
Buildings.Applications.DataCenters.LiquidCooled.Racks.ColdPlateR_P</a>.
</p>
<p>
The relative error of the data fit of the thermal resistance <i>R</i>
can be seen in the parameter <code>relErrR</code>.
</p>
</html>"));
end CaseTemperature;
