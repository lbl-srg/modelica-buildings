within Buildings.Fluid.Storage.Ice;
model Tank "Ice tank with performance based on performance curves"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final allowFlowReversal = false,
    final tau=tauHex,
    final energyDynamics=energyDynamicsHex,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

  parameter Real SOC_start(min=0, max=1, final unit="1")
   "Start value for state of charge"
    annotation(Dialog(tab = "Initialization"));

  replaceable parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic per
    "Performance data"
    annotation (
      choicesAllMatching = true,
      Placement(transformation(extent = {{40, 60}, {60, 80}}, rotation = 0)));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance for heat exchanger internal fluid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tauHex(min=1) = 30
    "Time constant of working fluid through the heat exchanger at nominal flow"
     annotation (Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        p=Medium.p_default,
        T=273.15,
        X=Medium.X_default))
    "Specific heat capacity of working fluid";
  Modelica.Blocks.Interfaces.RealOutput SOC(
    final unit = "1")
    "state of charge"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Temperature of the fluid leaving at port_b"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput mIce(
    quantity="Mass",
    unit="kg") "Mass of remaining ice"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Heat flow rate, positive during charging, negative when melting the ice"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

protected
  Buildings.Fluid.Storage.Ice.BaseClasses.Tank tanHeaTra(
    final SOC_start=SOC_start,
    final per=per,
    final cp=cp)
    "Model for tank heat transfer between working fluid and ice"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-11,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature of fluid"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-40})));

  Modelica.Blocks.Sources.RealExpression TIn(
    final y=Medium.temperature(state=
        Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)))) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-90,-74},{-70,-54}})));

  Modelica.Blocks.Sources.RealExpression limQ_flow(y=m_flow*cp*(per.TFre - TIn.y))
   "Upper/Lower limit for charging/discharging rate"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(tanHeaTra.TIn, TIn.y) annotation (Line(points={{-42,-64},{-69,-64}},
                           color={0,0,127}));
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(points={{-21,-40},{-26,
          -40},{-26,-10},{-9,-10}},                color={191,0,0}));
  connect(tanHeaTra.SOC, SOC) annotation (Line(points={{-19,-70},{80,-70},{80,-40},
          {110,-40}}, color={0,0,127}));
  connect(tanHeaTra.mIce, mIce) annotation (Line(points={{-19,-74},{80,-74},{80,
          -80},{110,-80}}, color={0,0,127}));
  connect(limQ_flow.y, tanHeaTra.QLim_flow) annotation (Line(points={{-69,-80},
          {-56,-80},{-56,-76},{-42,-76}},color={0,0,127}));
  connect(tanHeaTra.Q_flow, Q_flow) annotation (Line(points={{-19,-66},{10,-66},
          {10,-40},{74,-40},{74,40},{110,40}},    color={0,0,127}));
  connect(tanHeaTra.Q_flow, preHeaFlo.Q_flow) annotation (Line(points={{-19,-66},
          {10,-66},{10,-40},{-1,-40}},color={0,0,127}));
  connect(temSen.T, T) annotation (Line(points={{-51,-40},{-80,-40},{-80,50},{
          74,50},{74,80},{110,80}},
        color={0,0,127}));
  connect(temSen.T, tanHeaTra.TOut) annotation (Line(points={{-51,-40},{-54,-40},
          {-54,-70},{-42,-70}}, color={0,0,127}));
  connect(vol.heatPort, temSen.port) annotation (Line(points={{-9,-10},{-26,-10},
          {-26,-40},{-30,-40}}, color={191,0,0}));
  annotation (defaultComponentModel="iceTan", Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,52},{-36,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-24,52},{-8,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{4,52},{20,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{32,52},{48,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-92,6},{92,-4}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{100,72},{140,46}},
          textColor={0,0,88},
          textString="Q_flow"),
        Text(
          extent={{100,-48},{128,-72}},
          textColor={0,0,88},
          textString="mIce"),
        Rectangle(
          extent=DynamicSelect({{70,-60},{84,60}},{{85,-60},{70,-60+(SOC)*120}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{100,-10},{128,-34}},
          textColor={0,0,88},
          textString="SOC"),
        Text(
          extent={{90,110},{124,88}},
          textColor={0,0,88},
          textString="T")}),
    Documentation(info="<html>
<p>
This model implements an ice tank model whose performance is computed based on
performance curves.
</p>
<p>
The model is based on the implementation of
<a href=\"https://doi.org/10.3384/ecp21181177\">Guowen et al., 2020</a> and
similar to the detailed EnergyPlus ice tank model
<a href=\"https://bigladdersoftware.com/epx/docs/9-0/input-output-reference/group-plant-equipment.html#thermalstorageicedetailed\">ThermalStorage:Ice:Detailed</a>.
</p>
<p>
The governing equations are as follows:
</p>
<p>
The mass of ice in the storage <i>m<sub>ice</sub></i> is calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
d SOC/dt = Q&#775;/(H<sub>f</sub> &nbsp; m<sub>ice,max</sub>)
</p>
<p align=\"center\" style=\"font-style:italic;\">
m<sub>ice</sub> = SOC &nbsp; m<sub>ice,max</sub>
</p>
<p>
where <i>SOC</i> is state of charge,
<i>Q&#775;</i> is the heat transfer rate of the ice tank, positive for charging and negative for discharging,
<i>Hf</i> is the fusion of heat of ice and
<i>m<sub>ice,max</sub></i> is the nominal mass of ice in the storage tank.
</p>
<p>
The heat transfer rate of the ice tank <i>Q&#775;</i> is computed using
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775; = Q<sub>sto,nom</sub> &nbsp; q<sup>*</sup>,
</p>
<p>
where
<i>Q<sub>sto,nom</sub></i> is the storage capacity and
<i>q<sup>*</sup></i> is a normalized heat flow rate.
The storage capacity is
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>sto,nom</sub> = Hf &nbsp; m<sub>ice,max</sub>,
</p>
<p>
where <i>Hf</i> is the latent heat of fusion of ice and
<i>m<sub>ice,max</sub></i> is the maximum ice storage capacity.
</p>
<p>
The normalized heat flow rate is computed using performance curves
for charging (freezing) or discharging (melting).
For charging, the heat transfer rate <i>q*</i> between the chilled water
and the ice in the thermal storage tank is calculated using
</p>
<p align=\"center\">
<i>
q<sup>*</sup> &Delta;t = C<sub>1</sub> + C<sub>2</sub>x + C<sub>3</sub> x<sup>2</sup> + [C<sub>4</sub> + C<sub>5</sub>x + C<sub>6</sub> x<sup>2</sup>]&Delta;T<sub>lmtd</sub><sup>*</sup>
</i>
</p>
<p>where <i>&Delta;t</i> is the time step of the data samples used for the curve fitting,
<i>C<sub>1-6</sub></i> are the curve fit coefficients,
<i>x</i> is the fraction of charging, also known as the state-of-charge,
and <i>T<sub>lmtd</sub><sup>*</sup></i> is the normalized LMTD
calculated using <a href=\"mdoelica://Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar\">
Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar</a>.
Similarly, for discharging, the heat transfer rate <i>q*</i>
between the chilled water and the ice in the thermal storage tank is
</p>
<p align=\"center\" style=\"font-style:italic;\">
- q<sup>*</sup> &Delta;t = D<sub>1</sub> + D<sub>2</sub>(1-x) + D<sub>3</sub> (1-x)<sup>2</sup> + [D<sub>4</sub> + D<sub>5</sub>(1-x) + D<sub>6</sub> (1-x)<sup>2</sup>]&Delta;T<sub>lmtd</sub><sup>*</sup>
</p>
<p>
where <i>&Delta;t</i> is the time step of the data samples used for the curve fitting,
<i>D<sub>1-6</sub></i> are the curve fit coefficients.
<p>
The normalized LMTD <i>&Delta;T<sub>lmtd</sub><sup>*</sup></i> uses a nominal temperature difference of 10 Kelvin.
This value must be used when obtaining the curve fit coefficients.
</p>
<p>
The log mean temperature difference is calculated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
    &Delta;T<sub>lmtd</sub><sup>*</sup> = &Delta;T<sub>lmtd</sub>/T<sub>nom</sub>
</p>
<p align=\"center\" style=\"font-style:italic;\">
 &Delta;T<sub>lmtd</sub> = (T<sub>in</sub> - T<sub>out</sub>)/ln((T<sub>in</sub> - T<sub>fre</sub>)/(T<sub>out</sub> - T<sub>fre</sub>))
</p>
<p>
where <i>T<sub>in</sub></i> is the inlet temperature, <i>T<sub>out</sub></i> is the outlet temperature,
<i>T<sub>fre</sub></i> is the freezing temperature
and <i>T<sub>nom</sub></i> is a nominal temperature difference of 10 Kelvin.
</p>
<h4>Usage</h4>
<p>
This model requires the fluid to flow from <code>port_a</code> to <code>port_b</code>.
Otherwise, the simulation stops with an error.
</p>
<h4>
Reference
</h4>
<p>
Strand, R.K. 1992. “Indirect Ice Storage System Simulation,” M.S. Thesis,
Department of Mechanical and Industrial Engineering, University of Illinois at Urbana-Champaign.
</p>
<p>
Guowen Li, Yangyang Fu, Amanda Pertzborn, Jin Wen and Zheng O'Neill.
<i>An Ice Storage Tank Modelica Model: Implementation and Validation.</i> Modelica Conferences. 2021.
<a href=\"https://doi.org/10.3384/ecp21181177\">doi:10.3384/ecp21181177</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
Refactored model to new architecture.
Changed model to allow idealized control.
Avoided SOC to be outside <i>[0, 1]</i>.
</li>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tank;