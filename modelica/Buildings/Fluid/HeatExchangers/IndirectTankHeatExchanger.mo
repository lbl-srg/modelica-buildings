within Buildings.Fluid.HeatExchangers;
model IndirectTankHeatExchanger
  "Model of a heat exchanger used in an indirect water storage tank"

  parameter Integer nSeg(min=2) "Number of segments in the heat exchanger";
  parameter Modelica.SIunits.HeatCapacity C "Capacitance of the heat exchanger";
  parameter Modelica.SIunits.Volume GlyVol
    "Volume of fluid in the heat exchanger";
  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Nominal UA value for the heat exchanger";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_gly
    "Nominal mass flow rate of the heat transfer fluid";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_wat
    "Nominal mass flow rate of the water surrounding the heat exchanger";

  replaceable package Medium =
      Modelica.Media.Incompressible.Examples.Glycol47
    "Heat transfer fluid flowing through the heat exchanger";

  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-98,10},{-78,-10}})));
  MixingVolumes.MixingVolume vol[nSeg](each nPorts=3, redeclare package Medium
      = Medium,
    each V=GlyVol/nSeg,
    each m_flow_nominal=m_flow_nominal_gly)
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Cap[nSeg](each C=C/nSeg)
                annotation (Placement(transformation(extent={{-2,56},{18,76}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1[nSeg]
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{0,-78},{20,-58}})));
  BaseClasses.HADryCoil hADryCoil[nSeg](
    each UA_nominal=UA_nominal,
    each waterSideFlowDependent=true,
    each airSideFlowDependent=false,
    each waterSideTemperatureDependent=true,
    each airSideTemperatureDependent=true,
    each m_flow_nominal_w=m_flow_nominal_gly,
    each m_flow_nominal_a=m_flow_nominal_wat)
                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-30})));
  Modelica.Thermal.HeatTransfer.Components.Convection glyToHX[nSeg]
    annotation (Placement(transformation(extent={{-40,62},{-20,42}})));
  Modelica.Thermal.HeatTransfer.Components.Convection HXToWat[nSeg]
    annotation (Placement(transformation(extent={{22,62},{42,42}})));
  Modelica.Fluid.Sensors.Temperature temSenGly[nSeg](redeclare package Medium
      = Medium)                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-16,-22})));
  Modelica.Blocks.Sources.Constant masFloWat[nSeg](each k=0) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,-72})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenWat[nSeg]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={66,26})));
  Modelica.Blocks.Routing.Replicator rep(nout=nSeg)
    annotation (Placement(transformation(extent={{-54,-58},{-34,-38}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,60},{-90,80}}),
        iconTransformation(extent={{-100,60},{-80,80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{98,60},{118,80}}),
        iconTransformation(extent={{98,60},{118,80}})));
equation

  for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;

  connect(vol.heatPort, glyToHX.solid) annotation (Line(
      points={{-42,20},{-46,20},{-46,52},{-40,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(glyToHX.fluid, Cap.port)           annotation (Line(
      points={{-20,52},{8,52},{8,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cap.port, HXToWat.solid)           annotation (Line(
      points={{8,56},{8,52},{22,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hADryCoil.hA_1, glyToHX.Gc) annotation (Line(
      points={{7,-19},{7,36},{-30,36},{-30,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hADryCoil.hA_2, HXToWat.Gc) annotation (Line(
      points={{21,-19},{21,36},{32,36},{32,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenGly.T, hADryCoil.T_1) annotation (Line(
      points={{-16,-29},{-16,-52},{11,-52},{11,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloWat.y, hADryCoil.m2_flow) annotation (Line(
      points={{34,-61},{34,-52},{21,-52},{21,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenWat.T, hADryCoil.T_2) annotation (Line(
      points={{66,16},{66,-88},{16,-88},{16,-41},{17,-41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep.u, senMasFlo.m_flow) annotation (Line(
      points={{-56,-48},{-88,-48},{-88,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hADryCoil.m1_flow, rep.y) annotation (Line(
      points={{7,-41},{7,-48},{-33,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,70},{-100,0},{-98,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b1, temSenWat.port) annotation (Line(
      points={{4.44089e-16,-100},{84,-100},{84,44},{66,44},{66,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_b1, HXToWat.fluid) annotation (Line(
      points={{4.44089e-16,-100},{84,-100},{84,52},{42,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol[1].ports[1], senMasFlo.port_b) annotation (Line(
      points={{-34.6667,10},{-34,10},{-34,0},{-78,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{-32,10},{-32,0},{88,0},{88,70},{108,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSenGly.port, vol.ports[3]) annotation (Line(
      points={{-26,-22},{-29.3333,-22},{-29.3333,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-60,90},{80,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,90},{50,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,90},{-26,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,90},{12,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,14},{80,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,75},{113,65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-58,-102},{74,-134}},
          lineColor={0,0,255},
          textString="%name")}),
          defaultComponentName = "indTanHX");
end IndirectTankHeatExchanger;
