within Buildings.Fluid.Storage.BaseClasses;
model IndirectTankHeatExchanger
  "Heat exchanger typically submerged in a fluid with a second fluid circulating through it"

  replaceable package MediumHex = Modelica.Media.Interfaces.PartialMedium
    "Heat transfer fluid flowing through the heat exchanger";
  replaceable package MediumTan = Modelica.Media.Interfaces.PartialMedium
    "Heat transfer fluid inside the tank";

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
      redeclare final package Medium = MediumHex);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium = MediumHex,
    showDesignFlowDirection=false,
    final show_T=false);

  parameter Integer nSeg(min=2) "Number of segments in the heat exchanger";
  parameter Modelica.SIunits.HeatCapacity CHex
    "Capacitance of the heat exchanger";
  parameter Modelica.SIunits.Volume volHexFlu
    "Volume of heat transfer fluid in the heat exchanger";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat transfer at nominal conditions"
  annotation(Dialog(tab="General", group="Nominal condition"));

  final parameter Modelica.SIunits.ThermalConductance UA_nominal=
    abs(Q_flow_nominal/(THex_nominal-TTan_nominal))
    "Nominal UA value for the heat exchanger";
  parameter Modelica.SIunits.Temperature TTan_nominal
    "Temperature of fluid inside the tank at UA_nominal"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.Temperature THex_nominal
    "Temperature of fluid inside the heat exchanger at UA_nominal"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between coil inside and outside convective heat transfer"
          annotation(Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.SIunits.Diameter dExtHex
    "Exterior diameter of the heat exchanger pipe";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port[nSeg]
    "Heat port connected to water inside the tank"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}}),
        iconTransformation(extent={{-10,-108},{10,-88}})));

  FixedResistances.FixedResistanceDpM res(
    redeclare final package Medium = MediumHex,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final homotopyInitialization=homotopyInitialization,
    final show_T=show_T,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance)
    "Calculates the flow resistance and pressure drop through the heat exchanger"
    annotation (Placement(transformation(extent={{46,-60},{66,-40}})));

  MixingVolumes.MixingVolume vol[nSeg](each nPorts=2,
    each m_flow_nominal=m_flow_nominal,
    redeclare each package Medium = MediumHex,
    each V=volHexFlu/nSeg,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each p_start=p_start,
    each T_start=T_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal,
    each final allowFlowReversal=allowFlowReversal) "Heat exchanger fluid"
    annotation (Placement(transformation(extent={{-32,-40},{-12,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap[nSeg](each C=CHex/
        nSeg,
        T(each start=T_start,
          each fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial)),
        der_T(
          each fixed=(energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial))) if
        not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Thermal mass of the heat exchanger"
    annotation (Placement(transformation(extent={{-6,6},{14,26}})));
protected
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumHex,
      allowFlowReversal=allowFlowReversal)
    "Mass flow rate of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-60}})));
  Modelica.Thermal.HeatTransfer.Components.Convection htfToHex[nSeg] if
        not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Convection coefficient between the heat transfer fluid and heat exchanger"
    annotation (Placement(transformation(extent={{-10,12},{-30,-8}})));
  Modelica.Thermal.HeatTransfer.Components.Convection HexToTan[nSeg] if
        not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Convection coefficient between the heat exchanger and the surrounding medium"
    annotation (Placement(transformation(extent={{20,12},{40,-8}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
                                     temSenHex[nSeg]
    "Temperature of the heat transfer fluid"                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-20,-70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenWat[nSeg]
    "Temperature sensor of the fluid surrounding the heat exchanger"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,40})));
  Modelica.Blocks.Routing.Replicator rep(nout=nSeg)
    "Replicates senMasFlo signal from 1 seg to nSeg"
    annotation (Placement(transformation(extent={{-44,-108},{-24,-88}})));
  HeatExchangers.BaseClasses.HACoilInside hAPipIns[nSeg](
    each m_flow_nominal=m_flow_nominal,
    each hA_nominal=UA_nominal/nSeg*(r_nominal + 1)/r_nominal,
    each T_nominal=THex_nominal)
    "Computation of convection coefficients inside the coil"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={20,-80})));
  HeatExchangers.BaseClasses.HANaturalCylinder hANatCyl[nSeg](
    redeclare each final package Medium = Medium,
    each final ChaLen=dExtHex,
    each final hA_nominal=UA_nominal/nSeg*(1 + r_nominal),
    each final TFlu_nominal=TTan_nominal,
    each final TSur_nominal=TTan_nominal-(r_nominal/(1+r_nominal))*(TTan_nominal-THex_nominal))
    "Calculates an hA value for each side of the heat exchanger"
                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,110})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenSur[nSeg]
    "Temperature at the external surface of the heat exchanger" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,42})));

  Modelica.Blocks.Sources.RealExpression hA_series[nSeg](y={1/(1/hAPipIns[i].hA
         + 1/hANatCyl[i].hA) for i in 1:nSeg}) if
        (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Series resistance for steady state operation"
    annotation (Placement(transformation(extent={{100,-122},{8,-102}})));

  Modelica.Thermal.HeatTransfer.Components.Convection htfToTan[nSeg] if
        (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Convection coefficient between the heat transfer fluid and the surrounding medium"
    annotation (Placement(transformation(extent={{-6,-4},{14,-24}})));
equation
  for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;

  connect(rep.u,senMasFlo. m_flow) annotation (Line(
      points={{-46,-98},{-70,-98},{-70,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port,HexToTan. fluid)    annotation (Line(
      points={{4.44089e-16,-150},{88,-150},{88,2},{40,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol[1].ports[1],senMasFlo.port_b) annotation (Line(
      points={{-24,-40},{-24,-50},{-60,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cap.port,HexToTan.solid) annotation (Line(
      points={{4,6},{4,2},{20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort,htfToHex. fluid) annotation (Line(
      points={{-32,-30},{-36,-30},{-36,2},{-30,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(htfToHex.solid,HexToTan. solid) annotation (Line(
      points={{-10,2},{20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenHex.T, hAPipIns.T)     annotation (Line(
      points={{-10,-70},{0,-70},{0,-76},{9,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hAPipIns.hA, htfToHex.Gc)     annotation (Line(
      points={{31,-80},{32,-80},{32,-18},{-20,-18},{-20,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HexToTan.solid,temSenSur. port) annotation (Line(
      points={{20,2},{20,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenWat.port, port)    annotation (Line(
      points={{68,30},{68,2},{88,2},{88,-150},{4.44089e-16,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenSur.T, hANatCyl.TSur)
                                     annotation (Line(
      points={{20,52},{20,70},{-40,70},{-40,114},{-2,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hANatCyl.TFlu, temSenWat.T)
                                     annotation (Line(
      points={{-2,106},{-36,106},{-36,76},{68,76},{68,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,0},{-90,0},{-90,-50},{-80,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nSeg].ports[2], res.port_a) annotation (Line(
      points={{-20,-40},{-20,-50},{46,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, port_b) annotation (Line(
      points={{66,-50},{84,-50},{84,4.44089e-16},{100,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSenHex.port, vol.heatPort) annotation (Line(
      points={{-30,-70},{-36,-70},{-36,-30},{-32,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rep.y, hAPipIns.m_flow)     annotation (Line(
      points={{-23,-98},{0,-98},{0,-84},{9,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hANatCyl.hA,HexToTan. Gc) annotation (Line(
      points={{21,110},{50,110},{50,-14},{30,-14},{30,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(htfToTan.solid, vol.heatPort) annotation (Line(points={{-6,-14},{-36,-14},
          {-36,-30},{-32,-30}}, color={191,0,0}));
  connect(htfToTan.fluid, port) annotation (Line(points={{14,-14},{88,-14},{88,-150},
          {0,-150}}, color={191,0,0}));
  connect(hA_series.y, htfToTan.Gc) annotation (Line(points={{3.4,-112},{3.4,
          -30},{4,-30},{4,-24}},
                            color={0,0,127}));
  connect(htfToTan.fluid, temSenSur.port) annotation (Line(points={{14,-14},{14,
          -14},{14,28},{14,32},{20,32}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -150},{100,150}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-150},{100,150}}), graphics={
        Rectangle(
          extent={{-66,64},{74,-96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,5},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,-12},{74,-18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,64},{-32,-96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,64},{6,-96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,64},{44,-96}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
          defaultComponentName="indTanHex",
        Documentation(info = "<html>
          <p>
          This model is a heat exchanger with a moving fluid on one side and a stagnant fluid on the other.
          It is intended for use when a heat exchanger is submerged in a stagnant fluid.
          For example, the heat exchanger in a storage tank which is part of a solar thermal system.
          </p>
          <p>
          This component models the fluid in the heat exchanger, convection between the fluid and
          the heat exchanger, and convection from the heat exchanger to the surrounding fluid.
          </p>
          <p>
          The model is based on <a href=\"Buildings.Fluid.HeatExchangers.BaseClasses.HACoilInside\">
          Buildings.Fluid.HeatExchangers.BaseClasses.HACoilInside</a> and
          <a href=\"Buildings.Fluid.HeatExchangers.BaseClasses.HANaturalCylinder\">
          Buildings.Fluid.HeatExchangers.BaseClasses.HANaturalCylinder</a>.
          </p>
          <p>
          The fluid ports are intended to be connected to a circulated heat transfer fluid
          while the heat port is intended to be connected to a stagnant fluid.
          </p>
          </html>",
          revisions="<html>
<ul>
<li>
June 30, 2015, by Filip Jorissen:<br/>
Simplified implementation when energyDynamics are steady state.
This leads to smaller algebraic loops.
This is to correct issue 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/432\">#432</a>.
</li>
<li>
March 28, 2015, by Filip Jorissen:<br/>
Propagated <code>allowFlowReversal</code>.
</li>
          <li>
          August 29, 2014, by Michael Wetter:<br/>
          Introduced <code>MediumTan</code> for the tank medium, and assigned <code>Medium</code>
          to be equal to <code>MediumHex</code>.
          This is to correct issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">
          #271</a>.
          </li>
          <li>
          June 18, 2014, by Michael Wetter:<br/>
          Set initial equations for <code>cap</code>, and renamed this instance from
          <code>Cap</code> to <code>cap</code>.
          This was done to avoid a warning during translation, and to comply with
          the coding convention.
          </li>
          <li>
          October 8, 2013, by Michael Wetter:<br/>
          Removed parameter <code>show_V_flow</code>.
          </li>
          <li>
          January 29, 2013, by Peter Grant:<br/>
          First implementation.
          </li>
          </ul>
          </html>"));
end IndirectTankHeatExchanger;
