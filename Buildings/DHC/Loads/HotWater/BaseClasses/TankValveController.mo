within Buildings.DHC.Loads.HotWater.BaseClasses;
block TankValveController
  "Controller to divert the water to the middle or bottom of the tank"

  parameter Modelica.Units.SI.Temperature TSwi = 318.15 "Switching temperature for return water";

  Modelica.Blocks.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
    "Return water temperature" annotation (Placement(transformation(extent={{-140,
            -20},{-100,20}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Valve position" annotation (
      Placement(transformation(extent={{100,-20},{140,20}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Modelica.Blocks.Continuous.LimIntegrator ram(
    k=1/120,
    outMax=1,
    outMin=0,
    strict=false)
                 "Ramp signal for valve position"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis cha(uLow=TSwi - 1, uHigh=TSwi + 1)
    "Outputs true if tank should be charged"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(cha.y, booToRea.u)
    annotation (Line(points={{-38,0},{-2,0}},  color={255,0,255}));
  connect(booToRea.y, ram.u)
    annotation (Line(points={{22,0},{38,0}}, color={0,0,127}));
  connect(ram.y, y) annotation (Line(points={{61,0},{120,0}}, color={0,0,127}));
  connect(cha.u, TRet)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="conVal",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-90,18},{-40,-18}},
          textColor={0,0,127},
          textString="TRet"),
        Text(
          extent={{52,22},{102,-14}},
          textColor={0,0,127},
          textString="y")}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 4, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Controller that outputs the commanded position for the valve that diverts the return
water to the middle or bottom of the tank.
</p>
<p>
The controller changes its commanded valve position continuously between <i>0</i> and <i>1</i>.
If the measured temperature <code>TRet</code> is below <code>TSwi</code>, the output is
<i>0</i>, otherwise it is <i>1</i>. The controller has a hysteresis of <i>2</i> Kelvin.
</p>
</html>"));
end TankValveController;
