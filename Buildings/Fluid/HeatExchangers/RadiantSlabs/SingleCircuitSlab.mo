within Buildings.Fluid.HeatExchangers.RadiantSlabs;
model SingleCircuitSlab "Model of a single circuit of a radiant slab"
  extends Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Slab;
  extends Buildings.Fluid.FixedResistances.BaseClasses.Pipe(
     nSeg=if heatTransfer==Types.HeatTransfer.EpsilonNTU then 1 else 5,
     final diameter=pipe.dIn,
     length=A/disPip,
     final thicknessIns=0,
     final lambdaIns = 0.04,
     dp_nominal = Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=pipe.dIn,
      roughness=pipe.roughness,
      m_flow_small=m_flow_small),
      preDro(dp(nominal=200*length)));

  parameter Modelica.SIunits.Area A "Surface area of radiant slab"
    annotation(Dialog(group="Construction"));

  parameter Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer
    heatTransfer=Types.HeatTransfer.EpsilonNTU
    "Model for heat transfer between fluid and slab";
  parameter Modelica.SIunits.Temperature T_c_start=
    (T_a_start*con_b[1].layers.R+T_b_start*con_a[1].layers.R)/layers.R
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false"
    annotation(Dialog(tab="Initialization", group="Construction"));
  final parameter Modelica.SIunits.Velocity v_nominal=
    4*m_flow_nominal/pipe.dIn^2/Modelica.Constants.pi/rho_default
    "Velocity at m_flow_nominal";

  Buildings.HeatTransfer.Conduction.MultiLayer con_a[nSeg](
    each final A=A/nSeg,
    each final steadyStateInitial=steadyStateInitial,
    each layers(
      final nSta={layers.material[i].nSta for i in 1:1:iLayPip},
      final nLay = iLayPip,
      final material={layers.material[i] for i in 1:iLayPip},
      final absIR_a=layers.absIR_a,
      final absIR_b=layers.absIR_b,
      final absSol_a=layers.absSol_a,
      final absSol_b=layers.absSol_b,
      final roughness_a=layers.roughness_a),
    each T_a_start=T_a_start,
    each T_b_start=T_c_start,
    each stateAtSurface_a=stateAtSurface_a,
    each stateAtSurface_b=true)
    "Construction near the surface port surf_a"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,50})));

  Buildings.HeatTransfer.Conduction.MultiLayer con_b[nSeg](
      each final A=A/nSeg,
      each final steadyStateInitial=steadyStateInitial,
      each layers(
        final nSta={layers.material[i].nSta for i in iLayPip + 1:layers.nLay},
        final nLay = layers.nLay-iLayPip,
        final material={layers.material[i] for i in iLayPip + 1:layers.nLay},
        final absIR_a=layers.absIR_a,
        final absIR_b=layers.absIR_b,
        final absSol_a=layers.absSol_a,
        final absSol_b=layers.absSol_b,
        final roughness_a=layers.roughness_a),
      each T_a_start=T_c_start,
      each T_b_start=T_b_start,
    each stateAtSurface_a=false,
    each stateAtSurface_b=stateAtSurface_b)
    "Construction near the surface port surf_b"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-58})));

protected
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(
     final m=nSeg) "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        origin={40,-80})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne1(
     final m=nSeg) "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={40,76})));

  final parameter Modelica.SIunits.ThermalInsulance Rx=
      Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance(
        disPip=disPip,
        dPipOut=pipe.dOut,
        k=layers.material[iLayPip].k,
        sysTyp=sysTyp,
        kIns=layers.material[iLayPip+1].k,
        dIns=layers.material[iLayPip+1].x)
    "Thermal insulance for average temperature in plane with pipes";

  BaseClasses.PipeToSlabConductance fluSlaCon[nSeg](
    redeclare each final package Medium = Medium,
    each final APip=Modelica.Constants.pi*pipe.dIn*length/nSeg,
    each final RWal=Modelica.Math.log(pipe.dOut/pipe.dIn)/(2*Modelica.Constants.pi*pipe.k*(
        length/nSeg)),
    each final RFic=nSeg*Rx/A,
    each final  m_flow_nominal=m_flow_nominal,
    each kc_IN_con=
        Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(
        d_hyd=pipe.dIn,
        L=length/nSeg,
        K=pipe.roughness),
    each final heatTransfer=heatTransfer) "Conductance between fluid and the slab"
    annotation (Placement(transformation(extent={{-28,-80},{-8,-60}})));

  Modelica.SIunits.MassFraction Xi_in_a[Medium.nXi] = inStream(port_a.Xi_outflow)
    "Inflowing mass fraction at port_a";
  Modelica.SIunits.MassFraction Xi_in_b[Medium.nXi] = inStream(port_b.Xi_outflow)
    "Inflowing mass fraction at port_a";
  Modelica.Blocks.Sources.RealExpression T_a(
    final y=Medium.temperature_phX(p=port_a.p,
                                   h=inStream(port_a.h_outflow),
                                   X=cat(1,Xi_in_a,{1-sum(Xi_in_a)})))
    "Fluid temperature at port a"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Modelica.Blocks.Sources.RealExpression T_b(
    final y=Medium.temperature_phX(p=port_b.p,
                                   h=inStream(port_b.h_outflow),
                                   X=cat(1,Xi_in_b,{1-sum(Xi_in_b)})))
    "Fluid temperature at port b"
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));

  Modelica.Blocks.Sources.RealExpression mFlu_flow[nSeg](each final y=m_flow)
    "Input signal for mass flow rate"
    annotation (Placement(transformation(extent={{-80,-56},{-60,-36}})));

  Modelica.Blocks.Routing.Replicator T_a_rep(final nout=nSeg)
    "Signal replicator for T_a"
    annotation (Placement(transformation(extent={{-50,-16},{-42,-8}})));
  Modelica.Blocks.Routing.Replicator T_b_rep(final nout=nSeg)
    "Signal replicator for T_b"
    annotation (Placement(transformation(extent={{-50,-30},{-42,-22}})));
equation
  connect(colAllToOne1.port_b,surf_a)  annotation (Line(
      points={{40,82},{40,100},{40,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(colAllToOne.port_b,surf_b)  annotation (Line(
      points={{40,-86},{40,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(colAllToOne1.port_a, con_a.port_a) annotation (Line(
      points={{40,70},{40,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(colAllToOne.port_a, con_b.port_b)  annotation (Line(
      points={{40,-74},{40,-68}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(fluSlaCon.fluid, vol.heatPort) annotation (Line(
      points={{-8.4,-70},{-6,-70},{-6,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mFlu_flow.y, fluSlaCon.m_flow) annotation (Line(
      points={{-59,-46},{-50,-46},{-50,-66},{-29,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_a.y, T_a_rep.u) annotation (Line(
      points={{-59,-12},{-50.8,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_b.y, T_b_rep.u) annotation (Line(
      points={{-59,-26},{-50.8,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluSlaCon.T_a, T_a_rep.y) annotation (Line(
      points={{-29,-60},{-36,-60},{-36,-12},{-41.6,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_b_rep.y, fluSlaCon.T_b) annotation (Line(
      points={{-41.6,-26},{-38,-26},{-38,-63},{-29,-63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con_b.port_a, fluSlaCon.solid) annotation (Line(
      points={{40,-48},{40,-40},{20,-40},{20,-90},{-88,-90},{-88,-70},{-28.4,-70}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(fluSlaCon.solid, con_a.port_b) annotation (Line(
      points={{-28.4,-70},{-88,-70},{-88,30},{40,30},{40,40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
defaultComponentName="sla",
Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{-74,0},{-74,72},{60,72},{60,34},{-62,34},{-62,-6},
              {60,-6},{60,-44},{-66,-44},{-66,-74},{74,-74}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{74,-74},{74,2},{92,2}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>
This is a model of a single flow circuit of a radiant slab with pipes or a capillary heat exchanger
embedded in the construction.
For a model with multiple parallel flow circuits, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
user's guide</a> for more information.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 18, 2017, by Michael Wetter:<br/>
Removed state at surface b of <code>con_b</code>.
As this surface is connected to surface a of <code>con_a</code>, which
already has a state, the state can be removed, rather than relying
on the symbolic processor to remove one of these two states that are
directly coupled.
This is indeed required to avoid a warning about overdetermined initial equations.
</li>
<li>
January 06, 2016, by Thierry S. Nouidui:<br/>
Renamed parameter <code>nSta2</code> to <code>nSta</code>.
</li>
<li>
November 17, 2016, by Thierry S. Nouidui:<br/>
Added parameter <code>nSta2</code> to avoid translation error
in Dymola 2107. This is a work-around for a bug in Dymola
which will be addressed in future releases.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Renamed <code>res</code> to <code>preDro</code> for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/292\">#292</a>.
</li>
<li>
September 12, 2014, by Michael Wetter:<br/>
Set start value for <code>hPip(fluid(T))</code> to avoid
a warning about conflicting start values in Dymola 2015 FD01.
</li>
<li>
February 27, 2013, by Michael Wetter:<br/>
Fixed bug in the assignment of the fictitious thermal resistance by replacing
<code>RFic[nSeg](each G=A/Rx)</code> with
<code>RFic[nSeg](each G=A/nSeg/Rx)</code>.
</li>
<li>
April 5, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
April 3, 2012, by Xiufeng Pang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleCircuitSlab;
