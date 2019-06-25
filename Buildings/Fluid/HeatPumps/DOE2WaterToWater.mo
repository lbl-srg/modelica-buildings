within Buildings.Fluid.HeatPumps;
model DOE2WaterToWater "Water source heat pump_Performance curve"
//testtesttest
 extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    dp2_nominal=200,
    dp1_nominal=200,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   m1_flow_nominal= mCon_flow_nominal,
   m2_flow_nominal= mEva_flow_nominal,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      nPorts=2,
    final prescribedHeatFlowRate=true),
    vol1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=m1_flow_nominal*tau1/rho1_nominal,
    final prescribedHeatFlowRate=true));
    BaseClasses.DOE2Method DOE2(per=per)     annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

   parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    "Performance data" annotation (choicesAllMatching=
        true, Placement(transformation(extent={{48,66},{68,86}})));
   final parameter Modelica.SIunits.Power
     P_nominal = -QEva_heatflow_nominal/COP_nominal
    "Nominal power of the compressor";
   final parameter Modelica.SIunits.HeatFlowRate
     QCon_heatflow_nominal = - QEva_heatflow_nominal + P_nominal
    "Nominal heat flow at the condenser" annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.HeatFlowRate
     QEva_heatflow_nominal= per.QEva_flow_nominal
    "Nominal heat flow at the evaporator"
                                         annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.Efficiency
     COP_nominal=per.COP_nominal
     "Reference coefficient  of performance"
                                            annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.MassFlowRate
   mCon_flow_nominal= per.mCon_flow_nominal
   "Nominal mass flow at Condenser" annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal= per.mEva_flow_nominal
   "Nominal mass flow at Evaorator"
                                   annotation (Dialog(group="Nominal condition"));
   final parameter Modelica.SIunits.HeatFlowRate Q_flow_small = QCon_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";

   Modelica.Blocks.Interfaces.IntegerInput uMod
    "HeatPump control signal, Heating=+1, Off=0, Cooling=-1" annotation (Placement(transformation(extent={{-192,-16},{-160,16}}),
        iconTransformation(extent={{-118,-14},{-92,12}})));
   Modelica.Blocks.Interfaces.RealInput    TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving cooled water temperature" annotation (Placement(
        transformation(extent={{-188,-94},{-160,-66}}),
                                                      iconTransformation(extent={{-118,
            -104},{-92,-78}})));
   Modelica.Blocks.Interfaces.RealInput    TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature" annotation (Placement(
        transformation(extent={{-184,68},{-160,92}}),  iconTransformation(
          extent={{-116,78},{-92,102}})));

   Modelica.Blocks.Sources.RealExpression hConSet(final y=
        Medium1.specificEnthalpy_pTX(
        p=port_b1.p,
        T=TConSet,
        X=cat(
          1,
          port_b1.Xi_outflow,
          {1 - sum(port_b1.Xi_outflow)}))) "Heating water setpoint enthalpy"  annotation (Placement(transformation(extent={{-156,58},{-136,78}})));
   Modelica.Blocks.Sources.RealExpression hEvaSet(final y=
        Medium2.specificEnthalpy_pTX(
        p=port_b2.p,
        T=TEvaSet,
        X=cat(
          1,
          port_b2.Xi_outflow,
          {1 - sum(port_b2.Xi_outflow)})))
          "Cooled water setpoint enthalpy" annotation (Placement(transformation(extent={{-156,-80},{-136,-60}})));
  Modelica.Blocks.Sources.RealExpression QConFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMax(
        x1=mConFlo.y*(hConSet.y - inStream(port_a1.h_outflow)),
        x2=Q_flow_small,
        deltaX=Q_flow_small/10))
        "Setpoint heat flow rate at the condenser" annotation (Placement(transformation(extent={{-156,-2},{-136,18}})));
  Modelica.Blocks.Sources.RealExpression QEvaFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
        x1=mEvaFlo.y*(hEvaSet.y - inStream(port_a2.h_outflow)),
        x2=-Q_flow_small,
        deltaX=Q_flow_small/100))
        "Setpoint heat flow rate of the evaporator" annotation (Placement(transformation(extent={{-156,-20},{-136,0}})));
   Modelica.Blocks.Sources.RealExpression TConEnt(y=Medium1.temperature(
        Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow))))
        "Condenser entering water temperature" annotation (Placement(transformation(extent={{-156,42},
            {-136,62}})));
   Modelica.Blocks.Sources.RealExpression TEvaEnt(y=Medium2.temperature(
        Medium2.setState_phX(port_a2.p, inStream(port_a2.h_outflow))))
        "Evaporator entering water temperature"  annotation (Placement(transformation(extent={{-156,-64},{-136,-44}})));
   Modelica.Blocks.Sources.RealExpression TConLvg(y=vol1.heatPort.T)
        "Condenser leaving water temperature" annotation (Placement(transformation(extent={{-156,28},{-136,48}})));
   Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T)
        "Evaporator leaving water temperature"  annotation (Placement(transformation(extent={{-156,-50},{-136,-30}})));
   Modelica.Blocks.Sources.RealExpression mConFlo(y=vol1.ports[1].m_flow)
    "Condenser water mass flow rate" annotation (Placement(transformation(extent={{-156,14},{-136,34}})));
   Modelica.Blocks.Sources.RealExpression mEvaFlo(y=vol2.ports[1].m_flow)
    "Evaporator mass flow rate"    annotation (Placement(transformation(extent={{-156,-36},{-136,-16}})));
   Modelica.Blocks.Interfaces.RealOutput QCon(final unit="W", displayUnit="W")
    "Condenser heat flow rate" annotation (Placement(transformation(extent={{100,
            10},{120,30}}), iconTransformation(extent={{100,80},{120,100}})));
   Modelica.Blocks.Interfaces.RealOutput QEva(final unit="W", displayUnit="W")
    "Evaporator heat flow rate" annotation (Placement(transformation(extent={{100,
            -30},{120,-10}}), iconTransformation(extent={{100,-100},{120,-80}})));
   Modelica.Blocks.Interfaces.RealOutput   P(final unit="W", displayUnit="W")
    "Electric power consumed by compressor" annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
   HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed condenser heat flow rate" annotation (Placement(transformation(extent={{-41,24},{-21,44}})));
   HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed evaporator heat flow rate"  annotation (Placement(transformation(extent={{-41,-50},{-21,-30}})));


equation

  connect(preHeaFloCon.port,vol1.heatPort) annotation (Line(points={{-21,34},{-16,34},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloEva.port,vol2.heatPort) annotation (Line(points={{-21,-40},{-2,-40},{-2,-60},{12,-60}},
                                       color={191,0,0}));
  connect(port_a2, port_a2) annotation (Line(points={{100,-60},{105,-60},{105,-60},
          {100,-60}}, color={0,127,255}));
  connect(uMod, DOE2.uMod) annotation (Line(points={{-176,0},{-144,0},{-144,-0.1},
          {-110.9,-0.1}}, color={255,127,0}));
  connect(TConSet, DOE2.TConSet) annotation (Line(points={{-172,80},{-116,80},{-116,
          10},{-111,10}}, color={0,0,127}));
  connect(QConFloSet.y, DOE2.QConFloSet) annotation (Line(points={{-135,8},{-122,
          8},{-122,2},{-111,2}}, color={0,0,127}));
  connect(QEvaFloSet.y, DOE2.QEvaFloSet) annotation (Line(points={{-135,-10},{-120,
          -10},{-120,-2.7},{-110.9,-2.7}}, color={0,0,127}));
  connect(TEvaLvg.y, DOE2.TEvaLvg) annotation (Line(points={{-135,-40},{-118,-40},
          {-118,-4.9},{-110.9,-4.9}}, color={0,0,127}));
  connect(DOE2.TEvaEnt, TEvaEnt.y) annotation (Line(points={{-110.9,-7.5},{-116,
          -7.5},{-116,-54},{-135,-54}}, color={0,0,127}));
  connect(DOE2.TEvaSet, TEvaSet) annotation (Line(points={{-110.9,-9.9},{-114,-9.9},
          {-114,-80},{-174,-80}}, color={0,0,127}));
  connect(DOE2.QCon, preHeaFloCon.Q_flow) annotation (Line(points={{-89,4},{-58,
          4},{-58,34},{-41,34}}, color={0,0,127}));
  connect(DOE2.QCon, QCon) annotation (Line(points={{-89,4},{86,4},{86,20},{110,
          20}}, color={0,0,127}));
  connect(DOE2.P, P) annotation (Line(points={{-89,0},{110,0}}, color={0,0,127}));
  connect(DOE2.QEva, preHeaFloEva.Q_flow) annotation (Line(points={{-89,-4},{-58,
          -4},{-58,-40},{-41,-40}}, color={0,0,127}));
  connect(DOE2.QEva, QEva) annotation (Line(points={{-89,-4},{86,-4},{86,-20},{110,
          -20}}, color={0,0,127}));
  connect(TConLvg.y, DOE2.TConLvg) annotation (Line(points={{-135,38},{-120,38},
          {-120,4.2},{-111,4.2}}, color={0,0,127}));
  connect(TConEnt.y, DOE2.TConEnt) annotation (Line(points={{-135,52},{-118,52},
          {-118,6.6},{-111,6.6}}, color={0,0,127}));
    annotation (choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
                choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
                choicesAllMatching=true,Placement(transformation(extent={{48,66},{68,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{-92,96},{94,-94}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-66,78},{70,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-46},{70,-74}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,68},{0,90},{90,90},{100,90}},
                                                 color={0,0,255}),
        Line(points={{0,-70},{0,-84},{0,-90},{100,-90}}, color={28,108,200}),
        Line(points={{60,0},{104,0}}, color={28,108,200})}),
    defaultComponentName="heaPumDOE2",
   defaultComponentName="chi",
Documentation(info="<html>
<p>
Model of a water to water heat pump, based on the DOE-2.1 chiller model,
the EnergyPlus chiller model <code>Chiller:Electric:EIR</code> and from <a href=\"Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>.
</p>
<p>
This model uses three functions stated in <a href=\"Buildings.Fluid.HeatPumps.BaseClasses.DOE2Method\">
Buildings.Fluid.HeatPupms.BaseClasses.DOE2Method</a>. to predict the thermal capacity and the compressor power consumption through
three operational modes executed by a control input signal uMod=+1 heating mode, uMod=-1 cooling mode and
uMod=0 shutoff.
</p>

<ul>
<li>
A biquadratic function is used to predict the thermal capacity as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
<li>
A quadratic functions is used to predict power input to the thermal capacity
ratio with respect to the part load ratio.
</li>
<li>
A biquadratic functions is used to predict power input to the thermal capacity ratio as a function of
condenser entering and evaporator leaving fluid temperature.
</li>
</ul>

<p>
The model takes as input signals; the set point either for the leaving water temperature of the
condenser or the evaporator which is met if the heat pump has sufficient capacity and the
integer input uMod which identifies the heat pump operational mode:
uMod=+1 for heating mode, uMod=-1 for cooling mode, uMod=0 for shut off the system.
The model has a built-in, ideal temperature control.
</p>

<p>
The model can be parametrized to compute a transient
or steady-state response.
The transient response of the heatpump is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The heatpump outlet temperatures are equal to the temperatures of these lumped volumes.
</p>

<h4>References</h4>
<ul>
<li>
Hydeman, M. and K.L. Gillespie. 2002. Tools and Techniques to Calibrate Electric Chiller
Component Models. <i>ASHRAE Transactions</i>, AC-02-9-1.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 21, 2019, by Hagar Elarga:<br/>
First implementation.
Refactored ,<a href=\"Buildings.Fluid.Chillers.ElectricEIR\">ElectricEIR EIR chiller</a>
model to include simultaneous heating and cooling modes.
</li>
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{100,100}})));
end DOE2WaterToWater;
