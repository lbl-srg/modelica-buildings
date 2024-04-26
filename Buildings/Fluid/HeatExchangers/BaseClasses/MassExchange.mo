within Buildings.Fluid.HeatExchangers.BaseClasses;
model MassExchange
  "Block to compute the latent heat transfer based on the Lewis number"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium model"
      annotation (choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput XInf "Water mass fraction of medium"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TSur(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=0)
    "Surface temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(final unit = "kg/s")
    "Water flow rate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput Gc
    "Signal representing the convective (sensible) thermal conductance in [W/K]"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  parameter Real Le = 1 "Lewis number (around 1 for water vapor in air)";
  parameter Real n = 1/3
    "Exponent in bondary layer ratio, delta/delta_t = Pr^n";
public
  Buildings.Utilities.Psychrometrics.X_pW humRatPre(use_p_in=false)
    "Model to convert water vapor pressure into humidity ratio"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Utilities.Psychrometrics.pW_TDewPoi TDewPoi
    "Model to compute the water vapor pressure at the dew point"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Gain gain(k=1/cpLe_default)
    "Constant to convert from heat transfer to mass transfer"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Product mWat "Water flow rate"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Math.Min min annotation (Placement(transformation(extent={{20,
            -60},{40,-40}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Constant for zero"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.Add delX(k2=-1, k1=1) "Humidity difference"
    annotation (Placement(transformation(extent={{-40,-66},{-20,-46}})));
protected
 parameter Medium.ThermodynamicState sta_default = Medium.setState_phX(h=Medium.h_default,
       p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity";
 parameter Real cpLe_default(unit="J/(kg.K)") = cp_default * Le^(1-n);
equation
  connect(TSur, TDewPoi.T) annotation (Line(points={{-120,80},{-80,80},{-80,50},
          {-61,50}}, color={0,0,127}));
  connect(TDewPoi.p_w, humRatPre.p_w) annotation (Line(points={{-39,50},{-20,50},
          {-20,10},{-1,10}},color={0,0,255}));
  connect(Gc, gain.u) annotation (Line(points={{-120,-80},{-82,-80}}, color={0,
          0,127}));
  connect(gain.y, mWat.u2) annotation (Line(points={{-59,-80},{0,-80},{0,-76},{
          58,-76}}, color={0,0,127}));
  connect(mWat.y, mWat_flow) annotation (Line(points={{81,-70},{90,-70},{90,0},
          {110,0}},  color={0,0,127}));
  connect(zero.y,min. u1) annotation (Line(points={{1,-30},{10,-30},{10,-44},{
          18,-44}}, color={0,0,127}));
  connect(delX.u2,XInf)  annotation (Line(points={{-42,-62},{-80,-62},{-80,
          1.11022e-15},{-120,1.11022e-15}},   color={0,0,127}));
  connect(humRatPre.X_w, delX.u1) annotation (Line(points={{21,10},{28,10},{28,
          -8},{-60,-8},{-60,-50},{-42,-50}},
                           color={0,0,255}));
  connect(delX.y, min.u2)
    annotation (Line(points={{-19,-56},{18,-56}}, color={0,0,127}));
  connect(min.y, mWat.u1) annotation (Line(points={{41,-50},{48,-50},{48,-64},{
          58,-64}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,96},{-48,54}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TSur"),
        Text(
          extent={{-96,22},{-48,-26}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="XMed"),
        Text(
          extent={{-90,-66},{-58,-98}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Gc"),
        Text(
          extent={{54,10},{94,-6}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{72,12},{76,8}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-30,66},{-36,46},{-38,32},{-36,26},{-30,22},{-20,22},{-12,28},
              {-10,36},{-14,52},{-24,84},{-30,66}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,26},{4,6},{2,-8},{4,-14},{10,-18},{20,-18},{28,-12},{30,-4},
              {26,12},{16,44},{10,26}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-38,-18},{-44,-38},{-46,-52},{-44,-58},{-38,-62},{-28,-62},{
              -20,-56},{-18,-48},{-22,-32},{-32,0},{-38,-18}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{14,-46},{8,-66},{6,-80},{8,-86},{14,-90},{24,-90},{32,-84},{
              34,-76},{30,-60},{20,-28},{14,-46}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,100},{32,80},{30,66},{32,60},{38,56},{48,56},{56,62},{58,
              70},{54,86},{50,100},{38,100}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model computes the mass transfer based on similarity laws between
the convective sensible heat transfer coefficient and the mass transfer coefficient.
</p>
<p>
Using the Lewis number which is defined as the ratio between the heat and mass
diffusion coefficients, one can obtain the ratio between convection
heat transfer coefficient <i>h</i> in (W/(m^2*K)) and
mass transfer coefficient <i>h<sub>m</sub></i> in (m/s) as follows:
</p>
<p align=\"center\" style=\"font-style:italic;\">
  h &frasl; h<sub>m</sub> = &rho;  c<sub>p</sub>  Le<sup>(1-n)</sup> &frasl;
 h<sub>m</sub>
</p>
<p>
where <i>&rho;</i> is the mass density,
<i>c<sub>p</sub></i> is the specific heat capacity
of the bulk medium and <i>n</i> is a coefficient from the boundary layer analysis, which
is typically <i>n=1/3</i>.
From this equation, we can compute the water vapor mass flow rate
<i>n<sub>A</sub></i> in (kg/s) as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  n<sub>A</sub> = G<sub>c</sub> &frasl; (c<sub>p</sub> Le<sup>(1-n)</sup>)
  (X<sub>s</sub> - X<sub>&#8734;</sub>),
</p>
<p>
where <i>G<sub>c</sub></i> is the sensible heat conductivity in (W/K) and
<i>X<sub>s</sub></i> and
<i>X<sub>&#8734;</sub></i> are the water vapor mass per unit volume
in the boundary layer and in the
bulk of the medium. In this model,
<i>X<sub>s</sub></i> is the saturation water vapor pressure
corresponding to the temperature <i>T<sub>sur</sub></i> which is an input.
</p>
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions and fixed error in the documentation.
</li>
<li>
August 13, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassExchange;
