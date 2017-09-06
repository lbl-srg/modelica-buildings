within Buildings.Applications.DataCenters.AHUs.BaseClasses;
model ReheatControl "Electric heater on/off controller"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Real yValLow(min=0, max=1, unit="1")
    "If yVal<=yValLow, hysVal.y switches to false";
  parameter Real yValHig(min=0, max=1, unit="1")
    "If yVal>=yValHig, hysVal.y switches to true";
  parameter Modelica.SIunits.TemperatureDifference dTLow
    "If dT<=dTLow, hysTemDif.y switches to false";
  parameter Modelica.SIunits.TemperatureDifference dTHig
    "If dT>=dTHig, hysTemDif.y switches to true";
  parameter Boolean pre_yVal_start=true "Previous value of hysVal.y used at initialization"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean pre_dT_start=true "Previous value of hysTemDif.y used at initialization"
    annotation (Dialog(tab="Initialization"));

  Modelica.Blocks.Interfaces.RealInput yVal(
    min=0,
    max=1,
    unit="1") "Valve position"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
                iconTransformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput dT "Temperature difference"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
               iconTransformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Hysteresis hysVal(
    final pre_y_start=pre_yVal_start,
    final uLow=yValLow,
    final uHigh=yValHig)
    "Hysteresis for water-side valve position"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Hysteresis hysTemDif(
    final pre_y_start=pre_dT_start,
    final uLow=dTLow,
    final uHigh=dTHig)
    "Hysteresis for temperature difference"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Logical.Nor nor
    "Not or"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(hysVal.u, yVal)
    annotation (Line(points={{-42,50},{-42,50},{-120,50}}, color={0,0,127}));
  connect(dT, hysTemDif.u)
    annotation (Line(points={{-120,-50},{-42,-50}}, color={0,0,127}));
  connect(hysVal.y, nor.u1)
    annotation (Line(points={{-19,50},{20,50},{20,0},{38,0}}, color={255,0,255}));
  connect(hysTemDif.y, nor.u2)
    annotation (Line(points={{-19,-50},{20,-50},{20,-8},{38,-8}}, color={255,0,255}));
  connect(nor.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
          Line(points={{-61,65},{-61,-83}},color={192,192,192}),
          Line(points={{-86,-72},{86,-72}}, color={192,192,192}),
        Line(points={{-76,-72},{34,-72}},
            thickness=0.5),Line(
            points={{-46,8},{84,8}},
            thickness=0.5),Line(
            points={{-46,8},{-46,-72}},
            thickness=0.5),Line(
            points={{34,8},{34,-72}},
            thickness=0.5),Line(
            points={{-6,-67},{4,-72},{-6,-77}},
            thickness=0.5),Line(
            points={{-6,13},{-16,8},{-6,3}},
            thickness=0.5),Line(
            points={{-51,-22},{-46,-32},{-40,-22}},
            thickness=0.5),Line(
            points={{29,-32},{34,-21},{39,-32}},
            thickness=0.5),Text(
            extent={{-95,0},{-66,16}},
            lineColor={160,160,164},
            textString="true"),
        Text(extent={{23,-89},{48,-72}},
            lineColor={0,0,0},
            textString="uHigh"),
        Line(points={{-65,8},{-56,8}},
            color={160,160,164}),
        Text(extent={{-94,-89},{-62,-75}},
            lineColor={160,160,164},
            textString="false"),
        Polygon(points={{94,-72},{72,-64},{72,-80},{94,-72}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
        Polygon(points={{-61,87},{-69,65},{-53,65},{-61,87}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid)}),
        Diagram(
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
