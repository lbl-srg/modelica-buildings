within Buildings.Controls.OBC.CDL.SetPoints;
block SupplyReturnTemperatureReset
  "Block to compute the supply and return set point"

  parameter Real m = 1.3 "Exponent for heat transfer";
  parameter Modelica.SIunits.Temperature TSup_nominal "Supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TRet_nominal "Return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TZon_nominal = 293.15 "Zone temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TOut_nominal "Outside temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.TemperatureDifference dTOutHeaBal(displayUnit="K") = 8
    "Offset for heating curve";

  Interfaces.RealInput TSetZon(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC", min=200) "Zone setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Outside temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealOutput TSup(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Interfaces.RealOutput TRet(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Setpoint for return temperature"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  parameter Modelica.SIunits.Temperature TOutOffSet_nominal =  TOut_nominal + dTOutHeaBal
    "Effective outside temperature for heat transfer at nominal conditions (takes into account zone heat gains)";
  Real qRel "Relative heating load = Q_flow/Q_flow_nominal";
  Modelica.SIunits.Temperature TOutOffSet
    "Effective outside temperature for heat transfer (takes into account zone heat gains)";

equation
  TOutOffSet = TOut + dTOutHeaBal;
  // Relative heating load, compared to nominal conditions
  qRel = max(0, (TSetZon-TOutOffSet)/(TZon_nominal-TOutOffSet_nominal));
  TSup = TSetZon
          + ((TSup_nominal+TRet_nominal)/2-TZon_nominal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;
  TRet = TSup - qRel * (TSup_nominal-TRet_nominal);

annotation (
  defaultComponentName="watRes",
  Documentation(info="<html>
<p>
This block computes the set point temperatures for the
supply and return water temperature.
The set point for the zone air temperature can be an input to the model.
It allows to use this model with systems that have night set back.
</p>
<p>
If used to reset the temperature in a heating system,
the parameter <code>dTOutHeaBal</code> can be used to shift the heating curve
to take into account that heat gains from solar, equipment and people
make up for some of the transmission losses.
For example, in energy efficient houses, the heating may not be switched on if
the outside air temperature is greater than
<i>12</i>&deg;C, even if a zone temperature of <i>20</i>&deg;C is required.
In such a situation, set <code>dTOutHeaBal=20-12=8</code> Kelvin to
shift the heating curve.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2020, by Jianjun Hu:<br/>
Changed name from <code>HotWaterTemperatureReset</code> to 
<code>SupplyReturnTemperatureReset</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">#860</a>.
</li>
<li>
January 10, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
February 13, 2013, by Michael Wetter:<br/>
Corrected error that led to wrong results if the zone air temperature is
different from its nominal value <code>TZon_nominal</code>.
See ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">#74</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
February 5, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-82},{68,-74},{68,-90},{90,-82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-82},{82,-82}}, color={192,192,192}),
        Line(points={{-80,76},{-80,-92}}, color={192,192,192}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,86},{-80,88}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-82},{60,32}}),
        Line(
          points={{-80,-82},{-42,-38},{4,2},{60,32}},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-82},{-58,-42},{-4,8},{60,32}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-152,120},{-102,70}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          visible=use_TRoo_in,
          extent={{-152,-4},{-102,-54}},
          lineColor={0,0,127},
          textString="TRoo"),
        Text(
          extent={{40,86},{90,36}},
          lineColor={0,0,127},
          textString="TSup"),
        Text(
          extent={{42,-30},{92,-80}},
          lineColor={0,0,127},
          textString="TRet"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}));
end SupplyReturnTemperatureReset;
