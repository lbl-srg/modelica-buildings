within Buildings.Fluid.Storage.PCM.BaseClasses;
model HexElementSensibleFourPort
  "Element of a heat exchanger w PCM between flow channels"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
  redeclare final Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol1(
     prescribedHeatFlowRate=false),
  redeclare final Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatPort vol2(
     prescribedHeatFlowRate=false),
     dp1_nominal = TesScale*Design.dp1_coeff,
     dp2_nominal = TesScale*Design.dp2_coeff);
  extends
    Buildings.Fluid.Storage.PCM.BaseClasses.partialUnitCellPhaseChangeTwoCircuit;

  parameter Boolean initialize_p1 = not Medium1.singleState
    "Set to true to initialize the pressure of volume 1"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean initialize_p2 = not Medium2.singleState
    "Set to true to initialize the pressure of volume 2"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));
    Medium1.ThermodynamicState sta1 = Medium1.setState_phX(p=port_a1.p, h=port_a1.h_outflow, X=port_a1.Xi_outflow);
    Medium2.ThermodynamicState sta2 = Medium2.setState_phX(p=port_a2.p, h=port_a2.h_outflow, X=port_a2.Xi_outflow);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor1
    "Heat port for heat exchange with the control volume j-1"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor2
    "Heat port for heat exchange with the control volume j+1"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput QpcmDom
    "heat flow into PCM from domestic circuit"
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-107,21})));
  Modelica.Blocks.Interfaces.RealOutput QpcmPro
    "heat flow into PCM from process circuit"
    annotation (Placement(transformation(
        extent={{7,7},{-7,-7}},
        rotation=0,
        origin={-107,-21})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor Qvol1
    annotation (Placement(transformation(extent={{-26,94},{-38,82}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor Qvol2
    annotation (Placement(transformation(extent={{-16,-92},{-28,-80}})));
  Modelica.Blocks.Interfaces.RealOutput QvolDom "convective heat flow from domestic circuit"
    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-32,108})));
  Modelica.Blocks.Interfaces.RealOutput QvolPro "convective heat flow from process circuit"
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={-22,-108})));
  Modelica.Blocks.Sources.RealExpression realExpressionDom(y=((0.023*((4*abs(
        port_a1.m_flow))/(Modelica.Constants.pi*Design.di*Medium1.dynamicViscosity(state=sta1)))^(4/5)* Medium1.prandtlNumber(state=sta1)^0.4)*
        Medium1.thermalConductivity(state=sta1)/(Design.di))*(A_tubeDom)) "Dittus-Boelter correlation for turbulent heat transfer in smooth tube"
    annotation (Placement(transformation(extent={{42,10},{22,30}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conDom annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-40,72})));
  Modelica.Blocks.Sources.RealExpression realExpressionPro(y=((0.023*((4*abs(
        port_a2.m_flow))/(Modelica.Constants.pi*Design.di*Medium2.dynamicViscosity(state=sta2)))^(4/5)*Medium2.prandtlNumber(state=sta2)^0.4)*
        Medium2.thermalConductivity(state=sta2)/(Design.di))*(A_tubePro)) "Dittus-Boelter correlation for turbulent heat transfer in smooth tube"
    annotation (Placement(transformation(extent={{42,-20},{22,0}})));
  Modelica.Thermal.HeatTransfer.Components.Convection conPro annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-40,-72})));
  Modelica.Blocks.Interfaces.RealOutput Upcm "Value of Real output"
    annotation (Placement(transformation(extent={{-110,0},{-126,16}})));
  Modelica.Blocks.Interfaces.RealOutput mpcm "Value of Real output"
    annotation (Placement(transformation(extent={{-110,-16},{-126,0}})));
equation

  connect(heaFloDom.Q_flow,QpcmDom)  annotation (Line(points={{-64,20.6},{-82,20.6},
          {-82,21},{-107,21}}, color={0,0,127}));
  connect(vol1.heatPort, heaPor1) annotation (Line(points={{-10,60},{-20,60},{-20,
          88},{0,88},{0,100}}, color={191,0,0}));
  connect(vol2.heatPort, heaPor2) annotation (Line(points={{12,-60},{18,-60},{20,
          -60},{20,-90},{0,-90},{0,-100}}, color={191,0,0}));
  connect(heaFloPro.Q_flow,QpcmPro)  annotation (Line(points={{-64,-16.6},{-64,-20},
          {-80,-20},{-80,-21},{-107,-21}},
                                      color={0,0,127}));
  connect(Qvol1.port_b, conDom.fluid)
    annotation (Line(points={{-38,88},{-40,88},{-40,82}}, color={191,0,0}));
  connect(Qvol1.port_a, heaPor1)
    annotation (Line(points={{-26,88},{0,88},{0,100}}, color={191,0,0}));
  connect(conPro.fluid, Qvol2.port_b)
    annotation (Line(points={{-40,-82},{-40,-86},{-28,-86}}, color={191,0,0}));
  connect(Qvol2.port_a, vol2.heatPort) annotation (Line(points={{-16,-86},{20,
          -86},{20,-60},{12,-60}}, color={191,0,0}));
  connect(QvolDom, Qvol1.Q_flow)
    annotation (Line(points={{-32,108},{-32,94.6}},
                                                  color={0,0,127}));
  connect(Qvol2.Q_flow,QvolPro)
    annotation (Line(points={{-22,-92.6},{-22,-108}},
                                                    color={0,0,127}));
  connect(tubeDom.port_b, conDom.solid)
    annotation (Line(points={{-40,58},{-40,62}}, color={191,0,0}));
  connect(tubePro.port_b,conPro. solid)
    annotation (Line(points={{-40,-58},{-40,-62}}, color={191,0,0}));
  connect(conPro.Gc,realExpressionPro. y) annotation (Line(points={{-30,-72},{
          -22,-72},{-22,-10},{21,-10}}, color={0,0,127}));
  connect(conDom.Gc, realExpressionDom.y) annotation (Line(points={{-30,72},{-22,
          72},{-22,20},{21,20}}, color={0,0,127}));
  connect(USum.y, Upcm)
    annotation (Line(points={{-101,8},{-118,8}}, color={0,0,127}));
  connect(mSum.y, mpcm)
    annotation (Line(points={{-101,-8},{-118,-8}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger
with dynamics of the fluids and the solid.
The <i>hA</i> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid.
</p>
<p>
The heat capacity <i>C</i> of the metal is assigned as follows.
Suppose the metal temperature is governed by
</p>
<p align=\"center\" style=\"font-style:italic;\">
  C dT &frasl; dt = (hA)<sub>1</sub> (T<sub>1</sub> - T)
  + (hA)<sub>2</sub> (T<sub>2</sub> - T)
</p>
<p>
where <i>hA</i> are the convective heat transfer coefficients times
heat transfer area that also take
into account heat conduction in the heat exchanger fins and
<i>T<sub>1</sub></i> and <i>T<sub>2</sub></i> are the medium temperatures.
Assuming <i>(hA)<sub>1</sub>=(hA)<sub>2</sub></i>,
this equation can be rewritten as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  C dT &frasl; dt =
  2 (UA)<sub>0</sub> ( (T<sub>1</sub> - T) + (T<sub>2</sub> - T) )

</p>
<p>
where <i>(UA)<sub>0</sub></i> is the <i>UA</i> value at nominal conditions.
Hence we set the heat capacity of the metal
to
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = 2 (UA)<sub>0</sub> &tau;<sub>m</sub>
</p>
<p>
where <i>&tau;<sub>m</sub></i> is the time constant that the metal
of the heat exchanger has if the metal is approximated by a lumped
thermal mass.
</p>
<p>
<b>Note:</b> This model is introduced to allow the instances
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent
</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible
</a>
to redeclare the volume as <code>final</code>, thereby avoiding
that a GUI displays the volume as a replaceable component.
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
July 17, 2015, by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=false</code> for both volumes.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">
issue 282</a> of the Annex 60 library.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Changed <code>initalize_p</code> from a <code>parameter</code> to a
<code>constant</code>. This is only required in finite volume models
of heat exchangers (to avoid consistent but redundant initial conditions)
and hence it should be set as a <code>constant</code>.
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
July 2, 2014, by Michael Wetter:<br/>
Conditionally removed the mass of the metall <code>mas</code>.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Removed parameters <code>energyDynamics1</code> and <code>energyDynamics2</code>,
and used instead of these two parameters <code>energyDynamics</code>.
This was done as this complexity is not required.
</li>
<li>
September 11, 2013, by Michael Wetter:<br/>
Separated old model into one for dry and for wet heat exchangers.
This was done to make the coil compatible with OpenModelica.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Changed the redeclaration of <code>vol2</code> to be replaceable,
as <code>vol2</code> is replaced in some models.
</li>
<li>
April 19, 2013, by Michael Wetter:<br/>
Made instance <code>MassExchange</code> replaceable, rather than
conditionally removing the model, to avoid a warning
during translation because of unused connector variables.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Removed assignment of medium in <code>vol1</code> and <code>vol2</code>,
since this assignment is already done in the base class using the
<code>final</code> modifier.
</li>
<li>
August 12, 2008, by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
          Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.CrossDiag),
                              Text(
          extent={{-84,114},{-62,86}},
          lineColor={0,0,255},
          textString="h"), Text(
          extent={{58,-92},{84,-120}},
          lineColor={0,0,255},
          textString="h")}));
end HexElementSensibleFourPort;
