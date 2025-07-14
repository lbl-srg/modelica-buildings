within Buildings.Fluid.HeatExchangers.ThermalWheels.BaseClasses;
model SpeedCorrectionSensible "Sensible heat wheels"
  extends Modelica.Blocks.Icons.Block;

  final parameter Real xSpe[:] = if per.use_defaultMotorEfficiencyCurve
    then per.relMotEff_default.y else per.relMotEff.uSpe
    "x-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  final parameter Real[size(xSpe,1)] yEta = if per.use_defaultMotorEfficiencyCurve
    then per.relMotEff_default.eta else per.relMotEff.eta
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
  parameter Integer nSpe = size(yEta,1)
    "Number of the points in the power efficiency curve";
  parameter Real s = max(xSpe[i]/yEta[i] for i in 1:size(yEta,1)-1)
    "Maximum ratio of x-axis to y-axis in the power efficiency curve";

  parameter Real[nSpe] dP(each fixed=false, each final unit="W")
    "Derivatives at the support points for electric power consumption";
  parameter Real[size(per.senEff.uSpe, 1)] dEpsSenCor(each fixed=false, each final unit="1")
    "Derivatives at the support points for sensible heat exchanger effectiveness correction";

initial equation
  assert(s < 1 + 1E-4,
         "In " + getInstanceName() + ": The motor efficiency curve is wrong.
         The ratio of the speed ratio to the motor percent
         full-load efficiency must be less than 1.",
         level=AssertionLevel.error)
         "Check if the motor efficiency curve is correct";
  assert(abs(yEta[nSpe]-1) < 1E-4,
          "In " + getInstanceName() + ": The motor efficiency curve is wrong.
          The motor percent full-load efficiency at the full seepd must be 1.",
          level=AssertionLevel.error)
          "Check if the motor efficiency curve is consistent with the nominal condition";

  dP = Buildings.Utilities.Math.Functions.splineDerivatives(
    x=xSpe,
    y=yEta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(yEta, strict=false));
  dEpsSenCor = Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.senEff.uSpe,
    y=per.senEff.epsCor,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(per.senEff.epsCor, strict=false));
equation
  P = per.P_nominal*uSpe/Buildings.Utilities.Math.Functions.interpolate(
        u=uSpe,
        xd=xSpe,
        yd=yEta,
        d=dP)
        "Calculate the wheel power consumption";
  epsSenCor = Buildings.Utilities.Math.Functions.interpolate(
                u=uSpe,
                xd=per.senEff.uSpe,
                yd=per.senEff.epsCor,
                d=dEpsSenCor)
                "Calculate the sensible heat exchanger effectiveness correction";
   annotation (
   defaultComponentName="speCor",
   Documentation(info="<html>
<p>
This model calculates the power consumption and the sensible heat exchanger
effectiveness correction of a sensible heat wheel
when it is in the different rotational speed.
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
The efficiency <code>eta</code> is obtained based on a cubic hermite spline interpolation of
the motor percent full-load efficiency dataset (see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.MotorEfficiency\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.MotorEfficiency</a>).
Please note that <code>uSpe/eta</code> must be less or equal to 1.
</p>
</li>
<li>
The sensible heat exchanger effectiveness correction is calculated based
on a cubic hermite spline interpolation of the sensible heat exchanger effectiveness
dataset (see <a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Data.Characteristics.HeatExchangerEffectiveness</a>).
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 9, 2025, by Michael Wetter:<br/>
Refactored implementation to avoid repetitive calculation of derivatives for spline interpolation.
</li>
<li>
May 28, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(extent={{-42,64},{52,-58}}, lineColor={28,108,200},
          lineThickness=0.5),
        Line(points={{-26,50},{10,86},{-2,78},{10,86}}, color={28,108,200},
          thickness=0.5),
        Line(points={{10,86},{4,74}}, color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-38,96},{-8,56}},
          textColor={0,0,88},
          textString="u")}));
end SpeedCorrectionSensible;
