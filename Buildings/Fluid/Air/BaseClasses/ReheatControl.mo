within Buildings.Fluid.Air.BaseClasses;
model ReheatControl "Electric heater on/off controller"
  parameter Real y1Low(min=0, max=1, unit="1") "if y1=true and y1<=y1Low, switch to y1=false";
  parameter Real y1Hig(min=0, max=1, unit="1") "if y1=false and y1>=y1High, switch to y1=true";
  parameter Modelica.SIunits.TemperatureDifference y2Low(displayUnit="degC")
  "if y2=true and y2<=y2Low, switch to y2=false";
  parameter Modelica.SIunits.TemperatureDifference y2Hig(displayUnit="degC")
  "if y2=false and y2>=y2High, switch to y2=true";
  parameter Boolean pre_start1=true "Value of pre(y1) at initial time";
  parameter Boolean pre_start2=true "Value of pre(y2) at initial time";

  Modelica.Blocks.Interfaces.RealInput y1(min=0,max=1,unit="1")
  "Input signal 1"
   annotation (Placement(transformation(
          extent={{-140,30},{-100,70}}), iconTransformation(extent={{-140,30},{-100,
            70}})));
  Modelica.Blocks.Interfaces.RealInput y2
  "Input signal 2"
    annotation (Placement(transformation(
          extent={{-140,-70},{-100,-30}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Logical.Hysteresis hys1(
    final pre_y_start=pre_start1,
    final uLow=y1Low,
    final uHigh=y1Hig)
    "Hysteresis for signal 1"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Hysteresis hys2(
    final pre_y_start=pre_start2,
    final uLow=y2Low,
    final uHigh=y2Hig)
    "Hysteresis for signal 2"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Logical.Nor nor
  "Not or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(hys1.u, y1)
    annotation (Line(points={{-42,50},{-42,50},{-120,50}}, color={0,0,127}));
  connect(y2, hys2.u)
    annotation (Line(points={{-120,-50},{-42,-50}}, color={0,0,127}));
  connect(hys1.y, nor.u1) annotation (Line(points={{-19,50},{20,50},{20,0},{38,0}},
        color={255,0,255}));
  connect(hys2.y, nor.u2) annotation (Line(points={{-19,-50},{20,-50},{20,-8},{38,
          -8}}, color={255,0,255}));
  connect(nor.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
                                 Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model can be used to generate on/off signal for the reheater inside the AHU.</p>
<p>This reheater will be on only if the following two conditions are satisfied at the same time:</p>
<ul>
<li>the position of the water-side valve reaches its minimum value, that is <code>y_valve-yMinVal&lt;=0</code>;</li>
<li>the inlet temperature of reheater is still lower than required setpoint, that is <code>T_inflow_hea-TSet&lt;=0.</code></li>
</ul>
<p>And in the implementation, a hysteresis is used to avoid frequent switching.</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReheatControl;
