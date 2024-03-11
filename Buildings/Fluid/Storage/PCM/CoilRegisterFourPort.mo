within Buildings.Fluid.Storage.PCM;
model CoilRegisterFourPort
  "Four port register for a pcm heat exchanger"
  import Modelica.Constants;
  replaceable parameter Buildings.Fluid.Storage.PCM.Data.HeatExchanger.Generic Design "Heat Exchanger Design"  annotation (choicesAllMatching = true);
replaceable parameter Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.Generic Material "Phase Change Material" annotation (choicesAllMatching = true);
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal "mass flowrate through HPC";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal "mass flowrate through LPC";
  parameter Modelica.Units.SI.Temperature TStart_pcm "Starting temperature of pcm";
  Buildings.Fluid.Storage.PCM.BaseClasses.HexElementSensibleFourPort eleHex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    Design=Design,
    Material=Material,
    TStart_pcm=TStart_pcm)
    annotation (Placement(transformation(extent={{-12,-12},{12,12}})));
  replaceable package Medium = Buildings.Media.Water "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal in medium, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare each package Medium =
               Medium, each m_flow(start=0, min=if allowFlowReversal then -
          Constants.inf else 0))
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,32},{-90,52}}),
        iconTransformation(extent={{-110,32},{-90,52}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare each package Medium =
               Medium, each m_flow(start=0, max=if allowFlowReversal then +
          Constants.inf else 0))
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,32},{90,52}}),
        iconTransformation(extent={{110,32},{90,52}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare each package Medium =
               Medium, each m_flow(start=0, min=if allowFlowReversal then -
          Constants.inf else 0))
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-52},{110,-32}}),
        iconTransformation(extent={{90,-52},{110,-32}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare each package Medium =
               Medium, each m_flow(start=0, max=if allowFlowReversal then +
          Constants.inf else 0))
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-52},{-110,-32}}),
        iconTransformation(extent={{-90,-52},{-110,-32}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloDom(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-48,42},{-32,58}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloPro(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{32,-42},{48,-58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TInDom(redeclare package Medium =
        Medium, m_flow_nominal=m1_flow_nominal)
    annotation (Placement(transformation(extent={{-78,42},{-62,58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOutDom(redeclare package Medium =
        Medium, m_flow_nominal=m1_flow_nominal)
    annotation (Placement(transformation(extent={{62,42},{78,58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TInPro(redeclare package Medium =
        Medium, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{62,-42},{78,-58}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOutPro(redeclare package Medium =
        Medium, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{-78,-42},{-62,-58}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_a1 annotation (Placement(transformation(extent={{-108,26},
            {-94,12}}), iconTransformation(extent={{-108,26},{-94,12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_b2 annotation (Placement(transformation(extent={{-108,
            -26},{-94,-12}}), iconTransformation(extent={{-108,-26},{-94,-12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_b1 annotation (Placement(transformation(extent={{92,26},
            {106,12}}), iconTransformation(extent={{92,26},{106,12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a tubHeaPort_a2
    annotation (Placement(transformation(extent={{92,-26},{106,-12}}),
        iconTransformation(extent={{92,-26},{106,-12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorDom
    "Heat port for heat exchange with the control volume"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorPro
    "Heat port for heat exchange with the control volume"
    annotation (Placement(transformation(extent={{-10,-90},{10,-110}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "state of charge of PCM"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Continuous.Integrator Epcm(k=1) "sum of energy into PCM [J]"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-90,-8.88178e-16})));
  Modelica.Blocks.Math.Add Qpcm(k2=+1, k1=+1)
    "sum of heat transfer rates into PCM [W]" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-72,0})));
  Modelica.Blocks.Interfaces.RealOutput QDom
    "convective heat flow from domestic circuit [W]"
                                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,82}), iconTransformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,90})));
  Modelica.Blocks.Interfaces.RealOutput QPro
    "convective heat flow from process circuit [W]"
                                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,66}), iconTransformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,66})));
  Modelica.Blocks.Sources.RealExpression calcSOC(y=Buildings.Fluid.Storage.PCM.BaseClasses.SOC(
        Upcm=eleHex.Upcm,
        mpcm=eleHex.mpcm,
        TSol=Material.TSol,
        cSol=Material.c,
        LHea=Material.LHea))
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Interfaces.RealOutput EPCM "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-76},{120,-56}}),
        iconTransformation(extent={{100,-76},{120,-56}})));
  Modelica.Blocks.Sources.RealExpression calcTesCap(y=Buildings.Fluid.Storage.PCM.BaseClasses.Ufg(
        mpcm=eleHex.mpcm,
        LHea=Material.LHea))
    annotation (Placement(transformation(extent={{-50,-102},{-70,-82}})));
  Modelica.Blocks.Interfaces.RealOutput Ufg "Value of Real output"
    annotation (Placement(transformation(extent={{-100,-102},{-120,-82}})));
equation
  connect(port_b2,TOutPro. port_a)
    annotation (Line(points={{-100,-42},{-90,-42},{-90,-50},{-78,-50}},
                                                    color={0,127,255}));
  connect(port_a1,TInDom. port_a)
    annotation (Line(points={{-100,42},{-90,42},{-90,50},{-78,50}},
                                                  color={0,127,255}));
  connect(TOutPro.port_b, eleHex.port_b2) annotation (Line(points={{-62,-50},{
          -20,-50},{-20,-7.2},{-12,-7.2}},
                                   color={0,127,255}));
  connect(TOutDom.port_b, port_b1)
    annotation (Line(points={{78,50},{90,50},{90,42},{100,42}},
                                                color={0,127,255}));
  connect(TInPro.port_b, port_a2)
    annotation (Line(points={{78,-50},{90,-50},{90,-42},{100,-42}},
                                                  color={0,127,255}));
  connect(TOutDom.port_a, eleHex.port_b1) annotation (Line(points={{62,50},{20,
          50},{20,7.2},{12,7.2}},
                          color={0,127,255}));
  connect(TInDom.port_b,senMasFloDom. port_a)
    annotation (Line(points={{-62,50},{-48,50}}, color={0,127,255}));
  connect(senMasFloDom.port_b, eleHex.port_a1) annotation (Line(points={{-32,50},
          {-20,50},{-20,7.2},{-12,7.2}},
                                     color={0,127,255}));
  connect(senMasFloPro.port_b,TInPro. port_a)
    annotation (Line(points={{48,-50},{62,-50}}, color={0,127,255}));
  connect(senMasFloPro.port_a, eleHex.port_a2) annotation (Line(points={{32,-50},
          {20,-50},{20,-7.2},{12,-7.2}},
                                     color={0,127,255}));
  connect(tubHeaPort_a1, eleHex.tubHeaPort_a1) annotation (Line(points={{-101,19},
          {-53.5,19},{-53.5,4.56},{-12,4.56}},
                                             color={191,0,0}));
  connect(tubHeaPort_b2, eleHex.tubHeaPort_b2) annotation (Line(points={{-101,
          -19},{-53.5,-19},{-53.5,-4.56},{-12,-4.56}},
                                                color={191,0,0}));
  connect(eleHex.tubHeaPort_b1, tubHeaPort_b1) annotation (Line(points={{12,4.56},
          {54,4.56},{54,19},{99,19}},color={191,0,0}));
  connect(tubHeaPort_a2, eleHex.tubHeaPort_a2) annotation (Line(points={{99,-19},
          {54.5,-19},{54.5,-4.56},{12,-4.56}},
                                             color={191,0,0}));
  connect(heaPorDom, eleHex.heaPor1)
    annotation (Line(points={{0,100},{0,12}}, color={191,0,0}));
  connect(heaPorPro, eleHex.heaPor2)
    annotation (Line(points={{0,-100},{0,-12}}, color={191,0,0}));
  connect(Epcm.u, Qpcm.y)
    annotation (Line(points={{-82.8,0},{-78.6,0}}, color={0,0,127}));
  connect(Qpcm.u2, eleHex.QpcmDom) annotation (Line(points={{-64.8,3.6},{-36.4,
          3.6},{-36.4,2.52},{-12.84,2.52}},
                                          color={0,0,127}));
  connect(Qpcm.u1, eleHex.QpcmPro) annotation (Line(points={{-64.8,-3.6},{-36.4,
          -3.6},{-36.4,-2.52},{-12.84,-2.52}}, color={0,0,127}));
  connect(eleHex.QvolDom,QDom)  annotation (Line(points={{-3.84,12.96},{-3.92,
          12.96},{-3.92,82},{110,82}}, color={0,0,127}));
  connect(eleHex.QvolPro,QPro)  annotation (Line(points={{-2.64,-12.96},{-2.64,
          -34},{40,-34},{40,66},{110,66}}, color={0,0,127}));
  connect(calcSOC.y, SOC)
    annotation (Line(points={{61,-90},{110,-90}}, color={0,0,127}));
  connect(Epcm.y, EPCM) annotation (Line(points={{-96.6,0},{-120,0},{-120,-66},
          {110,-66}}, color={0,0,127}));
  connect(calcTesCap.y, Ufg)
    annotation (Line(points={{-71,-92},{-110,-92}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Register of a heat exchanger with dynamics on the fluids and the solid.
The register represents one array of pipes that are perpendicular to the
air stream.
The <i>hA</i> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid in each heat exchanger element.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 19, 2017, by Michael Wetter:<br/>
Changed initialization of pressure from a <code>constant</code> to a <code>parameter</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Changed <code>initalize_p</code> from a <code>parameter</code> to a
<code>constant</code>. This is only required in finite volume models
of heat exchangers (to avoid consistent but redundant initial conditions)
and hence it should be set as a <code>constant</code>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
August 10, 2014, by Michael Wetter:<br/>
Reformulated the multiple iterators in the <code>sum</code> function
as this language construct is not supported in OpenModelica.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Added parameters <code>initialize_p1</code> and <code>initialize_p2</code>.
This is required to enable the coil models to initialize the pressure in the
first volume, but not in the downstream volumes. Otherwise,
the initial equations will be overdetermined, but consistent.
This change was done to avoid a long information message that appears
when translating models.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Removed parameters <code>energyDynamics1</code> and <code>energyDynamics2</code>,
and used instead of these two parameters the new parameter <code>energyDynamics</code>.
Removed parameters <code>steadyState_1</code> and <code>steadyState_2</code>.
This was done as this complexity is not required.
</li>
<li>
August 12, 2008 by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
extent=[-20,80; 0,100],    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,5},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,4},{70,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Placement(transformation(extent={{-20,80},{0,100}})));
end CoilRegisterFourPort;
