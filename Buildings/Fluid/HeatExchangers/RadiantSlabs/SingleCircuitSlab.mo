within Buildings.Fluid.HeatExchangers.RadiantSlabs;
model SingleCircuitSlab "Model of a single circuit of a radiant slab"
  extends Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Slab;
   extends Buildings.Fluid.FixedResistances.BaseClasses.Pipe(
      final nSeg=1,
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
      res(dp(nominal=200*length)));

  parameter Modelica.SIunits.Area A "Surface area of the slab"
  annotation(Dialog(group="Construction"));

  parameter Modelica.SIunits.Temperature T_c_start=
    (T_a_start*con_b.layers.R+T_b_start*con_a.layers.R)/layers.R
    "Initial construction temperature in the layer that contains the pipes, used if steadyStateInitial = false"
    annotation(Dialog(tab="Initialization", group="Construction"));
  final parameter Modelica.SIunits.Velocity v_nominal=
    4*m_flow_nominal/pipe.dIn^2/Modelica.Constants.pi/rho_default
    "Velocity at m_flow_nominal";

  Buildings.HeatTransfer.Conduction.MultiLayer con_a(
    final A=A,
    steadyStateInitial=steadyStateInitial,
    layers(
      final nLay = iLayPip,
      final material={layers.material[i] for i in 1:iLayPip},
      absIR_a=layers.absIR_a,
      absIR_b=layers.absIR_b,
      absSol_a=layers.absSol_a,
      absSol_b=layers.absSol_b,
      roughness_a=layers.roughness_a),
      T_a_start=T_a_start,
      T_b_start=T_c_start) "Construction near the surface port surf_a"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,60})));
  Buildings.HeatTransfer.Conduction.MultiLayer con_b(
      final A=A,
      steadyStateInitial=steadyStateInitial,
      layers(
        final nLay = layers.nLay-iLayPip,
        final material={layers.material[i] for i in iLayPip + 1:layers.nLay},
        absIR_a=layers.absIR_a,
        absIR_b=layers.absIR_b,
        absSol_a=layers.absSol_a,
        absSol_b=layers.absSol_b,
        roughness_a=layers.roughness_a),
      T_a_start=T_c_start,
      T_b_start=T_b_start) "Construction near the surface port surf_b"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-60})));

protected
  final parameter Modelica.SIunits.ThermalInsulance Rx=
      Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance(
        disPip=disPip,
        dPipOut=pipe.dOut,
        k=layers.material[iLayPip].k,
        sysTyp=sysTyp,
        kIns=layers.material[iLayPip+1].k,
        dIns=layers.material[iLayPip+1].x)
    "Thermal insulance for average temperature in plane with pipes";

  BaseClasses.PipeToSlabConductance fluSlaCon(
    redeclare final package Medium = Medium,
    final APip=Modelica.Constants.pi*pipe.dIn*length,
    final RWal=Modelica.Math.log(pipe.dOut/pipe.dIn)/(2*Modelica.Constants.pi*pipe.k*
        length),
    final RFic=Rx/A,
    final  m_flow_nominal=m_flow_nominal,
    kc_IN_con=
        Modelica.Fluid.Dissipation.HeatTransfer.StraightPipe.kc_overall_IN_con(
        d_hyd=pipe.dIn,
        L=length,
        K=pipe.roughness)) "Conductance between fluid and the slab"
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
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.RealExpression T_b(
    final y=Medium.temperature_phX(p=port_b.p,
                                   h=inStream(port_b.h_outflow),
                                   X=cat(1,Xi_in_b,{1-sum(Xi_in_b)})))
    "Fluid temperature at port b"
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));

  Modelica.Blocks.Sources.RealExpression mFlu_flow(final y=m_flow)
    "Input signal for mass flow rate"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(mFlu_flow.y, fluSlaCon.m_flow) annotation (Line(
      points={{-59,-60},{-50,-60},{-50,-66},{-29,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con_b.port_a, fluSlaCon.solid) annotation (Line(
      points={{40,-50},{40,-40},{20,-40},{20,-90},{-88,-90},{-88,-70},{-28.4,-70}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(fluSlaCon.solid, con_a.port_b) annotation (Line(
      points={{-28.4,-70},{-88,-70},{-88,30},{40,30},{40,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surf_a, con_a.port_a) annotation (Line(
      points={{40,100},{40,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con_b.port_b, surf_b) annotation (Line(
      points={{40,-70},{40,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fluSlaCon.T_a, T_a.y) annotation (Line(
      points={{-29,-60},{-40,-60},{-40,-30},{-59,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_b.y, fluSlaCon.T_b) annotation (Line(
      points={{-59,-44},{-46,-44},{-46,-63},{-29,-63}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fluSlaCon.fluid, vol[1].heatPort) annotation (Line(
      points={{-8.4,-70},{-6,-70},{-6,-28},{-1,-28}},
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
For a model with multiple parallel flow circuits, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab</a>.
</p>
<p>
The figure below shows the thermal resistance network of the model for an 
example in which the pipes are embedded in the concrete slab, and
the layers below the pipes are insulation and reinforced concrete.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/RadiantSlabs/resistances.png\"/>
</p>
<p>
The construction <code>con_a</code> computes transient heat conduction
between the surface heat port <code>surf_a</code> and the
plane that contains the pipes, with the heat port <code>con_a.port_a</code> connecting to <code>surf_a</code>.
Similarly, the construction <code>con_b</code> is between the plane
that contains the pipes and the surface heat port
<code>sur_b</code>, with the heat port <code>con_b.port_b</code> connecting to <code>surf_b</code>.
The temperature of the plane that contains the pipes is computed using a fictitious
resistance <code>RFic</code>, which is computed by 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance</a>.
There is also a resistance for the pipe wall <code>RPip</code>
and a convective heat transfer coefficient between the fluid and the pipe inside wall.
The convective heat transfer coefficient is a function of the mass flow rate and is computed
in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance</a>.
</p>
<p>
This resistance network is instantiated once along the flow path.
An epilson-NTU model is used to compute the heat transfer between the fluid
stream and plane that contains the pipe. This is computed by
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.PipeToSlabConductance</a>.
</p>
<p>
The material layers are declared by the parameter <code>layers</code>, which is an instance of
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a>.
The first layer of this material is the one at the heat port <code>surf_a</code>, and the last layer
is at the heat port <code>surf_b</code>.
The parameter <code>iLayPip</code> must be set to the number of the interface in which the pipes
are located. For example, consider the following floor slab.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/RadiantSlabs/construction.png\"/>
</p>
Then, the construction definition is
<br/>
<pre>
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic layers(
        nLay=3, 
        material={
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.08,
            k=1.13,
            c=1000,
            d=1400,
            nSta=5),
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.05,
            k=0.04,
            c=1400,
            d=10),
          Buildings.HeatTransfer.Data.Solids.Generic(
            x=0.2,
            k=1.8,
            c=1100,
            d=2400)}) \"Material definition for floor construction\"; 
</pre>
<p>
Note that we set <code>nSta=5</code> in the first material layer. In this example,
this material layer is the concrete layer in which the pipes are embedded. By setting
<code>nSta=5</code> the simulation is forced to be done with five state variables in this layer.
The default setting would have led to only one state variable in this layer.
</p>
<p>
Since the pipes are at the interface of the concrete and the insulation, 
we set <code>iLayPip=1</code>.
</p>
<h5>Initialization</h5>
<p>
The initialization of the fluid in the pipes and of the slab temperature are 
independent of each other.
</p>
<p>
To initialize the medium, the same mechanism is used as for any other fluid 
volume, such as 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>. Specifically,
the parameters
<code>energyDynamics</code> and <code>massDynamics</code> on the 
<code>Dynamics</code> tab are used.
Depending on the values of these parameters, the medium is initialized using the values
<code>p_start</code>,
<code>T_start</code>,
<code>X_start</code> and
<code>C_start</code>, provided that the medium model contains 
species concentrations <code>X</code> and trace substances <code>C</code>.
</p>
<p>
To initialize the construction temperatures, the parameters 
<code>steadyStateInitial</code>,
<code>T_a_start</code>,
<code>T_b_start</code> and
<code>T_c_start</code> are used.
By default, <code>T_c_start</code> is set to the temperature that leads to steady-state
heat transfer between the surfaces <code>surf_a</code> and <code>surf_b</code>, whose
temperatures are both set to 
<code>T_a_start</code> and
<code>T_b_start</code>.
</p>
<p>
The parameter <code>pipe</code>, which is an instance of the record 
<a href=\"modelica://Buildings.Fluid.Data.Pipes\">
Buildings.Fluid.Data.Pipes</a>,
defines the pipe material and geometry.
The parameter <code>disPip</code> declares the spacing between the pipes and
the parameter <code>length</code>, with default <code>length=A/disPip</code>
where <code>A</code> is the slab surface area,
declares the whole length of the pipe circuit.
</p>
<p>
The parameter <code>sysTyp</code> is used to select the equation that is used to compute
the average temperature in the plane of the pipes.
It needs to be set to the following values:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr>
      <th>sysTyp</th>
      <th>System type</th>
    </tr>
    <tr>
      <td>BaseClasses.Types.SystemType.Floor</td>
      <td>Radiant heating or cooling systems with pipes embedded in the concrete slab above the thermal insulation.</td>
    </tr>
    <tr>
      <td>BaseClasses.Types.SystemType.Ceiling_Wall_or_Capillary</td>
      <td>Radiant heating or cooling systems with pipes embedded in the concrete slab in the ceiling, or 
          radiant wall systems. Radiant heating and cooling systems with capillary heat exchanger at the 
          construction surface.</td>
    </tr>
  </table>
<h4>Limitations</h4>
<p>
The analogy with a three-resistance network and the corresponding equation for
<code>Rx</code> is based on a steady-state heat transfer analysis. Therefore, it is
only valid during steady-state.
For a fully dynamic model, a three-dimensional finite element method for the radiant slab would need to be implemented.
</p>
<h4>Implementation</h4>
<p>
To separate the material declaration <code>layers</code> into layers between the pipes
and heat port <code>surf_a</code>, and between the pipes and <code>surf_b</code>, the
vector <code>layers.material[nLay]</code> is partitioned into 
<code>layers.material[1:iLayPip]</code> and <code>layers.material[iLayPip+1:nLay]</code>.
The respective partitions are then assigned to the models for heat conduction between the
plane with the pipes and the construction surfaces, <code>con_a</code> and <code>con_b</code>.
</p>
</html>
",
revisions="<html>
<ul>
<li>
October 9, 2014, by Michael Wetter:<br/>
Changed model to use an epsilon-NTU approach for the heat transfer between
the fluid and the slab rather than a finite difference scheme along the
flow path.
This has shown to lead to about five times faster computation on several 
test cases including the models in
<a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples\">
Buildings.Rooms.FLEXLAB.Rooms.Examples</a>.
This required removing the parameter <code>nSeg</code> as it is no longer used.
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end SingleCircuitSlab;
