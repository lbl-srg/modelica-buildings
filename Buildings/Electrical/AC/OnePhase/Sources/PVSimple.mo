within Buildings.Electrical.AC.OnePhase.Sources;
model PVSimple "Simple PV model"
  import Buildings;
  extends Buildings.Electrical.Interfaces.PartialAcDcParameters;
  extends Buildings.Electrical.Interfaces.PartialPV(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_p terminal,
    V_nominal = 120);
  parameter Boolean linearized=false
    "If =true, introduce a linearization in the load";
protected
  Modelica.Blocks.Math.Gain gain_DCAC(final k=eta_DCAC) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={12,0})));

  // fixme: why is this replaceable? Is this really needed for a protected instance?
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Capacitive load(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    final pf=pf,
    final V_nominal=V_nominal,
    final P_nominal=0,
    final linearized=linearized)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(load.terminal, terminal) annotation (Line(
      points={{-40,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(solarPower.y, gain_DCAC.u) annotation (Line(
      points={{70,0},{24,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain_DCAC.y, load.Pow) annotation (Line(
      points={{1,0},{-20,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
defaultComponentName="pv",
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
Documentation(info="<html>
<p>
Model of a simple photovoltaic array.
</p>
<p>
The electrical connector is an AC interface.
</p>
<p>
This model computes the active power as
<p align=\"center\" style=\"font-style:italic;\">
P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G &nbsp; &eta;<sub>DCAC</sub>,
</p>
<p>
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency,
<i>G</i> is the total solar irradiation, which is the
sum of direct and diffuse irradiation, and
<i>&eta;<sub>DCAC</sub></i> is the efficiency of the conversion 
between DC and AC.
</p>
<p>
This active power is equal to <i>P</i>, 
while the reactive power is equal to <i>Q = P &nbsp; tan(acos(pf)) </i>
where <i>pf</i> is the power factor.
</p>
<p>
<b>Note:</b> This model takes as input the total solar irradiation on the panel. 
This has to be computed converting the incoming radiation to take tilt and azimuth into account.
For a model that implements this conversion, use
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented</a>.
</p>
</html>", revisions="<html>
<li>
September 4, 2014, by Michael Wetter:<br/>
Revised model.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</html>"));
end PVSimple;
