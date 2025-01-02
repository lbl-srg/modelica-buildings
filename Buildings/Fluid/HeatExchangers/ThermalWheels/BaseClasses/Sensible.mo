within Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses;
model Sensible "Sensible heat wheels"
  extends Modelica.Blocks.Icons.Block;

  final parameter Real xSpe[:] = if per.useDefaultMotorEfficiencyCurve
    then per.motorEfficiency_default.y else per.motorEfficiency.uSpe
    "x-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  final parameter Real[size(xSpe,1)] yeta = if per.useDefaultMotorEfficiencyCurve
    then per.motorEfficiency_default.eta else per.motorEfficiency.eta
    "y-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  parameter Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Generic per
    "Record with performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput epsSenCor(final unit="1")
    "Sensible heat exchanger effectiveness correction"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer nSpe = size(yeta,1)
    "Number of the points in the power efficiency curve";
  parameter Real s = max(xSpe[i]/yeta[i] for i in 1:size(yeta,1)-1)
    "Maximum ratio of x-axis to y-axis in the power efficiency curve";


initial equation
  assert(s < 1 + 1E-4,
         "In " + getInstanceName() + ": The motor efficiency curve is wrong.
         The ratio of the speed ratio to the motor percent 
         full-load efficiency must be less than 1.",
         level=AssertionLevel.error)
         "Check if the motor efficiency curve is correct";
  assert(abs(yeta[nSpe]-1) < 1E-4,
          "In " + getInstanceName() + ": The motor efficiency curve is wrong.
          The motor percent full-load efficiency at the full seepd must be 1.",
          level=AssertionLevel.error)
          "Check if the motor efficiency curve is consistent with the nominal condition";
equation
  P = per.P_nominal*uSpe/Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=uSpe,
        xSup=xSpe,
        ySup=yeta)
        "Calculate the wheel power consumption";
  epsSenCor = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=uSpe,
                xSup=per.senHeatExchangeEffectiveness.uSpe,
                ySup=per.senHeatExchangeEffectiveness.epsCor)
                "Calculate the sensible heat exchanger effectiveness correction";
   annotation (
   defaultComponentName="senWhe",
   Documentation(info="<html>
<p>
This model calculates the power consumption and the sensible heat exchanger 
effectiveness correction of a sensible heat wheel.
</p>
<ul>
<li>
The power consumption of this wheel is calculated as
<p align=\"center\" style=\"font-style:italic;\">
P = P_nominal * uSpe / eta,
</p>
<p>
where <code>P_nominal</code> is the nominal wheel power consumption,
<code>uSpe</code> is the wheel speed ratio, 
and <code>eta</code> is the motor percent full-load efficiency, 
which is calculated as
<p align=\"center\" style=\"font-style:italic;\">
eta = eff(uSpe=x) / eff(uSpe=1),
</p>
<p>
where <code>eff(uSpe=x)</code> is the motor efficiency when the speed ratio is <code>x</code>.
The efficiency <code>eta</code> is obtained based on the cubic hermite spline interpolation of
the motor percent full-load efficiency dataset (see 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.MotorEfficiency\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.MotorEfficiency</a>).
Please note that <code>uSpe/eta</code> must be less or equal to 1.
</p>
</li>
<li>
The sensible heat exchanger effectiveness correction is calculated based 
on the cubic hermite spline interpolation of the sensible heat exchanger effectiveness 
dataset (see <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness</a>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Sensible;
