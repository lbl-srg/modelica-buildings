within Buildings.HeatTransfer.Convection;
model Interior "Model for a interior (room-side) convective heat transfer"
  extends Buildings.HeatTransfer.Convection.BaseClasses.PartialConvection;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Buildings.HeatTransfer.Types.InteriorConvection conMod=
    Buildings.HeatTransfer.Types.InteriorConvection.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient" annotation (Dialog(enable=(conMod ==
          Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));

  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt"
    annotation (Dialog(enable=(conMod <> Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));

protected
  constant Modelica.Units.SI.Temperature dT0=2
    "Initial temperature used in homotopy method";

  final parameter Real cosTil=Modelica.Math.cos(til) "Cosine of window tilt";
  final parameter Real sinTil=Modelica.Math.sin(til) "Sine of window tilt";
  final parameter Boolean is_ceiling = abs(sinTil) < 10E-10 and cosTil > 0
    "Flag, true if the surface is a ceiling";
  final parameter Boolean is_floor = abs(sinTil) < 10E-10 and cosTil < 0
    "Flag, true if the surface is a floor";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  if (conMod == Buildings.HeatTransfer.Types.InteriorConvection.Fixed) then
    q_flow = hFixed * dT;
  else
    // Even if hCon is a step function with a step at zero,
    // the product hCon*dT is differentiable at zero with
    // a continuous first derivative
    if homotopyInitialization then
      if is_ceiling then
         q_flow = homotopy(actual=Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling(dT=dT),
                    simplified=dT/dT0*Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling(dT=dT0));
      elseif is_floor then
         q_flow = homotopy(actual=Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor(dT=dT),
                    simplified=dT/dT0*Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor(dT=dT0));
      else
         q_flow = homotopy(actual=Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall(dT=dT),
                    simplified=dT/dT0*Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall(dT=dT0));
      end if;
    else
      if is_ceiling then
         q_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling(dT=dT);
      elseif is_floor then
         q_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor(dT=dT);
      else
         q_flow = Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall(dT=dT);
      end if;
    end if;

  end if;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-35,42},{-5,20}},
          textColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}),
    defaultComponentName="con",
    Documentation(info="<html>
<p>
This is a model for a convective heat transfer for interior, room-facing surfaces.
The parameter <code>conMod</code> determines the model that is used to compute
the heat transfer coefficient:
</p>
<ul>
<li>If <code>conMod=<a href=\"modelica://Buildings.HeatTransfer.Types.InteriorConvection\">
Buildings.HeatTransfer.Types.InteriorConvection.Fixed</a></code>, then
the convective heat transfer coefficient is set to the value specified by the parameter
<code>hFixed</code>.
</li>
<li>
If <code>conMod=<a href=\"modelica://Buildings.HeatTransfer.Types.InteriorConvection\">
Buildings.HeatTransfer.Types.InteriorConvection.Temperature</a></code>, then
the convective heat tranfer coefficient is a function of the temperature difference.
The convective heat flux is computed using
<ul>
<li>
for floors the function
<a href=\"modelica://Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor\">
Buildings.HeatTransfer.Convection.Functions.HeatFlux.floor</a>
</li>
<li>
for ceilings the function
<a href=\"modelica://Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling\">
Buildings.HeatTransfer.Convection.Functions.HeatFlux.ceiling</a>
</li>
<li>
for walls the function
<a href=\"modelica://Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall\">
Buildings.HeatTransfer.Convection.Functions.HeatFlux.wall</a>
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Michael Wetter:<br/>
Change parameter <code>isFloor</code> to <code>is_floor</code>,
and <code>isCeiling</code> to <code>is_ceiling</code>,
for consistency with naming convention.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Refactored model as part of enabling the pedantic model check in Dymola 2017 FD01 beta 2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 10 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Interior;
