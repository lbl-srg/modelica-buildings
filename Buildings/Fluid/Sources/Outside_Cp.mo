within Buildings.Fluid.Sources;
model Outside_Cp
  "Boundary that takes weather data, and optionally the wind pressure coefficient and trace substances, as an input"
  extends Buildings.Fluid.Sources.BaseClasses.Outside;

  parameter Boolean use_Cp_in= false
    "Get the wind pressure coefficient from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Real Cp = 0.6 "Fixed value of wind pressure coefficient"
    annotation (Dialog(enable = not use_Cp_in));

  Modelica.Blocks.Interfaces.RealInput Cp_in(unit="1")
  if use_Cp_in "Prescribed wind pressure coefficient"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Units.SI.Pressure pWin(displayUnit="Pa")
    "Change in pressure due to wind force";

protected
  Modelica.Blocks.Interfaces.RealInput Cp_in_internal(unit="1")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput pWea(min=0, nominal=1E5, unit="Pa")
    "Pressure from weather bus";
  Modelica.Blocks.Interfaces.RealInput vWin(unit="m/s")
    "Wind speed from weather bus";
  Modelica.Blocks.Interfaces.RealOutput pTot(min=0, nominal=1E5, unit="Pa")
    "Sum of atmospheric pressure and wind pressure";
equation
  connect(Cp_in, Cp_in_internal);
  if not use_Cp_in then
    Cp_in_internal = Cp;
  end if;
  pWin = 0.5*Cp_in_internal*vWin*vWin
    *Medium.density(Medium.setState_pTX(
      p=pWea,
      T=T_in_internal,
      X=Medium.X_default));
  pTot = pWea + pWin;

  connect(weaBus.winSpe, vWin);
  connect(weaBus.pAtm, pWea);
  connect(p_in_internal, pTot);
  connect(weaBus.TDryBul, T_in_internal);
  annotation (defaultComponentName="out",
    Documentation(info="<html>
<p>
This model describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained
from weather data. The model is identical to
<a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>,
except that it allows adding the wind pressure to the
pressure at the fluid port <code>ports</code>.
</p>
<p>
The pressure <i>p</i> at the port <code>ports</code> is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  p = p<sub>w</sub> + C<sub>p</sub> 1 &frasl; 2 v<sup>2</sup> &rho;
</p>
<p>
where
<i>p<sub>w</sub></i> is the atmospheric pressure from the weather bus,
<i>C<sub>p</sub></i> is the wind pressure coefficient,
<i>v</i> is the wind speed from the weather bus, and
<i>&rho;</i> is the fluid density.
If <code>use_Cp_in=true</code>, then the
wind pressure coefficient is obtained from the input connector
<code>Cp_in</code>. Otherwise, it is set to the parameter
<code>Cp</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2019, by Michael Wetter:<br/>
Changed model to use new base class.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 26, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          visible=use_Cp_in,
          extent={{-140,92},{-92,62}},
          textColor={0,0,255},
          textString="C_p"),
          Text(
          visible=use_C_in,
          extent={{-154,-28},{-102,-62}},
          textColor={0,0,255},
          textString="C"),
        Text(
          extent={{-28,22},{28,-22}},
          textColor={255,255,255},
          textString="Cp")}));
end Outside_Cp;
