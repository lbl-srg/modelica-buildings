within Buildings.Controls.SetPoints;
block HotWaterTemperatureReset
  "Block to compute the supply and return set point of heating systems"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real m = 1.3 "Exponent for heat transfer";
  parameter Modelica.SIunits.Temperature TSup_nominal "Supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TRet_nominal "Return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TRoo_nominal = 293.15
    "Room temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TOut_nominal "Outside temperature"
    annotation (Dialog(group="Nominal conditions"));

  parameter Boolean use_TRoo_in = false
    "Get the room temperature set point from the input connector"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Modelica.SIunits.Temperature TRoo = 293.15
    "Fixed value of room air temperature set point"
    annotation (Evaluate = true,
                Dialog(enable = not use_TRoo_in));
  parameter Modelica.SIunits.TemperatureDifference dTOutHeaBal = 8
    "Offset for heating curve";
  Modelica.Blocks.Interfaces.RealInput TRoo_in(final quantity="ThermodynamicTemperature",
                                               final unit = "K", displayUnit = "degC", min=0) if
          use_TRoo_in "Room air temperature set point"
    annotation (Placement(transformation(extent={{-139,-80},{-99,-40}},
          rotation=0)));

  Modelica.Blocks.Interfaces.RealInput TOut(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=0)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput TSup(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=0)
    "Setpoint for supply temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput TRet(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=0)
    "Setpoint for return temperature"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  Modelica.Blocks.Interfaces.RealInput TRoo_in_internal(final quantity="Temperature",
                                                        final unit = "K", displayUnit = "degC", min=0)
    "Needed to connect to conditional connector";
  Real qRel "Relative heat load = Q_flow/Q_flow_nominal";
  Modelica.SIunits.Temperature TOutOffSet
    "Effective outside temperature for heat transfer (takes into account room heat gains)";
  parameter Modelica.SIunits.Temperature TOutOffSet_nominal =  TOut_nominal + dTOutHeaBal
    "Effective outside temperature for heat transfer at nominal conditions (takes into account room heat gains)";

equation
  connect(TRoo_in, TRoo_in_internal);
  if not use_TRoo_in then
    TRoo_in_internal = TRoo;
  end if;
 TOutOffSet = TOut + dTOutHeaBal;
 // Relative heating load, compared to nominal conditions
 qRel = max(0, (TRoo_in_internal-TOutOffSet)/(TRoo_nominal-TOutOffSet_nominal));
 TSup = TRoo_in_internal
          + ((TSup_nominal+TRet_nominal)/2-TRoo_in_internal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;
 TRet = TSup - qRel * (TSup_nominal-TRet_nominal);
  annotation (Documentation(info="<html>
This block computes the set point temperatures for the
supply and return temperature of a heating system.
The set point for the room air temperature can either be specified
by a parameter, or it can be an input to the model. The latter allows
to use this model with systems that have night set back.
</p>
<p>
The parameter <tt>dTOutHeaBal</tt> can be used to shift the heating curve to account
for the fact that solar heat gains and heat gains from equipment and people 
make up for some of the transmission losses. 
For example, in energy efficient houses, the heating may not be switched on above 
12 degree Celsius, even if a room temperature of 20 degree is required.
In such a situation, set <tt>dTOutHeaBal=20-12=8</tt> Kelvin to 
shift the heating curve.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
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
          points={{-80,-82},{60,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-80,-82},{-42,-38},{4,2},{60,32}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-80,-82},{-58,-42},{-4,8},{60,32}},
          color={0,0,0},
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
          textString="TRet")}),
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics));
end HotWaterTemperatureReset;
