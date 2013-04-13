within Buildings.Fluid.Storage.BaseClasses;
model IndirectTankHeatExchanger

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    showDesignFlowDirection=false,
    final show_T=true);

  parameter Integer nSeg(min=2) "Number of segments in the heat exchanger";
  parameter Modelica.SIunits.HeatCapacity C "Capacitance of the heat exchanger";
  parameter Modelica.SIunits.Volume htfVol
    "Volume of heat transfer fluid in the heat exchanger";
  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Nominal UA value for the heat exchanger";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_htf
    "Nominal mass flow rate of the heat transfer fluid";
  parameter Modelica.SIunits.Area ASurHX
    "Area of the external surface on the HX";
  parameter Modelica.SIunits.Diameter dHXExt
    "Diameter of the exterior of the heat exchanger";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Fluid surrounding the heat exchanger";
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium
    "Heat transfer fluid flowing through the heat exchanger";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium_2)
    "Mass flow rate of the heat transfer fluid"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-60}})));
  MixingVolumes.MixingVolume vol[nSeg](each nPorts=3,
    each m_flow_nominal=m_flow_nominal_htf,
    redeclare package Medium = Medium_2,
    each V=htfVol/nSeg)
    annotation (Placement(transformation(extent={{-32,-40},{-12,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Cap[nSeg](each C=C/nSeg) if
       not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Thermal mass of the heat exchanger"
    annotation (Placement(transformation(extent={{-6,6},{14,26}})));

  Modelica.Thermal.HeatTransfer.Components.Convection htfToHX[nSeg]
    "Convection coefficient between the heat transfer fluid and heat exchanger"
    annotation (Placement(transformation(extent={{-10,12},{-30,-8}})));
  Modelica.Thermal.HeatTransfer.Components.Convection HXToWat[nSeg]
    "Convection coefficient between the heat exchanger and the surrounding medium"
    annotation (Placement(transformation(extent={{20,12},{40,-8}})));
  Modelica.Fluid.Sensors.Temperature temSenHtf[nSeg](redeclare package Medium
      = Medium_2) "Temperature of the heat transfer fluid"                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-6,-72})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenWat[nSeg]
    "Temperature sensor of the fluid surrounding the heat exchanger"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={68,40})));
  Modelica.Blocks.Routing.Replicator rep(nout=nSeg)
    "Replicates senMasFlo signal from 1 seg to nSeg"
    annotation (Placement(transformation(extent={{-44,-108},{-24,-88}})));
  HeatExchangers.BaseClasses.HASingleFlow hASingleFlow[nSeg](
    each UA_nominal=UA_nominal,
    each m_flow_nominal_w=m_flow_nominal_htf,
    each A_2=ASurHX/nSeg)                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={24,-78})));
  HeatExchangers.BaseClasses.HNatCyl hNatCyl[nSeg](each ChaLen=dHXExt,
      redeclare package Medium = Medium)
    "Calculates an hA value for each side of the heat exchanger"
                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,124})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenSur[nSeg]
    "Temperature at the external surface of the heat exchanger" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,42})));
  HeatExchangers.BaseClasses.RayleighNumber rayleighNumber[nSeg](each ChaLen=
        dHXExt, redeclare package Medium = Medium)
    "Calculates the Ra and Pr on the outside of the heat exchanger"
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={64,86})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1[nSeg]
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}}),
        iconTransformation(extent={{-10,-108},{10,-88}})));
  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal_htf)
    "Calculates the flow resistance and pressure drop through the heat exchanger"
    annotation (Placement(transformation(extent={{46,-60},{66,-40}})));
equation

  for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;

  connect(rep.u,senMasFlo. m_flow) annotation (Line(
      points={{-46,-98},{-70,-98},{-70,-61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_b1,HXToWat. fluid) annotation (Line(
      points={{4.44089e-16,-150},{88,-150},{88,2},{40,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol[1].ports[1],senMasFlo. port_b) annotation (Line(
      points={{-24.6667,-40},{-24,-40},{-24,-50},{-60,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Cap.port,HXToWat. solid) annotation (Line(
      points={{4,6},{4,2},{20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort,htfToHX. fluid) annotation (Line(
      points={{-32,-30},{-36,-30},{-36,2},{-30,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(htfToHX.solid,HXToWat. solid) annotation (Line(
      points={{-10,2},{20,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rep.y,hASingleFlow. m1_flow) annotation (Line(
      points={{-23,-98},{17,-98},{17,-89}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenHtf.T,hASingleFlow. T_1) annotation (Line(
      points={{-6,-79},{-6,-102},{21,-102},{21,-89}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASingleFlow.hA_1,htfToHX. Gc) annotation (Line(
      points={{17,-67},{17,-14},{-20,-14},{-20,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASingleFlow.hA_2,HXToWat. Gc) annotation (Line(
      points={{31,-67},{31,-38.5},{30,-38.5},{30,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HXToWat.solid,temSenSur. port) annotation (Line(
      points={{20,2},{20,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenWat.port,port_b1)  annotation (Line(
      points={{68,30},{68,2},{88,2},{88,-150},{4.44089e-16,-150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenWat.T,rayleighNumber. TFlu) annotation (Line(
      points={{68,50},{68,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenSur.T,rayleighNumber. TSur) annotation (Line(
      points={{20,52},{20,64},{60,64},{60,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenSur.T,hNatCyl. TSur) annotation (Line(
      points={{20,52},{20,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.TFlu,temSenWat. T) annotation (Line(
      points={{24,112},{24,58},{68,58},{68,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rayleighNumber.Ra,hNatCyl. Ra) annotation (Line(
      points={{64,97},{64,102},{32,102},{32,112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.Pr,rayleighNumber. Pr) annotation (Line(
      points={{36,112},{38,112},{38,106},{68,106},{68,97}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.h,hASingleFlow. h_2) annotation (Line(
      points={{28,135},{28,138},{80,138},{80,-98},{28,-98},{28,-89}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,0},{-90,0},{-90,-50},{-80,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSenHtf.port, vol.ports[3]) annotation (Line(
      points={{-16,-72},{-19.3333,-72},{-19.3333,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nSeg].ports[2], res.port_a) annotation (Line(
      points={{-22,-40},{-22,-50},{46,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, port_b) annotation (Line(
      points={{66,-50},{84,-50},{84,4.44089e-16},{100,4.44089e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -150},{100,150}}), graphics), Icon(coordinateSystem(
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
        Documentation(info = "<html>
          <p>
          This model is a heat exchanger with a fluid loop on one side and a heat exchanger on the other. It is intended for use when a heat exchanger is submerged in a stagnant fluid.<br>
          Example: A heat exchanger in a storage tank connected to a solar thermal collector.</p>
          <p>
          This component models the fluid in the heat exchanger, convection between the fluid and the heat exchanger, and convection from the heat exchanger to the surrounding fluid.</p>
          <p>
          The model is based on <a href=\"Buildings.Fluid.HeatExchangers.BaseClasses.HASingleFlow\">Buildings.Fluid.HeatExchangers.BaseClasses.HASingleFlow</a><p>
          <p>
          The fluid ports are intended to be connected to a circulated heat transfer fluid while the heat port is intended to be connected to a stagnant fluid.</p>          
          </html>",
          revisions = "<html>
          <ul>
          <li> Peter Grant, Jan 29, 2013<br>
          First implementation.
          </li>
          </ul>
          </html>"));
end IndirectTankHeatExchanger;
