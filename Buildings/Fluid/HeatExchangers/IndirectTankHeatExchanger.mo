within Buildings.Fluid.HeatExchangers;
model IndirectTankHeatExchanger
  "Model of a heat exchanger used in an indirect water storage tank"

  parameter Integer nSeg(min=2) "Number of segments in the heat exchanger";
  parameter Modelica.SIunits.HeatCapacity C "Capacitance of the heat exchanger";
  parameter Modelica.SIunits.Volume HtfVol
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
    "Heat transfer fluid flowing through the heat exchanger";
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium
    "Fluid surrounding the heat exchanger";

  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-98,10},{-78,-10}})));
  MixingVolumes.MixingVolume vol[nSeg](each nPorts=3, redeclare package Medium
      = Medium,
    each V=HtfVol/nSeg,
    each m_flow_nominal=m_flow_nominal_htf)
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Cap[nSeg](each C=C/nSeg)
                annotation (Placement(transformation(extent={{-2,56},{18,76}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b1[nSeg]
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{0,-78},{20,-58}})));
  Modelica.Thermal.HeatTransfer.Components.Convection htfToHX[nSeg]
    annotation (Placement(transformation(extent={{-20,62},{-40,42}})));
  Modelica.Thermal.HeatTransfer.Components.Convection HXToWat[nSeg]
    annotation (Placement(transformation(extent={{22,62},{42,42}})));
  Modelica.Fluid.Sensors.Temperature temSenHtf[nSeg](redeclare package Medium
      = Medium)                                      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-16,-22})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenWat[nSeg]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,90})));
  Modelica.Blocks.Routing.Replicator rep(nout=nSeg)
    annotation (Placement(transformation(extent={{-54,-58},{-34,-38}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,60},{-90,80}}),
        iconTransformation(extent={{-100,60},{-80,80}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{160,60},{180,80}}),
        iconTransformation(extent={{98,60},{118,80}})));
  BaseClasses.HASingleFlow hASingleFlow[nSeg](
    each UA_nominal=UA_nominal,
    each m_flow_nominal_w=m_flow_nominal_htf,
    each A_2=ASurHX/nSeg)                          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={24,-28})));
  BaseClasses.hNatCyl hNatCyl[nSeg](each ChaLen=dHXExt, redeclare package
      Medium =
        Medium_2)                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,174})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenSur[nSeg]
    "Temperature at the external surface of the heat exchanger" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={22,92})));
  BaseClasses.RayleighNumber rayleighNumber[nSeg](each ChaLen=dHXExt, redeclare
      package Medium = Medium_2)                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={66,136})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-140,-38},{-120,-18}})));
equation

  for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;

  connect(rep.u, senMasFlo.m_flow) annotation (Line(
      points={{-56,-48},{-88,-48},{-88,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,70},{-100,0},{-98,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b1, HXToWat.fluid) annotation (Line(
      points={{4.44089e-16,-100},{146,-100},{146,52},{42,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol[1].ports[1], senMasFlo.port_b) annotation (Line(
      points={{-34.6667,10},{-34,10},{-34,0},{-78,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{-32,10},{-32,0},{150,0},{150,70},{170,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSenHtf.port, vol.ports[3]) annotation (Line(
      points={{-26,-22},{-29.3333,-22},{-29.3333,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Cap.port, HXToWat.solid) annotation (Line(
      points={{8,56},{8,52},{22,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort,htfToHX. fluid) annotation (Line(
      points={{-42,20},{-46,20},{-46,52},{-40,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(htfToHX.solid, HXToWat.solid) annotation (Line(
      points={{-20,52},{22,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rep.y, hASingleFlow.m1_flow) annotation (Line(
      points={{-33,-48},{17,-48},{17,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenHtf.T, hASingleFlow.T_1) annotation (Line(
      points={{-16,-29},{-16,-52},{21,-52},{21,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASingleFlow.hA_1, htfToHX.Gc) annotation (Line(
      points={{17,-17},{17,36},{-30,36},{-30,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hASingleFlow.hA_2, HXToWat.Gc) annotation (Line(
      points={{31,-17},{31,11.5},{32,11.5},{32,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HXToWat.solid, temSenSur.port) annotation (Line(
      points={{22,52},{22,82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenWat.port, port_b1) annotation (Line(
      points={{70,80},{70,52},{146,52},{146,-100},{4.44089e-16,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenWat.T, rayleighNumber.TFlu) annotation (Line(
      points={{70,100},{70,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenSur.T, rayleighNumber.TSur) annotation (Line(
      points={{22,102},{22,114},{62,114},{62,124}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenSur.T, hNatCyl.TSur) annotation (Line(
      points={{22,102},{22,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.TFlu, temSenWat.T) annotation (Line(
      points={{26,162},{26,108},{70,108},{70,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rayleighNumber.Ra, hNatCyl.Ra) annotation (Line(
      points={{66,147},{66,152},{34,152},{34,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.Pr, rayleighNumber.Pr) annotation (Line(
      points={{38,162},{40,162},{40,156},{70,156},{70,147}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hNatCyl.h, hASingleFlow.h_2) annotation (Line(
      points={{30,185},{30,188},{90,188},{90,-48},{28,-48},{28,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-200},{200,200}}), graphics={
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
          defaultComponentName = "indHX",
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
