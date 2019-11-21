within Buildings.Fluid.Chillers;
model AbsorptionIndirectChiller
  "Absorption indirect chiller with performance curves model."
    extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
     dp2_nominal=200,
     dp1_nominal=200,
     show_T=true,
     T1_start = 273.15+25,
     T2_start = 273.15+5,
     m1_flow_nominal= per.mCon_flow_nominal,
     m2_flow_nominal= per.mEva_flow_nominal,
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume
      vol1( V=m1_flow_nominal*tau1/rho1_nominal,
            nPorts=2,final prescribedHeatFlowRate=true),
      vol2( V=m2_flow_nominal*tau2/rho2_nominal,
            nPorts=2,final prescribedHeatFlowRate=true));

  parameter Buildings.Fluid.Chillers.Data.AbsorptionIndirect.Generic per
   "Performance data"
    annotation (choicesAllMatching= true,
       Placement(transformation(extent={{60,72},{80,92}})));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_small = -per.QEva_flow_nominal*1E-9
   "Small value for heat flow rate or power, used to avoid division by zero";

  Modelica.Blocks.Interfaces.BooleanInput on
   "Chiller turn on/off input signal "
     annotation (Placement(transformation(extent={{-128,-8},{-100,20}}),
                                    iconTransformation(extent={{-122,-10},{-100,12}})));
  Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
   "Evaporator setpoint leaving water temperature"
     annotation (Placement(
        transformation(extent={{-126,-94},{-100,-68}}), iconTransformation(
          extent={{-122,-100},{-100,-78}})));
  Modelica.Blocks.Interfaces.RealOutput P(final unit="W")
   "Chiller pump power"
     annotation (Placement(transformation(extent={{100,0},{120,20}}),
                            iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QGen_flow( final unit="W")
  "Generator heat flow rate"
     annotation (Placement(transformation(extent={{100,-16},{120,4}}),
        iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W")
  "Evaporator heat flow rate"
     annotation (Placement(transformation(extent={{100,-46},{120,-26}}),
        iconTransformation(extent={{100,-96},{120,-76}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W")
  "Condenser heat flow rate"
     annotation (Placement(transformation(extent={{100,18},{120,38}}),
        iconTransformation(extent={{100,74},{120,94}})));
  Modelica.Blocks.Interfaces.RealOutput mSte( final unit="kg/s")
  "Generator steam mass flow rate "
     annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
        iconTransformation(extent={{100,10},{120,30}})));
  BaseClasses.AbsorptionIndirect absBlo(per=per)
   "Absorption indirect chiller equations block"
     annotation (Placement(transformation(extent={{-58,-4},{-38,16}})));
  Modelica.Blocks.Sources.RealExpression QEvaFloSet(final y=
        Buildings.Utilities.Math.Functions.smoothMin(
            x1 = m2_flow*(hEvaSet - inStream(port_a2.h_outflow)),
            x2 = -Q_flow_small,
        deltaX = Q_flow_small/100))
   "Setpoint heat flow rate of the evaporator"
     annotation (Placement(transformation(extent={{-98,-16},{-78,4}})));
  Modelica.SIunits.SpecificEnthalpy hEvaSet=
      Medium2.specificEnthalpy_pTX(
       p=port_b2.p,
       T=TEvaSet,
       X=cat( 1,port_b2.Xi_outflow,{1 - sum(port_b2.Xi_outflow)}))
   "Chilled water setpoint enthalpy";
  Modelica.Blocks.Sources.RealExpression TConEnt(
        y=Medium1.temperature(
        Medium1.setState_phX(port_a1.p, inStream(port_a1.h_outflow))))
   "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-98,4},{-78,24}})));
  Modelica.Blocks.Sources.RealExpression TEvaLvg(y=vol2.heatPort.T)
   "Evaporator leaving water temperature"
     annotation (Placement(transformation(extent={{-98,-34},{-78,-14}})));
  Modelica.Blocks.Sources.RealExpression TConLvg(y=vol1.heatPort.T)
    "Condenser leaving water temperature"
     annotation (Placement(transformation(extent={{-98,20},{-78,40}})));
protected
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate for the condenser"
     annotation (Placement(transformation(extent={{41,30},{61,50}})));
  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate for the evaporator"
     annotation (Placement(transformation(extent={{-15,-52},{5,-32}})));

equation
  connect(on,absBlo. on)
    annotation (Line(points={{-114,6},{-59,6}},
                               color={255,0,255}));
  connect(absBlo.QCon_flow, preHeaFloCon.Q_flow)
    annotation (Line(points={{-37,14},{-18,14},{-18,40},{41,40}},
                                       color={0,0,127}));
  connect(absBlo.QEva_flow, preHeaFloEva.Q_flow)
    annotation (Line(points={{-37,-1.4},{-26,-1.4},{-26,-42},{-15,-42}},
                                          color={0,0,127}));
  connect(preHeaFloEva.port, vol2.heatPort)
    annotation (Line(points={{5,-42},{84,-42},{84,-60},{12,-60}},
                                  color={191,0,0}));
  connect(absBlo.QEva_flow, QEva_flow)
    annotation (Line(points={{-37,-1.4},{-26,-1.4},{-26,-36},{110,-36}},
                                color={0,0,127}));
  connect(TConEnt.y,absBlo. TConEnt)
    annotation (Line(points={{-77,14},{-70,14},{-70,9.4},{-59,9.4}},
                                    color={0,0,127}));
  connect(TEvaLvg.y,absBlo. TEvaLvg)
    annotation (Line(points={{-77,-24},{-66,-24},{-66,-1.4},{-59,-1.4}},
                                    color={0,0,127}));
  connect(QEvaFloSet.y,absBlo. QEvaFloSet)
    annotation (Line(points={{-77,-6},{-70,-6},{-70,2.6},{-59,2.6}},
                                    color={0,0,127}));
  connect(TConLvg.y, absBlo.TConLvg)
    annotation (Line(points={{-77,30},{-68,30},{-68,13.2},{-59,13.2}},
                                    color={0,0,127}));
  connect(absBlo.P, P)
    annotation (Line(points={{-37,9.8},{-37,10},{110,10}}, color={0,0,127}));
  connect(absBlo.mSte, mSte)
    annotation (Line(points={{-37,3},{-18,3},{-18,-20},{110,-20}},
                      color={0,0,127}));
  connect(preHeaFloCon.port, vol1.heatPort) annotation (Line(points={{61,40},{
          68,40},{68,54},{18,54},{18,44},{-20,44},{-20,60},{-10,60}}, color={
          191,0,0}));
  connect(absBlo.QCon_flow, QCon_flow) annotation (Line(points={{-37,14},{-18,
          14},{-18,28},{110,28}}, color={0,0,127}));
  connect(absBlo.QGen_flow, QGen_flow) annotation (Line(points={{-37,6},{-12,6},
          {-12,-6},{110,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-120,-100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-96,98},{98,-100}},
          lineColor={238,46,47},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-72,0},{-38,28}},
          lineColor={238,46,47},
          lineThickness=0.5),
        Rectangle(
          extent={{-24,88},{30,62}},
          lineColor={28,108,200},
          fillColor={213,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-22,-46},{32,-84}},
          lineColor={170,213,255},
          fillColor={200,189,161},
          fillPattern=FillPattern.Forward,
          pattern=LinePattern.Dash),
        Line(
          points={{60,76},{60,-66}},
          color={28,108,200}),
        Line(points={{-56,-66},{-56,62},{-56,76}}, color={238,46,47}),
        Line(
          points={{54,18},{66,18},{54,4},{66,4},{54,18}},
          color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-56,26},{-42,8},{-66,8},{-70,8},{-56,26}},
          lineColor={0,0,255},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{30,76},{48,76},{60,76}}, color={0,0,255}),
        Line(points={{32,-66},{60,-66}}, color={0,0,255}),
        Line(points={{-22,-66},{-56,-66}}, color={238,46,47}),
        Line(points={{-24,76},{-56,76}}, color={238,46,47}),
        Line(points={{-40,76}}, color={238,46,47})}),
        Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
            defaultComponentName="absChi",
    Documentation(info="<html>
<p>
Model for an absorption indirect steam chiller using the performance curves method as described
in the EnergyPlus reference: Indirect Absorption Chiller.
</p>
<p>
The model uses six non-dimensional equations or curves stated in <a href=\"Buildings.Fluid.Chillers.BaseClasses.AbsorptionIndirect\">
Buildings.Fluid.Chillers.BaseClasses.AbsorptionIndirect</a> to predict the chiller performance.
The methodology involved using the generalized least square method to create a set of performance
coefficients from the catalog data at indicated reference conditions. These respective coefficients
and are used in the model to simulate the chiller performance.
</p>
<p>
The performance coefficients are stored in the data record <code>per</code> and are available from
 <a href=\"Buildings.Fluid.Chillers.Data.AbsorptionIndirect\">
Buildings.Fluid.Chillers.Data.AbsorptionIndirect</a>.
The model takes as input signals; the set point of the leaving water temperature from
the evaporator which is met if the chiller has sufficient capacity and the Boolean input <code>on</code> which turn on/off the chiller.
</p>
<p>
The electric power only includes the power for the chiller pump.
</p>
</html>", revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})));
end AbsorptionIndirectChiller;
