within Buildings.Fluid.BaseClasses.VariableSpeedWheel;
model Sensible "Sensible heat wheels"
  extends Modelica.Blocks.Icons.Block;
  import whe = Buildings.Fluid.BaseClasses.VariableSpeedWheel;
  final parameter Real xSpe[:] = if per.useDefaultMotorEfficiencyCurve
    then per.motorEfficiency_default.y else per.motorEfficiency_uSpe.y
    "x-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  final parameter Real[size(xSpe,1)] yeta = if per.useDefaultMotorEfficiencyCurve
    then per.motorEfficiency_default.eta else per.motorEfficiency_uSpe.eta
    "y-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  parameter whe.BaseClasses.Data.Generic per
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
    "Sensible heat exchanger effectiveness correction" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

initial equation
  for i in 1:size(yeta,1)-1 loop
         assert(xSpe[i]/yeta[i]<1 + 1E-4,
                  "In " + getInstanceName() + ": motor efficiency curve is wrong. 
                  The ratio of the speed ratio of the motor efficiency
                  to the motor percent full-load efficiency should be less than
                  1",
                  level=AssertionLevel.error)
                  "Check if the motor efficiency curve is correct";
  end for;
  assert(abs(yeta[size(yeta,1)]-1) < 1E-4 and abs(yeta[size(yeta,1)]-1) < 1E-4,
          "In " + getInstanceName() + ": motor efficiency curve is wrong. 
          The ratio of the speed ratio of the motor efficiency
          to the motor percent full-load efficiency should be less than
          1",
          level=AssertionLevel.error)
          "Check if the motor efficiency curve is correct";
equation
  P = per.P_nominal*uSpe/Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=uSpe,
        xSup=xSpe,
        ySup=yeta);
  epsSenCor = Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=uSpe,
                xSup=per.senHeatExchangeEffectiveness.uSpe,
                ySup=per.senHeatExchangeEffectiveness.epsCor);
   annotation (
   defaultComponentName="senWhe",
   Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the power consumption and the sensible heat exchanger 
effectiveness correction of a sensible heat wheel.
Specifically, this calculation is configured as follows.
</p>
<ul>
<li>
The power consumption of this wheel is calculated by
<p align=\"center\" style=\"font-style:italic;\">
P = P_nominal * uSpe / eta,
</p>
<p>
where <code>P_nominal</code> is the nominal wheel power consumption,
<code>uSpe</code> is the wheel speed ratio.
The <code>eta</code> is the motor percent full-load efficiency, i.e.,
the ratio of the motor efficiency to that when the <code>uSpe</code> is <i>1</i>.
The <code>eta</code> is obtained based on the cubic hermite spline interpolation of
the motor percent full-load efficiency dataset.
Please note that <code>uSpe/eta</code> should be less or equal to 1.
</p>
</li>
<li>
The sensible heat exchanger effectiveness correction is calculated based 
on the cubic hermite spline interpolation of the sensible heat exchanger effectiveness 
dataset.
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
